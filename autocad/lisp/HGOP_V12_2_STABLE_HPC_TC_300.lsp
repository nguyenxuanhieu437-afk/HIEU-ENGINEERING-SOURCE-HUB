; HGOP V12 PREFIX FILTER - Scan MARK directly from MODEL, paste grouped result into LAYOUT target
(vl-load-com)

(defun HG:Trim (s) (vl-string-trim " \t\r\n" (if s s "")))

(defun HG:CleanMText (s / p q)
  (setq s (if s s ""))
  (while (setq p (vl-string-search "\\f" s))
    (if (setq q (vl-string-search ";" s p))
      (setq s (strcat (substr s 1 p) (substr s (+ q 2))))
      (setq p nil)))
  (foreach x '("{" "}" "\\P" "\\L" "\\l" "\\O" "\\o")
    (setq s (vl-string-subst " " x s)))
  (HG:Trim s))

(defun HG:IsDigit (c / a)
  (and c (= (strlen c) 1) (setq a (ascii c)) (>= a 48) (<= a 57)))

(defun HG:IsAlphaNum (c / a)
  (and c (= (strlen c) 1)
       (setq a (ascii c))
       (or (and (>= a 48) (<= a 57))
           (and (>= a 65) (<= a 90))
           (and (>= a 97) (<= a 122)))))

; Extract FIRST valid MARK token from any text.
; Examples: "(1-100) PL6" -> ("1" 100)
;           "TC-22 COVER RETAINER" -> ("TC" 22)
;           "ABC TC-23 BRACKET" -> ("TC" 23)
(defun HG:ParseTag (s / i n hy l r pre numstr c)
  (setq s (HG:CleanMText s) i 1 n (strlen s) hy nil)
  (while (and (<= i n) (null hy))
    (if (= (substr s i 1) "-")
      (progn
        (setq l (1- i) r (1+ i))
        ; right side must start with digit
        (if (and (>= l 1) (<= r n) (HG:IsDigit (substr s r 1)))
          (progn
            ; walk left over alphanumeric prefix
            (while (and (>= l 1) (HG:IsAlphaNum (substr s l 1))) (setq l (1- l)))
            (setq l (1+ l))
            ; prefix must exist
            (if (< l i)
              (progn
                ; walk right over digits only: this deliberately drops descriptions
                (while (and (<= r n) (HG:IsDigit (substr s r 1))) (setq r (1+ r)))
                (setq pre (substr s l (- i l))
                      numstr (substr s (1+ i) (- r i 1)))
                (if (> (strlen numstr) 0) (setq hy T)))))))
    (setq i (1+ i)))
  (if hy (list (strcase pre) (atoi numstr)) nil)))

(defun HG:UniqueSort (lst / out last)
  (setq lst (vl-sort lst '<) out nil last nil)
  (foreach n lst
    (if (or (null last) (/= n last))
      (progn (setq out (cons n out)) (setq last n))))
  (reverse out))

(defun HG:RunText (a b)
  (cond ((= a b) (itoa a))
        ((= b (1+ a)) (strcat (itoa a) "," (itoa b)))
        (T (strcat (itoa a) "~" (itoa b)))))

(defun HG:Compress (nums / start prev n out piece)
  (setq nums (HG:UniqueSort nums) out "")
  (if nums
    (progn
      (setq start (car nums) prev start)
      (foreach n (cdr nums)
        (if (= n (1+ prev))
          (setq prev n)
          (progn
            (setq piece (HG:RunText start prev)
                  out (if (= out "") piece (strcat out "," piece))
                  start n prev n)))
      (setq piece (HG:RunText start prev)
            out (if (= out "") piece (strcat out "," piece)))))
  out))

(defun HG:ReplaceParen (s new / i rp lp)
  (setq i (strlen s) rp nil lp nil)
  (while (and (> i 0) (not rp))
    (if (= (substr s i 1) ")") (setq rp i))
    (setq i (1- i)))
  (if rp
    (progn
      (setq i (1- rp))
      (while (and (> i 0) (not lp))
        (if (= (substr s i 1) "(") (setq lp i))
        (setq i (1- i)))))
  (if (and lp rp) (strcat (substr s 1 lp) new (substr s rp)) nil))

(defun HG:GetObjText (e / o nm)
  (setq o (vlax-ename->vla-object e) nm (vla-get-ObjectName o))
  (if (member nm '("AcDbText" "AcDbMText" "AcDbAttribute")) (vla-get-TextString o) nil))

(defun HG:GetTargetPrefix (e / s p)
  (setq s (HG:GetObjText e))
  (if (and s (= (type s) 'STR))
    (progn
      (setq p (HG:ParseTag s))
      (if p (car p) nil))
    nil))

(defun HG:AddIfPrefix (txt want nums / p)
  (if (and txt want (= (type txt) 'STR) (= (type want) 'STR))
    (progn
      (setq p (HG:ParseTag txt))
      (if (and p (= (strcase (car p)) (strcase want)))
        (cons (cadr p) nums)
        nums))
    nums))

(defun HG:ScanInsertAttrs (e want nums / o arr a)
  (setq o (vlax-ename->vla-object e))
  (if (= :vlax-true (vla-get-HasAttributes o))
    (progn
      (setq arr (vlax-invoke o 'GetAttributes))
      (foreach a arr (setq nums (HG:AddIfPrefix (vla-get-TextString a) want nums)))))
  nums)

(defun HG:UpdateTarget (e new / o old rep nm)
  (setq o (vlax-ename->vla-object e) nm (vla-get-ObjectName o))
  (if (member nm '("AcDbText" "AcDbMText" "AcDbAttribute"))
    (progn
      (setq old (vla-get-TextString o) rep (HG:ReplaceParen old new))
      (if rep (progn (vla-put-TextString o rep) (vla-Update o) T) nil)) nil))

(defun c:HGOP (/ *error* oldcv oldtile target prefix ss i e typ txt nums result)
  (setq oldcv (getvar "CVPORT") oldtile (getvar "TILEMODE"))
  (defun *error* (msg)
    (if (= oldtile 0) (setvar "TILEMODE" 0))
    (if (and msg (/= msg "Function cancelled")) (princ (strcat "\nHGOP error: " msg)))
    (princ))

  (if (= (getvar "TILEMODE") 1)
    (princ "\nHGOP: Hay chuyen sang LAYOUT truoc khi chay lenh.")
    (progn
      ; Force Paper Space so target is definitely on Layout
      (if (> (getvar "CVPORT") 1) (command "_.PSPACE"))
      (setq target (car (entsel "\nHGOP - Click vao dong chu (...) tren LAYOUT can dien: ")))
      (if (null target)
        (princ "\nHGOP: Chua chon vi tri dich.")
        (progn
          ; Prefix is inferred from existing target, e.g. (1-100) or (TC-22)
          (setq prefix (HG:GetTargetPrefix target))
          (if (null prefix)
            (princ "\nHGOP: Khong doc duoc prefix MARK tu dong chu dich. Vi du dich can co (1-100) hoac (TC-22).")
            (progn
              (princ (strcat "\nDang quet MODEL cho MARK prefix [" prefix "] ..."))
              ; V12.2 STABLE SCAN
              ; Do NOT use DXF group 1 wildcard in ssget: on some drawings /
              ; AutoCAD entity combinations it can throw "stringp nil".
              ; Scan only TEXT+MTEXT in Model, then reject non-prefix strings
              ; using raw DXF text before calling the full parser.
              (setq nums nil
                    ss (ssget "_X" '((410 . "Model") (0 . "TEXT,MTEXT")))
                    i 0)
              (if ss
                (while (< i (sslength ss))
                  (setq e (ssname ss i)
                        typ (cdr (assoc 0 (entget e))))
                  (if (member typ '("TEXT" "MTEXT"))
                    (progn
                      (setq txt (HG:GetObjText e))
                      (if (and txt
                               (= (type txt) 'STR)
                               (vl-string-search
                                 (strcat (strcase prefix) "-")
                                 (strcase txt)))
                        (setq nums (HG:AddIfPrefix txt prefix nums)))))
                  (setq i (1+ i))))
              (setq nums (HG:UniqueSort nums))
              (if (null nums)
                (princ (strcat "\nHGOP: Khong tim thay MARK " prefix "-... trong MODEL."))
                (progn
                  (setq result (strcat prefix "-" (HG:Compress nums)))
                  (princ (strcat "\nTim thay " (itoa (length nums)) " MARK. Ket qua: " result))
                  (if (HG:UpdateTarget target result)
                    (princ (strcat "\nOK -> (" result ")"))
                    (princ "\nHGOP: Khong sua duoc text dich. Hay click TEXT/MTEXT/ATTRIB co ngoac (...).")))))))))))
  (princ)

(princ "\nHGOP V12.2 STABLE loaded - supports 1-..., TC-..., 300-... | MODEL -> LAYOUT. Lenh: HGOP")
(princ)