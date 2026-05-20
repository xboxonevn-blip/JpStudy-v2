# Conjugation Layer Design - 2026-05-21

## Mục tiêu

Make conjugation a first-class learning layer in two anchors:

1. Standalone Grammar entry: `Bảng chia thể động từ · tính từ`.
2. Inline lesson widget that appears only when the lesson has verbs or adjectives.

Each verb/adjective must support dense drills: at least 50 questions per item, distractors from other forms of the same lemma, and SRS updates by mode.

## Bối cảnh

The repo already has:

- `lib/core/conjugation/`
- `assets/data/content/conjugation/lemmas.json`
- `tool/research/build_conjugation_lemmas.dart`
- grammar-owned conjugation routes and focused tests

Phase 2 extends this instead of replacing it.

## Schema

`assets/data/content/conjugation/conjugation_corpus.json`

```json
{
  "schema_version": 1,
  "generated_at": "2026-05-21T00:00:00+07:00",
  "source_policy": {
    "rules": ["Tae Kim CC-BY-NC-SA reference", "MEXT Joyo grammar tables reference"],
    "lexemes": ["current app vocab", "JMdict POS facts"]
  },
  "verbs": {
    "食べる": {
      "item_id": "conj:verb:食べる",
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
        "potential": "食べられる"
      },
      "examples_per_form": {
        "te": [
          {
            "ja": "パンを食べてください。",
            "vi": "Hãy ăn bánh mì.",
            "source": "jpstudy-original"
          }
        ]
      }
    }
  },
  "i_adjectives": {},
  "na_adjectives": {}
}
```

## Generator algorithm

Tool: `tool/research/generate_conjugation_corpus.js`.

Inputs:

- current vocab assets
- JMdict POS tags already imported into lemma tooling where available
- existing `lemmas.json`
- manual irregular seed file

Steps:

1. Normalize lemma, reading, level, meaning.
2. Detect class through current `ConjugationSpec.fromJmDictPos`.
3. Apply `JapaneseConjugator` for supported forms.
4. Patch irregulars from manual seed before validation.
5. Generate at least 10 short original example templates per high-priority form where possible.
6. Log skipped entries to `conjugation_generation_errors.log`.

Manual irregular seed minimum:

- `する`, `来る`, `行く`, `ある`, `死ぬ`, `いる`
- honorific/humble: `いらっしゃる`, `おっしゃる`, `くださる`, `なさる`, `ござる`, `召し上がる`, `参る`, `伺う`, `いただく`
- common compound `する` verbs from current vocab

## Component tree

```text
ConjugationMasterPage
├── SearchAndFilterBar
├── FormFamilyTabs
├── LemmaResultList
│   └── LemmaCard
│       ├── FormsPreview
│       ├── SourceBadge
│       └── DrillCTA
└── ConjugationDrillLauncher

ConjugationWidget
├── LessonVerbAdjSummary
├── CompactFormsTable
└── DrillCTA "Luyện chia thể (50+ câu)"
```

Routes:

- `/grammar/conjugation`
- `/grammar/conjugation/:lemma`
- `/grammar/conjugation/:lemma/drill`

## SRS integration

New state key shape:

```text
conj:<lemma>:<form>:<mode>
```

Modes:

- recognition
- production
- typing
- context

Existing SRS progress is copied into `recognition`; other modes start fresh.

## Migration plan

1. Convert current `lemmas.json` into `conjugation_corpus.json`.
2. Add validator for required forms per class.
3. Add manual irregular seed and tests.
4. Add standalone master page search/filter.
5. Add conditional lesson widget.
6. Route existing conjugation CTAs to the dense drill engine.

## Acceptance criteria

- Corpus has at least 1000 verbs and 500 adjectives with valid forms.
- At least 30 irregular/manual entries pass exact fixtures.
- Standalone page renders and filters by level/group/form.
- Inline widget renders only when lesson has verb/adjective items.
- Drill generator produces at least 50 valid questions per lemma.

## Open questions

- Some JMdict POS labels can be ambiguous for suru compounds; default is to keep lemma and log `needs-pos-review`.
- Honorific old-style forms are pedagogically tricky; default is modern learner-facing forms first.
