# Lesson Page Design - 2026-05-21

## Mục tiêu

Replace the thin lesson page with a study workspace: strong flashcard zone, mode picker, term list, conjugation widget when relevant, and cross-link badges. Remove deceptive empty Kanji tabs.

## Bối cảnh

Owner compared JpStudy lesson pages with richer textbook-style references and called out:

- empty Kanji tab pretending content exists
- flashcards missing learner tools
- mode surface too shallow
- exercises too sparse

## Component tree

```text
LessonPage
├── BreadcrumbBar (sticky)
│   └── N5 / Minna N5 / 第1課 - Giới thiệu bản thân
├── LessonHeader
│   ├── Title ja + vi
│   ├── PrevNextPagination
│   └── ActionButtons (Góp ý, Xuất PDF luyện viết when available)
├── ResponsiveContainer(maxWidth: 1040)
│   ├── FlashcardZone
│   │   ├── FlashcardDisplay
│   │   ├── AudioButton
│   │   ├── StarButton
│   │   ├── NavArrows
│   │   ├── ShortcutHintsBar
│   │   ├── ContentToggle (Từ đơn / Ví dụ)
│   │   ├── DirectionToggle (JP->VI / VI->JP)
│   │   └── ProgressBar
│   ├── WarningBanner
│   ├── ModePicker
│   │   ├── Flashcard
│   │   ├── Recognition
│   │   ├── SentenceSort
│   │   ├── Typing
│   │   ├── Reading
│   │   ├── Listening
│   │   └── Conjugation (conditional)
│   ├── ConjugationWidget (conditional)
│   └── TermList
│       ├── FilterChips
│       └── TermCard[]
│           ├── NumberBadge
│           ├── JapaneseSurface
│           ├── Furigana/Reading
│           ├── Meaning
│           ├── SourceConfidenceBadge
│           ├── CrossLinkBadges
│           └── PracticeCTA
```

## ASCII mockup

```text
N5 / Minna N5 / 第1課
┌────────────────────────────────────────────────────────────┐
│ 第1課 - Giới thiệu bản thân              ← Bài trước | Tiếp → │
├────────────────────────────────────────────────────────────┤
│ ┌──────────────────── Flashcard ────────────────────────┐ │
│ │                         わたし                         │ │
│ │                         Tôi                            │ │
│ │     ◀                                      ▶            │ │
│ │ Space:lật  Z:biết  X:chưa  R:nghe                    │ │
│ └────────────────────────────────────────────────────────┘ │
│ [Flashcard] [MCQ] [Sắp câu] [Gõ] [Đọc hiểu] [Nghe] [Chia] │
│ ┌──────── Chia thể trong bài ────────┐                    │
│ │ 行く -> 行きます / 行って ...       │ [Luyện 50+ câu]     │
│ └────────────────────────────────────┘                    │
│ Từ trong bài                                               │
│ 01 わたし  Tôi        [Kanji] [Grammar dùng từ này] [Luyện]│
└────────────────────────────────────────────────────────────┘
```

## Data contract

Lesson page consumes:

- `lesson_index_<textbook>.json`
- `item_index_<textbook>_<lesson>.json`
- exercise count summary from `ExerciseBank`
- interlink summaries from `interlink_graph.json`
- conjugation summary from `conjugation_corpus.json`

## Migration plan

1. Keep current lesson screen route but add new data adapter.
2. Hide Kanji tab unless the lesson has lesson-specific kanji.
3. Replace tab layout with mode picker plus term list.
4. Add flashcard zone with keyboard shortcuts and mobile gestures.
5. Add conditional conjugation widget.
6. Add cross-link badges to term cards.
7. Add responsive tests for 360, 768, 1024, 1280 widths.

## Acceptance criteria

- No empty/stub Kanji tab.
- Flashcard has flip, audio, star, direction toggle, progress, and navigation.
- Mode picker only shows modes with content.
- Conjugation widget appears only when lesson has verbs/adjectives.
- Term cards have live cross-links and practice CTAs.
- No overflow at required breakpoints.

## Open questions

- PDF export for writing practice depends on generated handwriting assets; default is hide when unavailable.
- Some old lesson rows may lack enough examples for flashcard example mode; default is show term-only and log density gap.
