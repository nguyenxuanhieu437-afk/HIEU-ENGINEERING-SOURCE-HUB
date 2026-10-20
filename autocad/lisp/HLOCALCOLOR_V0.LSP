;;; ============================================================================
;;; HLOCALCOLOR_V0.LSP
;;; Proof of Concept - AutoCAD AutoLISP
;;;
;;; Lệnh: HLOCALCOLOR
;;; 1) Chọn nét mẫu có màu trực tiếp
;;; 2) Chọn 1 Block Reference
;;; 3) Chọn 2 góc vùng
;;; 4) Đổi màu entity có tâm Bounding Box nằm trong vùng
;;;
;;; LƯU Ý:
;;; - Không explode.
;;; - V0 sửa Block Definition, nên các block khác dùng cùng definition có thể đổi theo.
;;; - Phù hợp nhất với block 2D, rotation/scale thông thường.
;;; ============================================================================

(vl-load-com)

(defun hlc:safe-put-color (obj colorIndex)
  (if (and colorIndex (numberp colorIndex))
    (vl-catch-all-apply
      '(lambda () (vla-put-Color obj colorIndex))
    )
  )
)

(defun hlc:block-p (obj)
  (= (strcase (vla-get-ObjectName obj)) "ACDBBLOCKREFERENCE")
)

(defun hlc:mat-mul (a b / r i j k sum row)
  (setq r nil i 0)
  (repeat 4
    (setq row nil j 0)
    (repeat 4
      (setq sum 0.0 k 0)
      (repeat 4
        (setq sum
          (+ sum
             (* (nth k (nth i a))
                (nth j (nth k b)))))
        (setq k (1+ k))
      )
      (setq row (append row (list sum)))
      (setq j (1+ j))
    )
    (setq r (append r (list row)))
    (setq i (1+ i))
  )
  r
)

(defun hlc:pt-xform (pt m / x y z)
  (setq x (car pt)
        y (cadr pt)
        z (if (caddr pt) (caddr pt) 0.0))
  (list
    (+ (* x (nth 0 (nth 0 m)))
       (* y (nth 1 (nth 0 m)))
       (* z (nth 2 (nth 0 m)))
       (nth 3 (nth 0 m)))
    (+ (* x (nth 0 (nth 1 m)))
       (* y (nth 1 (nth 1 m)))
       (* z (nth 2 (nth 1 m)))
       (nth 3 (nth 1 m)))
    (+ (* x (nth 0 (nth 2 m)))
       (* y (nth 1 (nth 2 m)))
       (* z (nth 2 (nth 2 m)))
       (nth 3 (nth 2 m)))
  )
)

(defun hlc:block-matrix (br / ip rot sx sy sz c s)
  (setq ip  (vlax-safearray->list
              (vlax-variant-value (vla-get-InsertionPoint br))))
  (setq rot (vla-get-Rotation br))
  (setq sx  (vla-get-XScaleFactor br))
  (setq sy  (vla-get-YScaleFactor br))
  (setq sz  (vla-get-ZScaleFactor br))
  (setq c (cos rot)
        s (sin rot))
  (list
    (list (* c sx) (* (- s) sy) 0.0 (car ip))
    (list (* s sx) (* c sy)     0.0 (cadr ip))
    (list 0.0      0.0          sz  (if (caddr ip) (caddr ip) 0.0))
    (list 0.0      0.0          0.0 1.0)
  )
)

(defun hlc:get-bbox-center (obj / mn mx r p1 p2)
  (setq r
    (vl-catch-all-apply
      '(lambda () (vla-GetBoundingBox obj 'mn 'mx))
    )
  )
  (if (vl-catch-all-error-p r)
    nil
    (progn
      (setq p1 (vlax-safearray->list mn))
      (setq p2 (vlax-safearray->list mx))
      (list
        (/ (+ (car p1) (car p2)) 2.0)
        (/ (+ (cadr p1) (cadr p2)) 2.0)
        (/ (+ (caddr p1) (caddr p2)) 2.0)
      )
    )
  )
)

(defun hlc:inside-rect-p (pt p1 p2 / xmin xmax ymin ymax)
  (setq xmin (min (car p1) (car p2))
        xmax (max (car p1) (car p2))
        ymin (min (cadr p1) (cadr p2))
        ymax (max (cadr p1) (cadr p2)))
  (and
    (>= (car pt) xmin)
    (<= (car pt) xmax)
    (>= (cadr pt) ymin)
    (<= (cadr pt) ymax)
  )
)

(defun hlc:get-block-def (doc br / blocks name)
  (setq blocks (vla-get-Blocks doc))
  (setq name
    (if (vlax-property-available-p br 'EffectiveName)
      (vla-get-EffectiveName br)
      (vla-get-Name br)
    )
  )
  (vl-catch-all-apply
    '(lambda () (vla-Item blocks name))
  )
)

(defun hlc:process-definition
       (doc blockDef parentMatrix p1 p2 colorIndex visited depth
        / key obj localM total center worldCenter childDef)

  (if (> depth 100)
    0
    (progn
      (setq key (strcase (vla-get-Name blockDef)))
      (if (member key visited)
        0
        (progn
          (setq visited (cons key visited))
          (setq total 0)

          (vlax-for obj blockDef
            (cond
              ((hlc:block-p obj)
                (setq localM (hlc:block-matrix obj))
                (setq childDef (hlc:get-block-def doc obj))
                (if (not (vl-catch-all-error-p childDef))
                  (setq total
                    (+ total
                       (hlc:process-definition
                         doc childDef
                         (hlc:mat-mul parentMatrix localM)
                         p1 p2 colorIndex visited (1+ depth)
                       )
                    )
                  )
                )
              )
              (T
                (setq center (hlc:get-bbox-center obj))
                (if center
                  (progn
                    (setq worldCenter (hlc:pt-xform center parentMatrix))
                    (if (hlc:inside-rect-p worldCenter p1 p2)
                      (progn
                        (hlc:safe-put-color obj colorIndex)
                        (setq total (1+ total))
                      )
                    )
                  )
                )
              )
            )
          )
          total
        )
      )
    )
  )
)

(defun c:HLOCALCOLOR
       (/ *error* acad doc sampleEnt sampleObj colorIndex blockEnt blockObj
          p1 p2 blockDef rootM result undoStarted oldCmdecho)

  (vl-load-com)

  (setq acad (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acad))
  (setq oldCmdecho (getvar "CMDECHO"))
  (setq undoStarted nil)
  (setvar "CMDECHO" 0)

  (defun *error* (msg)
    (if undoStarted
      (vl-catch-all-apply '(lambda () (vla-EndUndoMark doc)))
    )
    (setvar "CMDECHO" oldCmdecho)
    (if (and msg
             (/= msg "Function cancelled")
             (/= msg "quit / exit abort"))
      (princ (strcat "\nHLOCALCOLOR lỗi: " msg))
    )
    (princ)
  )

  (prompt "\nHLOCALCOLOR - Chọn nét mẫu có màu trực tiếp: ")
  (setq sampleEnt (car (entsel)))

  (if (null sampleEnt)
    (*error* "Function cancelled")
    (progn
      (setq sampleObj (vlax-ename->vla-object sampleEnt))
      (setq colorIndex (vla-get-Color sampleObj))

      (if (or (= colorIndex 0) (= colorIndex 256))
        (progn
          (prompt "\nNét mẫu đang ByLayer/ByBlock. Hãy chọn nét có màu trực tiếp.")
          (*error* "Function cancelled")
        )
        (progn
          (prompt "\nChọn Block Reference cần đổi màu cục bộ: ")
          (setq blockEnt (car (entsel)))

          (if (or (null blockEnt)
                  (/= (cdr (assoc 0 (entget blockEnt))) "INSERT"))
            (progn
              (prompt "\nĐối tượng được chọn không phải Block Reference.")
              (*error* "Function cancelled")
            )
            (progn
              (setq blockObj (vlax-ename->vla-object blockEnt))
              (setq p1 (getpoint "\nChọn góc thứ nhất của vùng cần đổi màu: "))

              (if (null p1)
                (*error* "Function cancelled")
                (progn
                  (setq p2 (getcorner p1 "\nChọn góc đối diện: "))

                  (if (null p2)
                    (*error* "Function cancelled")
                    (progn
                      (setq blockDef (hlc:get-block-def doc blockObj))

                      (if (vl-catch-all-error-p blockDef)
                        (*error* "Không đọc được Block Definition.")
                        (progn
                          (setq rootM (hlc:block-matrix blockObj))
                          (vla-StartUndoMark doc)
                          (setq undoStarted T)

                          (setq result
                            (hlc:process-definition
                              doc blockDef rootM p1 p2 colorIndex nil 0
                            )
                          )

                          (vla-Regen doc 1)
                          (vla-EndUndoMark doc)
                          (setq undoStarted nil)
                          (setvar "CMDECHO" oldCmdecho)

                          (prompt
                            (strcat
                              "\nHLOCALCOLOR hoàn tất. Đã đổi màu "
                              (itoa result)
                              " entity trong vùng."
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
  (princ)
)

(princ "\nHLOCALCOLOR_V0 đã nạp. Gõ HLOCALCOLOR để thử.")
(princ)