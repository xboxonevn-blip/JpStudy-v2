# Vocab Fix Batch - n4-minna-text-hygiene-061

- Date: 2026-06-26T09:26:14.4593970+07:00
- Scope: QA-A-030, N4 Minna lesson 27 text hygiene
- Changed rows: 5
- Category: TEXT-HYGIENE-HIDDEN-BY-ACCENT-INSENSITIVE-DIFF

## Source Policy

This batch used owner-provided local canonical sources only. Exact local rows
verified `道具`, `自動販売機`, `通信販売`, `クリーニング`, and `マンション`.

## Rows

| Entry | Reading | Repair type | Old | New | Source notes |
| --- | --- | --- | --- | --- | --- |
| `道具` | `どうぐ` | Example repair | `これは道具です。` / `Đây là dụng cụ.` | `この道具は子どもでも使えます。` / `Dụng cụ này ngay cả trẻ con cũng có thể dùng.` | Meaning/source metadata already repaired in batch 034; retained `sourceConsensus`: `kanji-vocab-n3`, `kanji-vocab-n4`, `minna-2`. |
| `自動販売機` | `じどうはんばいき` | Meaning capitalization, metadata, and example repair | `máy bán hàng tự động` / `これは自動販売機です。` / `Đây là máy bán hàng tự động.` | `Máy bán hàng tự động` / `自動販売機で冷たい飲み物が買えます。` / `Có thể mua đồ uống lạnh ở máy bán hàng tự động.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n2`, `kanji-vocab-n3`, `kanji-vocab-n4`; ticket `QA-A-030`. |
| `通信販売` | `つうしんはんばい` | Meaning capitalization, metadata, and example repair | `thương mại viễn thông (mua bán qua bưu điện/internet)` / `これは通信販売です。` / `Đây là thương mại viễn thông.` | `Thương mại viễn thông, mua bán qua bưu điện/internet` / `通信販売のコマーシャルが毎日聞こえます。` / `Ngày nào cũng nghe thấy quảng cáo mua hàng từ xa.` | Exact local rows; `sourceConsensus`: `kanji-vocab-n2`, `kanji-vocab-n3`, `kanji-vocab-n4`; ticket `QA-A-030`. |
| `クリーニング` | `くりーにんぐ` | Meaning capitalization, metadata, and example repair | `giặt ủi` / `これはクリーニングです。` / `Đây là giặt ủi.` | `Giặt ủi` / `週末にスーツをクリーニングに出しました。` / `Cuối tuần tôi đã đem bộ vest đi giặt ủi.` | Exact local row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |
| `マンション` | `まんしょん` | Meaning, metadata, and example repair | `chung cư cao cấp` / `マンションの前で友だちを待ちました。` / `Tôi đã đợi bạn trước chung cư cao cấp.` | `Chung cư` / `あのマンションの窓からきれいな景色が見えます。` / `Từ cửa sổ chung cư đó có thể thấy phong cảnh đẹp.` | Exact local row; `sourceConsensus`: `minna-2`; ticket `QA-A-030`. |

## Learner-Facing Notes

- Replaced remaining lesson-27 bare noun examples with contexts that connect to
  the same visible grammar/vocab lesson surface.
- Normalized source-backed Vietnamese capitalization and tightened
  `マンション` to the broader learner-facing `Chung cư` sense from Minna-2.
