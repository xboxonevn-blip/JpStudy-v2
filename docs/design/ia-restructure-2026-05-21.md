# IA Restructure Design - 2026-05-21

## Mục tiêu

Restructure learning navigation from flat level tabs into a hierarchy that feels like real study material:

`JLPT level -> textbook/source track -> theme/chapter -> lesson -> item`.

The redesign must keep old URLs working while adding textbook manifests for Minna, Hajimete Tango, Shin Kanzen, Mimikara, and kanji/vocab companion sources.

## Bối cảnh

Current app surfaces level-first content. That makes upper-level study feel like a pile of independent assets instead of a guided curriculum. Owner specifically called out the missing textbook/theme/lesson hierarchy.

Existing data under `assets/data/content/` stays the source during transition. New manifests add structure and routing metadata without deleting flat assets.

## Schema

### `lib/data/manifests/textbook_index.json`

```json
{
  "schema_version": 1,
  "generated_at": "2026-05-21T00:00:00+07:00",
  "textbooks": [
    {
      "textbook_id": "minna_n5",
      "level": "N5",
      "name_ja": "みんなの日本語 初級I",
      "name_vi": "Minna no Nihongo Sơ cấp I",
      "name_en": "Minna no Nihongo Elementary I",
      "categories": ["grammar", "vocab"],
      "lesson_count": 25,
      "item_count_total": 0,
      "source_credit": "3A Corporation reference only; no verbatim reproduction"
    }
  ]
}
```

### `lib/data/manifests/lesson_index_<textbook>.json`

```json
{
  "schema_version": 1,
  "textbook_id": "minna_n5",
  "lessons": [
    {
      "lesson_id": "minna_n5_01",
      "lesson_number_ja": "第1課",
      "lesson_number_vi": "Bài 1",
      "theme_ja": "自己紹介",
      "theme_vi": "Giới thiệu bản thân",
      "item_counts": {"grammar": 0, "vocab": 0, "kanji": 0},
      "est_minutes": 45,
      "prerequisites": []
    }
  ]
}
```

### `lib/data/manifests/item_index_<textbook>_<lesson>.json`

```json
{
  "schema_version": 1,
  "lesson_id": "minna_n5_01",
  "items": [
    {
      "item_id": "vocab:n5:minna_n5:01:わたし",
      "type": "vocab",
      "surface": "わたし",
      "reading": "わたし",
      "legacy_ref": "vocab/n5/minna/lesson_01.json#わたし",
      "exercise_bank_ref": "exercises/n5/minna_n5/lesson_01.json#vocab:n5:minna_n5:01:わたし"
    }
  ]
}
```

## Component tree

```text
LearnHome
├── LevelSwitcher
├── TextbookRail
│   └── TextbookCard[]
├── ThemeLessonMap
│   ├── ThemeHeader
│   └── LessonCard[]
└── ContinueContextCard
```

Route pattern:

```text
/learn/:level
/learn/:level/:textbook
/learn/:level/:textbook/:lesson
/learn/:level/:textbook/:lesson/:item
```

Old routes redirect or deep-link into the nearest new route:

```text
/lesson/1?level=N5 -> /learn/N5/minna_n5/minna_n5_01
/grammar -> /learn/<persistedLevel>
/vocab -> /learn/<persistedLevel>
```

## Migration plan

1. Generate manifests from current flat content and owner source references.
2. Add `textbook_id`, `lesson_id`, and `item_id` tags through derived manifests first, not in every source JSON.
3. Implement `textbookContentReader` beside existing flat readers.
4. Update routes to prefer manifests but fall back to flat readers.
5. Add redirect helpers for old lesson/detail URLs.
6. Validate zero data loss: old item count equals manifest item count.

## Acceptance criteria

- `textbook_index.json` covers N5-N1 required textbooks.
- Every lesson in a manifest has at least one item or an explicit `coming_soon: true` reason.
- Old routes still render learner-facing content.
- New routes render level -> textbook -> lesson hierarchy.
- Migration validator reports 0 lost items and 0 orphan item IDs.

## Open questions

- Exact theme names for some owner-provided textbook tracks need later owner review.
- Mimikara N4/N5 availability in local folder needs inventory confirmation in Phase 1.
- Some existing app lessons are synthetic Shin Kanzen buckets; preserve them as "JpStudy structured track" if no exact publisher mapping exists.
