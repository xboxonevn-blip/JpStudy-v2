# Vocab Fix Batch - n4-minna-text-hygiene-064

- Date: 2026-06-26T14:47:45.8289729+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. Exact local rows
verified `パーティールーム` through Minna-2, `関西空港` through kanji-vocab
N2/N3/N4/N5, and `家` through the Minna-2 lesson-27 row. `秋葉原` and
`伊豆` are app-only place rows in the local diff, so their examples were
repaired without new source-verification metadata.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `パーティールーム` | `ぱーてぃーるーむ` | Meaning capitalization, metadata, and example repair | `phòng tiệc` / `パーティールームの前で友だちを待ちました。` / `Tôi đã đợi bạn trước phòng tiệc.` | `Phòng tiệc` / `このパーティールームはだれでも使えます。` / `Phòng tiệc này ai cũng có thể dùng.` | Exact Minna-2 row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `関西空港` | `かんさいくうこう` | Search normalization, metadata, and example repair | `san bay kansai` / `関西空港の前で友だちを待ちました。` / `Tôi đã đợi bạn trước Sân bay Kansai.` | `San bay Kansai` / `関西空港で友だちを迎えました。` / `Tôi đã đón bạn ở sân bay Kansai.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n2`, `kanji-vocab-n3`, `kanji-vocab-n4`, `kanji-vocab-n5`; ticket `QA-A-030`. |
| `秋葉原` | `あきはばら` | Example repair | `秋葉原の前で友だちを待ちました。` / `Tôi đã đợi bạn trước Akihabara.` | `秋葉原で電気製品を買いました。` / `Tôi đã mua đồ điện tử ở Akihabara.` | App-only place row; no new source-verification tag. |
| `伊豆` | `いず` | Example repair | `伊豆の前で友だちを待ちました。` / `Tôi đã đợi bạn trước Bán đảo Izu.` | `週末に伊豆へ旅行に行きました。` / `Cuối tuần tôi đã đi du lịch Izu.` | App-only place row; no new source-verification tag. |
| `家` | `いえ` | Meaning, metadata, and example repair | `ngôi nhà` / `家の前で友だちを待ちました。` / `Tôi đã đợi bạn trước ngôi nhà.` | `Nhà` / `将来、自分の家を建てたいです。` / `Trong tương lai, tôi muốn xây nhà của mình.` | Exact Minna-2 lesson-27 row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- This batch replaces the remaining lesson-27 place-context template
  `Xの前で友だちを待ちました` with concrete airport, shopping, travel, room-use,
  and house-building contexts.
- `秋葉原` and `伊豆` stay untagged because the local canonical corpus did not
  provide exact source rows for those app-only place entries.
