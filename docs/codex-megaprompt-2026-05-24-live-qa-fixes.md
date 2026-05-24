# JpStudy v2 — Codex Mega-Prompt: Live-QA Fixes (2026-05-24)

> **Autonomous mode.** Token UNLIMITED. Online lookup AUTHORIZED (whitelist
> §S3 of `docs/codex-megaprompt-2026-05-24-final-audit.md`). Commit thẳng
> `main`. Apply Directive A-F. Batch ~5 items/commit. Live-verify Playwright
> 1920+390 sau mỗi phase.

Nguồn: Claude làm QA **thao tác thật như user** ~26 phút (Playwright, click/gõ/
submit/ráp câu, mọi mode + flow, desktop 1440 + mobile 390). Đây là các defect
+ gap **chỉ lộ ra khi operate**, không quét code ra được.

## §0 — VERIFIED WORKING (KHÔNG redo)

Đã test thật, chạy đúng — đừng đụng trừ khi §1-§4 yêu cầu:
- Exercise engine: MCQ, True/False (sai→đỏ✗+xanh✓ reveal), Typing/Gõ (gõ
  →100% scored), Reading/Đọc hiểu (passage+Q+timer), Sắp câu (chip assembly),
  Biến đổi (transformation), Phân biệt (Bloom L4), Sửa câu sai (Bloom L5)
- Grammar 50-câu sessions, 8 loại câu hỏi, KHÔNG trivial (owner complaint fixed)
- Exam: questions + countdown timer + navigator + 1190-câu bank + deferred scoring
- SRS review hub (due categories 0 = đúng cho fresh account)
- Kanji "Quy tắc Hán Việt" tab (rules mapping + bài tập áp dụng)
- Mobile layout sạch, no overflow, tappable
- 0 console errors

═══════════════════════════════════════════════════════════════
## §1 — P0 CRITICAL (beta blockers)
═══════════════════════════════════════════════════════════════

### P0-1 — Audio / Listening engine HOÀN TOÀN KHÔNG CHẠY (MAJOR)

**Evidence**: Không có audio package nào (pubspec thiếu audioplayers/just_audio),
không TTS/Web Speech/audio service file, `audio_url` 100% rỗng,
`ExerciseSource.ttsReady` flag + `ExerciseType.listening` enum tồn tại nhưng
KHÔNG có engine phát. → Nút 🔊 (flashcard/term/example), mode "Nghe", và 聴解
section của đề thi JLPT đều câm. Với app JLPT, listening = 1/4 kỹ năng thi.

**Action**:
1. Chọn chiến lược audio (log DECISION):
   - **Khuyến nghị: Web Speech API (SpeechSynthesis) cho web** — miễn phí,
     không bloat bundle, có sẵn giọng JP trên đa số browser/OS. Wrap qua
     `dart:js_interop` hoặc package `flutter_tts` (hỗ trợ web + mobile).
   - Fallback cho từ high-frequency: pre-generate audio (VOICEVOX OSS / open
     TTS) cache vào assets nếu Web Speech thiếu giọng JP.
2. Tạo `lib/core/audio/tts_service.dart`:
   - `speak(String text, {String lang='ja-JP', double rate=0.9})`
   - Detect giọng JP available; nếu không → graceful fallback (hiện hint
     "Trình duyệt không có giọng tiếng Nhật" thay vì câm im lặng)
3. Wire mọi 🔊 button: flashcard front/back, term list, example sentence,
   grammar example, reading passage.
4. **Nghe mode** (ExerciseType.listening): phát audio của từ/câu → user chọn
   nghĩa/đáp án. Implement đầy đủ (hiện scaffold-only).
5. **Exam 聴解 section**: phát audio câu hỏi listening trong mock exam.
6. Populate audio: vì dùng TTS runtime, `audio_url` rỗng OK — TTS đọc trực
   tiếp từ `term`/`reading`/`example.ja`. Đảm bảo đọc đúng reading (kana),
   không đọc kanji sai.
7. Live verify: click 🔊 trên flashcard → nghe được; vào Nghe mode → audio
   phát + answer logic chạy; exam listening section có tiếng.

**Acceptance**: 🔊 phát tiếng mọi nơi; Nghe mode functional end-to-end; exam
聴解 có audio; graceful fallback khi browser thiếu giọng JP. Log DECISION
chiến lược audio.

### P0-2 — Mobile "Thêm" menu TRỐNG

**Evidence**: Click tab "Thêm" (bottom nav mobile) → bottom sheet rỗng, chỉ có
nút "Bỏ qua", không menu item.

**Action**: File `lib/app/navigation/` (bottom nav / more-sheet widget). "Thêm"
sheet phải chứa các mục overflow không vừa bottom nav: Lộ trình, Hán tự (nếu
ẩn), Cài đặt, Hồ sơ, Giới thiệu, v.v. Populate sheet content. Live verify mobile.

**Acceptance**: "Thêm" sheet hiện menu items đầy đủ, mỗi item navigate đúng.

### P0-3 — Empty sheet STUCK cross-navigation (state bug)

**Evidence**: Sau khi mở "Thêm" (sheet rỗng), navigate sang trang khác → sheet/
dialog rỗng "Hộp thoại" DÍNH LẠI + chặn content trang mới (vocab catalog bị che
sau dialog rỗng; phải thủ công "Bỏ qua" mới truy cập được).

**Action**: Tìm overlay/sheet controller. Đảm bảo bottom sheet / dialog
**dismiss khi route thay đổi** (listen route change → close active overlays).
Bug có thể là: sheet dùng global overlay không bind vào route lifecycle. Fix:
bind sheet vào current route hoặc auto-dismiss on navigation.

**Acceptance**: Mở "Thêm" rồi navigate → sheet tự đóng, trang mới không bị che.
Live verify: Thêm → click nav item khác → content hiện ngay, không cần Bỏ qua.

═══════════════════════════════════════════════════════════════
## §2 — P1 (content/UX quality)
═══════════════════════════════════════════════════════════════

### P1-1 — Kanji Hán-Việt per-item integration (Directive D owner priority)

**Evidence**: "Quy tắc Hán Việt" là tab standalone (rich), NHƯNG mở 1 kanji cụ
thể (vd 学) chưa thấy âm Hán-Việt + quy tắc liên quan inline. Owner Directive D:
"học 1 kanji thì quy tắc Hán Việt liên quan phải hiện + dùng được ngay tại đó".

**Action** (= COMPLETE-2 của megaprompt 2026-05-24): mỗi kanji entry có
`hanViet` (từ Unihan kVietnamese) + link quy tắc chuyển âm liên quan + ví dụ từ
Việt cùng gốc Hán. Kanji detail screen có section "Cầu Hán-Việt" inline. Live
verify mở 学 → "học" + rule + ví dụ ("học sinh", "đại học").

### P1-2 — Vocab count mismatch (card vs data)

**Evidence**: Minna N5 Bài 1 card hiện "51 từ" nhưng data file có 40 entries.

**Action**: Tìm nguồn count hiển thị trên lesson card (manifest `item_count` vs
actual entries). Reconcile — count hiển thị = số entries thật. Quét mọi lesson
card cho count mismatch tương tự (vocab + grammar + kanji). Live verify.

### P1-3 — Grammar "Sửa câu sai" framing confusing

**Evidence**: Exercise "Sửa câu sai" gắn nhãn câu đúng ngữ pháp ("失礼ですが、
どうしたら いいですか") là "Câu sau bị sai ngữ pháp" → người học bối rối.

**Action**: Review logic generate "Sửa câu sai": câu mồi PHẢI thực sự có lỗi
ngữ pháp rõ ràng (vd sai particle, sai thể, sai trật tự). Nếu generator lấy câu
đúng làm mồi → fix để chỉ dùng câu có lỗi chủ đích + đáp án sửa rõ ràng. Quét
toàn bộ exercise loại này. Live verify vài câu.

### P1-4 — Reading passage titles internal-sounding

**Evidence**: Titles như "翻訳の不足解説 1/2" (= "giải thích thiếu sót bản dịch")
không tự nhiên cho người học.

**Action**: Generate title tự nhiên cho reading passage (theo chủ đề nội dung,
vd "Lời khuyên của giáo viên sau giờ học"). Quét reading_passages_corpus, đổi
titles internal-sounding sang learner-friendly VI/JP titles.

═══════════════════════════════════════════════════════════════
## §3 — P2 (verify partial-tested)
═══════════════════════════════════════════════════════════════

### P2-1 — Full test/exam completion + score summary
Claude verify per-question scoring chạy nhưng chưa làm hết 30/50/95 câu để thấy
màn điểm cuối. **Action**: Verify hoàn thành trọn 1 bài test (vocab + exam) →
màn score summary render đúng (điểm, % đúng, review câu sai), không hang/blank.
Add e2e test cho completion flow.

### P2-2 — Kanji writing (Viết tay) canvas
Mode "Viết tay" tồn tại (5 kanji) nhưng Claude chưa vào canvas vẽ nét.
**Action**: Verify stroke-order canvas render + drawing interaction + chấm nét
(stroke validation) hoạt động. Live verify vẽ 1 kanji.

═══════════════════════════════════════════════════════════════
## §4 — CARRY-OVER (từ megaprompt 2026-05-24, chưa làm)
═══════════════════════════════════════════════════════════════

Tiếp tục các mục chưa hoàn tất từ `docs/codex-megaprompt-2026-05-24-final-audit.md`:
- **FIX-1 Font glyph**: bundle full Noto Sans JP (kanji 汚/煩/返 hiện tofu □ ở
  test browser). Verify mọi kanji render, kể cả rare.
- **COMPLETE-1 Vocab Directive E**: vocab hiện 0% directiveE (grammar đã 100%).
  Apply etymology + Hán-Việt bridge + humanMoment + crossLinks cho Top-500
  high-frequency vocab (ưu tiên từ có kanji), rồi scale dần.
- **FIX-2 Example level-cap**: ví dụ vocab N5 không dùng từ N2-N3.
- **ROADMAP** §3: recommendation engine tune, IRT adaptive, exam full mock,
  perf+a11y, beta ops gates (owner-only).

═══════════════════════════════════════════════════════════════
## §S — RULES + EXECUTION ORDER + ACCEPTANCE
═══════════════════════════════════════════════════════════════

### Execution order
```
1. P0-1 Audio engine (beta blocker, biggest)
2. P0-2 + P0-3 (Thêm menu + stuck sheet — quick UX fixes)
3. P1-1 Kanji Hán-Việt per-item (owner Directive D priority)
4. P1-2/3/4 (count mismatch, grammar framing, reading titles)
5. P2-1/2 (verify full-test score + writing canvas)
6. §4 carry-over: FIX-1 font → COMPLETE-1 vocab Directive E top-500 → FIX-2
7. ROADMAP per priority
```

### Constraints (per agent-directives + megaprompts)
- KHÔNG vi-human-approved, KHÔNG nhaikanji/thocodehoctiengnhat, KHÔNG --no-verify
  /--force/branch, KHÔNG App Check enforcement, KHÔNG execute ops gates.
- Apply Directive E (Dr. Linh voice) cho mọi content mới.
- Batch ~5 items/commit. Log DECISION + OQ. Update autonomous-loop-status.

### Live verification protocol (bắt buộc trước "done")
Playwright 1920 + 390:
1. Click 🔊 trên flashcard → CÓ TIẾNG (P0-1)
2. Nghe mode → audio + answer flow chạy
3. Mobile "Thêm" → menu items đầy đủ (P0-2)
4. Thêm → navigate khác → sheet tự đóng, content hiện (P0-3)
5. Mở kanji 学 → Hán-Việt "học" + rule inline (P1-1)
6. Lesson card count = data entries (P1-2)
7. Hoàn thành trọn 1 test → score summary (P2-1)
8. 0 console error, 0 tofu glyph
Archive screenshots: `docs/research/qa-live-2026-05-25-{x}.png`

### Acceptance gate
- [ ] P0-1: Audio phát tiếng (🔊 + Nghe + exam listening), graceful fallback
- [ ] P0-2: Thêm menu có content
- [ ] P0-3: Sheet auto-dismiss on navigation
- [ ] P1-1: Kanji Hán-Việt inline per-item
- [ ] P1-2/3/4: count fixed, grammar framing fixed, reading titles natural
- [ ] P2-1/2: score summary verified, writing canvas verified
- [ ] §4: font fixed, vocab Directive E top-500, example level-cap
- [ ] Live verified 1920+390, 0 console error, 0 tofu

Báo cáo sau P0 (audio + 2 bug) — đó là beta-blocker tier.
