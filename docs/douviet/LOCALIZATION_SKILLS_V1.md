---
name: douviet-localization-master
description: Orchestrate end-to-end Chinese-to-Vietnamese contextual film and video localization with offline-first modular engines, hard-sub restoration, professional subtitles, and optional expressive dubbing.
version: 1.0.0
language: vi-VN
---

# DouViet Localization Master — Quy tắc điều phối

## Phạm vi
Bộ này là **đặc tả kỹ năng và tài liệu triển khai**, KHÔNG phải ứng dụng video đã hoàn thành, không chứa trọng số AI hay bộ cài. Mục tiêu: một đầu vào → video Việt chất lượng; mỗi công đoạn có kiểm chứng, có thể chạy lại, có quyền truy cập rõ ràng.

## Nguyên tắc bất biến
1. Dịch theo cảnh và tuyến nhân vật; cấm dịch từng câu tách ngữ cảnh.
2. Bảo toàn nghĩa, phủ định, số liệu, tên, thái độ; không tự thêm tình tiết hoặc diễn biến.
3. Chia transcript bằng ID duy nhất; mọi bước giữ liên kết `utterance_id`.
4. Không được coi lỗi ASR/OCR là câu thoại xác thực. Mọi chỗ chưa chắc có confidence + review flag.
5. Sub mềm → tháo track; sub cứng → mask + inpainting. Không che đen/crop làm giải pháp mặc định.
6. Không tuyên bố video hoàn thành chỉ vì job trả về thành công; phải kiểm tra nội dung thực tế.
7. TTS/clone giọng chỉ áp dụng với giọng có quyền hoặc đồng ý; bản quyền video phải phù hợp.
8. Tính năng offline phải ghi rõ model có sẵn hay cần tải lần đầu; không bí mật dùng API trả phí.

## Chế độ
- `subtitle_only`: giữ âm thanh Trung + Việt sub mềm/cứng.
- `clean_and_sub`: xóa hardsub rồi gắn phụ đề Việt.
- `dub_plus_sub`: xóa sub Trung + TTS giọng Việt + Việt sub.
- `batch`: áp dụng bất kỳ chế độ trên cho nhiều video.

## Chu trình theo gate
1. Intake + quyền truy cập → G1
2. Media phân tích, Scene+ASR+OCR → G2
3. Diarization + Story Bible → G3
4. Dịch nghĩa → Việt hóa hội thoại → QA nghĩa → G4
5. Xử lý sub Trung, sync và style ASS → G5
6. TTS+mix (nếu chọn) → G6
7. Render + verify MP4/SRT/ASS → G7
8. Kiểm duyệt mẫu hoặc flag confidence thấp → RELEASE

## Hành vi khi lỗi
- Không bỏ qua câu lỗi. Ghi `needs_review`, `reason`, `source_id`, `time_range`.
- Giữ bản gốc và đầu ra từng bước để rollback; chỉ xóa cache có thể tái tạo, không xóa source.
- Retry hữu hạn, sau đó chuyển sang engine dự phòng hoặc review bằng tay.
- Khi resume: so checksum input + model hash + config hash; không trộn artifact giữa hai phiên bản dịch.

## File bắt đầu
- `README.md`: bản đồ kỹ năng.
- `docs/ARCHITECTURE.md`: cấu trúc pipeline/data contracts.
- `docs/QUALITY_GATES.md`: nghiệm thu.
- `docs/TOOL_MATRIX.md`: engine được khuyến nghị.
- `docs/LEARNING_ROADMAP.md`: lộ trình học.
- `skills/*.md`: 22 kỹ năng, áp dụng từng bước.
- `prompts/*.md`: prompt gợi ý cho mô hình cục bộ.
- `schemas/*.json`, `examples/*.json`: dữ liệu chuẩn.

## Không tuyên bố
Bản tài liệu này không xác nhận DouViet hiện đã tích hợp thành công bất cứ engine nào. Build, kiểm thử trên máy người dùng, chất lượng translation/TTS và hiệu năng GPU đều chưa được chứng thực bởi gói tài liệu.


---

# DOUVIET STUDIO — LOCALIZATION SKILLPACK V1.0
**Ngày:** 22/10/2026 · **Ngôn ngữ:** Trung → Việt · **Mục tiêu:** Offline-first, không phụ thuộc API trả phí khi inference.

## Đây là gì?
Một bộ **22 đặc tả kỹ năng** và tài liệu bàn giao để thiết kế/tích hợp DouViet Studio. Đây **không phải** mã nguồn của website hay bằng chứng rằng engine đã được cài và chạy. Bao gồm: pipeline, schema trung gian, prompt Việt hóa, kiểm thử, thư viện tham khảo, lộ trình học.

## Mục tiêu đầu ra
- Video giữ thoại Trung + phụ đề Việt (soft/hard).
- Video đã xóa phụ đề Trung cứng + phụ đề Việt đẹp.
- Video lồng giọng Việt theo nhân vật, nếu chọn.
- Xử lý nhiều video dài; không giới hạn nhân tạo về số phút/tệp; giới hạn thực tế là disk, RAM/VRAM, thời gian, platform và quyền nội dung.
- Có thể sửa từng câu, xem phụ đề Trung–Việt song song, duyệt lỗi, chọn preset.

## 22 module

| # | Kỹ năng | File |
|---|---|---|
| 01 | Tiếp nhận và tải video | [Xem](skills/01-video-acquisition.md) |
| 02 | Phân tích và chuẩn hóa media | [Xem](skills/02-media-profiling.md) |
| 03 | Phân đoạn cảnh và diễn giải hình ảnh | [Xem](skills/03-scene-segmentation.md) |
| 04 | Tách và làm sạch âm thanh | [Xem](skills/04-audio-separation.md) |
| 05 | Nhận dạng lời thoại tiếng Trung | [Xem](skills/05-chinese-asr.md) |
| 06 | Phân biệt người nói | [Xem](skills/06-speaker-diarization.md) |
| 07 | Bộ nhớ nhân vật và cốt truyện | [Xem](skills/07-character-story-bible.md) |
| 08 | Dịch Trung → Việt chuẩn ngữ nghĩa | [Xem](skills/08-translation-semantic.md) |
| 09 | Biên tập thoại Việt tự nhiên | [Xem](skills/09-dialogue-localization.md) |
| 10 | Giải mã cảm xúc và dụng ý | [Xem](skills/10-emotion-pragmatics.md) |
| 11 | Kiểm tra chất lượng bản dịch | [Xem](skills/11-translation-qc.md) |
| 12 | Nhận diện phụ đề Trung trong video | [Xem](skills/12-subtitle-ocr.md) |
| 13 | Xóa phụ đề cứng và khôi phục nền | [Xem](skills/13-subtitle-removal.md) |
| 14 | Căn thời gian và ngắt dòng phụ đề | [Xem](skills/14-subtitle-timing.md) |
| 15 | Thiết kế phụ đề đẹp theo thể loại | [Xem](skills/15-subtitle-design.md) |
| 16 | Tổng hợp giọng Việt offline | [Xem](skills/16-vietnamese-tts.md) |
| 17 | Gán giọng theo nhân vật và sắc thái | [Xem](skills/17-voice-character-matching.md) |
| 18 | Ghép lồng tiếng, nhạc nền, hiệu ứng | [Xem](skills/18-audio-mixing.md) |
| 19 | Xuất video đa định dạng | [Xem](skills/19-video-rendering.md) |
| 20 | Tự động hóa hàng loạt và phục hồi | [Xem](skills/20-batch-orchestration.md) |
| 21 | Đánh giá chất lượng đa tầng | [Xem](skills/21-quality-assurance.md) |
| 22 | Môi trường AI cục bộ, bảo mật và giấy phép | [Xem](skills/22-local-infrastructure.md) |

## Lộ trình sử dụng
1. Đọc `SKILL.md` để hiểu nguyên tắc và gate.
2. Đọc `docs/ARCHITECTURE.md` để xác định schema, pipeline.
3. Đọc `docs/TOOL_MATRIX.md` rồi kiểm tra license của từng dependency trước khi chốt công nghệ.
4. Triển khai thứ tự MVP: source → ASR → context/translation → SRT/ASS → export; sau đó removal/dubbing/batch.
5. Dùng `docs/QUALITY_GATES.md` và bộ test mẫu để xác nhận tính năng trước khi đánh dấu hoàn thành.

## Quan trọng về “miễn phí hoàn toàn”
- Các engine local có thể không tốn tiền API/tokens, nhưng tốn điện, GPU/CPU, ổ cứng. Phải download model trước khi dùng offline.
- Một website lưu trữ trên cloud không thể dùng tài nguyên máy cá nhân nếu không có local agent/desktop companion được người dùng cấp quyền.
- Model TTS có phiên bản đóng/mở; không mặc định mọi phiên bản đều open-source.
- Giấy phép code ≠ giấy phép trọng số model ≠ giấy phép video. Kiểm tra độc lập.
- Không tự ý tải nguồn DRM hoặc dùng clone giọng không được phép.

## Danh mục
- `SKILL.md`: kỹ năng master.
- `skills/`: 22 kỹ năng.
- `docs/`: kiến trúc, KPI/QA, ma trận công cụ, roadmap, nguồn.
- `prompts/`: 3 mẫu prompt để đưa vào local LLM.
- `schemas/`: JSON Schema mô tả dữ liệu lời thoại.
- `examples/`: ví dụ giả lập minh họa dữ liệu đầu ra.
- `config/`: preset chất lượng và style.
- `tests/`: kiểm tra cấu trúc tài liệu, không thay thế E2E tests với video thật.

## Trạng thái
**Đã hoàn tất:** biên soạn đặc tả + schema + prompt + kiểm tra cấu trúc.  
**Chưa thực hiện:** tích hợp website thật, tải trọng số, chạy audio/video thật, xác nhận performance và kiểm thử nghiệp vụ.


---

# KIẾN TRÚC TỔNG THỂ — Offline-first workflow

```text
URL/Video Upload → downloader (when authorized) → ffprobe/source registry
   ├─ Scene cuts + keyframes → context/characters/relations ─┐
   ├─ Audio extraction → VAD/separation → ASR → diarization ───┤
   └─ Soft-sub detection / Hard-sub OCR → OCR transcript ───────┤
                                                               ↓
                             ID-matched transcript + Story Bible + glossary
                                                               ↓
                      Semantic translation (zh→vi, accurate meaning)
                                                               ↓
                      Vietnamese conversational localization
                                                               ↓
                  Independent QA (meaning, names, relation, omission)
                          ├───────> Review queue if low confidence
                          ↓
         Subtitle timing → ASS design ───┐
         OCR mask → temporal inpainting ─┤→ FFmpeg render/verify → outputs
         Character voice → TTS/mix ──────┘ (optional)
```

## Nguyên tắc xử lý
- Tách thời gian nhận dạng `audio_time` khỏi thời gian video `video_pts`, ghi offset chính xác.
- `utterance_id` bất biến qua ASR→dịch→biên tập→sub→TTS. Một câu có thể chia thành nhiều subtitle segment nhưng phải giữ `parent_ids`.
- Dùng `speaker_id` vô danh; tên nhân vật chỉ xác nhận khi đã có bằng chứng.
- Scene context không được hiểu là sự thật nếu thiếu lời thoại/video căn cứ.
- Lời thoại cuối có `zh_original`, `vi_semantic`, `vi_localized`, `emotion`, `speaker_id`, `start_ms`, `end_ms`, `review_status`.
- Dự phòng cho phụ đề có sẵn: softsub được trích và đối chiếu, bỏ track khi xuất; hard-sub inpainting mới cần frame processing.

## DAG và khả năng quay lại
`source → media_info → scene/audio/OCR → transcript → cast/context → translate → QC → timed subtitle → style → render`.
Nhánh remove hard-sub có thể chạy song song sau OCR. Nhánh TTS chạy sau translate QA.
Mỗi stage cache theo `hash(input artifacts + engine version + prompt/config)` và lưu log.

## Data contract tối thiểu
Xem `schemas/utterances.schema.json`. Các timecode số nguyên milliseconds, được tăng dần theo mỗi track, có thể chồng khi 2 người nói cùng lúc.
Schema phân biệt `original_zh` và `semantic_vi`/`localized_vi`. Không thay thế tiếng Trung bằng bản dịch trong cùng một trường.

## Product UX (1-click but review-capable)
1. Dán link/tải file.
2. Chọn “Phụ đề Việt” hoặc “Phụ đề + Lồng tiếng”.
3. Chọn preset thể loại và font; click Bắt đầu.
4. Timeline có 4 cột: lời Trung / Việt tự nhiên / nhân vật / lỗi cần xem; preview trước/sau khôi phục nền.
5. Export SRT+ASS+MP4; button Download chỉ hiện khi export và verify thành công.

## Giới hạn không nên che giấu
- Hard-sub inpainting che mặt hoặc chuyển động mạnh có thể cần sửa mask thủ công.
- ASR và diarization dễ sai khi thoại chồng nhau hoặc giọng địa phương.
- TTS emotion/voice cloning chưa chắc đạt cảm xúc như diễn viên lồng tiếng; cho phép tắt hoặc thay giọng.
- Chunking để xử lý video dài không bảo đảm video vô hạn: phụ thuộc đĩa/thiết bị và thời gian.


---

# QUALITY GATES — Đặc tả nghiệm thu

Ngưỡng dưới đây là **mục tiêu đề xuất ban đầu để tinh chỉnh bằng pilot**, không phải số đo thực nghiệm của DouViet.

| Gate | Kiểm tra bắt buộc | Tiêu chí đề xuất |
|---|---|---|
| G1 nguồn | File mở được, quyền xử lý rõ | source tồn tại, stream/duration hợp lệ |
| G2 lời Trung | không bỏ sót đoạn thoại | 100% VAD speech ranges được gán transcript hoặc marked uncertain; CER trên gold set được báo riêng |
| G3 nhân vật | không gán chắc khi không chắc | speaker ID ổn định, uncertain cases phải review |
| G4 nghĩa | bảo toàn phủ định, số, tên, câu | 0 critical không xử lý; 100% utterance_id có bản dịch/trạng thái |
| G5 phụ đề | chữ đẹp, đúng mốc | max 2 dòng, target 13–20 CPS tùy preset, max 42 ký tự/dòng; vi phạm phải được flag |
| G5 phục hồi | không còn sub Trung mục tiêu | sample mọi phân cảnh khó, artifacts do người duyệt chấp thuận |
| G6 giọng | đủ thoại, rõ chữ | 0 missing utterance; không clipping; cố định voice mỗi character |
| G7 export | MP4 thực sự chứa kết quả | ffprobe hợp lệ, audio/subtrack đúng preset, runtime không sai đáng kể |

## Bộ kiểm thử phải có
- Hiện đại: đối thoại nam/nữ, tức giận, nói nhỏ, nói đùa.
- Cổ trang: xưng hô/địa vị, quan hệ, thành ngữ.
- Hài: chơi chữ và hàm ý chứ không dịch máy literal.
- Chồng lời: hai người nói cùng lúc; tiếng ồn nhạc nền lớn.
- Lời xa / video thiếu mặt / lời thoại ngoài khung.
- Softsub, hard-sub 1 dòng, hard-sub 2 dòng, text đè mặt, chuyển động nhanh.
- Video 9:16, 16:9, VFR, 30 phút+, tên file Unicode, lỗi tải giữa chừng.
- Xuất mp4 xem trên trình phát phổ biến, đầy đủ dấu tiếng Việt và lip/audio sync.

## Chỉ số kỹ thuật nên đo
- Speech coverage = số speech spans được xử lý / tổng speech spans phát hiện; so thủ công mẫu vì VAD có false negatives.
- Translation ID coverage = số utterance có bản dịch hoặc flag / tổng utterance.
- Meaning issues/100 utterance (human review); name/number/negation preservation.
- Diarization error rate (DER) khi có nhãn chuẩn, theo bộ test.
- Subtitle timing absolute error, over-2-line count, max CPS, overlap violations.
- Visual artifact frequency + residual original text rate trên clip kiểm mẫu.
- Dub completeness, speaker consistency, clipping samples, audio-video alignment.
- Resume success, batch fail/retry rate, peak VRAM/RAM/disk, processing time per media minute.

## Quy tắc release
Một job chỉ hiển thị **Hoàn tất** sau khi output tồn tại, kiểm tra được bằng ffprobe, các gate bắt buộc PASS và review flags được người dùng chấp nhận. Còn chỗ thiếu nghĩa/âm thanh phải hiển thị rõ **Cần duyệt**.


---

# TOOL MATRIX — Ưu tiên không trả phí API khi chạy local

| Khâu | Công cụ đề xuất | Lưu ý |
|---|---|---|
| Tải video được phép | yt-dlp | Nền tảng có thể thay đổi; không hứa hẹn bỏ watermark/DRM |
| Phân tích + encode | FFmpeg/ffprobe | Kiểm tra license của bản build và codec |
| Shot detector | PySceneDetect | Cắt shot ≠ hiểu cốt truyện |
| VAD | Silero VAD | Không phải ASR, chỉ tìm đoạn tiếng nói |
| Tách giọng/nhạc | Ultimate Vocal Remover | Kết quả không hoàn hảo với thoại chồng/nhạc |
| ASR Trung + cảm xúc | SenseVoiceSmall / FunASR | Bản Small hỗ trợ zh/yue/en/ja/ko; emotion tag không thay thế phân tích ngữ cảnh |
| Timing và người nói | WhisperX + pyannote community-1 | Cần thiết lập model; diarization có thể sai |
| OCR Trung | PaddleOCR | Chọn đúng model Chinese cho hardsub |
| Dịch thoại/QA | Qwen3 local + llama.cpp | Chất lượng phụ thuộc model, prompt, VRAM và ngữ cảnh |
| Xóa hard-sub | YaoFANGUK/video-subtitle-remover | Kết quả cần đánh giá theo cảnh |
| Sub edit + QC | Subtitle Edit 5 | Có local STT, OCR, timing, subtitle style |
| ASS render | libass | Kiểu .ASS cần font hỗ trợ tiếng Việt |
| TTS Việt local | VieNeu-TTS nhánh mã nguồn mở | Xem đúng license phiên bản weights; clone chỉ khi có quyền |
| Rendering | FFmpeg | soft/hard subs khác nhau |

## Quy tắc chọn công cụ
- Không tự xây lại model nhận dạng nếu công cụ có sẵn đã đáp ứng chất lượng.
- Model chưa tải không có nghĩa offline-ready. Cache model local, kiểm network dependencies.
- Không gọi API thương mại trừ khi người dùng chủ động bật chế độ tương ứng.
- So sánh CLI/SDK, version pin, unit test và nghiệm thu E2E trên cùng bộ clip.
- ProPainter gốc có license **chỉ phi thương mại**: không mặc định tích hợp vào sản phẩm thương mại.
- Các thư viện có thể có license khác với model weights, font hay các binaries đóng gói.

## Trạng thái thực tế
Đây là **công cụ ứng viên đã đối chiếu tài liệu GitHub**. Không phải danh sách các engine đã tích hợp hoặc chạy thành công trong DouViet Studio.


---

# LỘ TRÌNH HỌC / TRIỂN KHAI

## Trình tự để đạt kết quả sớm

### Giai đoạn 1 — Phụ đề Việt có nghĩa, không word-by-word
**Học:** Python cơ bản, JSON, ffprobe, ASR, Context Window, Prompting, semantic QA, SRT, FFmpeg.
**Làm:** video tải lên → Chinese ASR → story bible → Qwen3 translate 2-pass → SRT → MP4 (khi source không có hard-sub).
**Đầu ra nghiệm thu:** có file MP4 đúng tiếng Trung + sub Việt, tự nhiên, không mất câu.

### Giai đoạn 2 — Phụ đề hình đẹp và khôi phục nền
**Học:** OCR Chinese, bbox/mask, temporal video inpainting, style ASS, font metrics, rendering.
**Làm:** nhận diện sub cứng → mask → khôi phục → render ASS; UI kiểm vùng xóa.
**Đầu ra nghiệm thu:** trước/sau cùng cảnh, không che dải đen và không còn sub Trung mục tiêu.

### Giai đoạn 3 — Lồng tiếng từng nhân vật
**Học:** diarization, audio stem separation, TTS Việt, voice direction, audio mix, loudness.
**Làm:** cast mapping + 2-3 voice presets, utterance TTS, ghép music/SFX.
**Đầu ra nghiệm thu:** nhất quán giọng; người nghe hiểu câu mà không cần phụ đề.

### Giai đoạn 4 — Studio tự động hàng loạt
**Học:** queue/DAG, metadata/provenance, SQLite, checkpoint, retry, GPU scheduling, logs, monitoring.
**Làm:** nhập danh sách video, xử lý resume sau tắt máy, review queue, báo cáo QA, export assets.
**Đầu ra nghiệm thu:** hàng loạt có lỗi vẫn tiếp tục video khác, không âm thầm bỏ câu.

## Năng lực người triển khai cần
- Python/CLI/FFmpeg, JSON/SQL, Git và quản lý virtualenv.
- Ngôn ngữ Trung-Việt và biên tập thoại hoặc người kiểm duyệt có năng lực tương đương.
- ASR/speech signal processing, NLP/LLM prompting, basic computer vision.
- Subtitle typographic workflow, ASS/SRT, video codec/export.
- Hệ thống backend/local agent, xử lý job dài và UI trạng thái.

## Thứ tự ưu tiên P0
01 media/probe → 05 ASR → 07 story → 08 dịch nghĩa → 09 thoại tự nhiên → 11 QA → 14 timing → 15 subtitle style → 19 render → 21 QA. Song song: OCR/hard-sub removal là P0 khi video gốc có phụ đề cứng.


---

---
name: douviet-01-video-acquisition
description: Thu thập hợp pháp video từ liên kết, file hoặc danh sách/kênh được phép; bảo toàn metadata.
priority: P1
---

# SKILL 01 — Tiếp nhận và tải video

## Mục tiêu
Thu thập hợp pháp video từ liên kết, file hoặc danh sách/kênh được phép; bảo toàn metadata.

## Đầu vào
URL/file/danh sách URL, quyền sử dụng, tùy chọn tải, bộ lọc kênh.

## Quy trình chuẩn
1. Kiểm tra quyền xử lý và xác nhận loại nguồn; tránh nội dung DRM và nguồn không được phép.
2. Dùng yt-dlp khi extractor hỗ trợ; chọn định dạng và lưu metadata/video_id để chống tải trùng.
3. Cho phép nhập URL lô, playlist/kênh khi nền tảng cho phép; phân trang, retry có giới hạn, tiếp tục tải dở.
4. Kiểm tra hash, kích thước, thời lượng, stream và quyền truy cập; fallback upload thủ công khi extractor thay đổi.

## Đầu ra theo hợp đồng
source.mp4 hoặc container gốc, download_manifest.json, provenance.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Mỗi đầu vào được ghi trạng thái success/error rõ ràng; không báo ready khi chưa có file hợp lệ.
- Tải một kênh không tự động đồng nghĩa tải được mọi video hoặc bỏ watermark thành công.

## Công cụ ưu tiên
yt-dlp, ffprobe/FFmpeg. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Extractor lỗi, video riêng tư/DRM, hết dung lượng, trùng ID; giữ lỗi có thể khôi phục. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-02-media-profiling
description: Đọc chính xác stream, container, frame rate, VFR, aspect ratio, audio mapping và phụ đề mềm.
priority: P0
---

# SKILL 02 — Phân tích và chuẩn hóa media

## Mục tiêu
Đọc chính xác stream, container, frame rate, VFR, aspect ratio, audio mapping và phụ đề mềm.

## Đầu vào
source video, download_manifest.

## Quy trình chuẩn
1. Dùng ffprobe lấy streams, duration, color range, SAR/DAR, rotation, audio channels, audio/subtitle track.
2. Phân biệt phụ đề mềm (track riêng) và hard-sub (nằm trong pixel); ưu tiên tháo track mềm thay vì inpainting.
3. Trích proxy audio 16 kHz mono cho ASR nhưng giữ audio gốc chất lượng cao cho xuất cuối.
4. Dùng timestamp PTS thay vì giả định FPS cố định; lưu offset và đồng bộ theo timeline gốc.

## Đầu ra theo hợp đồng
media_info.json, asr_proxy.wav, source_tracks.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không sai thời lượng đáng kể; phát hiện track âm thanh không khớp ngôn ngữ.
- Mỗi stream có chỉ số và mapping ổn định khi export.

## Công cụ ưu tiên
ffprobe, FFmpeg, PyAV. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
VFR lệch sync, video xoay, track nhiều ngôn ngữ, codec không đọc được. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-03-scene-segmentation
description: Tách shot và ghép các shot thành cảnh truyện để cung cấp ngữ cảnh.
priority: P1
---

# SKILL 03 — Phân đoạn cảnh và diễn giải hình ảnh

## Mục tiêu
Tách shot và ghép các shot thành cảnh truyện để cung cấp ngữ cảnh.

## Đầu vào
source video, timeline, sampled frames.

## Quy trình chuẩn
1. Phát hiện cut/fade bằng PySceneDetect; không giả định mỗi cut là một cảnh hội thoại mới.
2. Chọn keyframes đại diện, phân loại bối cảnh/thời gian, nhận diện người xuất hiện khi đủ căn cứ.
3. Ghép các shot thành scene dựa trên âm thanh, thời gian và tình tiết; gắn scene_id cho lời thoại.
4. Lưu mô tả cảnh có trích dẫn timestamp, đánh dấu suy luận chưa chắc chắn.

## Đầu ra theo hợp đồng
shots.json, scenes.json, keyframes/. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Ranh giới shot có timestamp hợp lệ; mô tả cảnh không suy đoán tên hoặc quan hệ khi thiếu chứng cứ.

## Công cụ ưu tiên
PySceneDetect, OpenCV, local vision model (tùy chọn). Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Cut nhanh, montage, chữ trên màn hình không phải lời thoại. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-04-audio-separation
description: Tách thoại với nhạc nền/hiệu ứng để ASR và lồng tiếng có chất lượng.
priority: P1
---

# SKILL 04 — Tách và làm sạch âm thanh

## Mục tiêu
Tách thoại với nhạc nền/hiệu ứng để ASR và lồng tiếng có chất lượng.

## Đầu vào
audio gốc đa kênh, timeline.

## Quy trình chuẩn
1. Giữ nguyên bản audio sạch trước khi xử lý; tạo bản phục vụ nhận dạng.
2. Dùng VAD để biết vùng có giọng nói; dùng UVR/Demucs khi âm thanh nền gây nhiễu hoặc cần giữ nền để dub.
3. Kiểm tra nhiễu, méo tiếng, tiếng vọng và mất phụ âm sau tách; không dùng stem méo làm nguồn xuất cuối.
4. Lưu speech stem và music/effects stem; quản lý offset bằng sample count.

## Đầu ra theo hợp đồng
speech.wav, bed.wav, vad_segments.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không cắt đầu/cuối từ; không mất hội thoại nhỏ tiếng.
- Độ dài và vị trí các stem khớp nguồn.

## Công cụ ưu tiên
Silero VAD, Ultimate Vocal Remover/Demucs, FFmpeg. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Giọng và nhạc trộn sâu, thoại chồng, tiếng thở/tiếng cười bị lọc mất. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-05-chinese-asr
description: Transcribe Mandarin/Cantonese nếu model hỗ trợ, tên riêng, tiếng lóng và tiếng ngắt quãng.
priority: P0
---

# SKILL 05 — Nhận dạng lời thoại tiếng Trung

## Mục tiêu
Transcribe Mandarin/Cantonese nếu model hỗ trợ, tên riêng, tiếng lóng và tiếng ngắt quãng.

## Đầu vào
speech.wav, VAD segments, OCR text cues.

## Quy trình chuẩn
1. Nhận dạng ngôn ngữ/biến thể; chọn model hỗ trợ đúng vùng tiếng nói, ví dụ SenseVoiceSmall cho zh/yue.
2. Chạy ASR theo cụm có chồng biên, gom lại loại trùng; tận dụng OCR như nguồn tham khảo không tự động ghi đè ASR.
3. Lưu chính văn tự, dấu câu, confidence, lựa chọn n-best/uncertain spans; xử lý số, tên, đơn vị.
4. Đối chiếu đoạn im lặng và khoảng thời gian không có câu: không tự sáng tác khi ASR bất định.

## Đầu ra theo hợp đồng
transcript_zh.json, uncertainty_queue.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Kiểm soát không mất câu; ASR độ tin cậy thấp phải được đánh dấu.
- Với bộ test chuẩn có transcript gốc, đo CER riêng theo thể loại/giọng.

## Công cụ ưu tiên
SenseVoice / FunASR, Whisper/faster-whisper fallback. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Tên nhân vật, khẩu ngữ, giọng địa phương, thoại chồng, hallucination trên im lặng. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-06-speaker-diarization
description: Giữ đúng lượt thoại, tránh thay đổi đại từ nhân xưng khi chuyển cảnh.
priority: P0
---

# SKILL 06 — Phân biệt người nói

## Mục tiêu
Giữ đúng lượt thoại, tránh thay đổi đại từ nhân xưng khi chuyển cảnh.

## Đầu vào
speech.wav, ASR segments, video frames.

## Quy trình chuẩn
1. Diarization tạo ID vô danh như speaker_01; chưa tự suy ra tên người thật.
2. So khớp lượt thoại với cảnh/miệng nhân vật khi hình đủ rõ; hỗ trợ thoại ngoài màn hình.
3. Phát hiện câu chồng nhau và gắn overlap_flag; cho phép 2 speaker cùng timestamp.
4. Tạo bảng mapping speaker↔character có độ tin cậy và chỉnh thủ công khi cần.

## Đầu ra theo hợp đồng
speakers.json, diarized_utterances.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không gộp hai người khác nhau khi thiếu căn cứ; câu trùng thời gian không bị xóa.

## Công cụ ưu tiên
pyannote.audio community-1, WhisperX diarization. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Cùng giới tính/giọng, tiếng hét, âm thanh điện thoại, chồng thoại. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-07-character-story-bible
description: Xây story bible nhất quán xuyên các scene, tập phim và batch.
priority: P0
---

# SKILL 07 — Bộ nhớ nhân vật và cốt truyện

## Mục tiêu
Xây story bible nhất quán xuyên các scene, tập phim và batch.

## Đầu vào
scenes.json, diarized transcript, keyframes, previous project memory.

## Quy trình chuẩn
1. Tạo character_id, alias Trung/Việt, role, quan hệ, style_of_speech và xưng hô theo cặp.
2. Tóm tắt diễn biến từng cảnh dựa trên transcript và hình; giữ sự kiện và tình tiết chưa tiết lộ riêng.
3. Xây bảng thuật ngữ, địa danh, cấp bậc, cách dịch tên người; phân biệt cổ trang/hiện đại.
4. Trước mỗi lượt dịch, cấp ngữ cảnh trước/sau cùng bible; cập nhật bible sau khi kiểm tra tránh tích lũy lỗi.

## Đầu ra theo hợp đồng
story_bible.json, glossary.json, relationships.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Một nhân vật giữ tên và cách gọi nhất quán; không tự tiết lộ bí mật cốt truyện chưa xuất hiện.

## Công cụ ưu tiên
Qwen3/Qwen local, SQLite FTS, vector index tùy chọn. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Tên giống nhau, chuyển vai, kể chuyện trong quá khứ, quan hệ thay đổi. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-08-translation-semantic
description: Bảo toàn ý chính, sự kiện, phủ định, thời, sắc thái và thông tin chi tiết.
priority: P0
---

# SKILL 08 — Dịch Trung → Việt chuẩn ngữ nghĩa

## Mục tiêu
Bảo toàn ý chính, sự kiện, phủ định, thời, sắc thái và thông tin chi tiết.

## Đầu vào
transcript_zh, story_bible, glossary, timestamps.

## Quy trình chuẩn
1. Dịch theo nhóm hội thoại 30–90 giây có cửa sổ ngữ cảnh trước/sau; giữ ID và timestamp gốc.
2. Bắt buộc bảo toàn số, phủ định, danh xưng, tên riêng, nguyên nhân-kết quả và tình tiết.
3. Đưa 2–3 phương án khi thành ngữ/văn hóa khó và cờ cần kiểm duyệt.
4. Xuất bản dịch nghĩa trung gian trước khi biên tập tự nhiên để có thể đối chiếu.

## Đầu ra theo hợp đồng
semantic_vi.json, ambiguity_log.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không thêm/bớt nhân vật hoặc tình tiết; mỗi utterance gốc có output hoặc trạng thái ngoại lệ.

## Công cụ ưu tiên
Qwen3 local qua llama.cpp/Ollama. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Câu tỉnh lược chủ ngữ, chơi chữ, câu chửi, đơn vị tiền, thành ngữ. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-09-dialogue-localization
description: Chuyển bản dịch chính xác thành thoại giàu sắc thái như con người, không dịch word-by-word.
priority: P0
---

# SKILL 09 — Biên tập thoại Việt tự nhiên

## Mục tiêu
Chuyển bản dịch chính xác thành thoại giàu sắc thái như con người, không dịch word-by-word.

## Đầu vào
semantic_vi, zh original, story_bible, genre preset.

## Quy trình chuẩn
1. Giữ sự thật rồi viết lại đúng phong cách nhân vật: đời thường/cổ trang/hài/action.
2. Rút gọn câu cho thời lượng và đọc dễ; không làm thay đổi hàm ý, giới tính, vai vế, danh xưng.
3. Dựa quan hệ hai phía để chọn anh/em, cậu/tớ, tôi/anh, ngươi/ta...; không áp một hệ xưng hô cho mọi scene.
4. Đặt câu theo nhịp Việt, giữ punchline, tránh lặp từ máy móc; phương án phụ thuộc độ mạnh của cảm xúc.

## Đầu ra theo hợp đồng
localized_vi.json, style_decisions.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Người Việt đọc tự nhiên; sự khác biệt với bản nghĩa được kiểm tra bằng semantic QA.

## Công cụ ưu tiên
Qwen3 local, style guide corpus đã được cấp quyền. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Tự viết lại quá đà, dịch dài hơn khả năng hiển thị, lệch ngữ cảnh nhân vật. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-10-emotion-pragmatics
description: Nhận ra tức giận, mỉa mai, đe dọa, bông đùa, thờ ơ, xấu hổ và chuyển sắc thái.
priority: P1
---

# SKILL 10 — Giải mã cảm xúc và dụng ý

## Mục tiêu
Nhận ra tức giận, mỉa mai, đe dọa, bông đùa, thờ ơ, xấu hổ và chuyển sắc thái.

## Đầu vào
audio emotion tags, transcript, scene description, relationships.

## Quy trình chuẩn
1. Đối chiếu ngữ điệu với từ ngữ và biểu cảm thị giác; không chỉ dựa một nhãn từ ASR.
2. Đánh dấu emotion, intensity (0–1), speech_act (ra lệnh, chất vấn, đùa, cầu xin...).
3. Kiểm tra câu giễu cợt, từ đa nghĩa và các cảnh đổi cảm xúc giữa câu.
4. Điều chỉnh lựa chọn từ, dấu câu, độ ngắn dài; không thêm lời lẽ thô tục nếu bản gốc không có.

## Đầu ra theo hợp đồng
emotion_annotations.json, expressive_vi.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Emotion có căn cứ theo audio hoặc hình; người duyệt có thể sửa và ghi lý do.

## Công cụ ưu tiên
SenseVoice emotion tags, local LLM, optional video analysis. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Sarcasm trái nghĩa đen, khóc nói, cười đe dọa, âm thanh từ người ngoài khung. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-11-translation-qc
description: Bắt lỗi dịch thiếu, sai nghĩa, sai tên, đảo phủ định, bỏ câu và xưng hô không nhất quán.
priority: P0
---

# SKILL 11 — Kiểm tra chất lượng bản dịch

## Mục tiêu
Bắt lỗi dịch thiếu, sai nghĩa, sai tên, đảo phủ định, bỏ câu và xưng hô không nhất quán.

## Đầu vào
zh, semantic_vi, localized_vi, story_bible, ASR confidence.

## Quy trình chuẩn
1. Thực hiện kiểm tra ba bên zh↔dịch nghĩa↔thoại Việt; audit dữ kiện, số, tên, phủ định.
2. Phân tích continuity: nhân vật, xưng hô, timeline, thuật ngữ và bối cảnh trước/sau.
3. Xếp lỗi theo severity: critical (sai nghĩa), major (xưng hô/thiếu), minor (văn phong).
4. Tự sửa chỉ khi tự tin; các lỗi critical/độ tin cậy thấp yêu cầu review.

## Đầu ra theo hợp đồng
translation_qc.json, review_queue.json, corrected_vi.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không xuất trạng thái approved khi có lỗi critical chưa xử lý; tỷ lệ coverage kiểm bằng ID.

## Công cụ ưu tiên
LLM local reviewer độc lập, rule checks, human review queue. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Cả 2 vòng LLM cùng mắc một lỗi, thông tin văn hóa không chắc chắn. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-12-subtitle-ocr
description: Phân biệt chữ thuộc nội dung phim với phụ đề gốc; trích OCR để hỗ trợ bản dịch.
priority: P0
---

# SKILL 12 — Nhận diện phụ đề Trung trong video

## Mục tiêu
Phân biệt chữ thuộc nội dung phim với phụ đề gốc; trích OCR để hỗ trợ bản dịch.

## Đầu vào
keyframes, video frames, media_info, ASR.

## Quy trình chuẩn
1. Dò vùng chữ theo thời gian, kích thước, vị trí, màu sắc, độ bền giữa frame.
2. Nhận diện dòng Chinese và bbox; không xóa biển báo, bảng hiệu hay nội dung đồ họa có chủ ý.
3. Ghép cùng một dòng qua nhiều frame; tạo OCR cues để đối chiếu ASR.
4. Phân loại softsub/hardsub/mixed/none; xuất confidence và mask sơ bộ.

## Đầu ra theo hợp đồng
ocr_segments.json, subtitle_tracks.json, masks/. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Bbox khớp vùng chữ; không coi mọi chữ trong video là phụ đề.

## Công cụ ưu tiên
PaddleOCR (chọn model hỗ trợ Trung), VSR. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Chữ nhiều dòng, bóng đổ, chữ trên khuôn mặt, biển hiệu, watermark. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-13-subtitle-removal
description: Tháo track phụ đề mềm hoặc dùng temporal inpainting khi chữ đã thành pixel.
priority: P0
---

# SKILL 13 — Xóa phụ đề cứng và khôi phục nền

## Mục tiêu
Tháo track phụ đề mềm hoặc dùng temporal inpainting khi chữ đã thành pixel.

## Đầu vào
source, OCR bbox/masks, type classification.

## Quy trình chuẩn
1. Với softsub, remux bỏ track; không inpainting.
2. Với hard-sub, tạo mask chính xác theo frame và track text; mở rộng vùng viền chữ vừa đủ.
3. Ưu tiên khôi phục dựa frame lân cận và các engine của Video Subtitle Remover; dùng preview để chọn phương án.
4. Chấm artifact/flicker và mất texture; retry ở scene khó với mask sửa tay; bảo toàn nội dung không phải phụ đề.

## Đầu ra theo hợp đồng
clean_video_intermediate, removal_qc.json, corrected_masks/. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không còn chữ Trung mục tiêu ở vùng đã duyệt; không tạo nhòe/chớp dễ nhận thấy.

## Công cụ ưu tiên
Video Subtitle Remover (bản gốc); VSR Pro tham khảo. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Phụ đề đè mặt, nền chuyển động nhanh, chữ che đối tượng không có frame sạch. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-14-subtitle-timing
description: Xác định start/end theo âm thanh và sức đọc của người Việt.
priority: P0
---

# SKILL 14 — Căn thời gian và ngắt dòng phụ đề

## Mục tiêu
Xác định start/end theo âm thanh và sức đọc của người Việt.

## Đầu vào
expressive_vi, alignment words, scene timeline, shot list.

## Quy trình chuẩn
1. Bám mốc lời Trung và thoại Việt; chỉnh ranh giới theo VAD/forced alignment nếu có.
2. Gộp/tách ý theo câu tiếng Việt nhưng giữ quan hệ utterance ID; tránh tách làm sai nghĩa.
3. Dùng target preset: tối đa 2 dòng, không quá 42 ký tự/dòng (cấu hình); tốc độ đọc mục tiêu 13–20 ký tự/giây tùy genre.
4. Tránh chớp phụ đề quá ngắn và treo quá lâu; không che cut đặc biệt khi có cách tốt hơn.

## Đầu ra theo hợp đồng
timed_vi.json, subtitles_vi.srt. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- start < end, timestamp trong duration, không đoạn chồng không được phép; mục tiêu CPS báo cáo riêng.

## Công cụ ưu tiên
WhisperX, Subtitle Edit, pysubs2. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Thoại nhanh, Việt dài hơn Trung, trùng người nói, lời hét ngắn. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-15-subtitle-design
description: Tạo kiểu chữ dễ đọc trên cả điện thoại và TV, có preset và override cần thiết.
priority: P0
---

# SKILL 15 — Thiết kế phụ đề đẹp theo thể loại

## Mục tiêu
Tạo kiểu chữ dễ đọc trên cả điện thoại và TV, có preset và override cần thiết.

## Đầu vào
timed_vi, frame dimensions, genre, safe zones.

## Quy trình chuẩn
1. Chọn font có đủ dấu Việt và bản quyền phù hợp, tránh lỗi dấu khi export.
2. Đặt safe area bottom, căn lề, stroke/shadow, chống trùng chữ hoặc UI nền tảng.
3. Phong cách mặc định: tối đa 2 dòng, trắng viền đen, không nền kín màn hình; preset cổ trang, drama, short form.
4. Thử trên khung hình tối/sáng và video dọc/ngang; hạn chế karaoke, animation gây mất tập trung.

## Đầu ra theo hợp đồng
subtitles_vi.ass, subtitle_style.json, preview_frames/. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không mất dấu, không lệch vùng an toàn, tương phản đủ ở sample khó.

## Công cụ ưu tiên
Subtitle Edit 5, Aegisub, libass. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Font không cài, wrap sai, video có aspect ratio khác, hiệu ứng quá lòe loẹt. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-16-vietnamese-tts
description: Tạo thoại Việt rõ chữ, ngữ điệu và giọng vùng miền phù hợp với nội dung.
priority: P1
---

# SKILL 16 — Tổng hợp giọng Việt offline

## Mục tiêu
Tạo thoại Việt rõ chữ, ngữ điệu và giọng vùng miền phù hợp với nội dung.

## Đầu vào
expressive_vi, voice map, timing targets, pronunciation dictionary.

## Quy trình chuẩn
1. Chọn engine TTS có hỗ trợ Việt thật sự; kiểm tra chất lượng dấu, số và từ Hán-Việt.
2. Chuẩn hóa văn bản nói: số, thời gian, tên riêng, ngắt nghỉ và viết tắt.
3. Tạo audio theo utterance/chunk và gắn metadata model/version/seed/preset.
4. Soát lỗi đọc sai, im lặng, mất câu, lặp âm; cho phép người duyệt thay câu và render lại từng câu.

## Đầu ra theo hợp đồng
tts_segments/*.wav, tts_qc.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không bỏ từ/âm tiết; đầu ra hữu dụng khi nghe không nhìn sub; không giả định cảm xúc TTS luôn đạt.

## Công cụ ưu tiên
VieNeu-TTS phiên bản mã nguồn mở; hệ TTS Việt local khác khi kiểm chứng. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Ngắt sai, giọng đều, sai tên, phiên bản model độc quyền trá hình. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-17-voice-character-matching
description: Giữ cùng một nhân vật là cùng một giọng xuyên scene/tập, có cường độ cảm xúc.
priority: P1
---

# SKILL 17 — Gán giọng theo nhân vật và sắc thái

## Mục tiêu
Giữ cùng một nhân vật là cùng một giọng xuyên scene/tập, có cường độ cảm xúc.

## Đầu vào
characters, speakers, voice options, emotion annotations.

## Quy trình chuẩn
1. Lập danh sách giọng nam/nữ, tuổi giọng, chất giọng, tốc độ phù hợp nhân vật; không suy tuổi/giới từ hình khi bất định.
2. Gán character_id→voice_preset cố định, cho phép manual override theo phân vai.
3. Tạo voice direction cho từng câu: tốc độ, ngắt, cường độ, cảm xúc theo khả năng engine.
4. Chỉ voice-clone khi có sự đồng ý và quyền sử dụng giọng; giọng mặc định là giọng tổng hợp được cấp phép.

## Đầu ra theo hợp đồng
voice_cast.json, directed_tts.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Nhân vật không đổi giọng vô cớ; không dùng voice cloning trái phép.

## Công cụ ưu tiên
VieNeu-TTS với voice preset phù hợp. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Nhầm speaker→nhân vật, giọng quá giống nhau, TTS không hỗ trợ điều khiển cảm xúc. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-18-audio-mixing
description: Mix giọng Việt vào timeline mà không nuốt nhạc/tiếng động và không clip đỉnh.
priority: P1
---

# SKILL 18 — Ghép lồng tiếng, nhạc nền, hiệu ứng

## Mục tiêu
Mix giọng Việt vào timeline mà không nuốt nhạc/tiếng động và không clip đỉnh.

## Đầu vào
tts segments, source voice stem, bed stem, timeline.

## Quy trình chuẩn
1. Giữ tiếng động/nhạc nền hợp pháp với video; cân chỉnh bed và giọng theo cảnh.
2. Căn từng đoạn bằng time stretch nhẹ và khoảng nghỉ; không ép tốc độ đến mức méo tiếng.
3. Ducking theo giọng Việt; loudness và true peak theo preset xuất (nêu rõ preset, không coi là chuẩn tuyệt đối).
4. Render stereo/multichannel theo lựa chọn; nghe kiểm với tai nghe và loa điện thoại.

## Đầu ra theo hợp đồng
dub_mix.wav, audio_metrics.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không có clipping, thoại dễ nghe, lệch lời ít; không có khoảng lặng do thiếu TTS.

## Công cụ ưu tiên
FFmpeg filters loudnorm/sidechaincompress/atempo, pydub. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Giọng và hiệu ứng không tách sạch, ducking quá mạnh, phô khi biến tốc. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-19-video-rendering
description: Ghép hình sạch, audio và phụ đề; hỗ trợ hard/soft subtitles và file project.
priority: P0
---

# SKILL 19 — Xuất video đa định dạng

## Mục tiêu
Ghép hình sạch, audio và phụ đề; hỗ trợ hard/soft subtitles và file project.

## Đầu vào
clean video, ass/srt, audio mix, media profile, export preset.

## Quy trình chuẩn
1. Xuất lựa chọn: giữ audio Trung + Việt sub; dub Việt; song ngữ; sub mềm; sub cứng.
2. Dùng FFmpeg với libass cho phụ đề ASS; đảm bảo font/bản mã và tỷ lệ khung.
3. Ưu tiên remux khi chỉ thay softsub để tránh re-encode không cần thiết; hardsub cần encode video.
4. Đối chiếu duration, số stream, A/V sync, frame count, codec và file integrity trước gắn trạng thái complete.

## Đầu ra theo hợp đồng
final_vi.mp4, subtitles_vi.srt, subtitles_vi.ass, export_manifest.json. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Video mở được, có tiếng/sub như chọn, đúng thời lượng; file export không phải video gốc giả danh.

## Công cụ ưu tiên
FFmpeg, ffprobe, libass, mkvtoolnix (tùy chọn). Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Font thiếu, filter thoát lỗi, encode dở, luồng âm thanh sai, video trống. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-20-batch-orchestration
description: Một nút xử lý nhiều video dài; checkpoint, idempotency và resume.
priority: P0
---

# SKILL 20 — Tự động hóa hàng loạt và phục hồi

## Mục tiêu
Một nút xử lý nhiều video dài; checkpoint, idempotency và resume.

## Đầu vào
job manifest, media, profile/hardware, user presets.

## Quy trình chuẩn
1. Dùng pipeline dạng DAG với trạng thái pending/running/needs-review/succeeded/failed cho từng stage.
2. Lưu artifact trung gian/checksum/version/config để chạy lại chỉ phần lỗi.
3. Tách worker CPU, GPU, downloader, render; giới hạn cạnh tranh VRAM/disk và queue.
4. Quản lý chunk có overlap để không mất lời đầu/cuối; ghép timeline không trùng câu hoặc hở scene.

## Đầu ra theo hợp đồng
jobs.sqlite, job_status.json, outputs/, resumable checkpoints. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Dừng giữa chừng rồi resume không mất dữ liệu; báo lỗi nguyên nhân; không hiển thị 100% khi chưa đạt QA/export.

## Công cụ ưu tiên
Python asyncio/RQ/Celery/SQLite, FastAPI local backend. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Máy mất điện, đầy đĩa, timeout, API web frontend reload, hỏng checkpoint. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-21-quality-assurance
description: Đo riêng độ chính xác tiếng, nghĩa, phụ đề, hình, audio và tính đầy đủ.
priority: P0
---

# SKILL 21 — Đánh giá chất lượng đa tầng

## Mục tiêu
Đo riêng độ chính xác tiếng, nghĩa, phụ đề, hình, audio và tính đầy đủ.

## Đầu vào
all intermediates, test clips, gold references, QC config.

## Quy trình chuẩn
1. Thiết kế bộ test gồm: drama hiện đại/cổ trang/hài, giọng địa phương, 2+ người, chồng thoại, hard/softsub, 9:16/16:9.
2. Đo CER/WER khi có transcript chuẩn; độ phủ ID; sai tên/âm tiết; CPS/sub overlap; timing; video artifact; voice consistency.
3. Dùng golden clips và review mẫu bởi người biết Trung-Việt; ghi lỗi theo severity và người duyệt.
4. Gating release: zero unresolved critical; phát hiện subtitle tiếng Trung còn sót; xác thực đầu ra là video Việt.

## Đầu ra theo hợp đồng
qa_report.json, failure_samples/, acceptance.md. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Không đánh đồng test cấu trúc với chất lượng ngôn ngữ; có before-after thật để kiểm định.

## Công cụ ưu tiên
pytest, ffprobe, OpenCV, Subtitle Edit, human reviewer. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Tự chấm bằng cùng một model làm bản dịch, thiếu ground truth, bỏ qua video khó. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

---
name: douviet-22-local-infrastructure
description: Dùng CPU/GPU của máy và quản lý mô hình, phụ thuộc, quyền nội dung, an toàn.
priority: P1
---

# SKILL 22 — Môi trường AI cục bộ, bảo mật và giấy phép

## Mục tiêu
Dùng CPU/GPU của máy và quản lý mô hình, phụ thuộc, quyền nội dung, an toàn.

## Đầu vào
hardware profile, local model weights, license registry, storage configuration.

## Quy trình chuẩn
1. Chạy model inference tại PC/server của người dùng; website cloud chỉ điều phối nếu không có máy local sẽ không miễn phí hạ tầng.
2. Dựng local agent được người dùng cho phép, kết nối UI qua API có xác thực và kiểm soát nguồn file.
3. Khảo sát VRAM, RAM, dung lượng trống, CPU/GPU; dùng quantization/offloading và hạ batch size khi yếu.
4. Kiểm tra giấy phép mã nguồn, trọng số model, dữ liệu huấn luyện, font, video và giọng; ghi provenance, không bypass DRM.

## Đầu ra theo hợp đồng
hardware_profile.json, license_registry.json, model_registry.json, deployment_guide.md. Mỗi artifact phải gắn `project_id`, `source_hash`, `stage_version` và `generated_at` khi phù hợp.

## Tiêu chí nghiệm thu
- Mỗi engine có offline/online state và license rõ; không gửi dữ liệu đi ngoài ý muốn.

## Công cụ ưu tiên
llama.cpp/Ollama, Python venv, FFmpeg, container tùy chọn. Chỉ dùng phiên bản phù hợp license và phần cứng; có fallback khi công cụ không hỗ trợ file đầu vào.

## Rủi ro và cách xử lý
Máy web không có GPU, mô hình phải tải lần đầu, VRAM thiếu, license phi thương mại. Kích hoạt `needs_review` khi ảnh hưởng chất lượng đầu ra; không im lặng bỏ qua lỗi.

## Kiểm thử tối thiểu
- Test input hợp lệ + trường hợp trống hoặc lỗi rõ ràng.
- Test checkpoint và chạy lại cùng input không sinh bản ghi trùng.
- Test một video thật kèm timeline trước/sau; ghi log có thể truy ngược.

## Phụ thuộc
Xem `SKILL.md` tổng và `docs/ARCHITECTURE.md` để biết thứ tự chạy.


---

# PROMPT 1 — CHARACTER & STORY BIBLE (local LLM)

Vai trò: Biên kịch phụ trách tính liên tục và biên dịch hội thoại phim Hoa → Việt.
Dữ liệu đầu vào: `scene_description`, `zh_utterances`, `speaker_map`, `previous_story_bible` (nếu có).

Yêu cầu:
1. Tóm tắt đúng những gì có chứng cứ; tuyệt đối không bịa điều nhân vật không nói.
2. Xác định tên/biệt danh, quan hệ, đại từ gọi nhau, thể loại, mốc sự kiện.
3. Ghi `uncertain=true` nếu không đủ chứng cứ xác nhận tên người, họ hàng, địa vị.
4. Ghi trích dẫn `utterance_id` hoặc `scene_id` cho mỗi quan hệ/sự kiện suy ra.
5. Tránh spoiler từ các cảnh sau; story bible phải có `known_at_scene`.
6. Output chỉ JSON các khóa: `summary`, `characters`, `relationships`, `glossary`, `uncertainties`.

Kiểm tra: Nhân vật mới cần ID mới, không tự gộp hai người chỉ vì họ có cùng giọng hoặc trang phục.

# PROMPT 2 — SEMANTIC → NATURAL VIETNAMESE DIALOGUE

Vai trò: Biên dịch viên phim Trung → Việt; biên tập viên phụ đề Việt.
Inputs: JSON list `utterance_id`, `original_zh`, `speaker_id`, `scene_id`, `start_ms`, `end_ms`; `story_bible`; context 3–8 câu trước/sau; genre/style preset.

Quy trình phải theo thứ tự:
A. Hiểu nghĩa Trung: ai nói, nói với ai, hành vi lời nói, hàm ý, tình cảm, thông tin cốt lõi.
B. Dịch đúng nghĩa sang Việt (`semantic_vi`), bảo toàn mọi phủ định, số, vai vế, tên.
C. Chỉnh thoại tự nhiên (`localized_vi`): xưng hô đúng quan hệ, giữ cảm xúc, gãy gọn theo thời lượng, không máy móc word-by-word.
D. Đánh dấu thuật ngữ, tên, câu mơ hồ và cần kiểm duyệt (`review_required`, `review_reason`).

Ràng buộc:
- Không tự thêm lời thoại hoặc làm sai cốt truyện.
- Không chép lại văn bản Trung vào `localized_vi` trừ tên riêng/cố ý.
- Mỗi input ID phải có 1 output cùng ID, đúng thứ tự.
- Có thể sửa cách chia phụ đề sau, không đổi thời điểm ở bước dịch.
- Không tạo nội dung chỉ vì audio thiếu.
- Output JSON array: `utterance_id`, `semantic_vi`, `localized_vi`, `speaker_id`, `emotion`, `review_required`, `review_reason`.

Ví dụ phân biệt:
- zh: 你还知道回来啊？ context vợ tức giận vì chồng về muộn → vi: “Anh còn biết đường về cơ đấy?”
- zh: 你给我等着！ context bạn bè nói đùa → vi: “Được lắm, cứ chờ xem!”

# PROMPT 3 — INDEPENDENT TRANSLATION QA

Vai trò: Trợ lý kiểm định bản dịch độc lập (reviewer). KHÔNG tự cho điểm tốt chỉ vì văn hay.
Inputs: `original_zh`, `semantic_vi`, `localized_vi`, `story_bible`, `speaker_map`, `glossary`.

Kiểm tra từng ID:
1. Phủ định/khẳng định, chủ thể, đối tượng, số lượng, địa điểm, thời gian, tên, cấp bậc.
2. Thiếu lời hoặc thêm tình tiết không có trong bản gốc.
3. Xưng hô và cách nói có nhất quán nhân vật không.
4. Thái độ: xin lỗi, mỉa mai, ra lệnh, dọa nạt, nhờ vả; có bị mất hoặc đảo không.
5. Độ tự nhiên khi nói bằng tiếng Việt; có vừa mức thời lượng không.
6. Lỗi OCR/ASR nghi vấn, chỗ không chắc chắn.

Output JSON mỗi câu: `utterance_id`, `severity` ('none','minor','major','critical'), `category`, `evidence_zh`, `explanation_vi`, `fix_vi`, `needs_human_review`.
Cấm: sửa bản dịch khi chưa thấy bằng chứng, che lỗi critical, tự tạo tên hay sự kiện.

# NGUỒN THAM KHẢO ĐÃ ĐỐI CHIẾU (22/10/2026)

- yt-dlp: https://github.com/yt-dlp/yt-dlp
- FFmpeg: https://ffmpeg.org/
- PySceneDetect: https://github.com/Breakthrough/PySceneDetect
- Silero VAD: https://github.com/snakers4/silero-vad
- Ultimate Vocal Remover: https://github.com/Anjok07/ultimatevocalremovergui
- SenseVoice: https://github.com/QwenAudio/SenseVoice
- WhisperX: https://github.com/m-bain/whisperX
- pyannote.audio: https://github.com/pyannote/pyannote-audio
- Qwen3: https://github.com/QwenLM/Qwen3
- llama.cpp: https://github.com/ggml-org/llama.cpp
- PaddleOCR: https://github.com/PaddlePaddle/PaddleOCR
- Video Subtitle Remover (upstream): https://github.com/YaoFANGUK/video-subtitle-remover
- Video Subtitle Remover Pro (fork): https://github.com/SysAdminDoc/VideoSubtitleRemover
- Subtitle Edit: https://github.com/SubtitleEdit/subtitleedit
- libass: https://github.com/libass/libass
- VieNeu-TTS open-source fork references: https://github.com/NTC95/vieneu-tts
- ProPainter reference, non-commercial restriction: https://github.com/sczhou/ProPainter

Tài liệu hướng dẫn không khẳng định mỗi dự án/mô hình đều có giấy phép phù hợp thương mại hoặc có thể tích hợp trực tiếp. Cần rà soát `LICENSE`, model card, weights, binary dependencies và font cho từng bản chính xác.
