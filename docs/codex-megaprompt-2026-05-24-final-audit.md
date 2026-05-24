# JpStudy v2 — Codex Mega-Prompt: Final Audit Fixes + Roadmap (2026-05-24)

> **Autonomous mode.** Token UNLIMITED. Online lookup AUTHORIZED (whitelist
> §S3). Commit thẳng `main`. Tự quyết theo Decision Matrix megaprompt gốc.
> Apply Directive A-F (`docs/agent-directives.md`). Quality > speed.

Đây là mega-prompt tổng hợp sau audit cực kỹ #8 (Claude, live Chrome test
1920 + 390 viewports, file + data inspection). Chia 4 phần:
- **§0 CURRENT STATE** — đã verify done, KHÔNG redo
- **§1 IMMEDIATE FIXES** — bug audit #8 tìm ra
- **§2 COMPLETION WORK** — việc dở dang cần hoàn tất
- **§3 FUTURE ROADMAP** — việc tương lai, polish, beta launch
- **§S RULES** — constraints, sources, acceptance

═══════════════════════════════════════════════════════════════
## §0 — CURRENT STATE (VERIFIED DONE — DO NOT REDO)
═══════════════════════════════════════════════════════════════

Audit #8 xác nhận các mục sau ĐÃ HOÀN TẤT chất lượng cao. **KHÔNG làm lại**:

| Hạng mục | Trạng thái verified |
|---|---|
| Grammar Directive E | **100% all levels** (N5 118, N4 100, N3 158, N2 332, N1 415 = 1123/1123 full etymology+humanMoment+crossLinks, **0 generic filler**) |
| Vocab example sentences | **0% template** (13,791 examples, real contextual sentences) |
| Reading passages | 968 passages, real `vi_translation`, `vocabs_used` tagged |
| Conjugation corpus | 398 conjugable items, standalone `/grammar/conjugation` page works (search + filter + drill) |
| Shin Kanzen grammar | 83/163/88 lessons (N3/N2/N1), Bunpou-only |
| Mimikara vocab | N3/N2/N1 only (no bogus N4/N5) |
| Hajimete vocab | N5-N1 (14/20/28/38/50 chương) |
| Routes | exam start panel works, /profile→/me redirect, friendly 404 (no raw GoException) |
| Home page | Featured widget + 2-col top (Nền tảng/Dojo) + weekly signal + chrome flush |
| Mobile responsive | 0 horizontal overflow at 390px, bottom nav, level switcher chips |
| Console errors | 0 across all audited pages |
| Exercise | 50-question sessions, context-matching distractors (not trivial) |
| Cross-modal SRS | per-mode FSRS state, markKnown deprecated |

**Tinh thần: chỉ chạm các mục này nếu §1/§2/§3 yêu cầu rõ. Mặc định để yên.**

═══════════════════════════════════════════════════════════════
## §1 — IMMEDIATE FIXES (audit #8 bugs)
═══════════════════════════════════════════════════════════════

### FIX-1 (HIGH) — Font glyph coverage: kanji render thành □ tofu

**Evidence**: Trong `/grammar/conjugation` list, kanji 汚 (kitanai), 煩
(urusai), 返 (kaesu) render thành □ tofu box ở test browser. Data CORRECT
(corpus có 汚い/煩い/返す đúng), nên đây là **font-side issue**, không phải
data corruption. `replacementChars: 0` trong aria-labels confirm data sạch.

**Risk**: JLPT app mà kanji hiện tofu trên 1 số device = critical UX bug.
Nguyên nhân khả dĩ: (a) app không bundle full Japanese font, dựa vào system
font; (b) font subsetting chỉ include glyphs detect ở build-time từ static
strings, miss dynamic-content kanji.

**Action**:
1. Kiểm tra `web/index.html` + `pubspec.yaml` xem app load font JP nào.
2. BẮT BUỘC bundle **Noto Sans JP (full, không subset)** hoặc **Noto Serif
   JP** làm fallback font cho mọi CJK glyph. Nếu đang dùng Google Fonts CDN
   subset → chuyển sang self-host full font HOẶC dùng `fontLoader` đảm bảo
   đủ JIS X 0208 + 0213 coverage (toàn bộ Jōyō + Jinmeiyō kanji).
3. CanvasKit: set `CanvasKitVariant` + đảm bảo `FontFallback` chain có full
   JP font trước khi render.
4. Verify: live test `/grammar/conjugation`, search 汚, 煩, 返, 鬱, 麿,
   彁 (rare kanji) — tất cả phải render đúng, không □.
5. Test trên cả Chrome headless (Playwright) + thật để loại trừ test-env.

**Acceptance**: 0 tofu box across conjugation list + kanji grid + grammar
patterns, kể cả rare kanji. Document font strategy trong
`docs/design-system-v3.md`.

### FIX-2 (LOW) — Example level-appropriateness cap

**Evidence**: N5 vocab 私たち có example "想像力は私たちの生活のどの側面にも
影響を与える" dùng 想像力/側面/影響 (N2-N3 vocab) cho từ N5.

**Action**: Add level-cap validator: example sentence cho từ JLPT level X
chỉ dùng vocab ≤ X (cho phép +1 tối đa). Re-scan toàn bộ vocab examples,
thay những cái vượt >1 level. Nếu fix #25 đã làm rồi, verify + close.

**Acceptance**: 0 example vượt quá word-level + 1.

═══════════════════════════════════════════════════════════════
## §2 — COMPLETION WORK (dở dang cần hoàn tất)
═══════════════════════════════════════════════════════════════

### COMPLETE-1 (HIGH) — Vocab Directive E (hiện 0%)

**Gap**: Grammar có Directive E 100%, NHƯNG **vocab có 0% directiveE**.
141/370 vocab có `hanViet` label nhưng KHÔNG có etymology/humanMoment/
crossLinks. Owner's Directive E phải áp cho vocab — đặc biệt E.1
(etymology-first) + E.2 (Hán-Việt Bridge) cho từ có kanji.

**Action**: Apply Directive E cho vocab items (như đã làm cho grammar):
1. Schema: thêm `directiveE` cho mỗi vocab entry:
   ```json
   "directiveE": {
     "etymology": "...",      // E.1: gốc kanji/từ nguyên (cho từ có kanji)
     "hanVietBridge": "...",  // E.2: âm Hán-Việt + từ Việt cùng gốc Hán
     "humanMoment": "...",    // E.4: Dr. Linh note pattern/word-specific
     "crossLinks": [...],     // E.6: từ liên quan (đồng/trái nghĩa, cùng kanji)
     "fallbackReference": {...}
   }
   ```
2. Ưu tiên: vocab có kanji (etymology + Hán-Việt bridge giá trị nhất).
   Vd: 学生 (gakusei) → 学 (học) + 生 (sinh) = "học sinh"; link 大学, 学校.
3. Vocab thuần kana (あなた, はい) → humanMoment nhẹ + crossLinks, skip
   etymology kanji.
4. Validator `validate_directive_e_quality.js` (đã có cho grammar) — áp cho
   vocab: substitution test + banned phrase + etymology ≥60 chars cho từ
   có kanji + crossLinks non-empty.
5. UI: vocab detail / flashcard "Ngữ cảnh" mode show Directive E qua
   progressive disclosure "Tìm hiểu sâu hơn" (reuse component grammar).

**Scope**: Bắt đầu Top-500 high-frequency vocab (N5-N4 core). Phần còn lại
(~16K) batch sau. Apply ưu tiên từ có kanji.

**Acceptance**: Top-500 vocab có full directiveE pass validator; UI render
qua progressive disclosure; sample 20 owner-reviewable.

### COMPLETE-2 (HIGH) — Kanji Hán-Việt per-item integration

**Gap**: Kanji items có 0% `hanViet` field trong format kiểm tra. Có "Quy
tắc Hán Việt" tab ở kanji hub + `han_viet_on_rules_v2.json` rules file,
NHƯNG tích hợp per-kanji chưa rõ. Owner priority (Directive D): "Quy tắc
Hán Việt phải tích hợp vào màn học kanji — học 1 kanji thì quy tắc Hán Việt
liên quan phải hiện và dùng được ngay tại đó".

**Action**:
1. Mỗi kanji entry phải có:
   - `hanViet` (âm Hán-Việt từ Unihan kVietnamese) — vd 学 → "học"
   - `hanVietRule` link → quy tắc chuyển âm liên quan (từ han_viet_on_rules_v2)
   - Ví dụ từ vựng Việt cùng gốc Hán (học sinh, học tập, đại học)
2. Kanji detail screen: section "Cầu Hán-Việt" hiện inline (không phải trang
   tra cứu rời) — âm Hán-Việt + quy tắc + ví dụ Việt.
3. Per-kanji graph detail route (`/kanji/:char/graph`) hiện đang fallback về
   hub (OQ-010). Nâng cấp: route mở detail thật với Hán-Việt + stroke order
   + từ chứa kanji + grammar liên quan.
4. Apply Directive E.2 (Hán-Việt Bridge) + E.1 (etymology) cho mỗi kanji.

**Acceptance**: Mở 1 kanji (vd 学) → thấy âm Hán-Việt "học", quy tắc chuyển
âm, ví dụ từ Việt, stroke order, từ vựng chứa kanji — tất cả inline. Live
verify N5 + N3 + N1 sample.

### COMPLETE-3 (MEDIUM) — Phase G Track A exercise template quality

**Status**: `top_200_frequency_rank.json` có 200 entries (ranking done).
Grammar Directive E (Track B) 100% done. NHƯNG Track A (hand-crafted
exercise templates cho top-200) cần verify: exercise hiện sinh on-demand
(generator 50/item) — top-200 có hand-crafted templates riêng chưa, hay
chỉ dùng generator?

**Action**:
1. Verify: top-200 items có hand-crafted exercise templates (≥10/item, 5
   angles form/meaning/usage/context/contrast × Bloom L1-L4) chưa.
2. Nếu chưa → author per Phase G Track A spec (megaprompt
   2026-05-21 §6).
3. Distractor quality: re-verify không trivial (substitution test). Audit
   #8 thấy 1 question tốt (context-matching near-miss) — confirm toàn bộ
   top-200 đạt chuẩn đó.
4. Bloom L4 (Analyze): mỗi top-200 item ≥1 câu L4 ("câu nào đúng grammar
   trong context X").

**Acceptance**: 200 Tier-1 items có hand-crafted templates pass validator;
sample 30 owner spot-check "không nhìn vô biết đáp án".

### COMPLETE-4 (MEDIUM) — Reading passage VN translation full coverage

**Status**: N3 sample có real `vi_translation`. Verify TẤT CẢ 968 passages
có real translation (không còn label placeholder).

**Action**: Scan reading_passages_corpus.json — mọi passage `vi_translation`
phải là dịch thật của `ja_text` (không phải "Bài đọc gốc JpStudy cho..."
label). Fix những cái còn label.

**Acceptance**: 968/968 passages có real VN translation; `vocabs_used`
populated cho mọi passage.

═══════════════════════════════════════════════════════════════
## §3 — FUTURE ROADMAP (sau khi §1/§2 xong)
═══════════════════════════════════════════════════════════════

### ROADMAP-1 — Vocab Directive E full scale (~16K còn lại)
Sau Top-500 (COMPLETE-1), scale Directive E cho toàn bộ vocab N5-N1. Ưu
tiên theo frequency + có kanji. On-demand generation OK cho long-tail nếu
quality validator pass.

### ROADMAP-2 — Listening (Nghe) mode hoàn thiện
Mode "Nghe" có trong picker. Verify TTS audio thật cho mọi vocab/grammar/
reading. Nếu chưa: tích hợp TTS (Web Speech API hoặc pre-generated audio
cho high-frequency). Shadowing exercise per Kadota 2007.

### ROADMAP-3 — Dokkai (đọc hiểu) mode mở rộng
968 reading passages đã có. Verify Dokkai mode pull đúng passage theo
grammar/vocab learner đang học (tag-driven retrieval per Directive F.7).
Thêm timed reading + WPM tracking cho JLPT prep.

### ROADMAP-4 — Recommendation engine + adaptive path
Per megaprompt Phase 5: sau mỗi lesson, suggest 3 thứ (SRS due dùng item
vừa học / next lesson / cross-textbook similar). Verify hoạt động + tune
weighted scoring (SRS urgency × interlink strength × novelty).

### ROADMAP-5 — Exam (Thi thử) full mock implementation
Exam start panel works. Hoàn thiện: full mock exam đúng cấu trúc JLPT
(語彙/文法/読解/聴解 sections, timing, scoring, answer review). Mỗi level
N5-N1 đủ câu theo blueprint (N5 ~95 câu). KHÔNG reuse official JLPT
questions (copyright) — generate từ item bank.

### ROADMAP-6 — Bloom L4 + IRT adaptive difficulty
Exercise hiện có Bloom tagging. Thêm IRT-lite: track tỷ lệ đúng/sai per
question across sessions, dễ trước khó sau, drill khó hơn khi accuracy cao.

### ROADMAP-7 — Beta launch prep (ops, owner gates)
Các mục owner phải tự làm (KHÔNG Codex tự động):
- App Check enforcement (sau 1-2 tuần healthy verified traffic — owner decide)
- Rotate `admin@jpstudy.test` password (leaked in chat)
- Sentry first deployed issue URL
- Legal review /privacy + /terms
- First deletion runbook proof (owner runs --execute)
- GA4 UI retention proof
- Dependabot alerts (hiện 3) — review + patch
Codex chỉ chuẩn bị scaffolding/docs, KHÔNG execute các ops gate này.

### ROADMAP-8 — Performance + a11y polish
- Lighthouse: maintain Perf ≥70 mobile / ≥85 desktop, A11y ≥90
- Lazy-load content per level (tránh bundle bloat khi vocab Directive E scale)
- Visual regression baseline 6 viewports (360/768/1024/1280/1600/1920) — lock
- WCAG AA: contrast ratios, focus rings, screen reader cho mọi interactive

═══════════════════════════════════════════════════════════════
## §S — STANDING RULES, SOURCES, ACCEPTANCE
═══════════════════════════════════════════════════════════════

### §S1 — Directives (apply all)
`docs/agent-directives.md`: A (commit batch ~5 items), B (queue + crawl
ban), C (gate match changes), D (connected whole-flow work), E (pedagogy +
Dr. Linh-Phan-Trần voice), F (cross-link + exercise density ≥50/≥10).

### §S2 — Non-negotiable constraints
- KHÔNG add `vi-human-approved` (owner only)
- KHÔNG browse nhaikanji.com / thocodehoctiengnhat.com (chỉ local PDFs)
- KHÔNG --no-verify, --force push main, tạo branch
- KHÔNG enable App Check enforcement (owner decide)
- KHÔNG execute deletion / GitHub secrets / account creation
- Quote ≤15 từ verbatim từ copyrighted, cite license
- Strip brand attribution khi extract từ local PDFs

### §S3 — Whitelist sources
JMdict, KANJIDIC2 (CC-BY-SA 4.0), Unihan kVietnamese, Tatoeba (CC-BY 2.0),
Wiktionary (CC-BY-SA 3.0), NHK Easy (paraphrase + link-only), Tae Kim
(CC-BY-NC-SA 3.0), KANJIVG (CC-BY-SA 3.0), MEXT Jōyō (PD), Aozora Bunko
(PD), Noto Sans JP font (SIL OFL — for FIX-1).

### §S4 — Commit policy
Conventional Commits, subject ≤72 char, batch ~5 items/commit (audit #7
flagged 1-item/commit = git noise — gom lại 5). Commit thẳng main.

### §S5 — Execution order
```
1. FIX-1 (font) — HIGH, ảnh hưởng mọi kanji render
2. COMPLETE-2 (kanji Hán-Việt) — owner priority feature
3. COMPLETE-1 (vocab Directive E top-500) — biggest content gap
4. COMPLETE-3 (exercise Track A) + COMPLETE-4 (reading translation verify)
5. FIX-2 (example level-cap)
6. ROADMAP 1-8 theo thứ tự priority owner
```

### §S6 — Decision + OQ logging
Log mọi DECISION → `docs/research/decisions-log-2026-05-21.md`. OQ không
tự quyết được → `docs/research/open-questions-2026-05-21.md` (blocking flag,
skip + continue). Update `autonomous-loop-status.md` mỗi phase.

### §S7 — Acceptance gate (signal complete)
- [ ] FIX-1: 0 tofu kanji, full JP font bundled, documented
- [ ] FIX-2: 0 example vượt word-level+1
- [ ] COMPLETE-1: Top-500 vocab full directiveE, UI renders
- [ ] COMPLETE-2: kanji detail có Hán-Việt inline (âm + rule + ví dụ Việt)
- [ ] COMPLETE-3: 200 Tier-1 hand-crafted templates, Bloom L4 each
- [ ] COMPLETE-4: 968/968 reading real VN translation + vocabs_used
- [ ] Live verify Playwright 1920 + 390: mọi flow, 0 console error, 0 tofu
- [ ] Visual regression baseline 6 viewports locked
- [ ] All directives respected, decisions logged

Signal: append `autonomous-loop-status.md`:
"2026-05-24 Final audit megaprompt — §1 §2 done, §3 in progress, live verified."

### §S8 — Live verification protocol (mandatory before "done")
Run Playwright MCP at 1920x1080 + 390x844:
1. Navigate every route, screenshot, 0 GoException leak, 0 tofu glyph
2. Full journey: onboarding → home → vocab textbook → lesson → flashcard
   (Ngữ cảnh shows real example + Directive E) → exercise (50 câu, quality
   distractor) → grammar pattern (progressive disclosure full Directive E)
   → kanji (Hán-Việt inline) → conjugation drill → exam start → review SRS
3. Console 0 errors throughout
4. Archive screenshots: `docs/research/qa-live-2026-05-24-{page}.png`

Good luck. Báo cáo sau FIX-1 + COMPLETE-2 (owner priority items).
