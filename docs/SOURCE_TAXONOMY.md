# HIEU Engineering Source Hub — Source Taxonomy

Cập nhật: 2026-10-22. Mỗi nhóm có trạng thái: `legacy`, `experimental`, `candidate`, `released`, `pending-review`.

| Nhóm | Đường dẫn | Trạng thái kiểm kê |
|---|---|---|
| Inventor iLogic/BOM | `inventor/ilogic/bom/` | legacy/experimental, chưa nghiệm thu Inventor |
| Inventor CAM/DSTV | `inventor/ilogic/cam-dstv/` | experimental |
| Inventor C# Add-ins | `inventor/addins/` (dự kiến) | pending-review |
| AutoCAD LISP | `autocad/lisp/` | một phần đã nhập, các tool còn lại pending-review |
| Tekla | `tekla/` (dự kiến) | pending-review |
| Excel VBA | `excel/vba/` (dự kiến) | pending-review |
| IELTS Fighter | `education/ielts-fighter/` (dự kiến) | pending-review |
| DouViet Studio code | `web/douviet/` (dự kiến) | pending-review, không có bản build xác minh |
| DouViet localization specification | `docs/douviet/` | experimental documentation, V1.0 |
| DouViet Voice Casting / Audio Mixer V2 | `docs/douviet/VOICE_CASTING_AUDIO_V2.md` | experimental documentation, duplicate notes indexed once; no engine integration verified |

| Inventor iLogic K-Factor reference diagnostic | `inventor/ilogic/kfactor/experimental/` | experimental, source + SHA-256 manifest; static audit only; setter variants pending rights clearance |

Các thư mục “dự kiến” không đồng nghĩa mã nguồn đã được công khai. Mọi nhập nguồn phải có checksum, provenance, rà soát secrets và quyền phát hành.

| Inventor iLogic Drawing / Sheet Part Number | `inventor/ilogic/drawing/experimental/` | experimental; original source, README, checksum manifest; runtime untested |

| Inventor iLogic Drawing / Projected Dimension Audit | `inventor/ilogic/drawing/projected-dim/experimental/` | experimental; source + SHA-256 manifest; duplicate suppressed; runtime untested; global auto-fixer pending-review |
