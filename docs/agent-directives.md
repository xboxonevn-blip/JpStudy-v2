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

## Directive E - Pedagogy & Human Voice

Đây là directive về **chất lượng giảng dạy + giọng văn con người**: mỗi
explanation, mnemonic, etymology, ví dụ, và feedback message Codex sinh ra
phải nghe như giáo viên thật giảng cho người học Việt, không phải database
dump hay máy dịch. Bổ sung lớp chất lượng cho mọi nội dung học, áp dụng
song song với Directive F (số lượng + cấu trúc).

### Persona bắt buộc - Dr. Linh-Phan-Trần

Khi viết explanation, mnemonic, etymology, hoặc cultural note: dùng giọng
văn của **Dr. Linh-Phan-Trần** — nhà ngữ học so sánh Việt-Nhật, giáo viên
15 năm dạy tiếng Nhật cho sinh viên Việt Nam, hiểu cả 2 nền văn hóa, nói
tiếng Việt tự nhiên (không Hán hóa máy móc, không dịch word-by-word từ
giáo trình tiếng Anh).

Văn phong:

- Câu ngắn, ý rõ. Không sa đà
- Analogy người Việt hiểu được (chữ Hán-Việt quen thuộc, ca dao, thành ngữ
  khi phù hợp)
- Cảnh báo bẫy người Việt thường mắc (lẫn は với が, lẫn お với を, lẫn
  trật tự bổ ngữ kiểu Việt-Nhật)
- Tự tin nhưng khiêm tốn, không phán xét người học
- KHÔNG sến súa kiểu AI bot ("Tuyệt vời! Bạn đã học được...")

### E.1 - Etymology-first (gốc rễ trước)

Mọi kanji, vocab có yếu tố Hán, grammar pattern: BẮT BUỘC trình bày gốc
rễ TRƯỚC khi yêu cầu nhớ.

- Kanji: bộ thủ + ý nghĩa nguyên thủy + evolution (oracle bone → modern
  nếu có data)
- Vocab Hán-Nhật: âm Hán-Việt + nghĩa từng yếu tố Hán
- Grammar: tại sao particle/copula có hình dạng đó (lịch sử + chức năng)

Nguồn tham khảo: Heisig *Remembering the Kanji*, Henshall *A Guide to
Remembering Japanese Characters*, Hadamitzky-Spahn *Kanji & Kana*. Dùng
KẾT HỢP, không copy-paste 1 nguồn.

### E.2 - Hán-Việt Bridge Principle (cầu nối Hán-Việt)

Người học Việt có lợi thế Hán-Việt mà người học Tây không có. KHAI THÁC
triệt để: mọi kanji/từ Hán-Nhật phải có sub-section "Cầu Hán-Việt":

- Âm Hán-Việt tương ứng (lấy từ Unihan kVietnamese)
- Quy tắc chuyển âm Nhật ↔ Hán-Việt nếu có pattern
- Từ tiếng Việt đã biết chứa yếu tố Hán đó (vd: 学 = "học" → "học sinh",
  "học tập", "đại học")

Đây là cầu nối ngắn nhất từ kiến thức cũ sang kiến thức mới — Cognitive
Load Theory + schema theory (Sweller 1988).

### E.3 - Depth-of-Processing Multi-Perspective

Mỗi concept quan trọng trình bày từ ít nhất **3 góc nhìn**:

1. **Hình thức** (form): cách viết, cách đọc, cấu trúc
2. **Ý nghĩa** (meaning): nghĩa đen, nghĩa bóng, sắc thái
3. **Sử dụng** (usage): context cụ thể, ví dụ thật, common mistake

Cơ sở: Craik & Lockhart 1972 "Levels of Processing" — depth của processing
quyết định durability của memory trace. Tránh single-line definition kiểu
từ điển khô.

Hỗ trợ Paivio 1986 Dual Coding Theory: kết hợp text + image + audio khi có.

### E.4 - Human Moment Rule (khoảnh khắc người)

Mỗi page nội dung dài (kanji detail, grammar detail, vocab cluster) phải
có ít nhất **1 "khoảnh khắc người"**: anecdote ngắn, lưu ý văn hóa, câu
nói giáo viên, hoặc mnemonic story. KHÔNG pure data dump.

Ví dụ phong cách:

- "Lưu ý nhỏ từ Dr. Linh: chữ 友 (bạn) ban đầu là hình 2 bàn tay nắm
  nhau — nên 2 nét bên dưới chính là 2 bàn tay đấy."
- "Người Việt hay nhầm: 友達 đọc là ともだち, KHÔNG phải ゆうたつ — vì đây
  là jukujikun (trộn 訓読み + 音読み)."
- "Particle は viết là 'ha' nhưng đọc là 'wa' khi làm trợ từ chủ đề —
  giống như chữ 'không' người Việt đọc 'hông' khi nói nhanh, lịch sử để
  lại thôi."

Không quá 2-3 câu/page. Không sến.

### E.5 - Research Ladder Obligatory (thang nghiên cứu bắt buộc)

Khi gặp uncertainty về 1 fact (kanji reading, từ nghĩa, grammar nuance):
Codex leo thang theo thứ tự, KHÔNG skip:

1. App data hiện có (`assets/data/content/...`)
2. JMdict / KANJIDIC2 (offline đã import)
3. Unihan kVietnamese (âm Hán-Việt)
4. Owner-provided local PDFs (Mimikara, Mina, kanji-vocab folders)
5. Wiktionary (CC-BY-SA, online)
6. Tatoeba (CC-BY example sentences)
7. Tae Kim Grammar Guide (CC-BY-NC-SA)
8. Research notes (`docs/research/...`)

KHÔNG hardcode guess. KHÔNG generic AI knowledge. Sau 8 bước vẫn không
chắc → OPEN_QUESTION blocking, cite gap.

CẤM tuyệt đối nguồn ngoài whitelist + ban list (Directive B + megaprompt
§13).

### E.6 - Interlink Semantic (liên kết ngữ nghĩa)

Khái niệm liên kết qua **graph ngữ nghĩa**, không chỉ qua hierarchy file.

Ví dụ:

- Kanji 学 (học) link tới: 学生, 大学, 学校, 学ぶ
- Grammar 「は」 link tới: contrast với 「が」, ví dụ phủ định, dẫn xuất
  「には」「では」
- Vocab 食べる link tới: conjugation forms, 食事, 食べ物, 食堂, antonym
  飲む

Directive F.4 (cross-link graph) ở layer dữ liệu; E.6 là rule **nội dung
phải kích hoạt** các link đó (anchor text, hover preview, "xem thêm" CTA
hiển thị giải thích ngắn ngay tại chỗ).

### E.7 - Teaching Test (kiểm tra dạy được)

Trước khi commit nội dung mới, tự hỏi:

> Nếu đưa nội dung này cho 1 người học mới hoàn toàn, họ có thể đọc và
> GIẢNG LẠI cho người khác không?

Nếu không → nội dung chưa đủ rõ, viết lại. Đây là pseudo-Feynman Technique
áp dụng vào content authoring.

Concrete check:

- Term lạ không define inline → fix
- Logic skip step → bổ sung
- Ví dụ thiếu context → thêm setting
- Conclusion không tự nhiên rút ra từ premise → restructure

### Tài liệu tham khảo (cite khi dùng)

- Heisig, James W. *Remembering the Kanji*. (mnemonic structure)
- Henshall, Kenneth G. *A Guide to Remembering Japanese Characters*.
  (etymology)
- Hadamitzky, Wolfgang & Spahn, Mark. *Kanji & Kana*. (radical-based)
- Krashen, Stephen. *The Input Hypothesis*. (1985)
- Paivio, Allan. *Mental Representations: A Dual Coding Approach*. (1986)
- Roediger, Henry L. & Karpicke, Jeffrey D. *Test-enhanced learning*.
  *Psychological Science* (2006). (backing F.1)
- Craik, Fergus & Lockhart, Robert. *Levels of processing*. *Journal of
  Verbal Learning* (1972). (backing E.3)
- Sweller, John. *Cognitive Load Theory*. (1988) (backing E.2)

### Áp dụng song song

Directive E KHÔNG thay thế A/B/C/D/F. Khi Codex viết explanation/mnemonic/
etymology, áp dụng E làm filter chất lượng cuối. Khi viết exercise content,
áp dụng F.1-F.3 cho số lượng + Bloom + distractor; E.4 cho human moment
trong feedback message.

## Directive F - Cross-link & Exercise Density

Đây là directive về chất lượng nội dung học: mật độ exercise đủ dày để
mastery xảy ra (testing effect), distractor đủ khó để phân biệt người học thật
với người đoán mò, và data đủ link để học một thứ kích hoạt nhớ lại thứ liên
quan (spreading activation).

### F.1 - Sàn mật độ exercise

Mọi item học (grammar pattern, vocab, kanji, conjugation form) BẮT BUỘC có:

- >= 10 ví dụ thật (audio + Vietnamese + source citation)
- >= 50 exercise questions đa dạng theo F.2 + Bloom progression F.3

Nếu data hiện có không đủ, bắt buộc generate thêm bằng pipeline auto-gen +
validation pass. Không có ngoại lệ. Không giảm sàn dưới mọi lý do.

Bằng chứng: Roediger-Karpicke 2006 (testing effect cần >= 4 retrievals);
JLPT thật có 30-50 câu/section, người học cần luyện ở scale tương đương.

### F.2 - Distractor JLPT-pattern (anti-trivial)

- Vocab: 1 đáp án đúng + 1 phonetic trap (DL distance 1-2 trên kana) + 1
  compound trap (kanji khác cùng reading) + 1 random same-level.
- Grammar: 1 đúng + 3 distractor từ wrong particle (は<->が, に<->で,
  を<->が, へ<->に), wrong tense (です<->でした, する<->した<->している),
  wrong politeness (です<->だ, ます<->る), wrong negation
  (ない<->ありません<->ません<->じゃない).
- Kanji: 1 đúng + 3 visual lookalikes (湿/温, 鳥/烏, 困/因, 末/未) từ
  pre-built lookalike corpus (KANJIVG SVG diff).
- Conjugation: 1 đúng + 3 forms khác cùng verb (ăn nhầm 食べた vs 食べる
  vs 食べない vs 食べたい).

Validator phải reject distractor trùng correct, distractor sai grammar form,
distractor duplicate.

### F.3 - Bloom progression

Mỗi item có exercise set cover đủ 4 cấp Bloom:

- L1 Remember: matching, basic MCQ
- L2 Understand: explain meaning, paraphrase
- L3 Apply: dùng item trong câu mới (production)
- L4 Analyze: chọn câu nào đúng grammar trong 4 option context-heavy

"Mastery" chỉ unlock khi pass L4. Không cho phép tự khai sau pass L1.

### F.4 - Cross-link graph (bi-directional)

Mọi item detail page BẮT BUỘC có section "Liên quan" 4 sub-section:
Grammar dùng item này / Vocab chứa item này (nếu kanji) / Kanji trong item này
(nếu vocab) / Conjugation forms (nếu verb/adj). Link sống, không stub.

### F.5 - Cross-modal SRS (anti self-attestation cứng)

Một item có N FSRSState độc lập (N = số mode được luyện). Phải pass tất cả mode
với accuracy >= 80% mới gọi "thuộc". Loại bỏ UI button "Tôi đã thuộc" tự khai.
`SRSStore.markKnown()` deprecated, throw nếu được gọi.

### F.6 - Conjugation anchor 2 vị trí

- Standalone (vị trí A): Menu Grammar có card top "Bảng chia thể động từ ·
  tính từ" -> page tổng hợp toàn bộ patterns với search/filter.
- Inline (vị trí B): ConjugationWidget conditional - chỉ render khi lesson có
  >= 1 verb/adj. Widget show list + button "Luyện chia thể (>=50 câu)" ->
  drill mode.

### F.7 - Reading comprehension first-class

Mỗi level:

- N5-N4: >= 10 passages mini 50-150 ký tự
- N3-N1: >= 20 passages 100-300 ký tự

Mỗi passage có 3-5 câu hỏi (main idea / detail / inference), tag với
grammars/vocabs/kanjis nó dùng.
