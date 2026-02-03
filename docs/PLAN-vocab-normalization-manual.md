# PLAN - Vocab Normalization (Manual, phased)

## Goal
- Tách dữ liệu vocab theo 3 lớp để giảm trùng và liên kết lesson chặt hơn:
  - `master` (lemma duy nhất)
  - `sense` (nghĩa theo ngữ cảnh)
  - `map` (lesson -> sense + order + tag)
- Vẫn giữ logic app hiện tại (không làm vỡ flow học).

## Phasing strategy (no auto migration script)
1. **P1 - Infrastructure**
   - Bổ sung loader mới đọc `master/sense/map`.
   - Nếu lesson chưa chuẩn hóa thì fallback sang file cũ `vocab_nX_Y.json`.
   - Nếu lesson chuẩn hóa một phần thì ưu tiên row mới, phần thiếu lấy từ file cũ.
2. **P2 - Manual conversion by chunk**
   - Chuyển từng lesson theo khối nhỏ (ví dụ 10 mục/lần).
   - Mỗi chunk tạo/cập nhật 3 file: `master.json`, `sense.json`, `map.json`.
3. **P3 - Validation per chunk**
   - Mở lesson trong app, kiểm tra đủ số từ + đúng nghĩa.
   - Kiểm tra tag lesson (`minna_<lessonId>`) vẫn query được.
4. **P4 - Expand coverage**
   - Lặp lại cho toàn bộ N5, sau đó N4.
5. **P5 - Cleanup (khi đã phủ 100%)**
   - Cân nhắc loại bỏ dần phụ thuộc file legacy.

## Manual schema (current)
Ví dụ thư mục:
- `assets/data/vocab/normalized/n5/lesson_01/master.json`
- `assets/data/vocab/normalized/n5/lesson_01/sense.json`
- `assets/data/vocab/normalized/n5/lesson_01/map.json`

### `master.json`
```json
[
  {
    "vocabId": "n5_l01_v001",
    "term": "私",
    "reading": "わたし",
    "kanjiMeaning": "tư",
    "level": "N5"
  }
]
```

### `sense.json`
```json
[
  {
    "senseId": "n5_l01_s001",
    "vocabId": "n5_l01_v001",
    "meaningVi": "tôi",
    "meaningEn": "I"
  }
]
```

### `map.json`
```json
[
  {
    "lessonId": 1,
    "senseId": "n5_l01_s001",
    "order": 1,
    "tag": "pronoun"
  }
]
```

## Progress log
- [x] P1: Loader support + fallback merged vào `lib/data/db/content_database.dart`.
- [x] P2 chunk 1: N5 Lesson 01, mục 1-10 đã tách sang cấu trúc normalized.
- [x] P2 chunk 2: N5 Lesson 01, mục 11-20 đã tách sang cấu trúc normalized.
- [x] P2 chunk 3: N5 Lesson 01, mục 21-30 đã tách sang cấu trúc normalized.
- [x] P2 chunk 4: N5 Lesson 01, mục 31-40 đã tách sang cấu trúc normalized.
- [x] N5 Lesson 01 hoàn tất (40/40 mục).
- [x] P2 chunk 1: N5 Lesson 02, mục 1-10 đã tách sang cấu trúc normalized.
- [x] P2 chunk 2: N5 Lesson 02, mục 11-20 đã tách sang cấu trúc normalized.
- [x] P2 chunk 3: N5 Lesson 02, mục 21-30 đã tách sang cấu trúc normalized.
- [x] P2 chunk 4: N5 Lesson 02, mục 31-40 đã tách sang cấu trúc normalized.
- [x] P2 chunk 5: N5 Lesson 02, mục 41-47 đã tách sang cấu trúc normalized.
- [x] N5 Lesson 02 hoàn tất (47/47 mục).
- [x] N5 Lesson 03 hoàn tất (53 mục, gồm 42 mục gốc + 11 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 03 web-check đã bổ sung: `自動販売機`, `お国`, `どうも`, `いらっしゃいませ`, `イタリア`, `スイス`, `フランス`, `ジャカルタ`, `バンコク`, `ベルリン`, `新大阪`.
- [x] N5 Lesson 04 hoàn tất (61 mục, gồm 56 mục gốc + 5 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 04 web-check đã bổ sung: `電話番号`, `ニューヨーク`, `ペキン`, `ロサンゼルス`, `ロンドン`.
- [x] N5 Lesson 05 hoàn tất (56 mục, gồm 54 mục gốc + 2 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 05 web-check đã bổ sung: `一月`, `日`.
- [x] N5 Lesson 06 hoàn tất (53 mục, gồm 49 mục gốc + 4 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 06 web-check đã bổ sung: `ミルク`, `一緒に`, `ちょっと`, `また明日`.
- [x] N5 Lesson 07 hoàn tất (53 mục, gồm 46 mục gốc + 7 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 07 web-check đã bổ sung: `ファクス`, `ワープロ`, `素敵`, `旅行`, `お土産`, `ヨーロッパ`, `スペイン`.
- [x] N5 Lesson 08 hoàn tất (66 mục, gồm 52 mục gốc + 14 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 08 web-check đã bổ sung: `厳しい`, `不味い`, `富士山`, `上海`, `日本`, `車`, `慣れる`, `一杯`, `いかが`, `けっこう`, `そろそろ`, `失礼`, `また`, `いらっしゃってください`.
- [x] N5 Lesson 09 hoàn tất (55 mục, gồm 48 mục gốc + 7 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 09 web-check đã bổ sung: `もしもし`, `一緒に`, `いかが`, `ちょっと`, `ダメ`, `また今度`, `お願いします`.
- [x] N5 Lesson 10 hoàn tất (51 mục, gồm 44 mục gốc + 7 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 10 web-check đã bổ sung: `フィルム`, `段`, `コーナー`, `奥`, `スパイス`, `目`, `どうもすみません`.
- [x] N5 Lesson 11 hoàn tất (65 mục, gồm 54 mục gốc + 11 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 11 web-check đã bổ sung: `子供`, `日本`, `会社`, `カレーライス`, `いい天気`, `お出かけ`, `行く`, `いらっしゃる`, `行ってまいります`, `それから`, `オーストラリア`.
- [x] N5 Lesson 12 hoàn tất (54 mục, gồm 46 mục gốc + 8 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 12 web-check đã bổ sung: `人`, `コーヒー`, `すごい`, `疲れる`, `祇園祭`, `香港`, `シンガポール`, `でも`.
- [x] N5 Lesson 13 hoàn tất (46 mục, gồm 38 mục gốc + 8 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 13 web-check đã bổ sung: `手紙を出す`, `喫茶店`, `公園`, `スキー`, `おなか`, `いっぱい`, `ください`, `ロシア`.
- [x] N5 Lesson 14 hoàn tất (45 mục, gồm 40 mục gốc + 5 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 14 web-check đã bổ sung: `右`, `雨`, `信号`, `ください`, `これ`.
- [x] N5 Lesson 15 hoàn tất (29 mục, gồm 24 mục gốc + 5 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 15 web-check đã bổ sung: `立つ`, `座る`, `使う`, `大阪`, `家族`.
- [x] N5 Lesson 16 hoàn tất (64 mục, gồm 50 mục gốc + 14 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 16 web-check đã bổ sung: `電車`, `大学`, `やめる`, `会社を辞める`, `背が高い`, `頭がいい`, `いいえ`, `まず`, `次に`, `アジア`, `バンドン`, `ベラクルス`, `フランケン`, `ベトナム`.
- [x] N5 Lesson 17 hoàn tất (41 mục, gồm 31 mục gốc + 10 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 17 web-check đã bổ sung: `レポート`, `薬`, `お風呂`, `問題`, `答え`, `健康保険証`, `先生`, `までに`, `どうした`, `痛い`.
- [x] N5 Lesson 18 hoàn tất (36 mục, gồm 29 mục gốc + 7 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 18 web-check đã bổ sung: `できる`, `運転`, `予約`, `見学`, `国際`, `メートル`, `本当`.
- [x] N5 Lesson 19 hoàn tất (33 mục, gồm 27 mục gốc + 6 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 19 web-check đã bổ sung: `登る`, `泊まる`, `調子がいい`, `調子が悪い`, `実は`, `ケーキ`.
- [x] N5 Lesson 20 hoàn tất (34 mục, gồm 28 mục gốc + 6 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 20 web-check đã bổ sung: `要る`, `言葉`, `国`, `帰る`, `どうしよう`, `いろいろ`.
- [x] N5 Lesson 21 hoàn tất (42 mục, gồm 33 mục gốc + 9 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 21 web-check đã bổ sung: `お祭り`, `話`, `話をする`, `仕方がない`, `しばらく`, `飲む`, `見る`, `もちろん`, `カンガルー`.
- [x] N5 Lesson 22 hoàn tất (27 mục, gồm 18 mục gốc + 9 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 22 web-check đã bổ sung: `着る`, `履く`, `かぶる`, `眼鏡をかける`, `生む`, `靴`, `こちら`, `うーん`, `パリ`.
- [x] N5 Lesson 23 hoàn tất (48 mục, gồm 27 mục gốc + 21 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 23 web-check đã bổ sung: `聞く`, `回す`, `引く`, `変える`, `触る`, `出る`, `動く`, `歩く`, `渡る`, `気をつける`, `引っ越し`, `つまむ`, `正月`, `建物`, `外国人登録証`, `お釣り`, `時計`, `車`, `屋`, `ドア`, `先生`.
- [x] N5 Lesson 24 hoàn tất (32 mục, gồm 18 mục gốc + 14 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 24 web-check đã bổ sung: `くれる`, `連れて行く`, `連れて来る`, `送る`, `紹介`, `案内`, `説明`, `入れる`, `人`, `コーヒー`, `おじいちゃん`, `おばあちゃん`, `他に`, `弁当`.
- [x] N5 Lesson 25 hoàn tất (29 mục, gồm 17 mục gốc + 12 mục bổ sung từ đối chiếu nguồn ngoài).
- [x] Lesson 25 web-check đã bổ sung: `考える`, `着く`, `駅`, `留学`, `年を取る`, `一杯`, `飲む`, `いろいろ`, `お世話になる`, `頑張る`, `どうぞ`, `元気`.
