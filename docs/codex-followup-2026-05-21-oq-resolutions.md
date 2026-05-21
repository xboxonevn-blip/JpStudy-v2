# Codex Follow-up Sprint — 2026-05-21 OQ Resolutions + P0 Fix

> **Autonomous Overnight Mode.** Token UNLIMITED. Online lookup AUTHORIZED
> (whitelist §13 của megaprompt). Commit thẳng `main`. Self-decide, log
> DECISIONS. Run đến acceptance gate §10 pass.

## 0. CONTEXT — đọc trước khi làm

1. `CLAUDE.md` — đã được refresh, agent directives section liệt kê A-F + megaprompt + 2 logs
2. `docs/agent-directives.md` — **Directive E mới đã thêm** giữa D và F. Phải apply E.1-E.7 cho mọi content/explanation/example
3. `docs/research/open-questions-2026-05-21.md` — **10 OQ đã có owner answer**, không hỏi lại
4. `docs/research/decisions-log-2026-05-21.md` — base decisions
5. `docs/codex-megaprompt-2026-05-21-jpstudy-overhaul.md` — original 8-phase mission
6. `docs/research/autonomous-loop-status.md` — last batch state

Đọc xong, append entry vào `autonomous-loop-status.md`:

```
## 2026-05-21 Follow-up Sprint kickoff (OQ resolutions + P0)
- 10 OQ resolved with owner answers (see open-questions log)
- P0 Kanji tab violation acknowledged
- Sprint plan: 4 phases, deadline 2026-05-22 for Sprint 1
```

## 1. MISSION

7 owner decisions cần implement, sequenced theo urgency:

| Sprint | Phase | Item | Source | Deadline |
|---|---|---|---|---|
| 1 | A | Fix Kanji tab placeholder (P0) | audit 2026-05-21 | ASAP today |
| 1 | B | Mimikara N1-N5 lessons live (OQ-005) | OQ-005 | **2026-05-22 EOD** |
| 1 | C | Fill 4 missing Mimikara units (OQ-011) | OQ-011 | with Sprint 1 |
| 1 | D | Grammar fallback Tae Kim integration (OQ-013) | OQ-013 | with Sprint 1 |
| 2 | E | Vocab `example_sentences[]` field + flashcard wire-up (OQ-006) | OQ-006 | 2026-05-23 |
| 3 | F | Reading comp scale-up ~888 passages (OQ-008) | OQ-008 | 2026-05-25 |
| 4 | G | Hand-crafted exercise templates per-item, variant fallback (OQ-007) | OQ-007 | 2026-05-28 |

## 2. NEW DIRECTIVE E REMINDER

Directive E là **lớp chất lượng nội dung**: persona Dr. Linh-Phan-Trần,
etymology-first (E.1), Hán-Việt Bridge (E.2), Multi-Perspective (E.3),
Human Moment (E.4), Research Ladder (E.5), Interlink Semantic (E.6),
Teaching Test (E.7).

Áp dụng E khi viết: explanation, mnemonic, etymology, example sentence,
reading passage, exercise distractor explanation, feedback message.

Tài liệu reference: Heisig RTK, Henshall, Hadamitzky-Spahn, Krashen,
Paivio, Roediger-Karpicke, Craik-Lockhart, Sweller.

## 3. SPRINT 1 — Day 1 (Today + 2026-05-22)

### Phase A — Fix Kanji tab placeholder (P0)

**Source**: Owner audit 2026-05-21, DECISION-007 to be OVERTURNED.

**File**: `lib/features/vocab/screens/hajimete_chapter_detail_screen.dart`

Lines 1323 + 1450 vẫn render `_kanjiComingSoonTitle()` + `_kanjiContractTitle()`.
Owner explicit complaint trong screenshot session 2026-05-21 turn 1:

> "thẻ kanji ở hình thứ 5 nó chẳng để làm gì cả rất thừa thãi, có thể
> thay thế thẻ kanji đó bằng các thuật ngữ/từ vựng của bài tập đó"

#### Implementation

1. Xóa hoàn toàn tab "Kanji" khỏi navigation của hajimete chapter detail
2. Thay vào đó: render **term list inline** với các từ vựng của chapter
   (per megaprompt §7.4 + Directive F.4 cross-link + ảnh 3 reference Tango N5)
3. Mỗi từ trong term list có kanji clickable → popover Hán-Việt rule +
   stroke order (`KanjiInlinePopover` per Phase 3 design)
4. Quét toàn app: tìm mọi placeholder `Phần ... sẽ mở sau` / `... đang
   chờ dữ liệu` / `coming soon` tương tự. Pattern grep:
   ```
   grep -rln "sẽ mở sau\|đang chờ dữ liệu\|coming soon" lib/
   ```
   Nếu data chưa có → hide UI (KHÔNG show placeholder dối người dùng,
   vi phạm Directive D)
5. Apply Directive E khi viết term list explanation/popover content
6. Log DECISION trong `decisions-log-2026-05-21.md`:
   ```
   ## DECISION-XXX — DECISION-007 OVERTURNED (Kanji tab deleted)
   **Phase**: Sprint 1 Phase A
   **Context**: Owner audit 2026-05-21 flagged DECISION-007 as silent
                violation of megaprompt §7.4 + owner explicit screenshot
                request. Owner approval recorded in audit reply.
   **Action**: Kanji tab removed from hajimete chapter detail nav.
                Term list now renders inline with cross-link kanji popovers.
                Audit-wide placeholder sweep cleared other dialect leaks.
   **Reversible**: yes (data dual-read preserved)
   ```
7. Live-test trên `https://jpstudy.web.app` sau deploy

#### Acceptance Phase A

- [ ] `grep "Phần kanji sẽ mở sau\|Dữ liệu kanji đã sẵn sàng" lib/` → 0 matches
- [ ] Hajimete chapter detail page renders term list inline, không tab Kanji
- [ ] Kanji trong term clickable → popover hoạt động
- [ ] Audit-wide sweep: 0 placeholder kiểu "sẽ mở sau" trong UI
- [ ] DECISION-007 OVERTURNED logged
- [ ] Live verify trên jpstudy.web.app

### Phase B — Mimikara N1-N5 lessons live (OQ-005 deadline 2026-05-22)

**Source**: OQ-005 confirmed with hard deadline **2026-05-22 EOD**.

Hiện tại Mimikara textbook records có `migration_status: planned_source_pending`.
Phải đổi sang `live` với lessons populated.

#### Implementation

1. Verify QA-A-030 vocab extraction đã cover Mimikara N1/N2/N3 (xong)
2. Extract Mimikara N4 + N5 nếu có local PDFs:
   ```
   ls "C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Tu Vung/" | grep -i mimikara
   ```
   Nếu không có N4/N5 PDFs → log OQ-014 (Mimikara N4/N5 source gap) +
   dùng online whitelist (OQ-011 pattern)
3. Build lesson manifests cho Mimikara N1-N5
4. Update `textbook_index.json`: `migration_status: live` cho Mimikara
5. Wire lesson detail pages cho Mimikara routes
6. Add cross-link edges trong `interlink_graph.json` cho Mimikara vocab
7. Apply Directive E.2 (Hán-Việt Bridge) + E.4 (Human Moment) cho mọi
   Mimikara content explanation

#### Acceptance Phase B (DEADLINE 2026-05-22 EOD)

- [ ] Mimikara N1-N5 hiển thị trong textbook list của level tương ứng
- [ ] Click Mimikara N1 → 14 units (hoặc số units thực tế) hiện ra
- [ ] Click unit → vocab list của unit đó
- [ ] Cross-link: vocab Mimikara link tới grammar/kanji liên quan
- [ ] Live verify trên jpstudy.web.app
- [ ] DECISION logged

### Phase C — Fill 4 missing Mimikara units (OQ-011)

**Source**: OQ-011 confirmed online whitelist fill.

Missing units: N1 unit 6, N1 unit 10, N2 unit 5, N2 unit 9.

#### Implementation

1. Search whitelist sources cho Mimikara N1-1170/N2-1160 unit references:
   - JMdict + KANJIDIC2 (offline) — primary
   - Tatoeba CC-BY example sentences
   - Wiktionary CC-BY-SA gloss
   - Tofugu reference (link-only)
2. CẤM browse `thocodehoctiengnhat.com` hoặc `nhaikanji.com` per Directive B
3. Cross-reference với Mimikara textbook official theme grouping
   (Mimikara official units có chủ đề: vd N1 unit 6 = "Quan hệ xã hội",
   N1 unit 10 = "Văn học và nghệ thuật" — cần verify)
4. Generate vocab list per missing unit (~80-100 từ/unit)
5. **Dedup**: hash normalized term+reading, reject if duplicate với
   existing extracted units
6. **Brand sanitization**: scan extracted content cho `thocodehoctiengnhat`
   hoặc `nhaikanji` (filename + body); strip nếu có
7. Tag source: `online-whitelisted-fill-OQ011`
8. Build canonical files:
   - `docs/research/canonical/vocab/mimikara-n1-unit06-fill.md`
   - `docs/research/canonical/vocab/mimikara-n1-unit10-fill.md`
   - `docs/research/canonical/vocab/mimikara-n2-unit05-fill.md`
   - `docs/research/canonical/vocab/mimikara-n2-unit09-fill.md`
9. Merge into Mimikara N1/N2 corpus

#### Acceptance Phase C

- [ ] 4 missing units filled với ~80-100 entries each
- [ ] Dedup verified: 0 collision với existing units
- [ ] Brand leak audit: 0 occurrences of banned site name in extracted content
- [ ] DECISION logged về online-fill choice + dedup strategy

### Phase D — Grammar fallback Tae Kim (OQ-013)

**Source**: OQ-013 confirmed Tae Kim fallback per Directive E.5.

No dedicated grammar folder exists at `C:/Users/xboxo/Desktop/PC/Tai
lieu JPStudy/`. Owner authorizes Tae Kim Grammar Guide (CC-BY-NC-SA)
+ existing app grammar data as primary grammar reference.

#### Implementation

1. Audit existing app grammar data coverage gaps:
   ```
   ls assets/data/content/grammar/n*/
   ```
   Identify lessons/patterns thiếu detailed explanation
2. Build `tool/research/import_tae_kim_grammar.js`:
   - Source: Tae Kim Grammar Guide (CC-BY-NC-SA, attribution required)
   - Map Tae Kim chapter → JpStudy grammar pattern by structural pattern
   - Extract: form, meaning, usage notes, ví dụ
3. Apply Directive E.3 Multi-Perspective: form / meaning / usage three angles
4. Apply Directive E.4 Human Moment: thêm 1 anecdote ngắn cho mỗi grammar
   pattern (vd: tại sao は đọc 'wa' khi làm trợ từ)
5. Attribution: every grammar item with Tae Kim source must include
   `source_credit: "Tae Kim's Guide to Japanese Grammar (CC-BY-NC-SA 3.0)"`
6. NO crawl của thocodehoctiengnhat / nhaikanji

#### Acceptance Phase D

- [ ] Grammar coverage gap audit log: `docs/research/grammar-gap-audit-2026-05-21.md`
- [ ] Tae Kim import script tested + integrated
- [ ] Every grammar item has form/meaning/usage section per E.3
- [ ] Every grammar item has 1 human moment per E.4
- [ ] Attribution present for Tae Kim-sourced content

## 4. SPRINT 2 — 2026-05-23

### Phase E — Vocab `example_sentences[]` field migration (OQ-006 hybrid a+c)

**Source**: OQ-006 owner picked hybrid (a)+(c).

Schema migration: every vocab item gets `example_sentences[]` field
populated from `examples_corpus.json` (Phase 4 data). Flashcard back
side shows 1-2 examples inline (no mode switch).

#### Implementation

1. Schema bump: vocab item adds `example_sentences[]`:
   ```json
   {
     "example_sentences": [
       {
         "example_id": "ex-...",
         "ja": "...",
         "vi": "...",
         "audio_url": "...",
         "source": "tatoeba-cc-by | original-jpstudy | ..."
       }
     ]
   }
   ```
2. Migration script `tool/migration/wire_example_sentences.js`:
   - For each vocab item, query `examples_corpus.json` by vocab_id
   - Pick top 1-2 examples (prefer ones with audio + bilingual)
   - Populate `example_sentences[]`
3. Flashcard UI update:
   - Back side renders example sentences (with audio button)
   - Multi-language toggle (JP↔VI per Directive A pattern)
4. Apply Directive E.4 Human Moment: if vocab has interesting etymology,
   add hint chip on flashcard back ("Tip: hán-việt là ...")
5. Validate: every vocab item has ≥ 1 example_sentence; reject if 0

#### Acceptance Phase E

- [ ] Schema migration applied to all N5-N1 vocab files
- [ ] Migration script run + 0 orphan
- [ ] Flashcard back side renders example sentences
- [ ] ≥ 1 example per vocab (validator passes)
- [ ] Live verify on jpstudy.web.app

## 5. SPRINT 3 — 2026-05-23 → 2026-05-25

### Phase F — Reading comp scale-up to ~888 passages (OQ-008)

**Source**: OQ-008 scale-up with no owner review required.

Current: 80 passages. Target: ~968 total (~888 new). Apply per-lesson
2+ passages cho Mina I/II, Hajimete N5/N4, Shin Kanzen N3/N2/N1.

#### Scope estimate

| Textbook | Lessons | Passages needed |
|---|---|---|
| Mina I | 25 | 50 (25 × 2) |
| Mina II | 25 | 50 |
| Hajimete Tango N5 | 50 sub-lessons | 100 |
| Hajimete Tango N4 | 50 | 100 |
| Shin Kanzen N3 | 83 | 166 |
| Shin Kanzen N2 | 163 | 326 |
| Shin Kanzen N1 | 88 | 176 |
| **Total target** | | **~968** |
| Existing | | 80 |
| **NEW required** | | **~888** |

#### Implementation

1. `tool/research/generate_reading_passages.js`:
   - Input: lesson manifest (grammar + vocab + kanji in scope per lesson)
   - Strategy:
     - **Tatoeba (CC-BY)**: pull example sentences matching lesson's grammar/vocab,
       chain 3-5 into mini-passage
     - **Aozora Bunko (PD)**: find short excerpts using level-appropriate vocab,
       use verbatim with attribution
     - **NHK Easy News**: paraphrase + link-only, never verbatim
     - **Original Codex authoring**: when source mix insufficient
2. Length validation per level:
   - N5: 50-150 ký tự
   - N4: 100-200 ký tự
   - N3: 150-300 ký tự
   - N2: 200-400 ký tự
   - N1: 250-500 ký tự
3. 3 comprehension questions per passage:
   - Type 1: Main idea (主旨)
   - Type 2: Detail (詳細)
   - Type 3: Inference (推論)
4. Apply Directive E.7 Teaching Test: passage phải dạy được, not just
   text dump. Codex tự kiểm tra bằng prompt: "If a learner reads this,
   can they explain what happened?"
5. Apply Directive E.4 Human Moment: 1 passage/lesson nên có cultural
   touch (Nhật-Việt comparison, taboo note, common mistake)
6. Source attribution mandatory: every passage logs `source_type` +
   `source_credit`

#### Acceptance Phase F

- [ ] ~888 new passages added to `reading_passages_corpus.json`
- [ ] Per lesson: ≥ 2 passages for Mina/Hajimete/Shin Kanzen
- [ ] Per passage: 3 questions covering main_idea/detail/inference
- [ ] Length per level validated
- [ ] Source attribution complete
- [ ] Brand leak audit: 0 occurrences in passage content
- [ ] Live verify: random 20 passages render correctly on jpstudy.web.app

## 6. SPRINT 4 — 2026-05-25 → 2026-05-28

### Phase G — Hand-crafted exercise templates (OQ-007 option b)

**Source**: OQ-007 owner picked (b) for ALL items, not just top 200.

Replace deterministic variant generation với hand-crafted template-first
approach. Each item gets multiple genuine angles (form, meaning, usage,
context, contrast) authored before variants fill the gap to 50.

#### Implementation

1. Template schema per item:
   ```json
   {
     "item_id": "grammar:n5:mina:01:001",
     "templates": [
       {
         "template_id": "tpl-001",
         "angle": "form|meaning|usage|context|contrast",
         "bloom_level": "L1|L2|L3|L4",
         "prompt_template": "...",
         "answer_template": "...",
         "distractor_strategy": "phonetic-trap|wrong-particle|..."
       }
     ]
   }
   ```
2. `tool/research/author_exercise_templates.js`:
   - Per item, author N templates covering 5 angles + 4 Bloom levels
   - Target: 10-15 hand-crafted templates per item
   - Variants fill remaining to 50 if needed
3. Apply Directive E.3 Multi-Perspective: each item must have at least
   1 template per angle (form/meaning/usage)
4. Validator: reject if templates < 10 OR Bloom L4 < 1 OR angle coverage
   < 3 distinct angles
5. Token budget warning: this is the heaviest phase. Codex run autonomous,
   commit batch per 50 items (Directive A adjusted scope)
6. Quality target: "a learner cannot pass 50 questions by pattern-matching
   surface features; must actually understand the item"

#### Acceptance Phase G

- [ ] Every of ~21,563 items has ≥ 10 hand-crafted templates
- [ ] Angle coverage: every item covers ≥ 3 of 5 angles
- [ ] Bloom coverage: every item has ≥ 1 L4 template
- [ ] Validator passes 21,563/21,563
- [ ] Sample 30 random items, owner spot-check happy (no "nhìn vô biết")
- [ ] Live verify on jpstudy.web.app

## 7. NON-NEGOTIABLE RULES (per megaprompt §12)

ALL rules still apply. Highlights:

- KHÔNG add `vi-human-approved` — chỉ owner add
- KHÔNG browse `nhaikanji.com` / `thocodehoctiengnhat.com` — chỉ dùng
  local PDFs owner đã cung cấp, **strip brand attribution from filenames
  AND content**
- KHÔNG `--no-verify`, KHÔNG `--force` push main
- KHÔNG tạo branch
- KHÔNG enable App Check enforcement
- Mọi quote ≤ 15 từ verbatim từ copyrighted source, cite license

## 8. WHITELIST sources (per megaprompt §13)

Same whitelist. Reminder:
- JMdict CC-BY-SA 4.0
- KANJIDIC2 CC-BY-SA 4.0
- Unihan
- Tatoeba CC-BY 2.0 FR
- Wiktionary CC-BY-SA 3.0
- NHK Easy News (paraphrase + link-only, never verbatim)
- Tae Kim Grammar Guide CC-BY-NC-SA 3.0
- KANJIVG CC-BY-SA 3.0
- MEXT public domain
- Aozora Bunko public domain (Japanese literature)
- Tofugu link-only

## 9. DECISION + OPEN_QUESTIONS continued logging

- Mọi quyết định mới → append `docs/research/decisions-log-2026-05-21.md`
- Question owner không pre-answered → append
  `docs/research/open-questions-2026-05-21.md` với blocking flag
- Skip blocking OQ, làm phase khác, come back nếu owner answer trong session

## 10. ACCEPTANCE GATE — Sprint 1-4 đầy đủ

### Sprint 1 acceptance (by EOD 2026-05-22)
- [ ] Phase A: Kanji tab placeholder removed, audit-wide sweep clean
- [ ] Phase B: Mimikara N1-N5 live, lessons + units populated
- [ ] Phase C: 4 missing units filled with online whitelist, deduped
- [ ] Phase D: Grammar fallback Tae Kim integrated

### Sprint 2 acceptance (by EOD 2026-05-23)
- [ ] Phase E: Vocab example_sentences[] populated, flashcard back side
      renders inline

### Sprint 3 acceptance (by EOD 2026-05-25)
- [ ] Phase F: ~888 new reading passages, 2+/lesson for Mina/Hajimete/
      Shin Kanzen

### Sprint 4 acceptance (by EOD 2026-05-28)
- [ ] Phase G: ~21,563 items × ≥ 10 hand-crafted templates

### Cross-cutting acceptance
- [ ] All non-negotiable rules respected
- [ ] All new decisions logged
- [ ] All new OQs surfaced
- [ ] Live verified on jpstudy.web.app after each Phase
- [ ] Brand attribution leak audit: 0 occurrences

### Signal sprint complete
Final entry `autonomous-loop-status.md`:
```
## 2026-05-21 Follow-up Sprint COMPLETE
- All 4 Sprints + 7 Phases done
- 10 OQ resolutions implemented
- P0 Kanji tab fix shipped
- Acceptance gate: all checkboxes green
- Live verified: https://jpstudy.web.app
- Owner review pending for hand-crafted template sample (Phase G)
```

## 11. INITIAL ACTION — start NOW

1. Read CLAUDE.md, agent-directives.md (Directive E + F), OQ log
2. Append kickoff entry to autonomous-loop-status.md
3. Start Phase A (Kanji tab fix) FIRST — quickest, most-visible owner-flagged defect
4. Then Phase B-D in parallel (Sprint 1)
5. Then Phase E (Sprint 2)
6. Then Phase F (Sprint 3)
7. Then Phase G (Sprint 4)

KHÔNG hỏi owner trong sprint. Tự quyết theo Decision Matrix §14 megaprompt.
Log mọi DECISIONS + OQs. Skip blocking OQ và làm phase khác. Run đến
acceptance gate §10 pass.

Token UNLIMITED. Quality > speed. Directive A/B/C/D/E/F là tinh thần
chỉ đạo.

Báo cáo khi Sprint 1 xong (deadline 2026-05-22 EOD).
