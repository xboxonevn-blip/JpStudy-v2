# Agent Directives

Các directive này định nghĩa cách agent phải làm việc trên JpStudy. Áp dụng
chồng lên luật repo trong `CLAUDE.md`, `AGENTS.md`, và brief hiện tại.

## Directive A - Commit Theo Batch

Commit theo batch khoảng 5 lesson/mục: một commit cho mỗi batch, gộp thay đổi
nội dung và ghi chú live-proof vào chung commit đó. Không tách 2 commit cho mỗi
lesson. Mỗi batch deploy một lần. Conventional Commits, subject tối đa 72 ký
tự, commit thẳng `main`.

## Directive B - Hàng Đợi Ưu Tiên

Làm theo `docs/research/quality-backlog.md` đúng thứ tự ưu tiên: P0, bảo mật,
hoặc hỏng chức năng trước P1 trước P2; hoàn tất việc đang dở trước khi mở
workstream mới; không nhảy vượt thứ tự ưu tiên owner đã đặt.

### Crawl/source ban

Không search, crawl, scrape, fetch, hoặc browse `https://nhaikanji.com/` hay
`https://thocodehoctiengnhat.com/`. Hai site này có cơ chế chặn crawl, có thể
ban IP/tài khoản owner. Chỉ dùng PDF/file local owner đã cung cấp từ các nguồn
đó.

## Directive C - Gate Khớp Với Thay Đổi (Token Không Giới Hạn)

Chỉ chạy phần kiểm chứng mà thay đổi đó thực sự có thể làm hỏng:

- Batch chỉ sửa nội dung JSON: chạy focused test nội dung/DB/reachability/
  taxonomy cùng các guard là đủ.
- Full `flutter test`: chỉ chạy một lần khi xong trọn một cấp, hoặc khi sửa
  logic Dart không tầm thường - không phải mỗi batch.
- `flutter analyze`: chỉ khi có sửa code Dart.

Chỉ lấy PASS/FAIL và tên test fail, không nuốt log xanh dài; trích đúng entry
cần từ file tham khảo lớn. "Hiệu quả" nghĩa là không kiểm chứng thừa, KHÔNG
phải thu hẹp phạm vi hay làm hời hợt. Token được dùng thoải mái.

## Directive D - Làm Việc Liên Kết, Toàn Diện, Triệt Để

Đây là cách làm bao trùm mọi task. Đọc kỹ phần vấn đề để hiểu vì sao.

### Vấn Đề

Loop cũ làm việc kiểu silo: mỗi task chỉ chăm chăm đúng một việc; khi verify
bằng Playwright chỉ kiểm đúng cái vừa sửa; không nhìn cả màn hình; không phát
hiện vấn đề liên đới. Hệ quả: xong A thì lòi ra B, phải quay lại sửa, tốn công
gấp bội.

Bằng chứng owner đã thấy trên live:

- Loop source-verify + live-proof xong grammar N2, nhưng cùng màn đó phần ví
  dụ trống rỗng; nút "Luyện tập để hiểu" mở ra màn trống "Hiện không có từ đến
  hạn". N3/N4/N5 thì có bài. Loop nhìn thẳng vào màn đó mà không thấy vì chỉ
  kiểm đúng field formation/explanation vừa sửa.
- Copy tiếng Việt vỡ: "Một chuỗi ngắn để chặn rơi nhỏ, và điểm yếu...".
- Nhãn nội bộ như `D1` lòi ra giao diện người dùng.
- Kana có nút "Tôi đã thuộc" để người dùng tự khai khống, không kiểm tra gì.
- Quy tắc Hán Việt là trang danh sách tĩnh, không nối với học kanji, nên vô
  dụng trong flow học thật.

Đây chỉ là vài ví dụ. Owner không thể liệt kê hết; agent phải tự phát hiện lỗi
cùng kiểu.

### Token

Owner không yêu cầu tiết kiệm token. "Hiệu quả" nghĩa là mỗi lần làm gì thì
làm triệt để và nhìn toàn cảnh để không sinh vòng sửa lại.

Quy tắc cũ "đừng chạy test không liên quan, đừng nuốt log rác" vẫn đúng. Nhưng
tuyệt đối không được dùng các quy tắc đó làm cớ để thu hẹp phạm vi, bỏ audit,
verify hời hợt, hoặc làm cho xong. Chi token cho audit sâu, nghiên cứu, verify
toàn diện là chi đúng.

### Phương Pháp Bắt Buộc

1. Audit/nghiên cứu trước để có tầm nhìn. Trước khi sửa, audit khu vực và các
   tính năng liên quan, hiểu chúng nối với nhau ra sao. Không sửa mù.
2. Verify toàn màn hình, không chỉ field vừa sửa. Mỗi lần live-test một màn,
   bấm thử mọi nút/CTA; kiểm nội dung đã đầy đủ chưa, ví dụ có thật không, CTA
   có chạy không, copy tiếng Việt có tự nhiên không, có nhãn nội bộ/mã lòi ra
   không, layout có cân không, trạng thái rỗng/lỗi có hợp lý không, và các flow
   nối ra từ màn đó.
3. Phát hiện vấn đề liên đới. Thấy bất kỳ defect nào khác, dù ngoài task, phải
   ghi ngay thành ticket QA trong `docs/research/quality-backlog.md`. Sửa luôn
   nếu cùng khu vực, hoặc đưa vào queue. Không bỏ qua, không giả vờ không thấy.
4. Triệt để. Không tuyên bố task "xong" khi màn/flow đó còn lỗi hiển nhiên.
   "Xong" nghĩa là cả khu vực chạy đúng end-to-end, người học thật dùng được.
5. Tư duy liên kết. App là một hệ thống học tập nối liền, không phải các màn
   rời rạc.

### Nguyên Tắc Liên Kết

- Mọi nút "Tôi đã thuộc", "Đánh dấu đã học", hoặc self-attestation tương tự
  cho người dùng tự khai mà không kiểm chứng là anti-pattern. Phải thay bằng
  cổng luyện tập thật, gồm nhận biết/sản sinh và SRS, như hướng QA-A-008 đã làm
  cho grammar. Quét toàn app tìm mọi nút khống kiểu này, gồm Kana và các nơi
  khác, rồi thay hết.
- Grammar point phải đủ chuỗi: kết nối, giải thích, ví dụ thật, cổng luyện tập
  chạy được, và SRS.
- Quy tắc Hán Việt phải tích hợp vào màn học kanji. Học một kanji thì quy tắc
  Hán Việt liên quan phải hiện và dùng được ngay tại đó, không chỉ là trang tra
  cứu rời.
- Kana phải có vòng học thật: nhận diện, viết, và SRS. Không được chỉ là lưới
  bấm hoặc nút tự khai.
- Chia thể, từ vựng, và kanji phải nối với nhau theo QA-C-001.

### Hành Động Ngay Trước Khi Đi Tiếp Queue

Làm một audit trải nghiệm toàn app: đi từng màn, từng flow, đóng vai người học.
Kiểm nội dung đầy đủ, mọi CTA chạy thật, copy chuẩn, không nhãn nội bộ, các
tính năng có nối nhau không, layout có cân không.

Ghi audit vào `docs/research/app-experience-audit-2026-05-20.md`. Mỗi defect
phải thành một ticket trong `docs/research/quality-backlog.md`. Sau đó sửa theo
batch holistic: sửa trọn một khu vực một lần, triệt để.

### Việc Cụ Thể Owner Đã Nêu

Với mỗi mục dưới đây, quét toàn app để tìm mọi chỗ cùng loại:

- Grammar N2/N3/N4 loop đã đánh "done" nhưng chưa thật sự done vì thiếu ví dụ
  và hỏng cổng luyện tập. Phải quay lại hoàn thiện; không đi tiếp N5/N1 bằng
  cách làm hời hợt tương tự.
- Grammar mọi cấp N5-N1: phần ví dụ phải có câu thật cho mọi điểm.
- Cổng "Luyện tập để hiểu" phải sinh bài cho mọi điểm ngữ pháp mọi cấp. N2
  đang ra màn trống; kiểm cả N5/N4/N3/N1.
- Copy tiếng Việt vỡ, ví dụ "chặn rơi nhỏ...", phải sửa và quét toàn app tìm
  copy dịch máy/sai ngữ pháp.
- Nhãn nội bộ `D1` lòi ra UI phải sửa và quét mọi nhãn nội bộ/mã lòi ra.
- Layout "Kế hoạch hôm nay" mất cân; rà các màn khác cùng loại.
- Kana: thay nút tự khai bằng vòng luyện tập thật và SRS.
- Quy tắc Hán Việt: tích hợp vào màn học kanji.

### Giữ Nguyên

Directive A (commit batch), Directive B (queue), và Directive C (gate khớp
thay đổi) vẫn áp dụng. Directive D là cách làm bao trùm.

`vi-source-verified` được dùng cho nội dung đã kiểm nguồn. Không thêm
`vi-human-approved`; chỉ owner được thêm sau khi review từng item.

Commit thẳng `main`, dùng Conventional Commits, không tạo branch nếu owner
không yêu cầu rõ.
