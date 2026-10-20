# HIEU Engineering Source Hub

Kho tổng hợp mã nguồn kỹ thuật và phần mềm của Hiếu. Mục tiêu: lưu trữ **nguồn gốc có thể kiểm chứng**, phân loại, hướng dẫn cài đặt, bảo trì và đối chiếu các bản phát hành.

> **Tình trạng:** Đang nhập dữ liệu theo từng đợt. Repository này chưa chứa toàn bộ mã nguồn từ các dự án. Không xem các nhánh thử nghiệm là phiên bản production.

## Danh mục dự án

| Nhóm | Thành phần | Tình trạng |
| --- | --- | --- |
| Autodesk Inventor / iLogic | BOM Universal, iProperties, Drawing BOM | Đang kiểm kê và nhập nguồn |
| Autodesk Inventor / Add-in | HIEU BOM TOOL PRO, PROJECT 1.1 / 5.1 / 5.3 | Chờ nguồn checkpoint đầy đủ |
| CAD/CAM | ICIMCO, ISIMCO, DSTV NC, AK / BO | Đang kiểm kê; experimental |
| AutoCAD / AutoLISP | HLOCALCOLOR, công cụ text, layout, block, PDF | Đang nhập nguồn |
| Tekla Structures | Macro / utilities | Chờ xác minh nguồn |
| Excel | VBA, BOM, đối chiếu trọng lượng và số lượng | Chờ xác minh nguồn |
| Website | DouViet Studio, dịch video Douyin | Chờ xác minh nguồn |
| Education | IELTS FIGHTER | Chờ nguồn checkpoint đầy đủ |

## Cấu trúc thư mục

- `inventor/ilogic/bom/`: iLogic quản lý BOM.
- `inventor/ilogic/cam-dstv/`: mã kiểm nghiệm CAM / đọc DSTV.
- `autocad/lisp/`: mã AutoLISP.
- `docs/`: inventory, source provenance, master handoff, tiến độ kiểm thử.
- `scripts/`: kiểm tra secrets, manifest và quy trình đồng bộ.

## Nguyên tắc nhập nguồn

1. Không tự viết lại code rồi gọi là nguồn gốc. Chỉ commit nội dung đã thu hồi đầy đủ.
2. Bảo tồn tên, phiên bản, checksum SHA-256; đánh dấu **legacy**, **experimental**, **candidate**, **released** rõ ràng.
3. Rà soát secret (API key, mật khẩu, token, DSN), dữ liệu công ty và quyền tác giả trước khi công khai.
4. Không tự động cấp license MIT cho file không được phép cấp phép lại. Phân biệt license của repository và license của các thành phần.
5. README của mỗi dự án nêu yêu cầu phần mềm, phiên bản Autodesk, cài đặt, sử dụng, lỗi đã biết, trạng thái build/test.
6. **Git tag** chỉ dành cho mốc được xác minh; **GitHub topics** dùng để tra cứu nhóm công nghệ, không tạo release giả.

## Trạng thái kiểm thử

Hiện chưa xác nhận build toàn bộ Add-in / iLogic và chưa có kết quả Inventor acceptance test cho các nhánh nhập về.

## Bảo mật

Không commit file chứa token, API key, cấu hình bí mật, dữ liệu khách hàng hay mã nguồn công ty không thuộc quyền công bố. Những credentials từng được chia sẻ trong chat phải được thu hồi và tạo mới trước khi sử dụng.

**Owner:** nguyenxuanhieu437-afk · **Catalog ID:** HIEU-ENG-SOURCE-2026-001
