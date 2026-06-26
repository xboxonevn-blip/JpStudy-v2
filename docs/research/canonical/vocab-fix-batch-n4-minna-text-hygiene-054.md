# Vocab Fix Batch - n4-minna-text-hygiene-054

- Date: 2026-06-25T22:02:06.6681326+07:00
- Scope: QA-A-030, N4 Minna lesson 26 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. Exact phrase
coverage was absent for `都合がいい`, `都合が悪い`, and `困ったなあ`, so those
rows received example-only repairs and no new source-verification metadata.
`片付きます` was verified through local base lemma `片付く`; `ごみを拾う` was
verified through local base lemma `拾う`.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `都合がいい` | `つごうがいい` | Example-only context repair | `その態度は少し都合がいいと感じました。` / `Tôi cảm thấy thái độ đó hơi có thời gian.` | `明日の午後は都合がいいです。` / `Chiều mai thì tôi có thời gian.` | No `sourceConsensus` added because exact phrase coverage is absent. |
| `都合が悪い` | `つごうがわるい` | Example-only context repair | `その態度は少し都合が悪いと感じました。` / `Tôi cảm thấy thái độ đó hơi bận.` | `すみません、明日は都合が悪いです。` / `Xin lỗi, ngày mai tôi không tiện.` | No `sourceConsensus` added because exact phrase coverage is absent. |
| `片付きます` | `かたづきます` | Meaning and example repair | `được dọn dẹp (hành lý)` / `朝の準備が終わったら片付きます。` / `Khi chuẩn bị buổi sáng xong, tôi được dọn dẹp.` | `Được dọn dẹp ngăn nắp, gọn gàng [đồ đạc ~]` / `引っ越しの荷物は今日中に片付きます。` / `Đồ chuyển nhà sẽ được dọn xong trong hôm nay.` | Source lemma `片付く`; `sourceConsensus`: `minna-2`, `kanji-vocab-n3`, `kanji-vocab-n2`; ticket `QA-A-030`. |
| `困ったなあ` | `こまったなあ` | Example-only context repair | `困ったなあの前で友だちを待ちました。` / `Tôi đã đợi bạn trước Gay quá.` | `困ったなあ、財布を忘れました。` / `Gay quá, tôi quên ví rồi.` | No `sourceConsensus` added because exact phrase coverage is absent. |
| `ごみを拾う` | `ごみをひろう` | Meaning capitalization and example repair | `nhặt rác` / `困ったときは一度ごみを拾うことがあります。` / `Khi gặp khó, đôi khi tôi nhặt rác một lần.` | `Nhặt rác` / `公園でごみを拾いました。` / `Tôi đã nhặt rác ở công viên.` | Source lemma `拾う`; `sourceConsensus`: `minna-2`, `kanji-vocab-n3`; ticket `QA-A-030`. |

## Learner-Facing Notes

- Replaced stale generated examples that modeled schedule availability,
  cleanup state, exclamation usage, and trash-pickup contexts unnaturally.
- Kept exact-phrase rows without source verification when local canonical
  coverage was insufficient, preserving the distinction between authored
  example cleanup and source-verified content.
