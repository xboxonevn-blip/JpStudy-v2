# Vocab Fix Batch - n4-minna-text-hygiene-060

- Date: 2026-06-26T09:19:01.7399142+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. All five rows were
verified through exact local rows: `ペット`, `鳥`, `声`, `波`, and `花火`.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `ペット` | `ぺっと` | Meaning and example repair | `thú cưng` / `これはペットです。` / `Đây là thú cưng.` | `Thú cưng, động vật nuôi` / `このマンションではペットを飼えません。` / `Ở chung cư này không được nuôi thú cưng.` | Exact local row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `鳥` | `とり` | Meaning capitalization and example repair | `chim` / `これは鳥です。` / `Đây là chim.` | `Chim` / `朝、庭で鳥が鳴いています。` / `Buổi sáng, chim đang hót trong vườn.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |
| `声` | `こえ` | Meaning and example repair | `tiếng (người, động vật)` / `これは声です。` / `Đây là tiếng.` | `Tiếng, giọng nói` / `電話で母の声が聞こえました。` / `Qua điện thoại, tôi nghe thấy giọng của mẹ.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n4`, `minna-2`; ticket `QA-A-030`. |
| `波` | `なみ` | Meaning capitalization and example repair | `sóng` / `これは波です。` / `Đây là sóng.` | `Sóng` / `今日は波が高いです。` / `Hôm nay sóng cao.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n2`, `minna-2`; ticket `QA-A-030`. |
| `花火` | `はなび` | Meaning capitalization and example repair | `pháo hoa` / `これは花火です。` / `Đây là pháo hoa.` | `Pháo hoa` / `夏祭りで花火を見ました。` / `Tôi đã xem pháo hoa ở lễ hội mùa hè.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n5`, `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- Replaced bare `これは...です` examples with contexts connected to lesson-27
  themes: apartment pet rules, birds, audible voices, waves, and fireworks.
- Normalized Vietnamese capitalization and tightened `声` to the learner-facing
  voice/sound sense used by the lesson.
