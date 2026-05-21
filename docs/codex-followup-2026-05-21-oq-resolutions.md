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
| 1 | **A0** | **Architecture correction (BLOCKING all)** — delete Mimikara N4/N5 bogus, restructure Shin Kanzen to Bunpou-only 83/163/88 | OQ-014 + OQ-015 | **FIRST, before A** |
| 1 | A | Fix Kanji tab placeholder (P0) | audit 2026-05-21 | after A0 |
| 1 | B | Mimikara N1-N3 lessons live (scope corrected from N1-N5) | OQ-005 (revised) | **2026-05-22 EOD** |
| 1 | C | Fill 4 missing Mimikara units (OQ-011) | OQ-011 | with Sprint 1 |
| 1 | D | Grammar fallback Tae Kim integration (OQ-013) | OQ-013 | with Sprint 1 |
| 2 | **H** | **UI System refactor + home redesign + responsive polish** (owner request 2026-05-21) | owner audit ảnh trang chủ | **2026-05-26** |
| 2 | E | Vocab `example_sentences[]` field + flashcard wire-up (OQ-006) | OQ-006 | 2026-05-27 (parallel with H tail) |
| 3 | F | Reading comp scale-up ~888 passages (OQ-008) | OQ-008 | 2026-05-30 |
| 4 | G | Hand-crafted exercise templates (b1 refined: Top-200 Tier1 + 21K Tier2) | OQ-007 | 2026-06-03 |

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

### Phase A0 — Architecture correction (P0, BLOCKING all other phases)

**Source**: Owner correction 2026-05-21 + OQ-014 DELETE + OQ-015 default action.

Owner clarified textbook architecture is **product-catalog-by-category**,
not "all textbooks at every level". Megaprompt §5.1 (Claude error) wrongly
listed Mimikara N5/N4 and gave Shin Kanzen wrong scope. Codex followed
spec, so this is a Claude-spec bug being corrected NOW.

#### Correct architecture (single source of truth)

**VOCAB textbooks**:
| Textbook | Levels | Lessons | Status |
|---|---|---|---|
| Hajimete Tango | N5, N4, N3, N2, N1 | 14/20/28/38/50 | KEEP — already correct |
| Minna no Nihongo | N5, N4 | 25/25 | KEEP — vocab+grammar dual category OK |
| Mimikara | N3, N2, N1 | 12/13/14 | KEEP — already correct |
| ~~Mimikara N5/N4~~ | DOES NOT EXIST | 0 | **DELETE** (bogus data) |

**GRAMMAR textbooks**:
| Textbook | Levels | Lessons | Status |
|---|---|---|---|
| Minna no Nihongo Bunpou | N5, N4 | 25/25 | KEEP via Minna `grammar,vocab` tag |
| Shin Kanzen Master Bunpou | N3, N2, N1 | **83/163/88** | **RESTRUCTURE** (was 25/25/25 grammar+vocab+kanji) |

**KANJI**: canonical_kanji_n5-n1 unchanged.

**STANDALONE**: Bảng chia thể (Directive F.6) unchanged.

#### Implementation

**A0.1 — DELETE bogus Mimikara N4/N5**

1. Delete directories:
   - `assets/data/content/vocab/n4/mimikara/` (entire tree)
   - `assets/data/content/vocab/n5/mimikara/` (entire tree)
2. Remove from `lib/data/manifests/textbook_index.json`:
   - `mimikara_n4` entry
   - `mimikara_n5` entry
3. Audit `assets/data/content/interlink_graph/interlink_graph.json`:
   - Find all nodes with `textbook: "mimikara"` AND `level: "N4"` or `"N5"`
   - Remove these nodes AND remove all edges that reference them (both `from` and `to`)
   - Re-run interlink graph builder to validate 0 orphan edges
4. Audit `assets/data/content/exercises/exercise_coverage_manifest.json`:
   - Remove items where `textbook_id` matches `mimikara_n4` or `mimikara_n5`
5. Search-and-destroy:
   ```
   grep -rln "mimikara_n4\|mimikara_n5\|source-gap-fallback-OQ014" lib/ assets/ tool/
   ```
   Remove ALL references; if a reference is essential for backward compat,
   replace with neutral fallback or comment explaining removal.
6. UI verify: Mimikara card ONLY renders for N1/N2/N3 in vocab section.

**A0.2 — RESTRUCTURE Shin Kanzen Bunpou**

1. Update `textbook_index.json` entries `shinkanzen_n3/n2/n1`:
   - Change `name_ja` to "新完全マスター 文法 N3" (etc.)
   - Change `name_vi` to "Shin Kanzen Master 文法 N3" (etc.)
   - Change `categories` from `["grammar","vocab","kanji"]` to `["grammar"]`
   - Change `lesson_count`: N3 → 83, N2 → 163, N1 → 88
   - Add `source_credit` per OQ-015 default
2. Lesson scaffolding per OQ-015 default action:
   - Scrape publisher catalog metadata (whitelist only) for authoritative
     lesson titles + grammar patterns covered per Shin Kanzen book
   - Build `lesson_index_shinkanzen_n3.json` with 83 entries (theme, patterns)
   - Build `lesson_index_shinkanzen_n2.json` with 163 entries
   - Build `lesson_index_shinkanzen_n1.json` with 88 entries
3. Content authoring:
   - For each lesson, author 5-10 grammar patterns
   - Source: Tae Kim Grammar Guide (CC-BY-NC-SA, attribution required) +
     existing app grammar data + Directive E.5 Research Ladder fallback
   - Apply Directive E.3 (form/meaning/usage Multi-Perspective)
   - Apply Directive E.4 (1 Human Moment per lesson — Dr. Linh-Phan-Trần
     style anecdote about pattern usage in Japanese-Vietnamese contrast)
   - Apply Directive E.7 (Teaching Test before commit)
4. Existing 25-lesson Shin Kanzen data preservation:
   - Migrate existing items into Shin Kanzen lesson structure where match
   - Items that don't fit Shin Kanzen lesson structure → migrate to a
     "JpStudy curated grammar" supplementary track (don't delete)
5. Cross-link Shin Kanzen patterns to vocab + kanji per Directive F.4

**A0.3 — VERIFY Minna grammar+vocab dual categorization**

1. Check `textbook_index.json` `minna_n5` + `minna_n4` entries:
   - `categories` should contain BOTH `"grammar"` AND `"vocab"`
   - This is CORRECT — Minna textbook teaches both
2. Verify UI renders Minna in:
   - Vocab section (vocab N5 / vocab N4 list)
   - Grammar section (grammar N5 / grammar N4 list)
3. Backend: same lesson_id maps to vocab + grammar views (no duplication)

**A0.4 — VERIFY Hajimete vocab data**

1. `textbook_index.json` shows hajimete_tango_n5 (14 lessons), n4 (20), n3 (28), n2 (38), n1 (50)
2. Verify lesson files exist:
   - `assets/data/content/vocab/n*/hajimete/hajimete_ch*.json`
   - Count must match `lesson_count`
3. Verify cross-link edges in `interlink_graph.json` resolve to Hajimete items
4. If any lesson count mismatch → log DECISION + sync

#### Acceptance Phase A0 (BLOCKING)

- [ ] `grep -rln "mimikara_n4\|mimikara_n5" lib/ assets/ tool/` → 0 matches
- [ ] `textbook_index.json` has 18 entries (down from 20: removed Mimikara N4/N5)
- [ ] Shin Kanzen N3/N2/N1 entries show 83/163/88 lessons, grammar only category
- [ ] `lesson_index_shinkanzen_n3.json` exists with 83 lesson entries
- [ ] `lesson_index_shinkanzen_n2.json` exists with 163 lesson entries
- [ ] `lesson_index_shinkanzen_n1.json` exists with 88 lesson entries
- [ ] Interlink graph orphan audit: 0 broken edges
- [ ] DECISION logged in `decisions-log-2026-05-21.md`:
      "Mimikara N4/N5 deleted, Shin Kanzen restructured to Bunpou grammar-only"
- [ ] Live verify on jpstudy.web.app: Vocab section shows correct textbooks
      per level; Grammar section shows Minna N5/N4 + Shin Kanzen N3/N2/N1
      with correct lesson counts

**Phase A0 BLOCKS Phase A, B, C, D, E, F, G**. Architecture must be
correct before any other content work.

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

### Phase B — Mimikara N1-N3 lessons live (OQ-005 deadline 2026-05-22)

**Source**: OQ-005 confirmed with hard deadline **2026-05-22 EOD**.
**Scope corrected**: Per OQ-014 DELETE, Mimikara only exists at N3, N2, N1
(NOT N5/N4 — those were bogus). Phase A0 already deletes N5/N4 records.

Hiện tại Mimikara N3/N2/N1 textbook records có `migration_status: live`
(per textbook_index check). Verify chất lượng + acceptance.

#### Implementation

1. Verify QA-A-030 vocab extraction đã cover Mimikara N1/N2/N3 (xong per
   loop-status entries 2026-05-21 Phase 1)
2. Skip step "extract Mimikara N4/N5" — they don't exist (Phase A0 deletes)
3. Validate lesson manifests for Mimikara N1/N2/N3:
   - `lesson_index_mimikara_n1.json` should have 14 lesson entries
   - `lesson_index_mimikara_n2.json` should have 13 lesson entries
   - `lesson_index_mimikara_n3.json` should have 12 lesson entries
4. `migration_status: live` confirmed (already in textbook_index)
5. Wire lesson detail pages for Mimikara routes if not done
6. Add cross-link edges in `interlink_graph.json` for Mimikara vocab
7. Apply Directive E.2 (Hán-Việt Bridge) + E.4 (Human Moment) for all
   Mimikara content explanation

#### Acceptance Phase B (DEADLINE 2026-05-22 EOD)

- [ ] Mimikara N1/N2/N3 hiển thị trong vocab section của level tương ứng
- [ ] Mimikara KHÔNG hiển thị cho N5/N4 (xóa từ Phase A0)
- [ ] Click Mimikara N1 → 14 units hiện ra
- [ ] Click Mimikara N2 → 13 units
- [ ] Click Mimikara N3 → 12 units
- [ ] Click unit → vocab list của unit đó với explanation per Directive E
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

## 4. SPRINT 2 — 2026-05-23 → 2026-05-27 (Phase H priority)

### Phase H — UI System refactor + home redesign + responsive polish

**Source**: Owner audit 2026-05-21 sau khi xem live trang chủ. Phase 6
megaprompt §10 spec gap: max-width 1040 fix cứng → desktop wide-screen
phí 2 bên. Plus mobile responsive chưa verified. Owner chọn **"Polish +
UI System refactor"** scope (largest option).

7 sub-phase tuần tự, deadline Sprint 2 EOD 2026-05-26.

#### H.1 — UI Audit (Day 1)

1. Inventory tất cả custom widgets trong `lib/widgets/` + `lib/features/*/widgets/`
2. Identify duplicates (same purpose, slight visual variation)
3. Detect ad-hoc styling: hardcoded color/padding/margin/font-size không qua theme
4. List in `docs/research/ui-audit-2026-05-22.md`:
   - Component name + location + usage count
   - Style violations
   - Recommended dedupe targets
5. Apply Directive D (connected work): không chỉ audit lib/widgets, phải
   audit cả lib/features/*/screens for inline styling

#### H.2 — Design Tokens (Day 1-2)

Codify design system trong `lib/theme/tokens/`:

1. `spacing_tokens.dart`: 4/8/12/16/20/24/32/40/48/64 px scale
2. `color_tokens.dart`: semantic palette
   - Primary (brand green)
   - Surface (background layers)
   - Text (high/medium/low contrast)
   - Semantic (success/warning/danger/info)
   - Level colors (N5=red, N4=orange, N3=yellow, N2=green, N1=blue per JLPT convention)
3. `typography_tokens.dart`: type scale
   - Display (32/40/48px)
   - Heading (20/24/28px)
   - Body (14/16/18px)
   - Caption (12/13px)
   - Font family (Inter or Be Vietnam Pro for VI)
4. `elevation_tokens.dart`: 0/1/2/4/8 dp shadows
5. `motion_tokens.dart`: durations + easings (snap, smooth, bounce)
6. `radius_tokens.dart`: 4/8/12/16/24 px corner radii

Export via `lib/theme/app_theme.dart` để Material `ThemeData` consume.

#### H.3 — Component Library Refactor (Day 2-3)

1. Tạo `lib/widgets/foundation/` chứa primitives đã dedupe:
   - `AppCard` (replace ad-hoc Card variations)
   - `AppButton` (primary/secondary/ghost/destructive variants)
   - `AppChip` (status chip variants)
   - `AppBadge` (level/streak/count badge)
   - `AppIcon` (semantic icon wrapper)
   - `AppDivider` (horizontal/vertical với spacing tokens)
   - `AppSection` (titled section wrapper)
   - `AppEmptyState` (consistent empty placeholder — KHÔNG "sẽ mở sau")
2. Refactor existing widgets to use foundation primitives
3. Delete deprecated duplicates
4. Update unit tests + visual regression baseline

Apply Directive D: refactor batch theo Directive A (~5 file/commit).

#### H.4 — Home Page Redesign (Day 3-4)

Match owner's screenshot pain points:

1. **Adaptive max-width container**:
   - ≤ 1280px viewport: max-width 1040 (existing)
   - 1281-1600px viewport: max-width 1280
   - 1601-1920px viewport: max-width 1440
   - ≥ 1920px viewport: max-width 1600
   ```dart
   double adaptiveMaxWidth(double viewportWidth) {
     if (viewportWidth <= 1280) return 1040;
     if (viewportWidth <= 1600) return 1280;
     if (viewportWidth <= 1920) return 1440;
     return 1600;
   }
   ```

2. **2-column top section** (≥ 1280px):
   - Left col: "Nền tảng - Bảng chữ Hiragana/Katakana/Hán Việt" card
   - Right col: "DOJO HÔM NAY" banner
   - On smaller viewports: stack vertically

3. **Sidebar improvement**:
   - Add weekly streak mini-widget at bottom of sidebar
   - Add "Lessons due today" count chip
   - Collapsible toggle (⬅) khi user click, save preference

4. **Add new home widget**: "Featured this week" (top widget)
   - Suggest 1 grammar pattern + 1 vocab cluster + 1 kanji per week
   - Curated by frequency rank + SRS due intersection
   - CTA "Khám phá tuần này"

5. **Vertical fill on desktop**:
   - Move 4 existing widgets (Kế hoạch/Tiến độ/Chuỗi/Đang dở) up
   - Add "Hoạt động gần đây" timeline widget below (last 7 days activity)

6. **Visual polish**:
   - Use design tokens H.2
   - Use foundation components H.3
   - Smooth transitions per motion_tokens

#### H.5 — Responsive Polish (Day 4-5)

1. Implement 4 breakpoints properly (per megaprompt §10.1):
   - Mobile: < 768px
   - Tablet portrait: 768-1023px
   - Tablet landscape: 1024-1279px
   - Desktop: ≥ 1280px
2. Mobile patterns:
   - Bottom sheet mode picker on lesson page
   - Fullscreen flashcard (edge-to-edge)
   - Swipe gesture: trái/phải = prev/next, lên/xuống = next/prev card
   - Tap = lật thẻ, long-press = mark difficult
   - Sticky header gọn (chỉ ← Back + title)
3. Tablet portrait: 1-col rich layout
4. Tablet landscape: 2-col layout
5. Desktop: full adaptive max-width per H.4

Live test mọi page across 4 viewports:
- Home, Lesson, Vocab list, Grammar list, Kanji graph, Exam, Profile

#### H.6 — Style Guide Doc (Day 5)

`docs/design-system-v3.md`:
- Token documentation (spacing, colors, typography, elevation, motion, radii)
- Component catalog (with Storybook-style usage examples)
- Layout patterns (1-col, 2-col, 4-col, sidebar, modal, sheet)
- Responsive guidelines (breakpoint usage rules)
- Accessibility checklist (WCAG AA targets, contrast ratios, focus rings)
- Anti-patterns (don't do this)
- Brand voice cross-reference (link to Directive E persona Dr. Linh-Phan-Trần)

Existing `docs/design-system-v2.md` archive, không xóa.

#### H.7 — Visual Regression Lock (Day 5-6)

1. Update Playwright config (`tool/qa/visual_regression.config.js`):
   - 4 viewports (360 / 768 / 1024 / 1280) — already exists per Phase 7
   - **Add 1600 and 1920 viewports** for ultra-wide coverage
2. Re-baseline all pages after H.4/H.5 changes
3. CI integration: fail if pixel diff > 1% on any viewport
4. Document baseline procedure in `docs/qa/visual-regression-procedure.md`

#### Acceptance Phase H (DEADLINE 2026-05-26 EOD)

- [ ] H.1: `docs/research/ui-audit-2026-05-22.md` listing all components + violations
- [ ] H.2: 6 token files in `lib/theme/tokens/`, integrated into Material ThemeData
- [ ] H.3: `lib/widgets/foundation/` with ≥ 8 primitive components, used across app
- [ ] H.4: Home page renders with adaptive max-width, 2-col top, sidebar improvement,
      "Featured" widget, "Hoạt động gần đây" timeline
- [ ] H.5: 4 breakpoints work cleanly, mobile patterns verified
- [ ] H.6: `docs/design-system-v3.md` published
- [ ] H.7: Visual regression baseline locked at 6 viewports (added 1600+1920)
- [ ] Live verify on jpstudy.web.app: home page on 1920x1080 desktop shows
      full-width content (no large empty bands on sides)
- [ ] Live verify on mobile (Chrome DevTools 360x640): no overflow, gestures
      work, bottom sheet mode picker functional
- [ ] DECISION logged

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

### Phase G — Hand-crafted exercise templates (OQ-007 option b1 REFINED)

**Source**: OQ-007 refined to (b1) — owner accepted Claude's scope-reality
flag. Top-200 high-frequency items get full hand-crafted treatment;
remaining ~21K items get enhanced variant (≥ 3 hand-crafted seed + variant
fill to 50).

#### Tier 1: Top-200 high-frequency items (FULL hand-crafted)

Selection: top-200 by aggregate frequency across:
- Mina I/II grammar core (high learner contact)
- Hajimete Tango N5/N4 high-frequency vocab
- Shin Kanzen N3 most-tested grammar
- Joyo kanji N5-N4 (most-used)

Template requirement per Tier-1 item:
- ≥ 10 hand-crafted templates per item
- ≥ 1 template per angle (form / meaning / usage / context / contrast = 5 angles)
- ≥ 1 template per Bloom L1-L4 (4 levels)
- Validator reject if any of above missing

Apply Directive E.3 Multi-Perspective + E.7 Teaching Test rigorously.

#### Tier 2: Remaining ~21K items (ENHANCED variant)

Template requirement per Tier-2 item:
- ≥ 3 hand-crafted seed templates per item (vs current 0)
- Variant generation fills to 50 using seeds as anchor
- Variants must cover ≥ 2 distinct angles
- Variants must cover ≥ 3 Bloom levels

#### Implementation

1. Build frequency ranker `tool/research/rank_item_frequency.js`:
   - Input: usage logs (if any) + textbook lesson position + JLPT level
   - Output: top-200 list
2. Template schema per item:
   ```json
   {
     "item_id": "grammar:n5:mina:01:001",
     "tier": "tier1|tier2",
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
3. `tool/research/author_exercise_templates.js`:
   - Mode: tier1-full | tier2-enhanced
   - Tier1: 10-15 hand-crafted per item, 5-angle + 4-Bloom coverage
   - Tier2: 3-5 hand-crafted seed per item, variant fill to 50
4. Apply Directive E.3 Multi-Perspective to ALL items (Tier1 + Tier2)
5. Validator per tier:
   - Tier1 reject if templates < 10 OR Bloom L4 < 1 OR angle coverage < 5
   - Tier2 reject if templates < 3 OR final question count (after variant) < 50
6. Token budget: Tier1 ~200 items × 8 min/item = ~27 hours autonomous run;
   Tier2 ~21K items × 1 min/item = ~350 hours autonomous run. Sprint 4
   focuses on Tier1; Tier2 may overflow into Sprint 5 if needed
7. Quality target: "a learner cannot pass 50 questions by pattern-matching
   surface features"

#### Acceptance Phase G

- [ ] Top-200 list generated + committed (`docs/research/top-200-frequency-rank-2026-05-21.md`)
- [ ] All 200 Tier-1 items have ≥ 10 hand-crafted templates
- [ ] All Tier-1 items pass 5-angle × 4-Bloom validator
- [ ] All ~21K Tier-2 items have ≥ 3 hand-crafted seed templates
- [ ] All Tier-2 items reach ≥ 50 total questions (seed + variant)
- [ ] Sample 30 random items (15 Tier-1 + 15 Tier-2), owner spot-check
      happy — no "nhìn vô biết đáp án"
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
- [ ] **Phase A0: Architecture corrected — Mimikara N4/N5 deleted, Shin Kanzen restructured to Bunpou 83/163/88**
- [ ] Phase A: Kanji tab placeholder removed, audit-wide sweep clean
- [ ] Phase B: Mimikara N1-N3 live (NOT N4/N5), lessons + units populated
- [ ] Phase C: 4 missing units filled with online whitelist, deduped
- [ ] Phase D: Grammar fallback Tae Kim integrated

### Sprint 2 acceptance (by EOD 2026-05-26 + EOD 2026-05-27)
- [ ] **Phase H: UI System refactor + home redesign + responsive polish**
      (6 sub-phase H.1-H.7, deadline 2026-05-26)
- [ ] Phase E: Vocab example_sentences[] populated, flashcard back side
      renders inline (deadline 2026-05-27, parallel with H tail)

### Sprint 3 acceptance (by EOD 2026-05-30)
- [ ] Phase F: ~888 new reading passages, 2+/lesson for Mina/Hajimete/
      Shin Kanzen

### Sprint 4 acceptance (by EOD 2026-06-03)
- [ ] Phase G: Top-200 Tier1 (≥10 hand-crafted/item) + ~21K Tier2
      (≥3 seed + variant fill to 50)

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

1. Read CLAUDE.md, agent-directives.md (Directive E + F), OQ log (including
   NEW OQ-014 DELETE + OQ-015 Shin Kanzen restructure)
2. Append kickoff entry to autonomous-loop-status.md
3. **Start Phase A0 (Architecture correction) FIRST** — this BLOCKS all
   other phases. Delete Mimikara N4/N5 bogus + restructure Shin Kanzen
   to Bunpou-only 83/163/88 lessons
4. Then Phase A (Kanji tab fix) — quickest visible defect
5. Then Phase B-D in parallel (Sprint 1, deadline 2026-05-22 EOD)
6. **Then Phase H (UI System refactor) — Sprint 2 priority, owner-flagged
   2026-05-21 after seeing live home page wide-screen waste**
7. Then Phase E (Sprint 2, parallel with H tail)
8. Then Phase F (Sprint 3)
9. Then Phase G (Sprint 4)

KHÔNG hỏi owner trong sprint. Tự quyết theo Decision Matrix §14 megaprompt.
Log mọi DECISIONS + OQs. Skip blocking OQ và làm phase khác. Run đến
acceptance gate §10 pass.

Token UNLIMITED. Quality > speed. Directive A/B/C/D/E/F là tinh thần
chỉ đạo.

Báo cáo khi Sprint 1 xong (deadline 2026-05-22 EOD).
