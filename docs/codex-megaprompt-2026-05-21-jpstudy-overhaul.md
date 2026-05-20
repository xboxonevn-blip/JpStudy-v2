# JpStudy v2 — Codex Mega-Prompt Overhaul 2026-05-21

> **Autonomous Overnight Mode.** Token UNLIMITED. Online lookup AUTHORIZED
> (trừ ban list). Commit thẳng `main`. Không cần duyệt từng phase. Tự quyết
> theo Decision Matrix (§14), log mọi quyết định. Run đến khi Acceptance Gate
> (§15) pass.

---

## 0. CONTEXT — BẮT BUỘC ĐỌC TRƯỚC KHI LÀM BẤT KỲ VIỆC GÌ

Đọc theo thứ tự, **không** skip:

1. `CLAUDE.md` — project context, hosting, owner identity, ops debt
2. `AGENTS.md` — agent notes, test account, crawl ban
3. `docs/agent-directives.md` — **Directive A** (commit batch), **B** (queue + crawl ban), **C** (gate khớp thay đổi), **D** (làm việc liên kết, toàn diện, triệt để), **E** (pedagogy & human voice, persona Dr. Linh-Phan-Trần)
4. `docs/research/quality-backlog.md` — priority queue hiện tại
5. `docs/research/autonomous-loop-status.md` — batch cuối đã làm
6. `docs/SHIPPING.md` (nếu có) — release flow
7. `docs/free-web-stack-reference.md` — cost control
8. `docs/jlpt-exam-source-reference.md` — JLPT exam/audio source policy
9. `docs/credits/upper-jlpt-sources.md` — owner-provided source folders

**Sau khi đọc**, append vào `docs/research/autonomous-loop-status.md`:

```
## 2026-05-21 — Megaprompt Overhaul kickoff
- Context loaded: CLAUDE.md, AGENTS.md, agent-directives, quality-backlog, loop-status
- Mission acknowledged: 8 phases, Directive F to be appended
- DECISIONS_MADE log opened: docs/research/decisions-log-2026-05-21.md
- OPEN_QUESTIONS log opened: docs/research/open-questions-2026-05-21.md
```

---

## 1. MISSION STATEMENT

Owner đã live-review app trên `https://jpstudy.web.app` và xác định **7 pain
points lớn** (tất cả từ phiên audit 2026-05-21):

| # | Pain | Reference |
|---|---|---|
| P1 | IA flat — không có hierarchy textbook → theme → lesson như JLPT Mindmap | screenshots reference Tango N5, Mina N5, Shin Kanzen |
| P2 | Lesson page nghèo nàn — tab Kanji rỗng dối người dùng; flashcard thiếu features | so sánh ảnh 3 (reference) vs ảnh 4 (JpStudy) |
| P3 | Exercise chỉ 5 câu/item — "rất ẩu", phải lên **≥ 50 câu/item** | ảnh 5 (sentence-sort 5 câu) |
| P4 | Distractor trivial — "nhìn vô là biết đáp án", thiếu JLPT-pattern (phonetic traps, kanji lookalikes, wrong particle) | quote owner |
| P5 | **Không có reading comprehension** — JLPT N3+ phải có 読解 | quote owner |
| P6 | Conjugation rời rạc — phải thành **anchor 2 vị trí** (standalone + inline conditional) | reference JLPT Mindmap "Bảng chia thể" card |
| P7 | Desktop phí 2 bên, mobile vỡ responsive, home page generic | quote owner |

**Mission**: Trong autonomous overnight run này, giải quyết TẤT CẢ 7 pain
points qua **8 phase tuần tự** (§4-§11).

---

## 2. NEW DIRECTIVE F — Cross-link & Exercise Density

Áp dụng **song song** với Directive A/B/C/D/E. **Append** text này vào
`docs/agent-directives.md` ngay sau Directive E:

> ### Directive F — Cross-link & Exercise Density
>
> Đây là directive về **chất lượng nội dung học**: mật độ exercise đủ dày để
> mastery xảy ra (testing effect), distractor đủ khó để phân biệt người học
> thật vs người đoán mò, và data đủ link để học một thứ kích hoạt nhớ lại
> thứ liên quan (spreading activation).
>
> #### F.1 — Sàn mật độ exercise
>
> Mọi item học (grammar pattern, vocab, kanji, conjugation form) BẮT BUỘC có:
> - ≥ 10 ví dụ thật (audio + Vietnamese + source citation)
> - ≥ 50 exercise questions đa dạng theo F.2 + Bloom progression F.3
>
> Nếu data hiện có không đủ, **bắt buộc** generate thêm bằng pipeline auto-gen
> + validation pass. Không có ngoại lệ. Không giảm sàn dưới mọi lý do.
> Bằng chứng: Roediger-Karpicke 2006 (testing effect cần ≥ 4 retrievals);
> JLPT thật có 30-50 câu/section, người học cần luyện ở scale tương đương.
>
> #### F.2 — Distractor JLPT-pattern (anti-trivial)
>
> - **Vocab**: 1 đáp án đúng + 1 phonetic trap (DL distance 1-2 trên kana) + 1
>   compound trap (kanji khác cùng reading) + 1 random same-level
> - **Grammar**: 1 đúng + 3 distractor từ: wrong particle (は↔が, に↔で,
>   を↔が, へ↔に), wrong tense (です↔でした, する↔した↔している), wrong
>   politeness (です↔だ, ます↔る), wrong negation (ない↔ありません↔ません↔
>   じゃない)
> - **Kanji**: 1 đúng + 3 visual lookalikes (湿/温, 鳥/烏, 困/因, 末/未) từ
>   pre-built lookalike corpus (KANJIVG SVG diff)
> - **Conjugation**: 1 đúng + 3 forms khác cùng verb (ăn nhầm 食べた vs 食べる
>   vs 食べない vs 食べたい)
>
> Validator phải reject distractor trùng correct, distractor sai grammar form,
> distractor duplicate.
>
> #### F.3 — Bloom progression
>
> Mỗi item có exercise set cover đủ 4 cấp Bloom:
> - L1 Remember: matching, basic MCQ
> - L2 Understand: explain meaning, paraphrase
> - L3 Apply: dùng item trong câu mới (production)
> - L4 Analyze: chọn câu nào đúng grammar trong 4 option context-heavy
>
> "Mastery" chỉ unlock khi pass L4. Không cho phép tự khai sau pass L1.
>
> #### F.4 — Cross-link graph (bi-directional)
>
> Mọi item detail page BẮT BUỘC có section "Liên quan" 4 sub-section:
> Grammar dùng item này / Vocab chứa item này (nếu kanji) / Kanji trong item
> này (nếu vocab) / Conjugation forms (nếu verb/adj). Link sống, không stub.
>
> #### F.5 — Cross-modal SRS (anti self-attestation cứng)
>
> 1 item có N FSRSState độc lập (N = số mode được luyện). Phải pass tất cả
> mode với accuracy ≥ 80% mới gọi "thuộc". Loại bỏ UI button "Tôi đã thuộc"
> tự khai. `SRSStore.markKnown()` deprecated, throw nếu được gọi.
>
> #### F.6 — Conjugation anchor 2 vị trí
>
> - Standalone (vị trí A): Menu Grammar có card top "Bảng chia thể động từ ·
>   tính từ" → page tổng hợp toàn bộ patterns với search/filter.
> - Inline (vị trí B): ConjugationWidget **conditional** — chỉ render khi
>   lesson có ≥ 1 verb/adj. Widget show list + button "Luyện chia thể (≥50
>   câu)" → drill mode.
>
> #### F.7 — Reading comprehension first-class
>
> Mỗi level:
> - N5-N4: ≥ 10 passages mini 50-150 ký tự
> - N3-N1: ≥ 20 passages 100-300 ký tự
>
> Mỗi passage có 3-5 câu hỏi (main idea / detail / inference), tag với
> grammars/vocabs/kanjis nó dùng.

---

## 3. EXECUTION MODEL

### 3.1 Phase ordering (BLOCKING gates)

```
Phase 0 (design docs) → 1 (data migration) → 2 (conjugation layer) →
3 (lesson page) → 4 (exercise engine) → 5 (cross-link graph) →
6 (responsive + home) → 7 (live proof + acceptance)
```

KHÔNG skip, KHÔNG đảo. Mỗi phase có **acceptance check** trước khi sang
phase kế tiếp.

### 3.2 Commit batch policy (Directive A adapted)

- Mỗi commit subject ≤ 72 char, Conventional Commits
- 1 commit = 1 logical change (1 sub-task của phase)
- Phase 0: 1 commit duy nhất cho 7 design docs + Directive F append
- Phase 1-6: ~3-8 commit/phase tùy scope
- Phase 7: 1 commit/category cho live-proof artifacts
- Commit thẳng `main`. KHÔNG branch.
- KHÔNG `--no-verify`. KHÔNG `--force` push trừ khi owner explicit request.

### 3.3 Token & online lookup

- Token UNLIMITED per Directive C
- Online lookup AUTHORIZED cho whitelist sources (§13)
- CẤM browse `nhaikanji.com`, `thocodehoctiengnhat.com` (Directive B)
- Mọi quote ≤ 15 từ, cite source license

### 3.4 Decisions log + Open questions log

Mọi quyết định design Codex tự đưa ra → log vào
`docs/research/decisions-log-2026-05-21.md`:

```markdown
## DECISION-XXX — [Title]
**Phase**: N
**Date**: 2026-05-21 HH:MM (local)
**Context**: [why decision needed]
**Options considered**: A | B | C
**Chosen**: B
**Rationale**: [reasoning + reference]
**Reversible**: yes/no
**Owner review**: pending
```

Câu hỏi không tự quyết được → log vào
`docs/research/open-questions-2026-05-21.md`:

```markdown
## OQ-XXX — [Question]
**Phase**: N
**Date**: 2026-05-21 HH:MM
**Blocking**: yes | no
**Default action taken**: [if blocking=no, what Codex did]
**Owner answer**: pending
```

Nếu OQ blocking, sweep sang phase khác không depend on it, log lý do skip.

---

## 4. PHASE 0 — DESIGN DOCS (BLOCKING)

Commit duy nhất, message:
`docs: phase 0 design docs for IA + conjugation + exercise + responsive overhaul`

Tạo 7 design doc + 1 directive append. Mỗi doc tuân theo template:
**Mục tiêu / Bối cảnh / Schema (nếu data) / Component tree (nếu UI) /
Migration plan / Acceptance criteria / Open questions**.

### 4.1 `docs/design/ia-restructure-2026-05-21.md`

- Mục lục textbook hỗ trợ per level (xem §5.1 table)
- Schema `textbook_index.json`, `lesson_index_<textbook>.json`
- URL routing pattern: `/learn/:level/:textbook/:lesson/:item?`
- Migration plan: flat → theme→lesson, dual-read transition
- Backward compat: old URL redirect to new

### 4.2 `docs/design/conjugation-layer-2026-05-21.md`

- Schema `conjugation_corpus.json` (§6.1)
- Generator algorithm (Tae Kim CC-BY-NC-SA + MEXT spec)
- Irregular verb list (来る, する, 行く + ~30 honorific)
- UI: standalone page + inline ConjugationWidget
- SRS integration: 1 FSRSState per form per learner

### 4.3 `docs/design/exercise-engine-2026-05-21.md`

- 6 exercise type spec (§8.1)
- ≥ 50 question/item rule (Directive F.1)
- Distractor engine per type (Directive F.2)
- Bloom L1-L4 progression (Directive F.3)
- `ExerciseBank` class API + storage schema

### 4.4 `docs/design/lesson-page-2026-05-21.md`

- Component tree (xem §7.1)
- ASCII mockup (copy từ owner chat 2026-05-21 turn 1)
- `ResponsiveContainer(maxWidth: 1040)` spec
- Mode picker 7 modes (conjugation conditional)
- Term list with cross-link badges
- Delete Kanji tab placeholder (owner decision)

### 4.5 `docs/design/responsive-2026-05-21.md`

- 4 breakpoints: 360 / 768 / 1024 / 1280
- Mobile: bottom sheet mode picker, fullscreen flashcard, gesture swipe
- Tablet (768-1024): 1-col rich
- Desktop ≥ 1024: 2-col layout
- Visual regression test plan (Playwright 4 viewports)

### 4.6 `docs/design/interlink-graph-2026-05-21.md`

- Schema `interlink_graph.json` (§9.1)
- Build pipeline (static analysis pass)
- "Liên quan" UI section spec
- Recommendation engine algorithm

### 4.7 `docs/design/home-redesign-2026-05-21.md`

- 4 widget spec: today-plan / level-progress / streak / last-context
- Widget registry pattern
- Layout 1/2/4-col responsive

### 4.8 BONUS — Append Directive F vào `docs/agent-directives.md`

Copy nguyên văn text §2 của prompt này, append sau Directive E.

### Phase 0 Acceptance

- [ ] 7 design doc files exist
- [ ] `docs/agent-directives.md` has Directive F appended
- [ ] 1 commit covers all above (subject ≤ 72 char)
- [ ] Append entry `docs/research/autonomous-loop-status.md`: "Phase 0 done"

---

## 5. PHASE 1 — DATA MIGRATION (theme→lesson)

### 5.1 Textbook coverage per level

| Level | Textbooks bắt buộc cover |
|---|---|
| N5 | Mina I (25 bài), Hajimete Tango N5 (10 chủ đề × 5 bài = 50 bài), Mimikara N5 |
| N4 | Mina II (25 bài), Hajimete Tango N4, Mimikara N4 |
| N3 | Shin Kanzen N3 (Bunpou 83 bài, Goi, Kanji), Mimikara N3 |
| N2 | Shin Kanzen N2 (Bunpou 163 bài, Goi, Kanji), Mimikara N2 |
| N1 | Shin Kanzen N1 (Bunpou 88 bài, Goi, Kanji), Mimikara N1 |

Owner folder `C:\Users\xboxo\Desktop\PC\Tai lieu JPStudy\Tu Vung` đã có
từ vựng N5-N1 cho Mimikara, Mina I-II, vocab-by-kanji. Reference
`docs/credits/upper-jlpt-sources.md`.

### 5.2 New manifests

Tạo:

- `lib/data/manifests/textbook_index.json`
- `lib/data/manifests/lesson_index_<textbook>.json`
- `lib/data/manifests/item_index_<textbook>_<lesson>.json`

Schema `textbook_index.json`:

```json
{
  "schema_version": 1,
  "generated_at": "2026-05-21T...",
  "textbooks": [
    {
      "textbook_id": "mina_n5",
      "level": "N5",
      "name_ja": "みんなの日本語 初級I 第2版",
      "name_vi": "Minna no Nihongo Sơ cấp I",
      "categories": ["grammar", "vocab"],
      "lesson_count": 25,
      "item_count_total": 217,
      "source_credit": "3A Corporation © (reference only, no verbatim reproduction)"
    }
  ]
}
```

Schema `lesson_index_<textbook>.json`:

```json
{
  "textbook_id": "mina_n5",
  "lessons": [
    {
      "lesson_id": "mina_n5_01",
      "lesson_number_ja": "第1課",
      "lesson_number_vi": "Bài 1",
      "theme_ja": "じこしょうかい",
      "theme_vi": "Giới thiệu bản thân",
      "item_counts": {"grammar": 5, "vocab": 28},
      "est_minutes": 45,
      "prerequisites": []
    }
  ]
}
```

### 5.3 Migration script

`tool/migration/restructure_to_theme_lesson.js`:

- Read flat content hiện tại từ `assets/data/content/`
- Map to new theme→lesson structure dùng owner-provided source folders
  + Mina I/II official lesson numbering
  + Hajimete Tango official 10 themes × 5 lessons structure
  + Mimikara official theme groupings
- Write new files preserving content + adding `textbook_id`, `lesson_id` tags
- **Dual-read transition**: old reader (`flatContentReader`) still works
  during transition; new reader (`textbookContentReader`) reads new format.

### 5.4 Validation

`tool/qa/validate_migration.js`:

- Count items before vs after (must match)
- All `interlink_graph` references resolve (no orphan IDs)
- All lessons have ≥ 1 item
- All items have valid `textbook_id` + `lesson_id`
- Zero data loss check

### Phase 1 Acceptance

- [ ] `textbook_index.json` covers all levels per §5.1
- [ ] Migration script run + 0 orphan, 0 lost item
- [ ] Dual-read works (old + new format both load)
- [ ] Append loop-status entry

---

## 6. PHASE 2 — CONJUGATION DATA LAYER

### 6.1 Schema

`assets/data/content/conjugation/conjugation_corpus.json`:

```json
{
  "schema_version": 1,
  "verbs": {
    "食べる": {
      "lemma": "食べる",
      "reading": "たべる",
      "group": "ichidan",
      "meaning_vi": "ăn",
      "level": "N5",
      "frequency_rank": 234,
      "forms": {
        "dictionary": "食べる",
        "masu": "食べます",
        "masu_negative": "食べません",
        "masu_past": "食べました",
        "masu_past_negative": "食べませんでした",
        "te": "食べて",
        "ta": "食べた",
        "nai": "食べない",
        "nakatta": "食べなかった",
        "ba": "食べれば",
        "tara": "食べたら",
        "command": "食べろ",
        "volitional": "食べよう",
        "passive": "食べられる",
        "causative": "食べさせる",
        "causative_passive": "食べさせられる",
        "potential": "食べられる",
        "honorific": "召し上がる",
        "humble": "いただく"
      },
      "examples_per_form": {
        "te": ["パンを食べてください。"]
      }
    }
  },
  "i_adjectives": {
    "高い": {
      "lemma": "高い",
      "reading": "たかい",
      "meaning_vi": "cao, đắt",
      "level": "N5",
      "forms": {
        "dictionary": "高い",
        "negative": "高くない",
        "past": "高かった",
        "past_negative": "高くなかった",
        "te": "高くて",
        "ba": "高ければ",
        "adverb": "高く"
      }
    }
  },
  "na_adjectives": {
    "静か": {
      "lemma": "静か",
      "reading": "しずか",
      "meaning_vi": "yên tĩnh",
      "level": "N5",
      "forms": {
        "dictionary": "静かだ",
        "polite": "静かです",
        "negative": "静かじゃない",
        "negative_polite": "静かじゃありません",
        "past": "静かだった",
        "past_polite": "静かでした",
        "te": "静かで",
        "ba": "静かなら",
        "adverb": "静かに",
        "attributive": "静かな"
      }
    }
  }
}
```

### 6.2 Generator

`tool/research/generate_conjugation_corpus.js`:

- Input: vocab corpus (filter POS = verb / i-adj / na-adj)
- Apply Tae Kim conjugation rules (CC-BY-NC-SA, attribution required)
- Algorithm: detect group (Godan ending pattern, Ichidan -る, Irregular
  whitelist), apply per-group transformation table
- Output: `conjugation_corpus.json`
- Error log: `conjugation_generation_errors.log` (entries skipped + reason)

### 6.3 Irregular verbs — manual seed

Bắt buộc seed thủ công ~30 entries:

- する (verbal noun + する pattern)
- 来る (irregular all forms: こ-, き-, く-)
- 行く (te-form 行って not 行いて)
- ある (negative ない not あらない)
- 死ぬ (only ぬ-ending verb)
- いる (existence, irregular potential)
- 5 honorific với す-stem ます: ござる→ござります(古)/ございます,
  いらっしゃる→いらっしゃいます, おっしゃる, 下さる→くださいます,
  なさる→なさいます

Source: Tae Kim Grammar Guide + MEXT Joyo conjugation tables.

### 6.4 UI integration

- Standalone: `lib/features/conjugation/conjugation_master_page.dart` —
  list all với search/filter (group, level, form). Route:
  `/grammar/conjugation`
- Inline: `lib/features/conjugation/conjugation_widget.dart` — conditional
  render khi lesson có verb/adj. Show list + button "Luyện chia thể (≥50 câu)"
- Drill: `lib/features/conjugation/conjugation_drill_page.dart` — 50+
  questions, mix forms, distractor là other forms cùng verb

### Phase 2 Acceptance

- [ ] `conjugation_corpus.json` exists
- [ ] ≥ 1000 verbs với đầy đủ 16 forms
- [ ] ≥ 500 i-adj + na-adj
- [ ] ≥ 30 irregular manual-seeded
- [ ] Standalone page renders list with search/filter
- [ ] Inline widget conditionally renders in lesson page
- [ ] Drill mode generates ≥ 50 questions per verb

---

## 7. PHASE 3 — LESSON PAGE REDESIGN

### 7.1 Component tree

```
LessonPage
├── BreadcrumbBar (sticky top)
│   └── "N5 / Mina N5 / 第1課 — Giới thiệu bản thân"
├── LessonHeader
│   ├── Title (ja + vi)
│   ├── Pagination (← Bài trước | Bài tiếp →)
│   └── ActionButtons (Góp ý | Luyện viết PDF)
├── ResponsiveContainer(maxWidth: 1040)
│   ├── FlashcardZone (720px desktop, fullscreen mobile)
│   │   ├── FlashcardDisplay (front/back, audio button, star)
│   │   ├── FlashcardNavArrows (← →)
│   │   ├── ShortcutHintsBar (Space:lật | Z:biết | X:chưa biết | C:thêm deck | R:audio)
│   │   ├── ContentToggle (Từ đơn ↔ Ví dụ)
│   │   ├── ProgressBar (❌ X/N ✓)
│   │   ├── DirectionToggle (JP→VI ↔ VI→JP)
│   │   └── ActionButtons (🔄 shuffle, 🔀 randomize)
│   ├── WarningBanner (e.g. "Không dùng bộ gõ với mode nhồi nhét")
│   ├── ModePicker (7 modes, conditional rendering)
│   ├── ConjugationWidget (conditional, before TermList)
│   └── TermList
│       ├── FilterChips ([Tất cả] [Có kanji] [Chỉ kana])
│       └── TermCard[]
│           ├── Number badge
│           ├── Word (with kanji + furigana clickable)
│           ├── Reading + gloss + ⭐ + 🔊
│           ├── Example sentence + 🔊
│           ├── CrossLinkBadges (✦ G N5-01, ✦ K 食)
│           └── SRSStateChip (Per-mode mastery indicator)
```

### 7.2 ResponsiveContainer

```dart
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ResponsiveContainer({super.key, this.maxWidth = 1040, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 768 ? 0 : 16,
          ),
          child: child,
        ),
      ),
    );
  }
}
```

### 7.3 Mode picker — 7 modes

| Mode ID | VI label | Icon | Color | Conditional render |
|---|---|---|---|---|
| flashcard | Flashcard | 📇 | blue | always |
| mcq | Trắc nghiệm | 🎯 | green | always |
| matching | Ghép từ | 🧩 | purple | always |
| typing | Nhồi nhét | ⌨ | red | always |
| writing | Viết | ✏ | orange | if lesson has kanji |
| dokkai | Dokkai (đọc hiểu) | 📖 | cyan | if level ≥ N3 or lesson has passage |
| listening | Nghe đuổi | 🎧 | pink | always (audio required) |
| conjugation | Chia thể | 🔄 | yellow | if lesson has verb/adj |

ModePicker layout: horizontal scroll mobile, wrap row desktop.

### 7.4 Xóa Kanji tab placeholder (owner decision 2026-05-21)

- Delete: `lib/features/lesson/kanji_tab.dart` (hoặc tương đương — locate
  bằng `Grep` "Phần kanji sẽ mở sau")
- Remove tab Kanji from navigation
- Kanji trong term list inline render với popover Hán-Việt + stroke order
  (component mới `KanjiInlinePopover`)

### Phase 3 Acceptance

- [ ] Lesson page renders all 7.1 components
- [ ] ResponsiveContainer max-width = 1040
- [ ] Mode picker shows 7 modes (conditional logic correct)
- [ ] Kanji tab placeholder deleted
- [ ] Term list cross-link badges hiển thị (link tới grammar/kanji liên quan)
- [ ] Live-test 1 lesson per level (N5-N1) trên jpstudy.web.app

---

## 8. PHASE 4 — EXERCISE ENGINE OVERHAUL

### 8.1 6 exercise type spec

| Type | Input | Output | Bloom |
|---|---|---|---|
| Recognition (MCQ) | Item prompt | 4 options, pick 1 | L1-L2 |
| Production (sentence sort) | Target sentence + shuffled chunks | Drag-order chunks | L3 |
| Recall (typing) | Prompt (cue) | Type answer | L1-L3 |
| Reading comp | Passage + question | Pick 1 of 4 | L2-L4 |
| Listening | TTS audio + question | Pick 1 of 4 or type | L1-L3 |
| Conjugation drill | Verb/adj + target form | Type conjugated form | L3 |

### 8.2 ExerciseBank API

```dart
abstract class ExerciseBank {
  Future<List<Exercise>> getForItem({
    required String itemId,
    required ExerciseType type,
    BloomLevel? minLevel,
    int? limit,
  });

  Future<int> countForItem({
    required String itemId,
    required ExerciseType type,
  });

  /// Throws ExerciseDensityViolation nếu count < min (default 50)
  Future<void> ensureMinimumDensity({
    required String itemId,
    int min = 50,
  });

  /// Returns true nếu item có ≥ 1 exercise mỗi Bloom level
  Future<bool> hasBloomCoverage({required String itemId});
}
```

Storage: `assets/data/content/exercises/<level>/<textbook>/<lesson>.json`
keyed by `item_id`.

### 8.3 Generation pipeline

`tool/research/generate_exercises.js`:

- Input: item (grammar/vocab/kanji/conjugation) + examples + distractor bank
- Strategy per type:
  - **Recognition**: pick example, blank out item, generate distractor via
    DistractorEngine (Directive F.2)
  - **Production**: take example, chunk by 2-3 morpheme, shuffle
  - **Recall**: prompt = meaning_vi or audio, answer = item
  - **Reading comp**: pull from reading_passages_corpus where item appears,
    generate Q via templates (main_idea / detail / inference)
  - **Listening**: TTS prompt = example, Q types: "What did you hear?",
    "What's the meaning?"
  - **Conjugation**: lemma + target form prompt → type conjugated form
- Output: per-item exercise bank

Quality gate: each generated exercise pass through `ExerciseValidator`:

- Distractor not equal correct
- Distractor grammatically valid
- No duplicate within bank
- All 4 Bloom levels covered

### 8.4 Reading comp corpus

`assets/data/content/reading_passages/reading_passages_corpus.json`:

```json
{
  "passages": [
    {
      "passage_id": "rc-n3-001",
      "level": "N3",
      "ja_text": "...",
      "vi_translation": "...",
      "grammars_used": ["grammar:n3:shin_kanzen:01:003"],
      "vocabs_used": ["vocab:n3:..."],
      "kanjis_used": ["kanji:n3:..."],
      "questions": [
        {
          "type": "main_idea",
          "q_ja": "この文章の主旨は何ですか。",
          "q_vi": "Ý chính của đoạn văn này là gì?",
          "options_ja": [...],
          "options_vi": [...],
          "correct_index": 0,
          "explanation_vi": "..."
        }
      ],
      "source": "NHK Easy News (paraphrased, link-only attribution)"
    }
  ]
}
```

Counts required:

- N5: ≥ 10 mini passages (50-150 char)
- N4: ≥ 10 mini passages
- N3: ≥ 20 passages (100-300 char)
- N2: ≥ 20 passages
- N1: ≥ 20 passages

### 8.5 Phonetic confusion + kanji lookalike corpus

`tool/research/build_phonetic_trap_corpus.js`:

- For each vocab A, scan JMdict
- Compute Damerau-Levenshtein distance on kana
- Filter distance 1-2
- Rank by JLPT level closeness (prefer same level)
- Output `phonetic_traps.json` keyed by vocab_id

`tool/research/build_kanji_lookalike_corpus.js`:

- For each kanji, load KANJIVG SVG
- Render to 64×64 binary grid
- Compute Hamming distance vs all other kanji
- Top-3 lowest distance = visual lookalikes
- Output `kanji_lookalikes.json`

### 8.6 Validation

`tool/qa/validate_exercises.js`:

- Every item has ≥ 50 exercises (Directive F.1)
- Every exercise tagged with Bloom level
- Per item, all 4 Bloom levels covered
- Distractor checks (Directive F.2)
- Sample 20 random items, manual review log

### Phase 4 Acceptance

- [ ] `ExerciseBank` API implemented
- [ ] Every item ≥ 50 exercises (validator passes)
- [ ] 6 exercise types implemented
- [ ] Reading comp corpus populated per §8.4 counts
- [ ] Phonetic trap + kanji lookalike corpus built
- [ ] DistractorEngine integrated, distractor quality manual-reviewed (20 samples)

---

## 9. PHASE 5 — CROSS-LINK GRAPH

### 9.1 Build interlink_graph.json

`lib/data/interlink_graph.json` (built by
`tool/research/build_interlink_graph.js`):

```json
{
  "schema_version": 1,
  "generated_at": "2026-05-21T...",
  "nodes": {
    "grammar:n5:mina:01:001": {
      "type": "grammar",
      "level": "N5",
      "textbook": "mina",
      "lesson": "01",
      "label_ja": "N1 は N2 です",
      "label_vi": "N1 là N2"
    },
    "vocab:n5:mina:01:わたし": {
      "type": "vocab",
      "level": "N5",
      "textbook": "mina",
      "lesson": "01",
      "label_ja": "わたし",
      "label_vi": "Tôi"
    }
  },
  "edges": [
    {
      "from": "grammar:n5:mina:01:001",
      "to": "vocab:n5:mina:01:わたし",
      "rel": "uses"
    },
    {
      "from": "vocab:n5:mina:01:わたし",
      "to": "grammar:n5:mina:01:001",
      "rel": "used_in"
    }
  ]
}
```

Pipeline:

- Static analysis pass over all content
- For each grammar pattern: scan examples → find vocabs/kanjis used
- For each vocab: scan all grammar examples → find grammars dùng vocab này
- For each kanji: scan all vocabs → find vocabs chứa kanji này
- For each verb/adj: link to conjugation forms
- Output bi-directional edges

### 9.2 "Liên quan" UI section

`lib/widgets/related_section.dart`:

- Takes `node_id`, queries `interlink_graph`
- Renders 4 sub-sections:
  - Grammar dùng item này
  - Vocab chứa item này (nếu kanji)
  - Kanji trong item này (nếu vocab)
  - Conjugation forms (nếu verb/adj)
- Each sub-section: max 5 items, "Xem tất cả" link to full list
- Hover/long-press: preview popover

Integration: append to every detail page (grammar, vocab, kanji, conjugation).

### 9.3 Recommendation engine

`lib/services/recommendation_engine.dart`:

After lesson complete, suggest 3 things:

1. **SRS due hôm nay** dùng grammar/vocab/kanji vừa học (filter SRS state =
   due, intersect with `interlink_graph.successors(just_learned_item)`)
2. **Lesson kế tiếp** trong textbook đang theo
3. **Cross-textbook similar pattern** (e.g. vừa học pattern A ở Mina, suggest
   pattern tương tự ở Shin Kanzen)

Algorithm: weighted scoring (SRS urgency × interlink strength × novelty).

### 9.4 Cross-modal SRS migration

`tool/migration/migrate_srs_to_cross_modal.dart`:

- Old: 1 FSRSState per item
- New: `Map<ExerciseMode, FSRSState>` per item
- Migration: existing state copied to `flashcard` mode key; other modes
  start fresh (New state)

`SRSStore.markKnown()` → deprecated:

```dart
@Deprecated('Self-attestation removed per Directive F.5')
void markKnown(String itemId) {
  throw UnsupportedError(
    'markKnown removed. Use auto-update from exercise results.',
  );
}
```

### Phase 5 Acceptance

- [ ] `interlink_graph.json` exists with ≥ 50,000 edges (estimate for N5-N1 full)
- [ ] "Liên quan" section renders on every detail page
- [ ] Recommendation engine suggests 3 items after lesson complete
- [ ] SRS migrated to cross-modal schema (no data loss)
- [ ] `markKnown` throws + no UI button calls it

---

## 10. PHASE 6 — RESPONSIVE + HOME PAGE

### 10.1 Breakpoints

`lib/responsive/breakpoints.dart`:

```dart
enum Breakpoint { mobile, tabletPortrait, tabletLandscape, desktop }

class Breakpoints {
  static Breakpoint fromWidth(double width) {
    if (width < 768) return Breakpoint.mobile;
    if (width < 1024) return Breakpoint.tabletPortrait;
    if (width < 1280) return Breakpoint.tabletLandscape;
    return Breakpoint.desktop;
  }
}

class BreakpointBuilder extends StatelessWidget {
  final Widget Function(BuildContext, Breakpoint) builder;
  const BreakpointBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final bp = Breakpoints.fromWidth(constraints.maxWidth);
        return builder(ctx, bp);
      },
    );
  }
}
```

### 10.2 Mobile patterns

- Bottom sheet cho mode picker (swipe up to expand)
- Fullscreen flashcard (no horizontal padding, edge-to-edge)
- Sticky header gọn: chỉ ← Quay lại + lesson title
- Gesture swipe trái/phải = next/prev card
- Tap to flip
- Long press = mark difficult
- Pull-to-refresh trên home → reload SRS due count

### 10.3 Home page 4 widgets

`lib/features/home/widgets/`:

#### `today_plan_widget.dart`

- SRS due count (vocab/grammar/kanji breakdown)
- 1 đề xuất lesson (theo path plan)
- CTA "Bắt đầu học hôm nay"

#### `level_progress_widget.dart`

- 5 bars: N5/N4/N3/N2/N1
- Each: % completion + items mastered / total
- Tap → drill into level

#### `streak_widget.dart`

- Current streak (consecutive days với ≥ 1 SRS review)
- Freeze count (3/month available — auto-protect missed day)
- Best streak record

#### `last_context_widget.dart`

- "Đang dở: Mina N5 — Bài 3 — Nơi chốn & giá cả"
- CTA "Học tiếp"
- Progress bar in-lesson

#### Layout responsive

```dart
GridView(
  crossAxisCount: switch (breakpoint) {
    Breakpoint.mobile => 1,
    Breakpoint.tabletPortrait => 2,
    Breakpoint.tabletLandscape => 2,
    Breakpoint.desktop => 4,
  },
  ...
)
```

### Phase 6 Acceptance

- [ ] 4 breakpoints work, no overflow at any
- [ ] Mobile bottom sheet mode picker functional
- [ ] Mobile fullscreen flashcard với gesture swipe
- [ ] Home page 4 widgets render
- [ ] Layout responsive 1/2/4-col

---

## 11. PHASE 7 — LIVE PROOF + ACCEPTANCE

### 11.1 Random sampling N=5 per category

`tool/qa/random_sample_e2e.js`:

- Categories: grammar, vocab, kanji, conjugation, reading_comp
- N=5 random items per category × 5 categories = 25 items
- Per item, run E2E flow:
  1. Navigate to item detail page
  2. Verify content renders (no empty/placeholder)
  3. Verify "Liên quan" section has ≥ 1 link per applicable sub-section
  4. Open each available mode, attempt 5 exercises
  5. Verify SRS updates per-mode
  6. Verify cross-link nav works (click "Liên quan" link → lands correct page)
- Output report: `docs/research/phase7-random-sample-e2e-2026-05-21.md`

Acceptance: 25/25 items pass all flow steps.

### 11.2 Visual regression 4 viewports

Playwright config:

```js
const viewports = [
  { width: 360, height: 640, name: 'mobile' },
  { width: 768, height: 1024, name: 'tablet_portrait' },
  { width: 1024, height: 768, name: 'tablet_landscape' },
  { width: 1280, height: 800, name: 'desktop' },
];
```

Pages to screenshot:

- Home page
- Level page (random level)
- Textbook page (random textbook)
- Lesson page (random lesson)
- Item detail page (random per category: grammar, vocab, kanji, conjugation)
- Mode page (random per mode: flashcard, MCQ, matching, typing, writing,
  dokkai, listening, conjugation drill)

Process:

- First run: create baseline screenshots
- Subsequent runs: pixel diff vs baseline, fail if > 1% diff on any viewport

Output: `docs/research/phase7-visual-regression-2026-05-21.md`

### 11.3 E2E user flows (3 personas)

- **New learner**: signup anonymous → home → choose N5 → first lesson Mina
  Bài 1 → complete first MCQ exercise
- **Returning learner**: home → today's plan → SRS review → recommendation
  → next lesson
- **Power user**: search "は particle" → grammar detail → "Liên quan" → vocab
  → "Liên quan" → kanji → conjugation master page

Each flow: ≤ 30 sec to complete, no console errors, no broken links.

### 11.4 Lighthouse

```bash
npx lighthouse https://jpstudy.web.app/ \
  --output=json --output-path=docs/research/lighthouse-mobile-2026-05-21.json \
  --preset=mobile

npx lighthouse https://jpstudy.web.app/ \
  --output=json --output-path=docs/research/lighthouse-desktop-2026-05-21.json \
  --preset=desktop
```

Acceptance thresholds:

- Performance: ≥ 70 mobile, ≥ 85 desktop
- Accessibility: ≥ 90
- SEO: ≥ 90
- Best Practices: ≥ 90

### 11.5 Deploy + verify

```bash
node tool/deploy/hosting_deploy.js
```

Verify on `https://jpstudy.web.app`:

- Home page renders all 4 widgets
- Random lesson per category renders correctly
- Mobile viewport works (Chrome DevTools device emulation)
- App Check still **monitoring mode** (do NOT enforce per CLAUDE.md)
- Sentry DSN active (test với captureMessage)
- GA4 events firing (test với debug view)

### Phase 7 Acceptance

- [ ] Random sample 25/25 pass
- [ ] Visual regression all 4 viewports pass (≤ 1% diff)
- [ ] 3 personas flows pass
- [ ] Lighthouse meets thresholds
- [ ] Deploy successful
- [ ] Live verify checklist all green

---

## 12. NON-NEGOTIABLE RULES (KHÔNG ĐƯỢC VI PHẠM)

1. **KHÔNG add tag `vi-human-approved`** — chỉ owner add sau item-level review
2. **KHÔNG browse `nhaikanji.com` hoặc `thocodehoctiengnhat.com`** —
   Directive B ban list, owner đã rule cứng
3. **KHÔNG `git commit --no-verify`** — không skip hooks
4. **KHÔNG `git push --force` on `main`** — trừ khi owner explicit request
5. **KHÔNG tạo branch** — commit thẳng `main` per CLAUDE.md
6. **KHÔNG enable App Check enforcement** — giữ monitoring mode
7. **KHÔNG execute deletion runbook** — owner tự run với `--execute`
8. **KHÔNG enter GitHub Actions secrets** — owner set thủ công
9. **KHÔNG tạo account thay user** — owner tự tạo
10. **KHÔNG quote ≥ 15 từ verbatim từ copyrighted source** — facts only,
    paraphrase, cite license
11. **KHÔNG fabricate email/contact** — `xboxonevn@gmail.com` là email thật
12. **KHÔNG enable Firebase Storage** — Spark plan, owner descoped
13. **KHÔNG remove existing PII protections** — anonymous Auth, legacy
    storage migration gate

---

## 13. WHITELIST online sources

CHỈ dùng các nguồn sau (mọi citation phải attribute đúng license):

| Source | License | Use |
|---|---|---|
| JMdict | CC-BY-SA 4.0 (EDRDG) | Vocab data, POS, glosses |
| KANJIDIC2 | CC-BY-SA 4.0 (EDRDG) | Kanji info, readings, meanings |
| Unihan kVietnamese | Unicode license | Hán-Việt readings |
| Tatoeba | CC-BY 2.0 FR | Example sentences (JA-VI có sẵn) |
| Wiktionary | CC-BY-SA 3.0 | Etymology, usage notes |
| NHK Easy News | © NHK link-only | Reading paraphrase (no verbatim) |
| Tae Kim Grammar | CC-BY-NC-SA 3.0 | Conjugation rules |
| KANJIVG | CC-BY-SA 3.0 | Stroke order + lookalike detection |
| MEXT Joyo Kanji | Public domain | Official kanji list + readings |
| Tofugu (educational posts) | © Tofugu link-only | Reference for pedagogy methodology |

Owner-provided local files (PDFs from Mimikara, Mina I-II, vocab-by-kanji):
trong folder `C:\Users\xboxo\Desktop\PC\Tai lieu JPStudy\Tu Vung`. Use as
reference per `docs/credits/upper-jlpt-sources.md`.

---

## 14. DECISION MATRIX

### 14.1 Khi gặp tình huống cần quyết

| Situation | Action |
|---|---|
| Pure design choice (color, icon, label) | Tự quyết, log DECISION |
| Schema choice (field name, type) | Tự quyết theo Phase 0 design doc, log DECISION |
| Trade-off perf vs UX | Default to UX, log DECISION + trade-off |
| Trade-off content quality vs coverage | Default to **quality** (≥ 50 questions, distractor F.2), log DECISION |
| Owner-only policy choice (taxonomy, legal copy) | OPEN_QUESTION blocking, skip + continue khác phase |
| Data ambiguity (2 sources disagree) | Pick more authoritative (textbook > Wiktionary > web), log + cite |
| Tool/library choice | Stick with existing project conventions (Flutter Riverpod Drift), log DECISION nếu thêm dep |
| Breaking change risk | Add migration script + dual-read, log DECISION + rollback plan |
| Performance regression | Profile + optimize trước, không ship slow code, log DECISION |
| Accessibility concern | Default to WCAG AA, log DECISION |

### 14.2 Khi gặp lỗi

- Lỗi tech (test fail, build fail): debug + fix, KHÔNG skip/ignore
- Lỗi data (validation fail): regenerate + revalidate, KHÔNG bypass validator
- Lỗi production (live verification fail): rollback commit, log + retry với
  fix, KHÔNG leave broken
- Lỗi không hiểu: log OPEN_QUESTION blocking, continue khác phase

---

## 15. ACCEPTANCE GATE (final checklist)

Trước khi signal mission complete:

### Per-phase

- [ ] Phase 0: 7 design docs committed, Directive F appended
- [ ] Phase 1: textbook_index manifest exists, migration 0-loss validated
- [ ] Phase 2: conjugation_corpus ≥ 1000 verbs + ≥ 500 adj với full forms
- [ ] Phase 3: Lesson page renders all features, Kanji tab deleted
- [ ] Phase 4: Every item ≥ 50 exercises, 6 modes implemented, Bloom L1-L4
      covered, reading comp corpus populated
- [ ] Phase 5: interlink_graph built, "Liên quan" on every detail page,
      cross-modal SRS migrated, markKnown deprecated
- [ ] Phase 6: 4 breakpoints work, home page 4 widgets, mobile patterns OK
- [ ] Phase 7: 25/25 random sample pass, visual regression pass, 3 personas
      pass, Lighthouse meets thresholds, deploy + live verify pass

### Cross-cutting

- [ ] `docs/agent-directives.md` has Directive F appended
- [ ] `docs/research/quality-backlog.md` tickets closed for resolved pain points
- [ ] `docs/research/autonomous-loop-status.md` has 1+ entry per phase
- [ ] `docs/research/decisions-log-2026-05-21.md` documents all decisions
- [ ] `docs/research/open-questions-2026-05-21.md` documents all OQs
- [ ] No `vi-human-approved` tag added
- [ ] No nhaikanji / thocodehoctiengnhat accessed (grep git log to confirm)
- [ ] No `--no-verify`, no `--force` push on main
- [ ] All commits Conventional Commits format, subject ≤ 72 char

### Signal complete

Final entry `docs/research/autonomous-loop-status.md`:

```
## 2026-05-21 — Megaprompt Overhaul COMPLETE
- All 8 phases done (see per-phase entries above)
- Acceptance gate: all checkboxes green
- Live verified: https://jpstudy.web.app
- Owner review pending
- DECISIONS_MADE: N entries
- OPEN_QUESTIONS: N entries (pending owner review)
- Rollback safe: all migrations have dual-read fallback
```

---

## 16. INITIAL ACTION — START HERE

Run trong order:

1. **Read context** (§0): CLAUDE.md, AGENTS.md, docs/agent-directives.md,
   docs/research/quality-backlog.md, docs/research/autonomous-loop-status.md
2. **Append kickoff entry** to `docs/research/autonomous-loop-status.md`
   (template in §0)
3. **Open decision + OQ logs**:
   - Create `docs/research/decisions-log-2026-05-21.md` với header
   - Create `docs/research/open-questions-2026-05-21.md` với header
4. **Start Phase 0** (§4): write 7 design docs + append Directive F + commit
5. **Continue phase by phase** per §3.1 ordering
6. **Run acceptance gate** §15 trước khi signal complete

KHÔNG hỏi owner trong overnight run. Tự quyết theo Decision Matrix §14. Log
mọi DECISIONS_MADE + OPEN_QUESTIONS. Skip blocking OQ và làm phase khác. Run
liên tục đến Acceptance Gate §15 pass.

Token UNLIMITED. Online lookup AUTHORIZED (whitelist §13, ban list §12).
Quality > speed. Directive D + E + F là tinh thần chỉ đạo: làm việc liên
kết, dạy bằng giọng người, đảm bảo mật độ + cross-link + responsive.

Good luck. Báo cáo khi xong.
