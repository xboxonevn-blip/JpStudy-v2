# Exercise Engine Design - 2026-05-21

## Mục tiêu

Raise exercise density and quality from small drills to mastery-ready banks:

- at least 50 questions per learning item
- all four Bloom levels covered
- six exercise modes
- JLPT-pattern distractors that are not trivial
- validators that fail builds when density or quality drops

## Bối cảnh

Current grammar practice already uses a shared bank pattern, but density is too low for the new Directive F. Vocab, kanji, and conjugation also need the same bank contract so Review, Lesson, Detail, and Practice flows all use one source of truth.

## Schema

`assets/data/content/exercises/<level>/<textbook>/<lesson>.json`

```json
{
  "schema_version": 1,
  "lesson_id": "minna_n5_01",
  "items": {
    "grammar:n5:minna_n5:01:001": {
      "minimum_required": 50,
      "questions": [
        {
          "question_id": "ex:grammar:n5:minna_n5:01:001:recognition:0001",
          "type": "recognition",
          "bloom": "remember",
          "prompt_ja": "わたし ___ 学生です。",
          "prompt_vi": "Chọn trợ từ đúng.",
          "options": ["は", "が", "を", "に"],
          "correct_index": 0,
          "distractor_rationale": ["topic-vs-subject", "object", "direction"],
          "source": "jpstudy-generated",
          "validation": {"deduped": true, "not_trivial": true}
        }
      ]
    }
  }
}
```

## Exercise types

| Type | Input | Output | Bloom |
|---|---|---|---|
| recognition | item prompt | 4-option MCQ | L1-L2 |
| production | sentence chunks | ordered sentence | L3 |
| recall | cue | typed answer | L1-L3 |
| reading_comp | passage | main/detail/inference MCQ | L2-L4 |
| listening | TTS or owned audio | MCQ/typing | L1-L3 |
| conjugation_drill | lemma + target form | typed conjugated form | L3 |

## API

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
    ExerciseType? type,
  });

  Future<void> ensureMinimumDensity({
    required String itemId,
    int min = 50,
  });

  Future<bool> hasBloomCoverage({required String itemId});
}
```

## Distractor engine

Vocab:

- phonetic trap: Damerau-Levenshtein distance 1-2 on kana
- compound trap: different kanji, same or close reading
- same-level random semantic neighbor

Grammar:

- wrong particle
- wrong tense/aspect
- wrong politeness
- wrong negation
- near-synonym pattern with incompatible formation

Kanji:

- visual lookalike from `kanji_lookalikes.json`
- same reading different kanji
- same radical different meaning

Conjugation:

- other forms of same lemma
- same form from similar class
- common learner error for irregulars

## Bloom progression

Mastery gates require:

- L1 Remember: match, basic MCQ
- L2 Understand: paraphrase/meaning choice
- L3 Apply: use in sentence or produce form
- L4 Analyze: choose correct sentence in context-heavy options

An item cannot be called "mastered" until all required modes have at least 80 percent accuracy.

## Migration plan

1. Define common exercise models and validators.
2. Wrap current grammar bank behind `ExerciseBank`.
3. Generate static exercise assets from existing examples and item metadata.
4. Build phonetic trap and kanji lookalike corpora.
5. Add reading comprehension corpus and link passages to items.
6. Migrate Review and Lesson practice CTAs to the unified bank.

## Validation

`tool/qa/validate_exercises.js` must check:

- every eligible item has at least 50 questions
- no duplicate question IDs
- no duplicate options within a question
- correct answer appears exactly once
- Bloom L1-L4 exists per item
- distractor rationale exists for every wrong option
- source policy is explicit

## Acceptance criteria

- `ExerciseBank` implemented and used by grammar/vocab/kanji/conjugation practice entry points.
- Six exercise types render.
- Validator passes across all eligible items.
- Reading comprehension corpus meets per-level counts.
- Manual sample of 20 questions is logged.

## Open questions

- Listening mode needs owned/TTS audio policy before broad release; default is text-first with TTS placeholder disabled unless license-safe.
- Some low-frequency items may not have enough natural examples; default is generated original short sentences with validator tags.
