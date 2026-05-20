# Kanji Level Audit - QA-A-026

Date: `2026-05-20`
Scope: Phase 0 audit only. No kanji JSON data was edited.

## Source Decision

- Owner-supplied PDFs were found at `C:/Users/xboxo/Desktop/PC/Tai lieu JPStudy/Kanji/` (the `G:/Users/xboxo/Downloads/Kanji/` path in the ticket was not present in this workspace).
- `pdf-parse`/text extraction cannot recover reliable kanji text from the PDFs because the kanji are vector glyph drawings; Inkscape rendering works for visual inspection. Page counts: N1 `11`, N2 `5`, N3 `4`, N4 `2`.
- Visual inspection found direct conflicts between the PDF rows/public JLPT tables and the owner spot-check examples, so this document uses a candidate canonical map for review, not a data rewrite spec yet.
- N5 source selected: KANJIDIC2 old JLPT level `4` gives `103` kanji and is already in the repo source cache under `.codex/sources/kanjidic2`. This matches the requested approximate size better than Tanos/JLPT Sensei `80`-kanji N5 lists. The two owner-required N5 spot-check kanji `海` and `帰` are added as explicit review overrides.
- N1-N4 machine-readable comparison source: JLPT Sensei paginated kanji lists. They are used only to generate this Phase 0 diff because the supplied PDFs are not text-extractable.
- Owner spot-check overrides applied before diffing: `親 -> N4`, `帰 -> N5`, `銀 -> N3`, `議 -> N2`, `海 -> N5`, `売 -> N4`, `重 -> N3`.

## Source Conflict Requiring Owner Approval

| Kanji | Owner expected | Observed conflict |
| --- | --- | --- |
| 海 | N5 | Visible in supplied N4 PDF page 1; JLPT Sensei lists it as N4. |
| 帰 | N5 | Common public JLPT lists place it in N4. |
| 銀 | N3 | Visible in supplied N4 PDF page 1; JLPT Sensei lists it as N4. |
| 重 | N3 | Visible in supplied N4 PDF page 1; JLPT Sensei lists it as N4. |
| 議 | N2 | Visible in supplied N3 PDF page 1; JLPT Sensei lists it as N3. |

Phase 1 should not rewrite data until this conflict policy is approved. The audit tables below show the impact of accepting the owner spot-check overrides.

## Summary

| Metric | Count |
| --- | --- |
| Current app entries | 929 |
| Current app unique kanji | 638 |
| Candidate canonical unique kanji | 2495 |
| MOVE rows | 479 |
| DUPLICATE rows | 196 |
| MISSING rows | 1872 |
| EXTRA rows | 15 |

## Source Counts

| Level | Raw source count | Candidate canonical count after deconflict/overrides |
| --- | --- | --- |
| N5 | 103 | 105 |
| N4 | 167 | 141 |
| N3 | 370 | 370 |
| N2 | 374 | 375 |
| N1 | 1504 | 1504 |

## Spot-Check Result

| Kanji | Candidate correct level | Current app placement | Status |
| --- | --- | --- | --- |
| 親 | N4 | N2 L24 (n2/lesson_24.json)<br>N5 L23 (n5/lesson_23.json) | FAIL |
| 帰 | N5 | N2 L20 (n2/lesson_20.json) | FAIL |
| 銀 | N3 | NOT FOUND | MISSING |
| 議 | N2 | N1 L18 (n1/lesson_18.json)<br>N3 L22 (n3/lesson_22.json) | FAIL |
| 海 | N5 | NOT FOUND | MISSING |
| 売 | N4 | N2 L15 (n2/lesson_15.json)<br>N4 L28 (n4/lesson_28.json) | FAIL |
| 重 | N3 | N2 L24 (n2/lesson_24.json)<br>N5 L15 (n5/lesson_15.json) | FAIL |

## MOVE

Rows where current app placement differs from the candidate canonical level. Includes duplicate rows when at least one duplicate is in the wrong level.

| Kanji | Correct level | Current placement |
| --- | --- | --- |
| 一 | N5 | N1 L22 (n1/lesson_22.json)<br>N2 L08 (n2/lesson_08.json)<br>N5 L02 (n5/lesson_02.json) |
| 上 | N5 | N1 L04 (n1/lesson_04.json)<br>N2 L15 (n2/lesson_15.json)<br>N5 L10 (n5/lesson_10.json) |
| 不 | N4 | N3 L20 (n3/lesson_20.json)<br>N5 L23 (n5/lesson_23.json) |
| 並 | N2 | N4 L30 (n4/lesson_30.json) |
| 中 | N5 | N2 L25 (n2/lesson_25.json)<br>N5 L10 (n5/lesson_10.json) |
| 主 | N4 | N1 L15 (n1/lesson_15.json) |
| 乾 | N2 | N4 L44 (n4/lesson_44.json) |
| 予 | N3 | N1 L11 (n1/lesson_11.json)<br>N3 L10 (n3/lesson_10.json)<br>N4 L30 (n4/lesson_30.json) |
| 争 | N3 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json)<br>N3 L23 (n3/lesson_23.json) |
| 事 | N4 | N5 L13 (n5/lesson_13.json) |
| 井 | N1 | N1 L14 (n1/lesson_14.json)<br>N2 L10 (n2/lesson_10.json) |
| 京 | N4 | N5 L21 (n5/lesson_21.json) |
| 人 | N5 | N1 L04 (n1/lesson_04.json)<br>N2 L25 (n2/lesson_25.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L11 (n5/lesson_11.json) |
| 今 | N5 | N1 L25 (n1/lesson_25.json) |
| 介 | N2 | N3 L22 (n3/lesson_22.json) |
| 他 | N3 | N1 L07 (n1/lesson_07.json) |
| 付 | N3 | N2 L06 (n2/lesson_06.json) |
| 代 | N4 | N2 L20 (n2/lesson_20.json)<br>N5 L14 (n5/lesson_14.json) |
| 以 | N4 | N2 L07 (n2/lesson_07.json)<br>N4 L34 (n4/lesson_34.json) |
| 仮 | N1 | N2 L21 (n2/lesson_21.json) |
| 会 | N5 | N2 L17 (n2/lesson_17.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L07 (n5/lesson_07.json)<br>N5 L13 (n5/lesson_13.json) |
| 伝 | N3 | N2 L23 (n2/lesson_23.json)<br>N3 L08 (n3/lesson_08.json)<br>N4 L38 (n4/lesson_38.json) |
| 伯 | N1 | N2 L22 (n2/lesson_22.json) |
| 伺 | N2 | N4 L49 (n4/lesson_49.json) |
| 位 | N3 | N1 L21 (n1/lesson_21.json) |
| 住 | N4 | N1 L19 (n1/lesson_19.json)<br>N2 L08 (n2/lesson_08.json)<br>N3 L15 (n3/lesson_15.json)<br>N5 L21 (n5/lesson_21.json) |
| 体 | N4 | N2 L16 (n2/lesson_16.json)<br>N5 L16 (n5/lesson_16.json) |
| 何 | N5 | N1 L16 (n1/lesson_16.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L12 (n5/lesson_12.json) |
| 余 | N3 | N1 L14 (n1/lesson_14.json)<br>N2 L04 (n2/lesson_04.json) |
| 作 | N4 | N3 L01 (n3/lesson_01.json) |
| 依 | N2 | N1 L14 (n1/lesson_14.json) |
| 価 | N1 | N3 L06 (n3/lesson_06.json) |
| 便 | N3 | N5 L23 (n5/lesson_23.json) |
| 保 | N2 | N3 L19 (n3/lesson_19.json) |
| 信 | N3 | N4 L45 (n4/lesson_45.json) |
| 倍 | N2 | N4 L42 (n4/lesson_42.json) |
| 倒 | N3 | N4 L39 (n4/lesson_39.json) |
| 借 | N4 | N5 L07 (n5/lesson_07.json) |
| 値 | N3 | N1 L07 (n1/lesson_07.json) |
| 偉 | N3 | N2 L16 (n2/lesson_16.json)<br>N4 L28 (n4/lesson_28.json) |
| 健 | N1 | N3 L07 (n3/lesson_07.json) |
| 儀 | N1 | N2 L22 (n2/lesson_22.json) |
| 兄 | N4 | N5 L24 (n5/lesson_24.json) |
| 光 | N3 | N1 L25 (n1/lesson_25.json) |
| 入 | N5 | N2 L11 (n2/lesson_11.json) |
| 公 | N4 | N5 L24 (n5/lesson_24.json) |
| 具 | N3 | N1 L10 (n1/lesson_10.json)<br>N2 L16 (n2/lesson_16.json)<br>N4 L27 (n4/lesson_27.json) |
| 内 | N3 | N5 L16 (n5/lesson_16.json) |
| 円 | N5 | N2 L17 (n2/lesson_17.json)<br>N5 L02 (n5/lesson_02.json) |
| 再 | N2 | N3 L03 (n3/lesson_03.json) |
| 写 | N4 | N2 L14 (n2/lesson_14.json) |
| 冷 | N3 | N3 L01 (n3/lesson_01.json)<br>N4 L43 (n4/lesson_43.json) |
| 凡 | N1 | N1 L12 (n1/lesson_12.json)<br>N2 L20 (n2/lesson_20.json) |
| 処 | N3 | N1 L07 (n1/lesson_07.json) |
| 出 | N5 | N1 L15 (n1/lesson_15.json)<br>N2 L06 (n2/lesson_06.json) |
| 分 | N5 | N1 L22 (n1/lesson_22.json)<br>N2 L07 (n2/lesson_07.json) |
| 切 | N4 | N1 L23 (n1/lesson_23.json)<br>N2 L15 (n2/lesson_15.json)<br>N5 L23 (n5/lesson_23.json) |
| 別 | N4 | N1 L22 (n1/lesson_22.json)<br>N4 L47 (n4/lesson_47.json) |
| 利 | N3 | N3 L21 (n3/lesson_21.json)<br>N5 L23 (n5/lesson_23.json) |
| 則 | N2 | N3 L18 (n3/lesson_18.json) |
| 前 | N5 | N1 L07 (n1/lesson_07.json)<br>N5 L10 (n5/lesson_10.json) |
| 劇 | N2 | N2 L17 (n2/lesson_17.json)<br>N3 L12 (n3/lesson_12.json) |
| 力 | N4 | N1 L09 (n1/lesson_09.json)<br>N2 L12 (n2/lesson_12.json)<br>N3 L02 (n3/lesson_02.json)<br>N5 L11 (n5/lesson_11.json)<br>N5 L14 (n5/lesson_14.json) |
| 加 | N3 | N1 L15 (n1/lesson_15.json)<br>N4 L38 (n4/lesson_38.json) |
| 労 | N3 | N1 L21 (n1/lesson_21.json) |
| 動 | N4 | N1 L24 (n1/lesson_24.json)<br>N4 L32 (n4/lesson_32.json) |
| 包 | N2 | N4 L42 (n4/lesson_42.json) |
| 化 | N3 | N1 L08 (n1/lesson_08.json)<br>N3 L04 (n3/lesson_04.json)<br>N3 L24 (n3/lesson_24.json) |
| 区 | N2 | N5 L21 (n5/lesson_21.json) |
| 卒 | N2 | N3 L13 (n3/lesson_13.json) |
| 単 | N3 | N4 L44 (n4/lesson_44.json) |
| 危 | N3 | N1 L11 (n1/lesson_11.json)<br>N2 L04 (n2/lesson_04.json)<br>N4 L32 (n4/lesson_32.json) |
| 卸 | N1 | N2 L24 (n2/lesson_24.json) |
| 厚 | N2 | N2 L02 (n2/lesson_02.json)<br>N4 L42 (n4/lesson_42.json) |
| 原 | N3 | N4 L36 (n4/lesson_36.json) |
| 参 | N3 | N2 L24 (n2/lesson_24.json)<br>N3 L01 (n3/lesson_01.json)<br>N4 L50 (n4/lesson_50.json) |
| 叔 | N1 | N2 L22 (n2/lesson_22.json) |
| 取 | N3 | N2 L12 (n2/lesson_12.json)<br>N4 L37 (n4/lesson_37.json) |
| 受 | N3 | N2 L12 (n2/lesson_12.json) |
| 口 | N5 | N1 L08 (n1/lesson_08.json)<br>N2 L14 (n2/lesson_14.json)<br>N5 L11 (n5/lesson_11.json) |
| 古 | N5 | N1 L25 (n1/lesson_25.json)<br>N5 L08 (n5/lesson_08.json) |
| 召 | N2 | N4 L49 (n4/lesson_49.json) |
| 史 | N2 | N3 L23 (n3/lesson_23.json) |
| 右 | N5 | N3 L01 (n3/lesson_01.json)<br>N5 L10 (n5/lesson_10.json) |
| 合 | N3 | N1 L02 (n1/lesson_02.json)<br>N2 L13 (n2/lesson_13.json)<br>N4 L33 (n4/lesson_33.json) |
| 同 | N4 | N1 L22 (n1/lesson_22.json)<br>N5 L13 (n5/lesson_13.json) |
| 名 | N5 | N2 L03 (n2/lesson_03.json)<br>N5 L01 (n5/lesson_01.json) |
| 向 | N3 | N1 L19 (n1/lesson_19.json) |
| 否 | N3 | N1 L15 (n1/lesson_15.json) |
| 味 | N4 | N1 L06 (n1/lesson_06.json)<br>N2 L02 (n2/lesson_02.json)<br>N3 L19 (n3/lesson_19.json)<br>N4 L35 (n4/lesson_35.json) |
| 呼 | N3 | N1 L01 (n1/lesson_01.json)<br>N4 L36 (n4/lesson_36.json) |
| 和 | N3 | N2 L16 (n2/lesson_16.json)<br>N3 L23 (n3/lesson_23.json) |
| 品 | N4 | N3 L06 (n3/lesson_06.json) |
| 員 | N4 | N5 L14 (n5/lesson_14.json) |
| 商 | N3 | N1 L04 (n1/lesson_04.json) |
| 問 | N4 | N5 L14 (n5/lesson_14.json) |
| 喜 | N3 | N4 L47 (n4/lesson_47.json) |
| 営 | N2 | N1 L24 (n1/lesson_24.json) |
| 回 | N3 | N1 L09 (n1/lesson_09.json)<br>N5 L22 (n5/lesson_22.json) |
| 困 | N3 | N3 L25 (n3/lesson_25.json)<br>N4 L41 (n4/lesson_41.json) |
| 図 | N4 | N1 L24 (n1/lesson_24.json) |
| 園 | N3 | N2 L17 (n2/lesson_17.json)<br>N5 L24 (n5/lesson_24.json) |
| 圧 | N2 | N1 L08 (n1/lesson_08.json)<br>N2 L03 (n2/lesson_03.json) |
| 在 | N3 | N2 L05 (n2/lesson_05.json) |
| 地 | N4 | N1 L11 (n1/lesson_11.json)<br>N2 L08 (n2/lesson_08.json)<br>N5 L13 (n5/lesson_13.json) |
| 坊 | N2 | N1 L05 (n1/lesson_05.json) |
| 域 | N2 | N1 L16 (n1/lesson_16.json) |
| 場 | N4 | N5 L14 (n5/lesson_14.json) |
| 増 | N3 | N4 L43 (n4/lesson_43.json) |
| 壊 | N1 | N4 L29 (n4/lesson_29.json) |
| 声 | N3 | N4 L27 (n4/lesson_27.json)<br>N5 L16 (n5/lesson_16.json) |
| 売 | N4 | N2 L15 (n2/lesson_15.json)<br>N4 L28 (n4/lesson_28.json) |
| 変 | N3 | N1 L01 (n1/lesson_01.json)<br>N4 L43 (n4/lesson_43.json) |
| 夕 | N4 | N5 L17 (n5/lesson_17.json) |
| 外 | N5 | N1 L17 (n1/lesson_17.json)<br>N2 L06 (n2/lesson_06.json)<br>N5 L10 (n5/lesson_10.json) |
| 多 | N5 | N1 L18 (n1/lesson_18.json)<br>N5 L15 (n5/lesson_15.json) |
| 夜 | N4 | N5 L17 (n5/lesson_17.json) |
| 夢 | N3 | N4 L27 (n4/lesson_27.json) |
| 大 | N5 | N2 L20 (n2/lesson_20.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L08 (n5/lesson_08.json) |
| 天 | N5 | N1 L10 (n1/lesson_10.json) |
| 夫 | N3 | N4 L26 (n4/lesson_26.json) |
| 失 | N3 | N4 L41 (n4/lesson_41.json) |
| 奏 | N1 | N3 L12 (n3/lesson_12.json) |
| 女 | N5 | N1 L09 (n1/lesson_09.json)<br>N2 L19 (n2/lesson_19.json)<br>N5 L11 (n5/lesson_11.json) |
| 好 | N3 | N5 L09 (n5/lesson_09.json) |
| 妹 | N4 | N2 L11 (n2/lesson_11.json)<br>N5 L24 (n5/lesson_24.json) |
| 姉 | N4 | N2 L10 (n2/lesson_10.json)<br>N5 L24 (n5/lesson_24.json) |
| 始 | N4 | N5 L17 (n5/lesson_17.json) |
| 委 | N2 | N1 L20 (n1/lesson_20.json) |
| 威 | N1 | N2 L11 (n2/lesson_11.json) |
| 嫌 | N1 | N2 L11 (n2/lesson_11.json) |
| 字 | N4 | N1 L03 (n1/lesson_03.json)<br>N5 L09 (n5/lesson_09.json) |
| 存 | N3 | N1 L20 (n1/lesson_20.json)<br>N4 L49 (n4/lesson_49.json) |
| 季 | N2 | N3 L08 (n3/lesson_08.json) |
| 学 | N5 | N3 L04 (n3/lesson_04.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L12 (n5/lesson_12.json) |
| 宅 | N3 | N3 L15 (n3/lesson_15.json)<br>N4 L48 (n4/lesson_48.json) |
| 守 | N3 | N4 L33 (n4/lesson_33.json)<br>N4 L46 (n4/lesson_46.json) |
| 安 | N5 | N1 L14 (n1/lesson_14.json)<br>N2 L05 (n2/lesson_05.json)<br>N3 L20 (n3/lesson_20.json)<br>N5 L08 (n5/lesson_08.json) |
| 定 | N3 | N1 L14 (n1/lesson_14.json)<br>N2 L10 (n2/lesson_10.json) |
| 実 | N3 | N4 L28 (n4/lesson_28.json) |
| 室 | N4 | N2 L25 (n2/lesson_25.json) |
| 宴 | N1 | N2 L17 (n2/lesson_17.json) |
| 家 | N4 | N1 L15 (n1/lesson_15.json) |
| 寝 | N3 | N1 L05 (n1/lesson_05.json) |
| 審 | N1 | N3 L16 (n3/lesson_16.json) |
| 対 | N3 | N1 L01 (n1/lesson_01.json)<br>N2 L19 (n2/lesson_19.json) |
| 将 | N2 | N3 L02 (n3/lesson_02.json) |
| 導 | N2 | N3 L13 (n3/lesson_13.json) |
| 小 | N5 | N2 L22 (n2/lesson_22.json)<br>N5 L08 (n5/lesson_08.json) |
| 就 | N1 | N3 L05 (n3/lesson_05.json) |
| 届 | N2 | N4 L48 (n4/lesson_48.json) |
| 屋 | N4 | N2 L21 (n2/lesson_21.json)<br>N4 L34 (n4/lesson_34.json) |
| 左 | N5 | N3 L01 (n3/lesson_01.json)<br>N5 L10 (n5/lesson_10.json) |
| 市 | N3 | N1 L21 (n1/lesson_21.json)<br>N5 L21 (n5/lesson_21.json) |
| 帯 | N2 | N1 L23 (n1/lesson_23.json)<br>N2 L25 (n2/lesson_25.json) |
| 帰 | N5 | N2 L20 (n2/lesson_20.json) |
| 年 | N5 | N2 L09 (n2/lesson_09.json) |
| 幾 | N3 | N1 L18 (n1/lesson_18.json)<br>N2 L07 (n2/lesson_07.json) |
| 広 | N4 | N5 L15 (n5/lesson_15.json) |
| 府 | N2 | N5 L21 (n5/lesson_21.json) |
| 度 | N4 | N2 L10 (n2/lesson_10.json) |
| 康 | N1 | N3 L07 (n3/lesson_07.json) |
| 式 | N3 | N4 L40 (n4/lesson_40.json) |
| 引 | N3 | N2 L11 (n2/lesson_11.json)<br>N5 L18 (n5/lesson_18.json) |
| 弟 | N4 | N5 L24 (n5/lesson_24.json) |
| 張 | N1 | N2 L11 (n2/lesson_11.json)<br>N3 L20 (n3/lesson_20.json)<br>N4 L30 (n4/lesson_30.json) |
| 当 | N3 | N1 L07 (n1/lesson_07.json) |
| 彼 | N3 | N1 L06 (n1/lesson_06.json)<br>N4 L33 (n4/lesson_33.json) |
| 往 | N1 | N2 L19 (n2/lesson_19.json) |
| 律 | N2 | N1 L23 (n1/lesson_23.json)<br>N3 L18 (n3/lesson_18.json) |
| 後 | N5 | N1 L05 (n1/lesson_05.json)<br>N2 L07 (n2/lesson_07.json)<br>N5 L10 (n5/lesson_10.json) |
| 従 | N1 | N2 L10 (n2/lesson_10.json) |
| 御 | N3 | N2 L22 (n2/lesson_22.json) |
| 心 | N4 | N1 L23 (n1/lesson_23.json)<br>N5 L16 (n5/lesson_16.json) |
| 応 | N1 | N2 L08 (n2/lesson_08.json) |
| 怒 | N3 | N1 L16 (n1/lesson_16.json)<br>N3 L20 (n3/lesson_20.json)<br>N4 L47 (n4/lesson_47.json) |
| 思 | N4 | N2 L24 (n2/lesson_24.json) |
| 怠 | N1 | N2 L21 (n2/lesson_21.json) |
| 急 | N4 | N5 L22 (n5/lesson_22.json) |
| 性 | N3 | N1 L20 (n1/lesson_20.json) |
| 怪 | N1 | N2 L04 (n2/lesson_04.json) |
| 恨 | N1 | N2 L15 (n2/lesson_15.json) |
| 恩 | N1 | N2 L25 (n2/lesson_25.json) |
| 恵 | N1 | N2 L25 (n2/lesson_25.json) |
| 悪 | N4 | N1 L04 (n1/lesson_04.json)<br>N2 L08 (n2/lesson_08.json)<br>N5 L15 (n5/lesson_15.json) |
| 悲 | N3 | N3 L20 (n3/lesson_20.json)<br>N4 L47 (n4/lesson_47.json) |
| 惜 | N1 | N2 L22 (n2/lesson_22.json) |
| 想 | N3 | N1 L01 (n1/lesson_01.json) |
| 意 | N4 | N1 L17 (n1/lesson_17.json)<br>N2 L06 (n2/lesson_06.json)<br>N4 L35 (n4/lesson_35.json) |
| 愛 | N3 | N1 L01 (n1/lesson_01.json) |
| 憎 | N2 | N1 L02 (n1/lesson_02.json) |
| 憧 | N1 | N1 L05 (n1/lesson_05.json)<br>N2 L02 (n2/lesson_02.json) |
| 成 | N3 | N1 L17 (n1/lesson_17.json)<br>N5 L19 (n5/lesson_19.json) |
| 戦 | N3 | N1 L18 (n1/lesson_18.json)<br>N3 L23 (n3/lesson_23.json) |
| 戻 | N3 | N4 L30 (n4/lesson_30.json) |
| 所 | N3 | N5 L21 (n5/lesson_21.json) |
| 扇 | N1 | N2 L01 (n2/lesson_01.json) |
| 手 | N5 | N2 L23 (n2/lesson_23.json)<br>N5 L07 (n5/lesson_07.json)<br>N5 L11 (n5/lesson_11.json)<br>N5 L14 (n5/lesson_14.json) |
| 打 | N3 | N2 L13 (n2/lesson_13.json)<br>N4 L45 (n4/lesson_45.json) |
| 技 | N2 | N3 L17 (n3/lesson_17.json) |
| 投 | N3 | N3 L21 (n3/lesson_21.json)<br>N4 L45 (n4/lesson_45.json) |
| 折 | N3 | N4 L45 (n4/lesson_45.json) |
| 押 | N3 | N2 L21 (n2/lesson_21.json)<br>N4 L37 (n4/lesson_37.json) |
| 招 | N3 | N4 L36 (n4/lesson_36.json) |
| 拝 | N2 | N2 L20 (n2/lesson_20.json)<br>N4 L49 (n4/lesson_49.json) |
| 拾 | N2 | N4 L37 (n4/lesson_37.json) |
| 持 | N4 | N2 L13 (n2/lesson_13.json) |
| 指 | N3 | N2 L24 (n2/lesson_24.json) |
| 挙 | N1 | N1 L23 (n1/lesson_23.json)<br>N2 L02 (n2/lesson_02.json) |
| 掛 | N3 | N2 L18 (n2/lesson_18.json)<br>N4 L30 (n4/lesson_30.json) |
| 接 | N2 | N2 L19 (n2/lesson_19.json)<br>N3 L05 (n3/lesson_05.json) |
| 揚 | N1 | N2 L01 (n2/lesson_01.json) |
| 援 | N1 | N2 L19 (n2/lesson_19.json)<br>N3 L14 (n3/lesson_14.json) |
| 撮 | N1 | N3 L12 (n3/lesson_12.json) |
| 改 | N2 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json) |
| 敗 | N3 | N1 L24 (n1/lesson_24.json) |
| 教 | N4 | N2 L23 (n2/lesson_23.json)<br>N3 L13 (n3/lesson_13.json)<br>N5 L07 (n5/lesson_07.json) |
| 数 | N3 | N4 L40 (n4/lesson_40.json) |
| 文 | N4 | N2 L16 (n2/lesson_16.json)<br>N3 L04 (n3/lesson_04.json)<br>N3 L06 (n3/lesson_06.json)<br>N4 L35 (n4/lesson_35.json) |
| 斉 | N1 | N2 L09 (n2/lesson_09.json) |
| 料 | N4 | N3 L19 (n3/lesson_19.json) |
| 新 | N5 | N3 L09 (n3/lesson_09.json)<br>N5 L08 (n5/lesson_08.json)<br>N5 L14 (n5/lesson_14.json) |
| 方 | N4 | N1 L07 (n1/lesson_07.json)<br>N2 L01 (n2/lesson_01.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L14 (n5/lesson_14.json) |
| 旅 | N4 | N3 L10 (n3/lesson_10.json)<br>N5 L09 (n5/lesson_09.json) |
| 族 | N4 | N3 L14 (n3/lesson_14.json) |
| 日 | N5 | N1 L05 (n1/lesson_05.json)<br>N2 L09 (n2/lesson_09.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L03 (n5/lesson_03.json) |
| 早 | N4 | N5 L15 (n5/lesson_15.json) |
| 明 | N4 | N1 L03 (n1/lesson_03.json)<br>N2 L01 (n2/lesson_01.json)<br>N3 L17 (n3/lesson_17.json)<br>N5 L15 (n5/lesson_15.json) |
| 易 | N3 | N2 L05 (n2/lesson_05.json) |
| 昔 | N3 | N4 L27 (n4/lesson_27.json) |
| 映 | N4 | N2 L13 (n2/lesson_13.json) |
| 昨 | N3 | N2 L09 (n2/lesson_09.json) |
| 昼 | N4 | N5 L17 (n5/lesson_17.json) |
| 時 | N5 | N1 L24 (n1/lesson_24.json) |
| 晩 | N3 | N5 L17 (n5/lesson_17.json) |
| 景 | N3 | N4 L27 (n4/lesson_27.json) |
| 暖 | N1 | N2 L02 (n2/lesson_02.json)<br>N4 L43 (n4/lesson_43.json) |
| 暗 | N3 | N1 L13 (n1/lesson_13.json)<br>N2 L13 (n2/lesson_13.json)<br>N5 L15 (n5/lesson_15.json) |
| 更 | N3 | N1 L25 (n1/lesson_25.json)<br>N3 L01 (n3/lesson_01.json) |
| 替 | N2 | N3 L24 (n3/lesson_24.json)<br>N4 L43 (n4/lesson_43.json) |
| 有 | N4 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json)<br>N5 L23 (n5/lesson_23.json) |
| 朝 | N4 | N1 L05 (n1/lesson_05.json)<br>N5 L17 (n5/lesson_17.json) |
| 木 | N5 | N2 L12 (n2/lesson_12.json) |
| 未 | N3 | N1 L25 (n1/lesson_25.json) |
| 材 | N2 | N3 L19 (n3/lesson_19.json) |
| 村 | N2 | N5 L21 (n5/lesson_21.json) |
| 束 | N3 | N4 L46 (n4/lesson_46.json) |
| 来 | N5 | N3 L02 (n3/lesson_02.json)<br>N5 L01 (n5/lesson_01.json) |
| 東 | N5 | N1 L06 (n1/lesson_06.json) |
| 染 | N1 | N3 L25 (n3/lesson_25.json) |
| 栄 | N2 | N3 L07 (n3/lesson_07.json) |
| 案 | N2 | N1 L13 (n1/lesson_13.json)<br>N2 L06 (n2/lesson_06.json) |
| 械 | N2 | N3 L17 (n3/lesson_17.json) |
| 植 | N2 | N2 L12 (n2/lesson_12.json)<br>N4 L30 (n4/lesson_30.json) |
| 業 | N4 | N5 L13 (n5/lesson_13.json) |
| 楽 | N4 | N5 L09 (n5/lesson_09.json) |
| 様 | N3 | N1 L13 (n1/lesson_13.json)<br>N3 L01 (n3/lesson_01.json)<br>N4 L49 (n4/lesson_49.json) |
| 標 | N1 | N3 L02 (n3/lesson_02.json) |
| 機 | N3 | N3 L17 (n3/lesson_17.json)<br>N4 L41 (n4/lesson_41.json) |
| 歌 | N4 | N5 L09 (n5/lesson_09.json)<br>N5 L18 (n5/lesson_18.json) |
| 止 | N4 | N5 L20 (n5/lesson_20.json) |
| 歩 | N4 | N1 L11 (n1/lesson_11.json)<br>N5 L18 (n5/lesson_18.json) |
| 歳 | N3 | N4 L31 (n4/lesson_31.json) |
| 歴 | N2 | N3 L23 (n3/lesson_23.json) |
| 段 | N3 | N2 L09 (n2/lesson_09.json) |
| 殺 | N3 | N1 L13 (n1/lesson_13.json) |
| 母 | N5 | N2 L24 (n2/lesson_24.json)<br>N5 L12 (n5/lesson_12.json) |
| 民 | N3 | N1 L25 (n1/lesson_25.json)<br>N3 L15 (n3/lesson_15.json) |
| 気 | N5 | N1 L08 (n1/lesson_08.json) |
| 汚 | N2 | N3 L25 (n3/lesson_25.json)<br>N4 L29 (n4/lesson_29.json) |
| 決 | N3 | N3 L16 (n3/lesson_16.json)<br>N4 L30 (n4/lesson_30.json) |
| 沸 | N2 | N4 L42 (n4/lesson_42.json) |
| 油 | N2 | N1 L10 (n1/lesson_10.json)<br>N4 L36 (n4/lesson_36.json) |
| 治 | N3 | N2 L21 (n2/lesson_21.json)<br>N3 L07 (n3/lesson_07.json)<br>N3 L23 (n3/lesson_23.json) |
| 泊 | N2 | N3 L10 (n3/lesson_10.json) |
| 法 | N3 | N3 L01 (n3/lesson_01.json)<br>N3 L18 (n3/lesson_18.json)<br>N4 L35 (n4/lesson_35.json) |
| 波 | N2 | N4 L27 (n4/lesson_27.json) |
| 泣 | N1 | N4 L44 (n4/lesson_44.json) |
| 注 | N4 | N3 L06 (n3/lesson_06.json)<br>N4 L36 (n4/lesson_36.json) |
| 洗 | N3 | N2 L23 (n2/lesson_23.json)<br>N5 L18 (n5/lesson_18.json) |
| 津 | N1 | N3 L11 (n3/lesson_11.json) |
| 洪 | N1 | N3 L11 (n3/lesson_11.json) |
| 活 | N3 | N1 L18 (n1/lesson_18.json) |
| 流 | N3 | N2 L09 (n2/lesson_09.json)<br>N3 L04 (n3/lesson_04.json)<br>N3 L24 (n3/lesson_24.json) |
| 浅 | N2 | N1 L06 (n1/lesson_06.json) |
| 浮 | N3 | N2 L12 (n2/lesson_12.json) |
| 消 | N3 | N2 L13 (n2/lesson_13.json)<br>N4 L29 (n4/lesson_29.json) |
| 混 | N2 | N4 L42 (n4/lesson_42.json) |
| 減 | N2 | N1 L15 (n1/lesson_15.json)<br>N4 L43 (n4/lesson_43.json) |
| 渡 | N3 | N4 L48 (n4/lesson_48.json) |
| 測 | N2 | N4 L40 (n4/lesson_40.json) |
| 港 | N3 | N4 L31 (n4/lesson_31.json) |
| 源 | N1 | N3 L03 (n3/lesson_03.json) |
| 演 | N3 | N2 L17 (n2/lesson_17.json)<br>N3 L12 (n3/lesson_12.json) |
| 漢 | N4 | N5 L09 (n5/lesson_09.json) |
| 灰 | N2 | N1 L04 (n1/lesson_04.json) |
| 災 | N1 | N3 L11 (n3/lesson_11.json) |
| 炒 | N1 | N1 L21 (n1/lesson_21.json)<br>N2 L11 (n2/lesson_11.json) |
| 無 | N4 | N2 L14 (n2/lesson_14.json)<br>N3 L03 (n3/lesson_03.json) |
| 然 | N3 | N1 L20 (n1/lesson_20.json) |
| 焼 | N2 | N4 L39 (n4/lesson_39.json) |
| 煎 | N1 | N2 L11 (n2/lesson_11.json) |
| 煙 | N3 | N2 L18 (n2/lesson_18.json)<br>N4 L32 (n4/lesson_32.json) |
| 熱 | N3 | N4 L28 (n4/lesson_28.json) |
| 父 | N5 | N2 L22 (n2/lesson_22.json)<br>N5 L12 (n5/lesson_12.json) |
| 物 | N4 | N2 L04 (n2/lesson_04.json) |
| 特 | N4 | N5 L22 (n5/lesson_22.json) |
| 王 | N3 | N2 L19 (n2/lesson_19.json) |
| 現 | N3 | N1 L12 (n1/lesson_12.json) |
| 理 | N4 | N3 L19 (n3/lesson_19.json) |
| 環 | N1 | N3 L03 (n3/lesson_03.json) |
| 甘 | N2 | N1 L10 (n1/lesson_10.json)<br>N2 L04 (n2/lesson_04.json) |
| 生 | N5 | N1 L16 (n1/lesson_16.json)<br>N2 L06 (n2/lesson_06.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L12 (n5/lesson_12.json) |
| 用 | N4 | N2 L20 (n2/lesson_20.json) |
| 申 | N3 | N4 L38 (n4/lesson_38.json) |
| 町 | N4 | N5 L21 (n5/lesson_21.json) |
| 画 | N4 | N3 L02 (n3/lesson_02.json) |
| 留 | N3 | N3 L04 (n3/lesson_04.json)<br>N4 L33 (n4/lesson_33.json) |
| 疑 | N3 | N4 L45 (n4/lesson_45.json) |
| 病 | N4 | N5 L16 (n5/lesson_16.json) |
| 痛 | N3 | N1 L21 (n1/lesson_21.json) |
| 療 | N2 | N3 L07 (n3/lesson_07.json) |
| 発 | N4 | N3 L17 (n3/lesson_17.json)<br>N5 L13 (n5/lesson_13.json) |
| 白 | N5 | N1 L03 (n1/lesson_03.json)<br>N2 L01 (n2/lesson_01.json) |
| 益 | N1 | N3 L21 (n3/lesson_21.json) |
| 目 | N5 | N1 L23 (n1/lesson_23.json)<br>N3 L02 (n3/lesson_02.json)<br>N5 L11 (n5/lesson_11.json) |
| 相 | N3 | N1 L01 (n1/lesson_01.json) |
| 県 | N2 | N5 L21 (n5/lesson_21.json) |
| 眠 | N3 | N3 L07 (n3/lesson_07.json)<br>N4 L44 (n4/lesson_44.json) |
| 着 | N4 | N2 L23 (n2/lesson_23.json)<br>N3 L24 (n3/lesson_24.json)<br>N4 L31 (n4/lesson_31.json) |
| 睡 | N1 | N3 L07 (n3/lesson_07.json) |
| 短 | N2 | N5 L15 (n5/lesson_15.json) |
| 石 | N3 | N4 L36 (n4/lesson_36.json) |
| 破 | N3 | N4 L46 (n4/lesson_46.json) |
| 確 | N3 | N4 L40 (n4/lesson_40.json) |
| 示 | N3 | N1 L13 (n1/lesson_13.json) |
| 礼 | N3 | N3 L08 (n3/lesson_08.json)<br>N4 L41 (n4/lesson_41.json) |
| 祈 | N2 | N1 L25 (n1/lesson_25.json) |
| 祭 | N2 | N3 L08 (n3/lesson_08.json) |
| 禁 | N2 | N4 L32 (n4/lesson_32.json) |
| 私 | N4 | N1 L07 (n1/lesson_07.json)<br>N4 L26 (n4/lesson_26.json) |
| 科 | N3 | N1 L03 (n1/lesson_03.json)<br>N3 L17 (n3/lesson_17.json)<br>N5 L16 (n5/lesson_16.json) |
| 移 | N2 | N1 L19 (n1/lesson_19.json)<br>N2 L10 (n2/lesson_10.json) |
| 税 | N2 | N3 L21 (n3/lesson_21.json) |
| 空 | N5 | N1 L04 (n1/lesson_04.json)<br>N4 L31 (n4/lesson_31.json) |
| 突 | N3 | N2 L18 (n2/lesson_18.json) |
| 笑 | N3 | N1 L06 (n1/lesson_06.json)<br>N4 L44 (n4/lesson_44.json) |
| 算 | N2 | N1 L13 (n1/lesson_13.json) |
| 節 | N1 | N3 L03 (n3/lesson_03.json)<br>N3 L08 (n3/lesson_08.json) |
| 築 | N2 | N3 L15 (n3/lesson_15.json) |
| 簡 | N2 | N4 L44 (n4/lesson_44.json) |
| 米 | N3 | N2 L20 (n2/lesson_20.json) |
| 粗 | N1 | N1 L12 (n1/lesson_12.json)<br>N2 L04 (n2/lesson_04.json) |
| 粧 | N1 | N3 L24 (n3/lesson_24.json) |
| 約 | N3 | N3 L03 (n3/lesson_03.json)<br>N3 L10 (n3/lesson_10.json)<br>N4 L46 (n4/lesson_46.json) |
| 納 | N1 | N2 L21 (n2/lesson_21.json) |
| 紙 | N4 | N5 L07 (n5/lesson_07.json) |
| 紹 | N2 | N3 L22 (n3/lesson_22.json) |
| 終 | N4 | N5 L17 (n5/lesson_17.json) |
| 経 | N3 | N1 L17 (n1/lesson_17.json)<br>N3 L21 (n3/lesson_21.json) |
| 結 | N2 | N3 L14 (n3/lesson_14.json) |
| 絡 | N2 | N4 L46 (n4/lesson_46.json) |
| 統 | N1 | N3 L08 (n3/lesson_08.json) |
| 絵 | N3 | N1 L10 (n1/lesson_10.json)<br>N2 L16 (n2/lesson_16.json)<br>N5 L09 (n5/lesson_09.json) |
| 続 | N3 | N4 L31 (n4/lesson_31.json) |
| 緊 | N1 | N3 L20 (n3/lesson_20.json) |
| 線 | N2 | N5 L22 (n5/lesson_22.json) |
| 緯 | N1 | N1 L17 (n1/lesson_17.json)<br>N2 L10 (n2/lesson_10.json) |
| 練 | N2 | N3 L16 (n3/lesson_16.json) |
| 縮 | N1 | N2 L03 (n2/lesson_03.json) |
| 績 | N2 | N3 L13 (n3/lesson_13.json) |
| 義 | N1 | N2 L06 (n2/lesson_06.json) |
| 習 | N4 | N5 L07 (n5/lesson_07.json) |
| 翻 | N1 | N3 L22 (n3/lesson_22.json) |
| 考 | N4 | N3 L01 (n3/lesson_01.json)<br>N4 L31 (n4/lesson_31.json)<br>N4 L34 (n4/lesson_34.json)<br>N5 L25 (n5/lesson_25.json) |
| 者 | N4 | N5 L13 (n5/lesson_13.json) |
| 聞 | N5 | N3 L09 (n3/lesson_09.json)<br>N5 L06 (n5/lesson_06.json) |
| 育 | N3 | N1 L18 (n1/lesson_18.json)<br>N2 L07 (n2/lesson_07.json)<br>N3 L13 (n3/lesson_13.json)<br>N3 L14 (n3/lesson_14.json)<br>N4 L37 (n4/lesson_37.json) |
| 自 | N4 | N5 L13 (n5/lesson_13.json) |
| 良 | N3 | N1 L14 (n1/lesson_14.json)<br>N5 L08 (n5/lesson_08.json) |
| 花 | N5 | N2 L07 (n2/lesson_07.json) |
| 芸 | N2 | N2 L17 (n2/lesson_17.json)<br>N3 L12 (n3/lesson_12.json) |
| 若 | N3 | N4 L37 (n4/lesson_37.json) |
| 英 | N4 | N2 L16 (n2/lesson_16.json) |
| 荒 | N2 | N1 L11 (n1/lesson_11.json)<br>N2 L04 (n2/lesson_04.json) |
| 荷 | N2 | N4 L48 (n4/lesson_48.json) |
| 落 | N3 | N2 L23 (n2/lesson_23.json)<br>N4 L29 (n4/lesson_29.json) |
| 著 | N2 | N1 L22 (n1/lesson_22.json)<br>N2 L05 (n2/lesson_05.json) |
| 薄 | N2 | N2 L13 (n2/lesson_13.json)<br>N4 L42 (n4/lesson_42.json) |
| 薬 | N3 | N5 L16 (n5/lesson_16.json) |
| 行 | N5 | N1 L17 (n1/lesson_17.json)<br>N2 L15 (n2/lesson_15.json)<br>N3 L24 (n3/lesson_24.json)<br>N5 L01 (n5/lesson_01.json) |
| 衣 | N2 | N1 L19 (n1/lesson_19.json)<br>N2 L08 (n2/lesson_08.json) |
| 袋 | N2 | N4 L29 (n4/lesson_29.json) |
| 裁 | N1 | N3 L18 (n3/lesson_18.json) |
| 装 | N2 | N1 L19 (n1/lesson_19.json)<br>N3 L24 (n3/lesson_24.json) |
| 見 | N5 | N1 L19 (n1/lesson_19.json)<br>N5 L06 (n5/lesson_06.json) |
| 親 | N4 | N2 L24 (n2/lesson_24.json)<br>N5 L23 (n5/lesson_23.json) |
| 言 | N5 | N1 L15 (n1/lesson_15.json)<br>N2 L06 (n2/lesson_06.json)<br>N3 L04 (n3/lesson_04.json) |
| 計 | N4 | N3 L02 (n3/lesson_02.json) |
| 討 | N1 | N2 L13 (n2/lesson_13.json) |
| 設 | N2 | N3 L15 (n3/lesson_15.json) |
| 訳 | N1 | N1 L15 (n1/lesson_15.json)<br>N3 L22 (n3/lesson_22.json) |
| 評 | N1 | N3 L06 (n3/lesson_06.json) |
| 試 | N4 | N3 L16 (n3/lesson_16.json) |
| 誌 | N2 | N3 L09 (n3/lesson_09.json) |
| 認 | N3 | N4 L40 (n4/lesson_40.json) |
| 語 | N5 | N3 L04 (n3/lesson_04.json) |
| 誤 | N3 | N1 L11 (n1/lesson_11.json) |
| 課 | N2 | N3 L13 (n3/lesson_13.json) |
| 謝 | N1 | N3 L22 (n3/lesson_22.json)<br>N4 L45 (n4/lesson_45.json) |
| 議 | N2 | N1 L18 (n1/lesson_18.json)<br>N3 L22 (n3/lesson_22.json) |
| 貸 | N4 | N3 L15 (n3/lesson_15.json)<br>N5 L07 (n5/lesson_07.json) |
| 賃 | N1 | N3 L15 (n3/lesson_15.json) |
| 賞 | N2 | N3 L12 (n3/lesson_12.json) |
| 赤 | N4 | N1 L03 (n1/lesson_03.json) |
| 走 | N4 | N5 L18 (n5/lesson_18.json) |
| 越 | N3 | N2 L18 (n2/lesson_18.json) |
| 足 | N5 | N2 L02 (n2/lesson_02.json)<br>N5 L11 (n5/lesson_11.json) |
| 跡 | N2 | N1 L09 (n1/lesson_09.json)<br>N2 L02 (n2/lesson_02.json) |
| 踊 | N2 | N4 L28 (n4/lesson_28.json) |
| 軍 | N2 | N1 L18 (n1/lesson_18.json) |
| 転 | N4 | N2 L10 (n2/lesson_10.json)<br>N5 L22 (n5/lesson_22.json) |
| 軽 | N2 | N5 L15 (n5/lesson_15.json) |
| 輸 | N2 | N4 L36 (n4/lesson_36.json) |
| 辞 | N3 | N2 L22 (n2/lesson_22.json) |
| 込 | N3 | N1 L17 (n1/lesson_17.json)<br>N2 L24 (n2/lesson_24.json)<br>N4 L38 (n4/lesson_38.json) |
| 返 | N3 | N2 L14 (n2/lesson_14.json)<br>N3 L06 (n3/lesson_06.json) |
| 追 | N3 | N2 L18 (n2/lesson_18.json) |
| 送 | N4 | N2 L21 (n2/lesson_21.json)<br>N3 L06 (n3/lesson_06.json)<br>N5 L07 (n5/lesson_07.json) |
| 通 | N4 | N2 L20 (n2/lesson_20.json)<br>N3 L10 (n3/lesson_10.json)<br>N4 L28 (n4/lesson_28.json) |
| 速 | N3 | N4 L48 (n4/lesson_48.json) |
| 連 | N3 | N1 L23 (n1/lesson_23.json)<br>N3 L22 (n3/lesson_22.json)<br>N4 L46 (n4/lesson_46.json) |
| 運 | N4 | N2 L15 (n2/lesson_15.json)<br>N4 L32 (n4/lesson_32.json)<br>N4 L34 (n4/lesson_34.json) |
| 過 | N3 | N1 L11 (n1/lesson_11.json) |
| 違 | N3 | N1 L17 (n1/lesson_17.json) |
| 遠 | N3 | N2 L18 (n2/lesson_18.json) |
| 遭 | N1 | N2 L01 (n2/lesson_01.json) |
| 選 | N3 | N3 L16 (n3/lesson_16.json)<br>N4 L28 (n4/lesson_28.json) |
| 避 | N1 | N3 L11 (n3/lesson_11.json) |
| 部 | N3 | N1 L22 (n1/lesson_22.json) |
| 都 | N3 | N5 L21 (n5/lesson_21.json) |
| 配 | N3 | N3 L06 (n3/lesson_06.json)<br>N4 L48 (n4/lesson_48.json) |
| 重 | N3 | N2 L24 (n2/lesson_24.json)<br>N5 L15 (n5/lesson_15.json) |
| 量 | N2 | N4 L42 (n4/lesson_42.json) |
| 銅 | N2 | N1 L03 (n1/lesson_03.json) |
| 鑑 | N1 | N3 L12 (n3/lesson_12.json) |
| 長 | N5 | N2 L18 (n2/lesson_18.json)<br>N5 L15 (n5/lesson_15.json) |
| 閉 | N3 | N4 L29 (n4/lesson_29.json) |
| 開 | N4 | N3 L17 (n3/lesson_17.json)<br>N5 L14 (n5/lesson_14.json) |
| 間 | N5 | N1 L01 (n1/lesson_01.json)<br>N5 L10 (n5/lesson_10.json) |
| 降 | N3 | N2 L07 (n2/lesson_07.json)<br>N4 L37 (n4/lesson_37.json) |
| 集 | N4 | N1 L08 (n1/lesson_08.json)<br>N4 L47 (n4/lesson_47.json) |
| 離 | N1 | N3 L14 (n3/lesson_14.json) |
| 難 | N3 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json)<br>N3 L11 (n3/lesson_11.json)<br>N3 L25 (n3/lesson_25.json) |
| 雨 | N5 | N1 L10 (n1/lesson_10.json)<br>N2 L03 (n2/lesson_03.json)<br>N5 L20 (n5/lesson_20.json) |
| 雪 | N3 | N5 L20 (n5/lesson_20.json) |
| 震 | N2 | N3 L11 (n3/lesson_11.json) |
| 青 | N4 | N2 L01 (n2/lesson_01.json) |
| 静 | N3 | N1 L14 (n1/lesson_14.json)<br>N4 L32 (n4/lesson_32.json) |
| 面 | N3 | N1 L22 (n1/lesson_22.json)<br>N3 L05 (n3/lesson_05.json) |
| 音 | N4 | N5 L09 (n5/lesson_09.json) |
| 頂 | N3 | N1 L21 (n1/lesson_21.json) |
| 頭 | N3 | N5 L16 (n5/lesson_16.json) |
| 頼 | N3 | N3 L14 (n3/lesson_14.json)<br>N4 L36 (n4/lesson_36.json) |
| 題 | N4 | N3 L13 (n3/lesson_13.json) |
| 顔 | N3 | N5 L16 (n5/lesson_16.json) |
| 願 | N3 | N4 L41 (n4/lesson_41.json) |
| 飛 | N3 | N4 L41 (n4/lesson_41.json) |
| 食 | N5 | N2 L08 (n2/lesson_08.json)<br>N3 L19 (n3/lesson_19.json)<br>N5 L06 (n5/lesson_06.json) |
| 飢 | N1 | N2 L12 (n2/lesson_12.json) |
| 飼 | N1 | N4 L27 (n4/lesson_27.json) |
| 飽 | N1 | N2 L01 (n2/lesson_01.json) |
| 飾 | N1 | N3 L24 (n3/lesson_24.json)<br>N4 L30 (n4/lesson_30.json) |
| 養 | N1 | N3 L07 (n3/lesson_07.json) |
| 首 | N3 | N5 L16 (n5/lesson_16.json) |
| 駄 | N1 | N3 L03 (n3/lesson_03.json) |
| 験 | N4 | N3 L17 (n3/lesson_17.json) |
| 驚 | N1 | N2 L23 (n2/lesson_23.json)<br>N4 L47 (n4/lesson_47.json) |
| 鮮 | N1 | N1 L06 (n1/lesson_06.json)<br>N3 L19 (n3/lesson_19.json) |

## DUPLICATE

Rows where a character appears in more than one app level file.

| Kanji | Candidate correct level | Current placement |
| --- | --- | --- |
| 一 | N5 | N1 L22 (n1/lesson_22.json)<br>N2 L08 (n2/lesson_08.json)<br>N5 L02 (n5/lesson_02.json) |
| 上 | N5 | N1 L04 (n1/lesson_04.json)<br>N2 L15 (n2/lesson_15.json)<br>N5 L10 (n5/lesson_10.json) |
| 不 | N4 | N3 L20 (n3/lesson_20.json)<br>N5 L23 (n5/lesson_23.json) |
| 中 | N5 | N2 L25 (n2/lesson_25.json)<br>N5 L10 (n5/lesson_10.json) |
| 予 | N3 | N1 L11 (n1/lesson_11.json)<br>N3 L10 (n3/lesson_10.json)<br>N4 L30 (n4/lesson_30.json) |
| 争 | N3 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json)<br>N3 L23 (n3/lesson_23.json) |
| 井 | N1 | N1 L14 (n1/lesson_14.json)<br>N2 L10 (n2/lesson_10.json) |
| 人 | N5 | N1 L04 (n1/lesson_04.json)<br>N2 L25 (n2/lesson_25.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L11 (n5/lesson_11.json) |
| 代 | N4 | N2 L20 (n2/lesson_20.json)<br>N5 L14 (n5/lesson_14.json) |
| 以 | N4 | N2 L07 (n2/lesson_07.json)<br>N4 L34 (n4/lesson_34.json) |
| 会 | N5 | N2 L17 (n2/lesson_17.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L07 (n5/lesson_07.json)<br>N5 L13 (n5/lesson_13.json) |
| 伝 | N3 | N2 L23 (n2/lesson_23.json)<br>N3 L08 (n3/lesson_08.json)<br>N4 L38 (n4/lesson_38.json) |
| 住 | N4 | N1 L19 (n1/lesson_19.json)<br>N2 L08 (n2/lesson_08.json)<br>N3 L15 (n3/lesson_15.json)<br>N5 L21 (n5/lesson_21.json) |
| 体 | N4 | N2 L16 (n2/lesson_16.json)<br>N5 L16 (n5/lesson_16.json) |
| 何 | N5 | N1 L16 (n1/lesson_16.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L12 (n5/lesson_12.json) |
| 余 | N3 | N1 L14 (n1/lesson_14.json)<br>N2 L04 (n2/lesson_04.json) |
| 偉 | N3 | N2 L16 (n2/lesson_16.json)<br>N4 L28 (n4/lesson_28.json) |
| 具 | N3 | N1 L10 (n1/lesson_10.json)<br>N2 L16 (n2/lesson_16.json)<br>N4 L27 (n4/lesson_27.json) |
| 円 | N5 | N2 L17 (n2/lesson_17.json)<br>N5 L02 (n5/lesson_02.json) |
| 冷 | N3 | N3 L01 (n3/lesson_01.json)<br>N4 L43 (n4/lesson_43.json) |
| 凡 | N1 | N1 L12 (n1/lesson_12.json)<br>N2 L20 (n2/lesson_20.json) |
| 出 | N5 | N1 L15 (n1/lesson_15.json)<br>N2 L06 (n2/lesson_06.json) |
| 分 | N5 | N1 L22 (n1/lesson_22.json)<br>N2 L07 (n2/lesson_07.json) |
| 切 | N4 | N1 L23 (n1/lesson_23.json)<br>N2 L15 (n2/lesson_15.json)<br>N5 L23 (n5/lesson_23.json) |
| 別 | N4 | N1 L22 (n1/lesson_22.json)<br>N4 L47 (n4/lesson_47.json) |
| 利 | N3 | N3 L21 (n3/lesson_21.json)<br>N5 L23 (n5/lesson_23.json) |
| 前 | N5 | N1 L07 (n1/lesson_07.json)<br>N5 L10 (n5/lesson_10.json) |
| 劇 | N2 | N2 L17 (n2/lesson_17.json)<br>N3 L12 (n3/lesson_12.json) |
| 力 | N4 | N1 L09 (n1/lesson_09.json)<br>N2 L12 (n2/lesson_12.json)<br>N3 L02 (n3/lesson_02.json)<br>N5 L11 (n5/lesson_11.json)<br>N5 L14 (n5/lesson_14.json) |
| 加 | N3 | N1 L15 (n1/lesson_15.json)<br>N4 L38 (n4/lesson_38.json) |
| 動 | N4 | N1 L24 (n1/lesson_24.json)<br>N4 L32 (n4/lesson_32.json) |
| 化 | N3 | N1 L08 (n1/lesson_08.json)<br>N3 L04 (n3/lesson_04.json)<br>N3 L24 (n3/lesson_24.json) |
| 危 | N3 | N1 L11 (n1/lesson_11.json)<br>N2 L04 (n2/lesson_04.json)<br>N4 L32 (n4/lesson_32.json) |
| 厚 | N2 | N2 L02 (n2/lesson_02.json)<br>N4 L42 (n4/lesson_42.json) |
| 参 | N3 | N2 L24 (n2/lesson_24.json)<br>N3 L01 (n3/lesson_01.json)<br>N4 L50 (n4/lesson_50.json) |
| 取 | N3 | N2 L12 (n2/lesson_12.json)<br>N4 L37 (n4/lesson_37.json) |
| 口 | N5 | N1 L08 (n1/lesson_08.json)<br>N2 L14 (n2/lesson_14.json)<br>N5 L11 (n5/lesson_11.json) |
| 古 | N5 | N1 L25 (n1/lesson_25.json)<br>N5 L08 (n5/lesson_08.json) |
| 右 | N5 | N3 L01 (n3/lesson_01.json)<br>N5 L10 (n5/lesson_10.json) |
| 合 | N3 | N1 L02 (n1/lesson_02.json)<br>N2 L13 (n2/lesson_13.json)<br>N4 L33 (n4/lesson_33.json) |
| 同 | N4 | N1 L22 (n1/lesson_22.json)<br>N5 L13 (n5/lesson_13.json) |
| 名 | N5 | N2 L03 (n2/lesson_03.json)<br>N5 L01 (n5/lesson_01.json) |
| 味 | N4 | N1 L06 (n1/lesson_06.json)<br>N2 L02 (n2/lesson_02.json)<br>N3 L19 (n3/lesson_19.json)<br>N4 L35 (n4/lesson_35.json) |
| 呼 | N3 | N1 L01 (n1/lesson_01.json)<br>N4 L36 (n4/lesson_36.json) |
| 和 | N3 | N2 L16 (n2/lesson_16.json)<br>N3 L23 (n3/lesson_23.json) |
| 回 | N3 | N1 L09 (n1/lesson_09.json)<br>N5 L22 (n5/lesson_22.json) |
| 困 | N3 | N3 L25 (n3/lesson_25.json)<br>N4 L41 (n4/lesson_41.json) |
| 園 | N3 | N2 L17 (n2/lesson_17.json)<br>N5 L24 (n5/lesson_24.json) |
| 圧 | N2 | N1 L08 (n1/lesson_08.json)<br>N2 L03 (n2/lesson_03.json) |
| 地 | N4 | N1 L11 (n1/lesson_11.json)<br>N2 L08 (n2/lesson_08.json)<br>N5 L13 (n5/lesson_13.json) |
| 声 | N3 | N4 L27 (n4/lesson_27.json)<br>N5 L16 (n5/lesson_16.json) |
| 売 | N4 | N2 L15 (n2/lesson_15.json)<br>N4 L28 (n4/lesson_28.json) |
| 変 | N3 | N1 L01 (n1/lesson_01.json)<br>N4 L43 (n4/lesson_43.json) |
| 外 | N5 | N1 L17 (n1/lesson_17.json)<br>N2 L06 (n2/lesson_06.json)<br>N5 L10 (n5/lesson_10.json) |
| 多 | N5 | N1 L18 (n1/lesson_18.json)<br>N5 L15 (n5/lesson_15.json) |
| 大 | N5 | N2 L20 (n2/lesson_20.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L08 (n5/lesson_08.json) |
| 女 | N5 | N1 L09 (n1/lesson_09.json)<br>N2 L19 (n2/lesson_19.json)<br>N5 L11 (n5/lesson_11.json) |
| 妹 | N4 | N2 L11 (n2/lesson_11.json)<br>N5 L24 (n5/lesson_24.json) |
| 姉 | N4 | N2 L10 (n2/lesson_10.json)<br>N5 L24 (n5/lesson_24.json) |
| 字 | N4 | N1 L03 (n1/lesson_03.json)<br>N5 L09 (n5/lesson_09.json) |
| 存 | N3 | N1 L20 (n1/lesson_20.json)<br>N4 L49 (n4/lesson_49.json) |
| 学 | N5 | N3 L04 (n3/lesson_04.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L12 (n5/lesson_12.json) |
| 宅 | N3 | N3 L15 (n3/lesson_15.json)<br>N4 L48 (n4/lesson_48.json) |
| 安 | N5 | N1 L14 (n1/lesson_14.json)<br>N2 L05 (n2/lesson_05.json)<br>N3 L20 (n3/lesson_20.json)<br>N5 L08 (n5/lesson_08.json) |
| 定 | N3 | N1 L14 (n1/lesson_14.json)<br>N2 L10 (n2/lesson_10.json) |
| 宛 | EXTRA | N1 L09 (n1/lesson_09.json)<br>N2 L03 (n2/lesson_03.json) |
| 対 | N3 | N1 L01 (n1/lesson_01.json)<br>N2 L19 (n2/lesson_19.json) |
| 小 | N5 | N2 L22 (n2/lesson_22.json)<br>N5 L08 (n5/lesson_08.json) |
| 屋 | N4 | N2 L21 (n2/lesson_21.json)<br>N4 L34 (n4/lesson_34.json) |
| 左 | N5 | N3 L01 (n3/lesson_01.json)<br>N5 L10 (n5/lesson_10.json) |
| 市 | N3 | N1 L21 (n1/lesson_21.json)<br>N5 L21 (n5/lesson_21.json) |
| 帯 | N2 | N1 L23 (n1/lesson_23.json)<br>N2 L25 (n2/lesson_25.json) |
| 幾 | N3 | N1 L18 (n1/lesson_18.json)<br>N2 L07 (n2/lesson_07.json) |
| 引 | N3 | N2 L11 (n2/lesson_11.json)<br>N5 L18 (n5/lesson_18.json) |
| 張 | N1 | N2 L11 (n2/lesson_11.json)<br>N3 L20 (n3/lesson_20.json)<br>N4 L30 (n4/lesson_30.json) |
| 彼 | N3 | N1 L06 (n1/lesson_06.json)<br>N4 L33 (n4/lesson_33.json) |
| 律 | N2 | N1 L23 (n1/lesson_23.json)<br>N3 L18 (n3/lesson_18.json) |
| 後 | N5 | N1 L05 (n1/lesson_05.json)<br>N2 L07 (n2/lesson_07.json)<br>N5 L10 (n5/lesson_10.json) |
| 心 | N4 | N1 L23 (n1/lesson_23.json)<br>N5 L16 (n5/lesson_16.json) |
| 怒 | N3 | N1 L16 (n1/lesson_16.json)<br>N3 L20 (n3/lesson_20.json)<br>N4 L47 (n4/lesson_47.json) |
| 悪 | N4 | N1 L04 (n1/lesson_04.json)<br>N2 L08 (n2/lesson_08.json)<br>N5 L15 (n5/lesson_15.json) |
| 悲 | N3 | N3 L20 (n3/lesson_20.json)<br>N4 L47 (n4/lesson_47.json) |
| 意 | N4 | N1 L17 (n1/lesson_17.json)<br>N2 L06 (n2/lesson_06.json)<br>N4 L35 (n4/lesson_35.json) |
| 憧 | N1 | N1 L05 (n1/lesson_05.json)<br>N2 L02 (n2/lesson_02.json) |
| 成 | N3 | N1 L17 (n1/lesson_17.json)<br>N5 L19 (n5/lesson_19.json) |
| 戦 | N3 | N1 L18 (n1/lesson_18.json)<br>N3 L23 (n3/lesson_23.json) |
| 手 | N5 | N2 L23 (n2/lesson_23.json)<br>N5 L07 (n5/lesson_07.json)<br>N5 L11 (n5/lesson_11.json)<br>N5 L14 (n5/lesson_14.json) |
| 打 | N3 | N2 L13 (n2/lesson_13.json)<br>N4 L45 (n4/lesson_45.json) |
| 投 | N3 | N3 L21 (n3/lesson_21.json)<br>N4 L45 (n4/lesson_45.json) |
| 押 | N3 | N2 L21 (n2/lesson_21.json)<br>N4 L37 (n4/lesson_37.json) |
| 拝 | N2 | N2 L20 (n2/lesson_20.json)<br>N4 L49 (n4/lesson_49.json) |
| 挙 | N1 | N1 L23 (n1/lesson_23.json)<br>N2 L02 (n2/lesson_02.json) |
| 掛 | N3 | N2 L18 (n2/lesson_18.json)<br>N4 L30 (n4/lesson_30.json) |
| 接 | N2 | N2 L19 (n2/lesson_19.json)<br>N3 L05 (n3/lesson_05.json) |
| 援 | N1 | N2 L19 (n2/lesson_19.json)<br>N3 L14 (n3/lesson_14.json) |
| 改 | N2 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json) |
| 教 | N4 | N2 L23 (n2/lesson_23.json)<br>N3 L13 (n3/lesson_13.json)<br>N5 L07 (n5/lesson_07.json) |
| 文 | N4 | N2 L16 (n2/lesson_16.json)<br>N3 L04 (n3/lesson_04.json)<br>N3 L06 (n3/lesson_06.json)<br>N4 L35 (n4/lesson_35.json) |
| 新 | N5 | N3 L09 (n3/lesson_09.json)<br>N5 L08 (n5/lesson_08.json)<br>N5 L14 (n5/lesson_14.json) |
| 方 | N4 | N1 L07 (n1/lesson_07.json)<br>N2 L01 (n2/lesson_01.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L14 (n5/lesson_14.json) |
| 旅 | N4 | N3 L10 (n3/lesson_10.json)<br>N5 L09 (n5/lesson_09.json) |
| 日 | N5 | N1 L05 (n1/lesson_05.json)<br>N2 L09 (n2/lesson_09.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L03 (n5/lesson_03.json) |
| 明 | N4 | N1 L03 (n1/lesson_03.json)<br>N2 L01 (n2/lesson_01.json)<br>N3 L17 (n3/lesson_17.json)<br>N5 L15 (n5/lesson_15.json) |
| 暖 | N1 | N2 L02 (n2/lesson_02.json)<br>N4 L43 (n4/lesson_43.json) |
| 暗 | N3 | N1 L13 (n1/lesson_13.json)<br>N2 L13 (n2/lesson_13.json)<br>N5 L15 (n5/lesson_15.json) |
| 更 | N3 | N1 L25 (n1/lesson_25.json)<br>N3 L01 (n3/lesson_01.json) |
| 替 | N2 | N3 L24 (n3/lesson_24.json)<br>N4 L43 (n4/lesson_43.json) |
| 有 | N4 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json)<br>N5 L23 (n5/lesson_23.json) |
| 朝 | N4 | N1 L05 (n1/lesson_05.json)<br>N5 L17 (n5/lesson_17.json) |
| 来 | N5 | N3 L02 (n3/lesson_02.json)<br>N5 L01 (n5/lesson_01.json) |
| 案 | N2 | N1 L13 (n1/lesson_13.json)<br>N2 L06 (n2/lesson_06.json) |
| 植 | N2 | N2 L12 (n2/lesson_12.json)<br>N4 L30 (n4/lesson_30.json) |
| 様 | N3 | N1 L13 (n1/lesson_13.json)<br>N3 L01 (n3/lesson_01.json)<br>N4 L49 (n4/lesson_49.json) |
| 機 | N3 | N3 L17 (n3/lesson_17.json)<br>N4 L41 (n4/lesson_41.json) |
| 歩 | N4 | N1 L11 (n1/lesson_11.json)<br>N5 L18 (n5/lesson_18.json) |
| 母 | N5 | N2 L24 (n2/lesson_24.json)<br>N5 L12 (n5/lesson_12.json) |
| 民 | N3 | N1 L25 (n1/lesson_25.json)<br>N3 L15 (n3/lesson_15.json) |
| 汚 | N2 | N3 L25 (n3/lesson_25.json)<br>N4 L29 (n4/lesson_29.json) |
| 決 | N3 | N3 L16 (n3/lesson_16.json)<br>N4 L30 (n4/lesson_30.json) |
| 油 | N2 | N1 L10 (n1/lesson_10.json)<br>N4 L36 (n4/lesson_36.json) |
| 治 | N3 | N2 L21 (n2/lesson_21.json)<br>N3 L07 (n3/lesson_07.json)<br>N3 L23 (n3/lesson_23.json) |
| 法 | N3 | N3 L01 (n3/lesson_01.json)<br>N3 L18 (n3/lesson_18.json)<br>N4 L35 (n4/lesson_35.json) |
| 注 | N4 | N3 L06 (n3/lesson_06.json)<br>N4 L36 (n4/lesson_36.json) |
| 洗 | N3 | N2 L23 (n2/lesson_23.json)<br>N5 L18 (n5/lesson_18.json) |
| 流 | N3 | N2 L09 (n2/lesson_09.json)<br>N3 L04 (n3/lesson_04.json)<br>N3 L24 (n3/lesson_24.json) |
| 消 | N3 | N2 L13 (n2/lesson_13.json)<br>N4 L29 (n4/lesson_29.json) |
| 減 | N2 | N1 L15 (n1/lesson_15.json)<br>N4 L43 (n4/lesson_43.json) |
| 演 | N3 | N2 L17 (n2/lesson_17.json)<br>N3 L12 (n3/lesson_12.json) |
| 炒 | N1 | N1 L21 (n1/lesson_21.json)<br>N2 L11 (n2/lesson_11.json) |
| 無 | N4 | N2 L14 (n2/lesson_14.json)<br>N3 L03 (n3/lesson_03.json) |
| 煙 | N3 | N2 L18 (n2/lesson_18.json)<br>N4 L32 (n4/lesson_32.json) |
| 父 | N5 | N2 L22 (n2/lesson_22.json)<br>N5 L12 (n5/lesson_12.json) |
| 甘 | N2 | N1 L10 (n1/lesson_10.json)<br>N2 L04 (n2/lesson_04.json) |
| 生 | N5 | N1 L16 (n1/lesson_16.json)<br>N2 L06 (n2/lesson_06.json)<br>N5 L01 (n5/lesson_01.json)<br>N5 L12 (n5/lesson_12.json) |
| 留 | N3 | N3 L04 (n3/lesson_04.json)<br>N4 L33 (n4/lesson_33.json) |
| 発 | N4 | N3 L17 (n3/lesson_17.json)<br>N5 L13 (n5/lesson_13.json) |
| 白 | N5 | N1 L03 (n1/lesson_03.json)<br>N2 L01 (n2/lesson_01.json) |
| 目 | N5 | N1 L23 (n1/lesson_23.json)<br>N3 L02 (n3/lesson_02.json)<br>N5 L11 (n5/lesson_11.json) |
| 眠 | N3 | N3 L07 (n3/lesson_07.json)<br>N4 L44 (n4/lesson_44.json) |
| 着 | N4 | N2 L23 (n2/lesson_23.json)<br>N3 L24 (n3/lesson_24.json)<br>N4 L31 (n4/lesson_31.json) |
| 礼 | N3 | N3 L08 (n3/lesson_08.json)<br>N4 L41 (n4/lesson_41.json) |
| 私 | N4 | N1 L07 (n1/lesson_07.json)<br>N4 L26 (n4/lesson_26.json) |
| 科 | N3 | N1 L03 (n1/lesson_03.json)<br>N3 L17 (n3/lesson_17.json)<br>N5 L16 (n5/lesson_16.json) |
| 移 | N2 | N1 L19 (n1/lesson_19.json)<br>N2 L10 (n2/lesson_10.json) |
| 空 | N5 | N1 L04 (n1/lesson_04.json)<br>N4 L31 (n4/lesson_31.json) |
| 笑 | N3 | N1 L06 (n1/lesson_06.json)<br>N4 L44 (n4/lesson_44.json) |
| 粗 | N1 | N1 L12 (n1/lesson_12.json)<br>N2 L04 (n2/lesson_04.json) |
| 約 | N3 | N3 L03 (n3/lesson_03.json)<br>N3 L10 (n3/lesson_10.json)<br>N4 L46 (n4/lesson_46.json) |
| 経 | N3 | N1 L17 (n1/lesson_17.json)<br>N3 L21 (n3/lesson_21.json) |
| 絵 | N3 | N1 L10 (n1/lesson_10.json)<br>N2 L16 (n2/lesson_16.json)<br>N5 L09 (n5/lesson_09.json) |
| 緯 | N1 | N1 L17 (n1/lesson_17.json)<br>N2 L10 (n2/lesson_10.json) |
| 考 | N4 | N3 L01 (n3/lesson_01.json)<br>N4 L31 (n4/lesson_31.json)<br>N4 L34 (n4/lesson_34.json)<br>N5 L25 (n5/lesson_25.json) |
| 聞 | N5 | N3 L09 (n3/lesson_09.json)<br>N5 L06 (n5/lesson_06.json) |
| 育 | N3 | N1 L18 (n1/lesson_18.json)<br>N2 L07 (n2/lesson_07.json)<br>N3 L13 (n3/lesson_13.json)<br>N3 L14 (n3/lesson_14.json)<br>N4 L37 (n4/lesson_37.json) |
| 良 | N3 | N1 L14 (n1/lesson_14.json)<br>N5 L08 (n5/lesson_08.json) |
| 芸 | N2 | N2 L17 (n2/lesson_17.json)<br>N3 L12 (n3/lesson_12.json) |
| 荒 | N2 | N1 L11 (n1/lesson_11.json)<br>N2 L04 (n2/lesson_04.json) |
| 落 | N3 | N2 L23 (n2/lesson_23.json)<br>N4 L29 (n4/lesson_29.json) |
| 著 | N2 | N1 L22 (n1/lesson_22.json)<br>N2 L05 (n2/lesson_05.json) |
| 薄 | N2 | N2 L13 (n2/lesson_13.json)<br>N4 L42 (n4/lesson_42.json) |
| 行 | N5 | N1 L17 (n1/lesson_17.json)<br>N2 L15 (n2/lesson_15.json)<br>N3 L24 (n3/lesson_24.json)<br>N5 L01 (n5/lesson_01.json) |
| 衣 | N2 | N1 L19 (n1/lesson_19.json)<br>N2 L08 (n2/lesson_08.json) |
| 装 | N2 | N1 L19 (n1/lesson_19.json)<br>N3 L24 (n3/lesson_24.json) |
| 見 | N5 | N1 L19 (n1/lesson_19.json)<br>N5 L06 (n5/lesson_06.json) |
| 親 | N4 | N2 L24 (n2/lesson_24.json)<br>N5 L23 (n5/lesson_23.json) |
| 言 | N5 | N1 L15 (n1/lesson_15.json)<br>N2 L06 (n2/lesson_06.json)<br>N3 L04 (n3/lesson_04.json) |
| 訳 | N1 | N1 L15 (n1/lesson_15.json)<br>N3 L22 (n3/lesson_22.json) |
| 謝 | N1 | N3 L22 (n3/lesson_22.json)<br>N4 L45 (n4/lesson_45.json) |
| 議 | N2 | N1 L18 (n1/lesson_18.json)<br>N3 L22 (n3/lesson_22.json) |
| 貸 | N4 | N3 L15 (n3/lesson_15.json)<br>N5 L07 (n5/lesson_07.json) |
| 足 | N5 | N2 L02 (n2/lesson_02.json)<br>N5 L11 (n5/lesson_11.json) |
| 跡 | N2 | N1 L09 (n1/lesson_09.json)<br>N2 L02 (n2/lesson_02.json) |
| 転 | N4 | N2 L10 (n2/lesson_10.json)<br>N5 L22 (n5/lesson_22.json) |
| 込 | N3 | N1 L17 (n1/lesson_17.json)<br>N2 L24 (n2/lesson_24.json)<br>N4 L38 (n4/lesson_38.json) |
| 返 | N3 | N2 L14 (n2/lesson_14.json)<br>N3 L06 (n3/lesson_06.json) |
| 送 | N4 | N2 L21 (n2/lesson_21.json)<br>N3 L06 (n3/lesson_06.json)<br>N5 L07 (n5/lesson_07.json) |
| 通 | N4 | N2 L20 (n2/lesson_20.json)<br>N3 L10 (n3/lesson_10.json)<br>N4 L28 (n4/lesson_28.json) |
| 連 | N3 | N1 L23 (n1/lesson_23.json)<br>N3 L22 (n3/lesson_22.json)<br>N4 L46 (n4/lesson_46.json) |
| 運 | N4 | N2 L15 (n2/lesson_15.json)<br>N4 L32 (n4/lesson_32.json)<br>N4 L34 (n4/lesson_34.json) |
| 選 | N3 | N3 L16 (n3/lesson_16.json)<br>N4 L28 (n4/lesson_28.json) |
| 配 | N3 | N3 L06 (n3/lesson_06.json)<br>N4 L48 (n4/lesson_48.json) |
| 重 | N3 | N2 L24 (n2/lesson_24.json)<br>N5 L15 (n5/lesson_15.json) |
| 長 | N5 | N2 L18 (n2/lesson_18.json)<br>N5 L15 (n5/lesson_15.json) |
| 開 | N4 | N3 L17 (n3/lesson_17.json)<br>N5 L14 (n5/lesson_14.json) |
| 間 | N5 | N1 L01 (n1/lesson_01.json)<br>N5 L10 (n5/lesson_10.json) |
| 降 | N3 | N2 L07 (n2/lesson_07.json)<br>N4 L37 (n4/lesson_37.json) |
| 集 | N4 | N1 L08 (n1/lesson_08.json)<br>N4 L47 (n4/lesson_47.json) |
| 難 | N3 | N1 L12 (n1/lesson_12.json)<br>N2 L05 (n2/lesson_05.json)<br>N3 L11 (n3/lesson_11.json)<br>N3 L25 (n3/lesson_25.json) |
| 雨 | N5 | N1 L10 (n1/lesson_10.json)<br>N2 L03 (n2/lesson_03.json)<br>N5 L20 (n5/lesson_20.json) |
| 静 | N3 | N1 L14 (n1/lesson_14.json)<br>N4 L32 (n4/lesson_32.json) |
| 面 | N3 | N1 L22 (n1/lesson_22.json)<br>N3 L05 (n3/lesson_05.json) |
| 頼 | N3 | N3 L14 (n3/lesson_14.json)<br>N4 L36 (n4/lesson_36.json) |
| 食 | N5 | N2 L08 (n2/lesson_08.json)<br>N3 L19 (n3/lesson_19.json)<br>N5 L06 (n5/lesson_06.json) |
| 飾 | N1 | N3 L24 (n3/lesson_24.json)<br>N4 L30 (n4/lesson_30.json) |
| 驚 | N1 | N2 L23 (n2/lesson_23.json)<br>N4 L47 (n4/lesson_47.json) |
| 鮮 | N1 | N1 L06 (n1/lesson_06.json)<br>N3 L19 (n3/lesson_19.json) |

## MISSING

Candidate canonical kanji absent from all current app kanji JSON files.

| Kanji | Correct level | Source tier |
| --- | --- | --- |
| 丁 | N1 | N1 |
| 丈 | N1 | N1 |
| 与 | N3 | N3 |
| 丑 | N1 | N1 |
| 世 | N4 | N4 |
| 丘 | N1 | N1 |
| 両 | N3 | N3 |
| 串 | N1 | N1 |
| 丸 | N2 | N2 |
| 丹 | N1 | N1 |
| 丼 | N1 | N1 |
| 乃 | N1 | N1 |
| 久 | N2 | N2 |
| 之 | N1 | N1 |
| 乏 | N1 | N1 |
| 乗 | N3 | N3 |
| 乙 | N1 | N1 |
| 乞 | N1 | N1 |
| 也 | N1 | N1 |
| 乱 | N2 | N2 |
| 乳 | N2 | N2 |
| 亀 | N1 | N1 |
| 了 | N2 | N2 |
| 互 | N3 | N3 |
| 亘 | N1 | N1 |
| 亡 | N3 | N3 |
| 亨 | N1 | N1 |
| 享 | N1 | N1 |
| 亭 | N1 | N1 |
| 亮 | N1 | N1 |
| 仁 | N1 | N1 |
| 仇 | N1 | N1 |
| 仏 | N2 | N2 |
| 仕 | N4 | N4 |
| 仙 | N1 | N1 |
| 令 | N2 | N2 |
| 仲 | N2 | N2 |
| 件 | N3 | N3 |
| 企 | N1 | N1 |
| 伍 | N1 | N1 |
| 伏 | N1 | N1 |
| 伐 | N1 | N1 |
| 休 | N5 | N5 |
| 伴 | N1 | N1 |
| 伸 | N2 | N2 |
| 似 | N3 | N3 |
| 伽 | N1 | N1 |
| 佃 | N1 | N1 |
| 但 | N1 | N1 |
| 低 | N2 | N2 |
| 佐 | N1 | N1 |
| 佑 | N1 | N1 |
| 佳 | N1 | N1 |
| 併 | N1 | N1 |
| 使 | N4 | N4 |
| 例 | N3 | N3 |
| 侍 | N1 | N1 |
| 供 | N3 | N3 |
| 侠 | N1 | N1 |
| 侮 | N1 | N1 |
| 侯 | N1 | N1 |
| 侵 | N1 | N1 |
| 係 | N3 | N3 |
| 促 | N1 | N1 |
| 俊 | N1 | N1 |
| 俗 | N1 | N1 |
| 俣 | N1 | N1 |
| 修 | N1 | N1 |
| 俳 | N1 | N1 |
| 俵 | N1 | N1 |
| 俸 | N1 | N1 |
| 倉 | N1 | N1 |
| 個 | N2 | N2 |
| 候 | N3 | N3 |
| 倣 | N1 | N1 |
| 倫 | N1 | N1 |
| 倭 | N1 | N1 |
| 倶 | N1 | N1 |
| 倹 | N1 | N1 |
| 偏 | N1 | N1 |
| 偕 | N1 | N1 |
| 停 | N2 | N2 |
| 偲 | N1 | N1 |
| 側 | N3 | N3 |
| 偵 | N1 | N1 |
| 偶 | N3 | N3 |
| 偽 | N1 | N1 |
| 傍 | N1 | N1 |
| 傑 | N1 | N1 |
| 傘 | N1 | N1 |
| 催 | N1 | N1 |
| 債 | N1 | N1 |
| 傷 | N1 | N1 |
| 傾 | N2 | N2 |
| 働 | N3 | N3 |
| 像 | N2 | N2 |
| 僑 | N1 | N1 |
| 僕 | N1 | N1 |
| 僚 | N1 | N1 |
| 僧 | N1 | N1 |
| 億 | N2 | N2 |
| 儒 | N1 | N1 |
| 償 | N1 | N1 |
| 儲 | N1 | N1 |
| 允 | N1 | N1 |
| 元 | N4 | N4 |
| 充 | N1 | N1 |
| 兆 | N2 | N2 |
| 克 | N1 | N1 |
| 免 | N1 | N1 |
| 党 | N2 | N2 |
| 兜 | N1 | N1 |
| 全 | N3 | N3 |
| 共 | N3 | N3 |
| 兵 | N2 | N2 |
| 其 | N1 | N1 |
| 典 | N1 | N1 |
| 兼 | N1 | N1 |
| 冊 | N2 | N2 |
| 冒 | N1 | N1 |
| 冗 | N1 | N1 |
| 冠 | N1 | N1 |
| 冤 | N1 | N1 |
| 冥 | N1 | N1 |
| 冨 | N1 | N1 |
| 冬 | N4 | N4 |
| 冴 | N1 | N1 |
| 凄 | N1 | N1 |
| 准 | N1 | N1 |
| 凌 | N1 | N1 |
| 凍 | N2 | N2 |
| 凝 | N1 | N1 |
| 凧 | N1 | N1 |
| 凱 | N1 | N1 |
| 凶 | N1 | N1 |
| 凸 | N1 | N1 |
| 凹 | N1 | N1 |
| 函 | N1 | N1 |
| 刀 | N1 | N1 |
| 刃 | N1 | N1 |
| 刈 | N1 | N1 |
| 刊 | N2 | N2 |
| 刑 | N1 | N1 |
| 列 | N3 | N3 |
| 初 | N3 | N3 |
| 判 | N3 | N3 |
| 到 | N3 | N3 |
| 刷 | N2 | N2 |
| 券 | N2 | N2 |
| 刺 | N2 | N2 |
| 刻 | N3 | N3 |
| 剃 | N1 | N1 |
| 削 | N1 | N1 |
| 剖 | N1 | N1 |
| 剛 | N1 | N1 |
| 剣 | N1 | N1 |
| 剤 | N1 | N1 |
| 剥 | N1 | N1 |
| 副 | N2 | N2 |
| 剰 | N1 | N1 |
| 割 | N3 | N3 |
| 創 | N1 | N1 |
| 劉 | N1 | N1 |
| 功 | N1 | N1 |
| 劣 | N1 | N1 |
| 助 | N3 | N3 |
| 励 | N1 | N1 |
| 効 | N2 | N2 |
| 劾 | N1 | N1 |
| 勅 | N1 | N1 |
| 勉 | N4 | N4 |
| 勘 | N1 | N1 |
| 務 | N3 | N3 |
| 募 | N2 | N2 |
| 勢 | N2 | N2 |
| 勤 | N3 | N3 |
| 勧 | N1 | N1 |
| 勲 | N1 | N1 |
| 匂 | N1 | N1 |
| 北 | N5 | N5 |
| 匠 | N1 | N1 |
| 匡 | N1 | N1 |
| 匹 | N2 | N2 |
| 医 | N4 | N4 |
| 匿 | N1 | N1 |
| 升 | N1 | N1 |
| 午 | N5 | N5 |
| 半 | N5 | N5 |
| 卑 | N1 | N1 |
| 卓 | N1 | N1 |
| 協 | N2 | N2 |
| 南 | N5 | N5 |
| 博 | N1 | N1 |
| 卯 | N1 | N1 |
| 印 | N2 | N2 |
| 即 | N1 | N1 |
| 却 | N1 | N1 |
| 卵 | N2 | N2 |
| 卿 | N1 | N1 |
| 厄 | N1 | N1 |
| 厘 | N1 | N1 |
| 厦 | N1 | N1 |
| 厨 | N1 | N1 |
| 厳 | N1 | N1 |
| 去 | N4 | N4 |
| 又 | N1 | N1 |
| 及 | N1 | N1 |
| 双 | N2 | N2 |
| 反 | N3 | N3 |
| 叙 | N1 | N1 |
| 叢 | N1 | N1 |
| 句 | N1 | N1 |
| 叩 | N1 | N1 |
| 只 | N1 | N1 |
| 叫 | N2 | N2 |
| 可 | N1 | N1 |
| 台 | N4 | N4 |
| 叱 | N1 | N1 |
| 叶 | N1 | N1 |
| 号 | N3 | N3 |
| 司 | N1 | N1 |
| 吉 | N1 | N1 |
| 吊 | N1 | N1 |
| 后 | N1 | N1 |
| 吐 | N1 | N1 |
| 君 | N3 | N3 |
| 吟 | N1 | N1 |
| 含 | N2 | N2 |
| 吸 | N3 | N3 |
| 吹 | N3 | N3 |
| 吾 | N1 | N1 |
| 呂 | N1 | N1 |
| 呈 | N1 | N1 |
| 呉 | N1 | N1 |
| 告 | N3 | N3 |
| 呑 | N1 | N1 |
| 呪 | N1 | N1 |
| 命 | N3 | N3 |
| 咲 | N2 | N2 |
| 咸 | N1 | N1 |
| 哀 | N1 | N1 |
| 哨 | N1 | N1 |
| 哲 | N1 | N1 |
| 哺 | N1 | N1 |
| 唄 | N1 | N1 |
| 唆 | N1 | N1 |
| 唇 | N1 | N1 |
| 唐 | N1 | N1 |
| 唯 | N1 | N1 |
| 唱 | N1 | N1 |
| 啄 | N1 | N1 |
| 啓 | N1 | N1 |
| 善 | N1 | N1 |
| 喉 | N1 | N1 |
| 喋 | N1 | N1 |
| 喘 | N1 | N1 |
| 喚 | N1 | N1 |
| 喝 | N1 | N1 |
| 喧 | N1 | N1 |
| 喪 | N1 | N1 |
| 喫 | N2 | N2 |
| 喬 | N1 | N1 |
| 嗅 | N1 | N1 |
| 嗜 | N1 | N1 |
| 嗣 | N1 | N1 |
| 嘆 | N1 | N1 |
| 嘉 | N1 | N1 |
| 嘘 | N1 | N1 |
| 嘱 | N1 | N1 |
| 噂 | N1 | N1 |
| 噛 | N1 | N1 |
| 器 | N1 | N1 |
| 噴 | N1 | N1 |
| 噺 | N1 | N1 |
| 嚇 | N1 | N1 |
| 囃 | N1 | N1 |
| 囚 | N1 | N1 |
| 因 | N3 | N3 |
| 団 | N2 | N2 |
| 囲 | N2 | N2 |
| 固 | N2 | N2 |
| 圏 | N1 | N1 |
| 土 | N5 | N5 |
| 圭 | N1 | N1 |
| 坂 | N2 | N2 |
| 均 | N2 | N2 |
| 坐 | N1 | N1 |
| 坑 | N1 | N1 |
| 坪 | N1 | N1 |
| 垂 | N1 | N1 |
| 型 | N2 | N2 |
| 垣 | N1 | N1 |
| 城 | N2 | N2 |
| 埴 | N1 | N1 |
| 執 | N1 | N1 |
| 培 | N1 | N1 |
| 基 | N1 | N1 |
| 埼 | N1 | N1 |
| 堀 | N1 | N1 |
| 堂 | N4 | N4 |
| 堅 | N1 | N1 |
| 堆 | N1 | N1 |
| 堕 | N1 | N1 |
| 堤 | N1 | N1 |
| 堪 | N1 | N1 |
| 堰 | N1 | N1 |
| 堺 | N1 | N1 |
| 塀 | N1 | N1 |
| 塁 | N1 | N1 |
| 塊 | N1 | N1 |
| 塔 | N2 | N2 |
| 塗 | N2 | N2 |
| 塙 | N1 | N1 |
| 塚 | N1 | N1 |
| 塩 | N2 | N2 |
| 塾 | N1 | N1 |
| 境 | N2 | N2 |
| 墓 | N1 | N1 |
| 墜 | N1 | N1 |
| 墨 | N1 | N1 |
| 墳 | N1 | N1 |
| 壁 | N1 | N1 |
| 壇 | N1 | N1 |
| 壌 | N1 | N1 |
| 壕 | N1 | N1 |
| 士 | N1 | N1 |
| 壬 | N1 | N1 |
| 壮 | N1 | N1 |
| 壱 | N1 | N1 |
| 壷 | N1 | N1 |
| 夏 | N4 | N4 |
| 太 | N3 | N3 |
| 央 | N2 | N2 |
| 夷 | N1 | N1 |
| 奄 | N1 | N1 |
| 奇 | N1 | N1 |
| 奈 | N1 | N1 |
| 奉 | N1 | N1 |
| 契 | N1 | N1 |
| 奔 | N1 | N1 |
| 奥 | N2 | N2 |
| 奨 | N1 | N1 |
| 奪 | N1 | N1 |
| 奮 | N1 | N1 |
| 奴 | N1 | N1 |
| 妃 | N1 | N1 |
| 妄 | N1 | N1 |
| 妊 | N1 | N1 |
| 妖 | N1 | N1 |
| 妙 | N1 | N1 |
| 妥 | N1 | N1 |
| 妨 | N1 | N1 |
| 妻 | N3 | N3 |
| 姑 | N1 | N1 |
| 姓 | N2 | N2 |
| 姚 | N1 | N1 |
| 姜 | N1 | N1 |
| 姫 | N1 | N1 |
| 姻 | N1 | N1 |
| 姿 | N1 | N1 |
| 娘 | N3 | N3 |
| 娠 | N1 | N1 |
| 娯 | N1 | N1 |
| 娼 | N1 | N1 |
| 婆 | N1 | N1 |
| 婚 | N3 | N3 |
| 婿 | N1 | N1 |
| 媒 | N1 | N1 |
| 媛 | N1 | N1 |
| 嫁 | N1 | N1 |
| 嫉 | N1 | N1 |
| 嫡 | N1 | N1 |
| 嬉 | N1 | N1 |
| 嬢 | N1 | N1 |
| 孔 | N1 | N1 |
| 孜 | N1 | N1 |
| 孝 | N1 | N1 |
| 孟 | N1 | N1 |
| 孤 | N1 | N1 |
| 孫 | N2 | N2 |
| 宇 | N2 | N2 |
| 宋 | N1 | N1 |
| 完 | N3 | N3 |
| 宍 | N1 | N1 |
| 宏 | N1 | N1 |
| 宕 | N1 | N1 |
| 宗 | N1 | N1 |
| 官 | N3 | N3 |
| 宙 | N1 | N1 |
| 宜 | N1 | N1 |
| 宝 | N2 | N2 |
| 客 | N3 | N3 |
| 宣 | N1 | N1 |
| 宮 | N1 | N1 |
| 宰 | N1 | N1 |
| 宵 | N1 | N1 |
| 容 | N3 | N3 |
| 寂 | N1 | N1 |
| 寄 | N3 | N3 |
| 寅 | N1 | N1 |
| 密 | N1 | N1 |
| 富 | N3 | N3 |
| 寒 | N3 | N3 |
| 寓 | N1 | N1 |
| 寛 | N1 | N1 |
| 察 | N3 | N3 |
| 寡 | N1 | N1 |
| 寧 | N1 | N1 |
| 寮 | N1 | N1 |
| 寸 | N1 | N1 |
| 寺 | N2 | N2 |
| 寿 | N1 | N1 |
| 封 | N2 | N2 |
| 専 | N2 | N2 |
| 射 | N1 | N1 |
| 尉 | N1 | N1 |
| 尊 | N2 | N2 |
| 尋 | N1 | N1 |
| 尖 | N1 | N1 |
| 尚 | N1 | N1 |
| 尭 | N1 | N1 |
| 尹 | N1 | N1 |
| 尺 | N1 | N1 |
| 尻 | N1 | N1 |
| 尼 | N1 | N1 |
| 尽 | N1 | N1 |
| 尾 | N1 | N1 |
| 尿 | N1 | N1 |
| 局 | N3 | N3 |
| 居 | N3 | N3 |
| 屈 | N1 | N1 |
| 屏 | N1 | N1 |
| 展 | N1 | N1 |
| 属 | N1 | N1 |
| 層 | N2 | N2 |
| 履 | N1 | N1 |
| 屯 | N1 | N1 |
| 岐 | N1 | N1 |
| 岡 | N1 | N1 |
| 岩 | N2 | N2 |
| 岬 | N1 | N1 |
| 岳 | N1 | N1 |
| 岸 | N2 | N2 |
| 峙 | N1 | N1 |
| 峠 | N1 | N1 |
| 峡 | N1 | N1 |
| 峨 | N1 | N1 |
| 峯 | N1 | N1 |
| 峰 | N1 | N1 |
| 島 | N2 | N2 |
| 峻 | N1 | N1 |
| 崇 | N1 | N1 |
| 崎 | N1 | N1 |
| 崔 | N1 | N1 |
| 崩 | N1 | N1 |
| 嵐 | N1 | N1 |
| 嵯 | N1 | N1 |
| 嶋 | N1 | N1 |
| 嶌 | N1 | N1 |
| 嶺 | N1 | N1 |
| 嶽 | N1 | N1 |
| 巌 | N1 | N1 |
| 州 | N2 | N2 |
| 巡 | N1 | N1 |
| 巣 | N1 | N1 |
| 工 | N4 | N4 |
| 巧 | N1 | N1 |
| 巨 | N2 | N2 |
| 差 | N3 | N3 |
| 己 | N1 | N1 |
| 已 | N1 | N1 |
| 巳 | N1 | N1 |
| 巴 | N1 | N1 |
| 巷 | N1 | N1 |
| 巻 | N2 | N2 |
| 巽 | N1 | N1 |
| 布 | N2 | N2 |
| 帆 | N1 | N1 |
| 希 | N2 | N2 |
| 帖 | N1 | N1 |
| 帝 | N1 | N1 |
| 帥 | N1 | N1 |
| 師 | N3 | N3 |
| 帳 | N1 | N1 |
| 常 | N3 | N3 |
| 帽 | N2 | N2 |
| 幅 | N2 | N2 |
| 幌 | N1 | N1 |
| 幕 | N1 | N1 |
| 幡 | N1 | N1 |
| 幣 | N1 | N1 |
| 干 | N2 | N2 |
| 幸 | N3 | N3 |
| 幹 | N1 | N1 |
| 幻 | N1 | N1 |
| 幼 | N2 | N2 |
| 幽 | N1 | N1 |
| 庁 | N2 | N2 |
| 庄 | N1 | N1 |
| 床 | N2 | N2 |
| 序 | N1 | N1 |
| 底 | N2 | N2 |
| 店 | N5 | N5 |
| 座 | N3 | N3 |
| 庫 | N2 | N2 |
| 庭 | N3 | N3 |
| 庵 | N1 | N1 |
| 庶 | N1 | N1 |
| 庸 | N1 | N1 |
| 廃 | N1 | N1 |
| 廉 | N1 | N1 |
| 廊 | N1 | N1 |
| 廟 | N1 | N1 |
| 廣 | N1 | N1 |
| 廷 | N1 | N1 |
| 弁 | N1 | N1 |
| 弊 | N1 | N1 |
| 弓 | N1 | N1 |
| 弔 | N1 | N1 |
| 弘 | N1 | N1 |
| 弛 | N1 | N1 |
| 弥 | N1 | N1 |
| 弦 | N1 | N1 |
| 弧 | N1 | N1 |
| 弱 | N2 | N2 |
| 強 | N4 | N4 |
| 弾 | N1 | N1 |
| 彗 | N1 | N1 |
| 形 | N3 | N3 |
| 彦 | N1 | N1 |
| 彩 | N1 | N1 |
| 彪 | N1 | N1 |
| 彫 | N1 | N1 |
| 彬 | N1 | N1 |
| 彭 | N1 | N1 |
| 彰 | N1 | N1 |
| 影 | N1 | N1 |
| 役 | N3 | N3 |
| 征 | N1 | N1 |
| 径 | N1 | N1 |
| 徐 | N1 | N1 |
| 徒 | N3 | N3 |
| 得 | N3 | N3 |
| 徘 | N1 | N1 |
| 循 | N1 | N1 |
| 微 | N1 | N1 |
| 徳 | N1 | N1 |
| 徴 | N1 | N1 |
| 徹 | N1 | N1 |
| 必 | N3 | N3 |
| 忌 | N1 | N1 |
| 忍 | N1 | N1 |
| 志 | N1 | N1 |
| 忘 | N3 | N3 |
| 忙 | N3 | N3 |
| 忠 | N1 | N1 |
| 快 | N2 | N2 |
| 怖 | N3 | N3 |
| 怜 | N1 | N1 |
| 怨 | N1 | N1 |
| 恋 | N2 | N2 |
| 恐 | N3 | N3 |
| 恒 | N1 | N1 |
| 恣 | N1 | N1 |
| 恥 | N3 | N3 |
| 恭 | N1 | N1 |
| 息 | N3 | N3 |
| 悌 | N1 | N1 |
| 悔 | N1 | N1 |
| 悟 | N1 | N1 |
| 悠 | N1 | N1 |
| 患 | N2 | N2 |
| 悦 | N1 | N1 |
| 悩 | N2 | N2 |
| 悼 | N1 | N1 |
| 惇 | N1 | N1 |
| 惑 | N1 | N1 |
| 惚 | N1 | N1 |
| 惟 | N1 | N1 |
| 惣 | N1 | N1 |
| 惧 | N1 | N1 |
| 惨 | N1 | N1 |
| 惰 | N1 | N1 |
| 愁 | N1 | N1 |
| 愉 | N1 | N1 |
| 愚 | N1 | N1 |
| 慈 | N1 | N1 |
| 態 | N1 | N1 |
| 慎 | N1 | N1 |
| 慕 | N1 | N1 |
| 慢 | N1 | N1 |
| 慣 | N3 | N3 |
| 慧 | N1 | N1 |
| 慨 | N1 | N1 |
| 慮 | N1 | N1 |
| 慰 | N1 | N1 |
| 慶 | N1 | N1 |
| 憂 | N1 | N1 |
| 憤 | N1 | N1 |
| 憩 | N1 | N1 |
| 憲 | N1 | N1 |
| 憶 | N1 | N1 |
| 憾 | N1 | N1 |
| 懇 | N1 | N1 |
| 懐 | N1 | N1 |
| 懲 | N1 | N1 |
| 懸 | N1 | N1 |
| 我 | N1 | N1 |
| 戒 | N1 | N1 |
| 房 | N1 | N1 |
| 扉 | N1 | N1 |
| 才 | N3 | N3 |
| 払 | N3 | N3 |
| 扶 | N1 | N1 |
| 批 | N1 | N1 |
| 抄 | N1 | N1 |
| 把 | N1 | N1 |
| 抑 | N1 | N1 |
| 抒 | N1 | N1 |
| 抗 | N1 | N1 |
| 抜 | N3 | N3 |
| 択 | N1 | N1 |
| 披 | N1 | N1 |
| 抱 | N3 | N3 |
| 抵 | N1 | N1 |
| 抹 | N1 | N1 |
| 抽 | N1 | N1 |
| 担 | N2 | N2 |
| 拍 | N1 | N1 |
| 拐 | N1 | N1 |
| 拒 | N1 | N1 |
| 拓 | N1 | N1 |
| 拘 | N1 | N1 |
| 拙 | N1 | N1 |
| 拠 | N1 | N1 |
| 拡 | N1 | N1 |
| 拭 | N1 | N1 |
| 拳 | N1 | N1 |
| 拷 | N1 | N1 |
| 挟 | N2 | N2 |
| 挨 | N1 | N1 |
| 挫 | N1 | N1 |
| 振 | N1 | N1 |
| 挺 | N1 | N1 |
| 挿 | N1 | N1 |
| 捉 | N1 | N1 |
| 捕 | N3 | N3 |
| 捜 | N2 | N2 |
| 捧 | N1 | N1 |
| 捨 | N2 | N2 |
| 据 | N1 | N1 |
| 掃 | N2 | N2 |
| 授 | N1 | N1 |
| 掌 | N1 | N1 |
| 排 | N1 | N1 |
| 掘 | N2 | N2 |
| 採 | N2 | N2 |
| 探 | N3 | N3 |
| 控 | N1 | N1 |
| 推 | N1 | N1 |
| 措 | N1 | N1 |
| 掲 | N1 | N1 |
| 揃 | N1 | N1 |
| 描 | N1 | N1 |
| 提 | N1 | N1 |
| 換 | N2 | N2 |
| 握 | N1 | N1 |
| 揮 | N1 | N1 |
| 揺 | N1 | N1 |
| 損 | N2 | N2 |
| 搜 | N1 | N1 |
| 搬 | N1 | N1 |
| 搭 | N1 | N1 |
| 携 | N1 | N1 |
| 搾 | N1 | N1 |
| 摂 | N1 | N1 |
| 摘 | N1 | N1 |
| 摩 | N1 | N1 |
| 摯 | N1 | N1 |
| 撃 | N1 | N1 |
| 撚 | N1 | N1 |
| 撤 | N1 | N1 |
| 撫 | N1 | N1 |
| 播 | N1 | N1 |
| 撲 | N1 | N1 |
| 擁 | N1 | N1 |
| 擦 | N1 | N1 |
| 擬 | N1 | N1 |
| 支 | N3 | N3 |
| 攻 | N1 | N1 |
| 故 | N1 | N1 |
| 敏 | N1 | N1 |
| 救 | N1 | N1 |
| 散 | N3 | N3 |
| 敦 | N1 | N1 |
| 整 | N1 | N1 |
| 敵 | N1 | N1 |
| 敷 | N1 | N1 |
| 斎 | N1 | N1 |
| 斐 | N1 | N1 |
| 斑 | N1 | N1 |
| 斗 | N1 | N1 |
| 斜 | N1 | N1 |
| 斥 | N1 | N1 |
| 斬 | N1 | N1 |
| 断 | N3 | N3 |
| 於 | N1 | N1 |
| 施 | N1 | N1 |
| 旋 | N1 | N1 |
| 旗 | N1 | N1 |
| 旛 | N1 | N1 |
| 既 | N1 | N1 |
| 旧 | N2 | N2 |
| 旨 | N1 | N1 |
| 旬 | N1 | N1 |
| 旭 | N1 | N1 |
| 旺 | N1 | N1 |
| 昆 | N1 | N1 |
| 昇 | N2 | N2 |
| 昌 | N1 | N1 |
| 星 | N2 | N2 |
| 春 | N4 | N4 |
| 昭 | N1 | N1 |
| 是 | N1 | N1 |
| 晃 | N1 | N1 |
| 晋 | N1 | N1 |
| 普 | N2 | N2 |
| 晴 | N3 | N3 |
| 晶 | N1 | N1 |
| 智 | N1 | N1 |
| 暁 | N1 | N1 |
| 暉 | N1 | N1 |
| 暑 | N1 | N1 |
| 暢 | N1 | N1 |
| 暦 | N1 | N1 |
| 暫 | N1 | N1 |
| 暮 | N3 | N3 |
| 曇 | N2 | N2 |
| 曙 | N1 | N1 |
| 曜 | N4 | N4 |
| 曲 | N3 | N3 |
| 曹 | N1 | N1 |
| 曼 | N1 | N1 |
| 曽 | N1 | N1 |
| 最 | N3 | N3 |
| 月 | N5 | N5 |
| 朋 | N1 | N1 |
| 服 | N4 | N4 |
| 朔 | N1 | N1 |
| 朗 | N1 | N1 |
| 望 | N3 | N3 |
| 期 | N3 | N3 |
| 末 | N3 | N3 |
| 札 | N2 | N2 |
| 朱 | N1 | N1 |
| 朴 | N1 | N1 |
| 机 | N2 | N2 |
| 朽 | N1 | N1 |
| 杉 | N1 | N1 |
| 李 | N1 | N1 |
| 杏 | N1 | N1 |
| 杖 | N1 | N1 |
| 杜 | N1 | N1 |
| 杞 | N1 | N1 |
| 条 | N1 | N1 |
| 杭 | N1 | N1 |
| 杯 | N3 | N3 |
| 杵 | N1 | N1 |
| 松 | N1 | N1 |
| 板 | N2 | N2 |
| 析 | N1 | N1 |
| 枕 | N1 | N1 |
| 林 | N2 | N2 |
| 枚 | N2 | N2 |
| 果 | N3 | N3 |
| 枝 | N2 | N2 |
| 枠 | N1 | N1 |
| 枢 | N1 | N1 |
| 枯 | N2 | N2 |
| 架 | N1 | N1 |
| 柏 | N1 | N1 |
| 某 | N1 | N1 |
| 柔 | N2 | N2 |
| 柚 | N1 | N1 |
| 柱 | N2 | N2 |
| 柳 | N1 | N1 |
| 柴 | N1 | N1 |
| 査 | N2 | N2 |
| 柿 | N1 | N1 |
| 栃 | N1 | N1 |
| 栓 | N1 | N1 |
| 栗 | N1 | N1 |
| 株 | N1 | N1 |
| 核 | N1 | N1 |
| 根 | N2 | N2 |
| 格 | N3 | N3 |
| 栽 | N1 | N1 |
| 桂 | N1 | N1 |
| 桃 | N1 | N1 |
| 桐 | N1 | N1 |
| 桑 | N1 | N1 |
| 桜 | N1 | N1 |
| 桝 | N1 | N1 |
| 桟 | N1 | N1 |
| 桧 | N1 | N1 |
| 桶 | N1 | N1 |
| 梁 | N1 | N1 |
| 梅 | N1 | N1 |
| 梓 | N1 | N1 |
| 梨 | N1 | N1 |
| 梯 | N1 | N1 |
| 梶 | N1 | N1 |
| 棄 | N1 | N1 |
| 棋 | N1 | N1 |
| 棒 | N2 | N2 |
| 棚 | N1 | N1 |
| 棟 | N1 | N1 |
| 森 | N2 | N2 |
| 棺 | N1 | N1 |
| 椅 | N1 | N1 |
| 椎 | N1 | N1 |
| 椙 | N1 | N1 |
| 検 | N1 | N1 |
| 椿 | N1 | N1 |
| 楊 | N1 | N1 |
| 楕 | N1 | N1 |
| 楠 | N1 | N1 |
| 楢 | N1 | N1 |
| 極 | N2 | N2 |
| 楼 | N1 | N1 |
| 榊 | N1 | N1 |
| 榎 | N1 | N1 |
| 榛 | N1 | N1 |
| 構 | N3 | N3 |
| 槌 | N1 | N1 |
| 槍 | N1 | N1 |
| 槙 | N1 | N1 |
| 槻 | N1 | N1 |
| 槽 | N1 | N1 |
| 樋 | N1 | N1 |
| 樟 | N1 | N1 |
| 模 | N1 | N1 |
| 権 | N3 | N3 |
| 横 | N3 | N3 |
| 樫 | N1 | N1 |
| 樹 | N1 | N1 |
| 樺 | N1 | N1 |
| 樽 | N1 | N1 |
| 橋 | N2 | N2 |
| 橘 | N1 | N1 |
| 橿 | N1 | N1 |
| 檀 | N1 | N1 |
| 檄 | N1 | N1 |
| 檜 | N1 | N1 |
| 櫛 | N1 | N1 |
| 欄 | N1 | N1 |
| 欠 | N3 | N3 |
| 次 | N3 | N3 |
| 欣 | N1 | N1 |
| 欲 | N3 | N3 |
| 欽 | N1 | N1 |
| 款 | N1 | N1 |
| 歓 | N1 | N1 |
| 正 | N4 | N4 |
| 武 | N2 | N2 |
| 歯 | N3 | N3 |
| 殉 | N1 | N1 |
| 殊 | N1 | N1 |
| 殖 | N1 | N1 |
| 殴 | N1 | N1 |
| 殻 | N1 | N1 |
| 殿 | N2 | N2 |
| 毅 | N1 | N1 |
| 毒 | N2 | N2 |
| 比 | N2 | N2 |
| 毛 | N2 | N2 |
| 毬 | N1 | N1 |
| 氏 | N1 | N1 |
| 水 | N5 | N5 |
| 氷 | N2 | N2 |
| 永 | N2 | N2 |
| 汁 | N1 | N1 |
| 求 | N3 | N3 |
| 汎 | N1 | N1 |
| 汐 | N1 | N1 |
| 汗 | N2 | N2 |
| 江 | N1 | N1 |
| 池 | N2 | N2 |
| 汪 | N1 | N1 |
| 汽 | N1 | N1 |
| 沈 | N2 | N2 |
| 沖 | N1 | N1 |
| 沙 | N1 | N1 |
| 没 | N1 | N1 |
| 沢 | N1 | N1 |
| 沼 | N1 | N1 |
| 沿 | N1 | N1 |
| 況 | N2 | N2 |
| 泌 | N1 | N1 |
| 泡 | N1 | N1 |
| 泥 | N2 | N2 |
| 泰 | N1 | N1 |
| 泳 | N3 | N3 |
| 洋 | N4 | N4 |
| 洒 | N1 | N1 |
| 洛 | N1 | N1 |
| 洞 | N1 | N1 |
| 洲 | N1 | N1 |
| 洸 | N1 | N1 |
| 派 | N2 | N2 |
| 浄 | N1 | N1 |
| 浙 | N1 | N1 |
| 浜 | N1 | N1 |
| 浦 | N1 | N1 |
| 浩 | N1 | N1 |
| 浪 | N1 | N1 |
| 浴 | N2 | N2 |
| 海 | N5 | N5 owner override |
| 浸 | N1 | N1 |
| 涙 | N2 | N2 |
| 涯 | N1 | N1 |
| 涼 | N2 | N2 |
| 淀 | N1 | N1 |
| 淑 | N1 | N1 |
| 淘 | N1 | N1 |
| 淡 | N1 | N1 |
| 深 | N3 | N3 |
| 淳 | N1 | N1 |
| 淵 | N1 | N1 |
| 添 | N1 | N1 |
| 清 | N2 | N2 |
| 渇 | N1 | N1 |
| 渉 | N1 | N1 |
| 渋 | N1 | N1 |
| 渓 | N1 | N1 |
| 渕 | N1 | N1 |
| 渚 | N1 | N1 |
| 渥 | N1 | N1 |
| 渦 | N1 | N1 |
| 湊 | N1 | N1 |
| 湖 | N2 | N2 |
| 湘 | N1 | N1 |
| 湛 | N1 | N1 |
| 湧 | N1 | N1 |
| 湯 | N2 | N2 |
| 湾 | N2 | N2 |
| 湿 | N2 | N2 |
| 満 | N3 | N3 |
| 準 | N2 | N2 |
| 溜 | N1 | N1 |
| 溝 | N1 | N1 |
| 溥 | N1 | N1 |
| 溶 | N2 | N2 |
| 滅 | N1 | N1 |
| 滋 | N1 | N1 |
| 滑 | N1 | N1 |
| 滝 | N1 | N1 |
| 滞 | N1 | N1 |
| 滴 | N2 | N2 |
| 漁 | N2 | N2 |
| 漂 | N1 | N1 |
| 漆 | N1 | N1 |
| 漏 | N1 | N1 |
| 漕 | N1 | N1 |
| 漠 | N1 | N1 |
| 漫 | N1 | N1 |
| 漬 | N1 | N1 |
| 漱 | N1 | N1 |
| 漸 | N1 | N1 |
| 潔 | N1 | N1 |
| 潜 | N1 | N1 |
| 潟 | N1 | N1 |
| 潤 | N1 | N1 |
| 潮 | N1 | N1 |
| 澄 | N1 | N1 |
| 澤 | N1 | N1 |
| 激 | N1 | N1 |
| 濁 | N1 | N1 |
| 濃 | N2 | N2 |
| 濡 | N1 | N1 |
| 濯 | N2 | N2 |
| 瀋 | N1 | N1 |
| 瀕 | N1 | N1 |
| 瀬 | N1 | N1 |
| 灘 | N1 | N1 |
| 火 | N5 | N5 |
| 灯 | N2 | N2 |
| 炉 | N1 | N1 |
| 炊 | N1 | N1 |
| 炎 | N1 | N1 |
| 炭 | N2 | N2 |
| 点 | N3 | N3 |
| 為 | N1 | N1 |
| 烈 | N1 | N1 |
| 烏 | N1 | N1 |
| 焉 | N1 | N1 |
| 煕 | N1 | N1 |
| 煥 | N1 | N1 |
| 照 | N2 | N2 |
| 煩 | N1 | N1 |
| 煮 | N1 | N1 |
| 熊 | N1 | N1 |
| 熟 | N1 | N1 |
| 燃 | N2 | N2 |
| 燈 | N1 | N1 |
| 燕 | N1 | N1 |
| 燥 | N2 | N2 |
| 爆 | N2 | N2 |
| 爪 | N1 | N1 |
| 爽 | N1 | N1 |
| 片 | N2 | N2 |
| 版 | N2 | N2 |
| 牌 | N1 | N1 |
| 牙 | N1 | N1 |
| 牛 | N4 | N4 |
| 牝 | N1 | N1 |
| 牟 | N1 | N1 |
| 牡 | N1 | N1 |
| 牢 | N1 | N1 |
| 牧 | N1 | N1 |
| 牲 | N1 | N1 |
| 犀 | N1 | N1 |
| 犠 | N1 | N1 |
| 犬 | N4 | N4 |
| 状 | N3 | N3 |
| 狂 | N1 | N1 |
| 狐 | N1 | N1 |
| 狙 | N1 | N1 |
| 狛 | N1 | N1 |
| 狩 | N1 | N1 |
| 独 | N1 | N1 |
| 狭 | N1 | N1 |
| 狸 | N1 | N1 |
| 狼 | N1 | N1 |
| 猛 | N1 | N1 |
| 猟 | N1 | N1 |
| 猪 | N1 | N1 |
| 猫 | N3 | N3 |
| 献 | N1 | N1 |
| 猶 | N1 | N1 |
| 猷 | N1 | N1 |
| 猿 | N1 | N1 |
| 獄 | N1 | N1 |
| 獅 | N1 | N1 |
| 獣 | N1 | N1 |
| 獲 | N1 | N1 |
| 玄 | N1 | N1 |
| 率 | N1 | N1 |
| 玉 | N2 | N2 |
| 玩 | N1 | N1 |
| 玲 | N1 | N1 |
| 珂 | N1 | N1 |
| 珍 | N2 | N2 |
| 珠 | N1 | N1 |
| 班 | N1 | N1 |
| 球 | N3 | N3 |
| 琉 | N1 | N1 |
| 琢 | N1 | N1 |
| 琴 | N1 | N1 |
| 琵 | N1 | N1 |
| 琶 | N1 | N1 |
| 瑛 | N1 | N1 |
| 瑞 | N1 | N1 |
| 瑠 | N1 | N1 |
| 瓜 | N1 | N1 |
| 瓦 | N1 | N1 |
| 瓶 | N2 | N2 |
| 甕 | N1 | N1 |
| 甚 | N1 | N1 |
| 産 | N3 | N3 |
| 甦 | N1 | N1 |
| 甫 | N1 | N1 |
| 田 | N4 | N4 |
| 由 | N3 | N3 |
| 甲 | N1 | N1 |
| 界 | N4 | N4 |
| 畏 | N1 | N1 |
| 畑 | N1 | N1 |
| 畔 | N1 | N1 |
| 畜 | N2 | N2 |
| 畝 | N1 | N1 |
| 畠 | N1 | N1 |
| 略 | N2 | N2 |
| 番 | N3 | N3 |
| 畳 | N2 | N2 |
| 畿 | N1 | N1 |
| 疎 | N1 | N1 |
| 疫 | N1 | N1 |
| 疲 | N3 | N3 |
| 疾 | N1 | N1 |
| 症 | N1 | N1 |
| 痕 | N1 | N1 |
| 痢 | N1 | N1 |
| 痴 | N1 | N1 |
| 瘤 | N1 | N1 |
| 癌 | N1 | N1 |
| 癒 | N1 | N1 |
| 癖 | N1 | N1 |
| 登 | N3 | N3 |
| 的 | N3 | N3 |
| 皆 | N3 | N3 |
| 皇 | N1 | N1 |
| 皐 | N1 | N1 |
| 皓 | N1 | N1 |
| 皮 | N2 | N2 |
| 皿 | N2 | N2 |
| 盆 | N1 | N1 |
| 盗 | N3 | N3 |
| 盛 | N1 | N1 |
| 監 | N1 | N1 |
| 盤 | N1 | N1 |
| 盧 | N1 | N1 |
| 盲 | N1 | N1 |
| 直 | N3 | N3 |
| 盾 | N1 | N1 |
| 省 | N2 | N2 |
| 眉 | N1 | N1 |
| 看 | N1 | N1 |
| 眞 | N1 | N1 |
| 眺 | N1 | N1 |
| 眼 | N1 | N1 |
| 督 | N1 | N1 |
| 睦 | N1 | N1 |
| 瞑 | N1 | N1 |
| 瞬 | N1 | N1 |
| 瞳 | N1 | N1 |
| 矛 | N1 | N1 |
| 知 | N4 | N4 |
| 矩 | N1 | N1 |
| 矯 | N1 | N1 |
| 砂 | N2 | N2 |
| 研 | N4 | N4 |
| 砕 | N1 | N1 |
| 砦 | N1 | N1 |
| 砲 | N1 | N1 |
| 硝 | N1 | N1 |
| 硫 | N1 | N1 |
| 硬 | N2 | N2 |
| 硯 | N1 | N1 |
| 碁 | N1 | N1 |
| 碓 | N1 | N1 |
| 碧 | N1 | N1 |
| 磁 | N1 | N1 |
| 磐 | N1 | N1 |
| 磨 | N2 | N2 |
| 磯 | N1 | N1 |
| 礁 | N1 | N1 |
| 礎 | N1 | N1 |
| 礒 | N1 | N1 |
| 祇 | N1 | N1 |
| 祉 | N1 | N1 |
| 祐 | N1 | N1 |
| 祝 | N2 | N2 |
| 祥 | N1 | N1 |
| 票 | N1 | N1 |
| 禄 | N1 | N1 |
| 禅 | N1 | N1 |
| 禍 | N1 | N1 |
| 禎 | N1 | N1 |
| 福 | N3 | N3 |
| 秀 | N1 | N1 |
| 秋 | N4 | N4 |
| 秒 | N2 | N2 |
| 秘 | N1 | N1 |
| 租 | N1 | N1 |
| 秦 | N1 | N1 |
| 秩 | N1 | N1 |
| 称 | N1 | N1 |
| 稀 | N1 | N1 |
| 程 | N3 | N3 |
| 稔 | N1 | N1 |
| 稚 | N1 | N1 |
| 稜 | N1 | N1 |
| 種 | N3 | N3 |
| 稼 | N1 | N1 |
| 稽 | N1 | N1 |
| 稿 | N1 | N1 |
| 穀 | N1 | N1 |
| 穂 | N1 | N1 |
| 積 | N3 | N3 |
| 穏 | N1 | N1 |
| 穣 | N1 | N1 |
| 穫 | N1 | N1 |
| 穴 | N1 | N1 |
| 究 | N4 | N4 |
| 窃 | N1 | N1 |
| 窒 | N1 | N1 |
| 窓 | N3 | N3 |
| 窪 | N1 | N1 |
| 窮 | N1 | N1 |
| 窯 | N1 | N1 |
| 竜 | N1 | N1 |
| 章 | N2 | N2 |
| 童 | N2 | N2 |
| 竪 | N1 | N1 |
| 端 | N1 | N1 |
| 競 | N2 | N2 |
| 竹 | N2 | N2 |
| 竿 | N1 | N1 |
| 笏 | N1 | N1 |
| 笘 | N1 | N1 |
| 笛 | N1 | N1 |
| 笠 | N1 | N1 |
| 符 | N2 | N2 |
| 第 | N2 | N2 |
| 笹 | N1 | N1 |
| 筆 | N2 | N2 |
| 筑 | N1 | N1 |
| 筒 | N2 | N2 |
| 策 | N2 | N2 |
| 箏 | N1 | N1 |
| 箕 | N1 | N1 |
| 管 | N2 | N2 |
| 箱 | N3 | N3 |
| 箸 | N1 | N1 |
| 範 | N1 | N1 |
| 篆 | N1 | N1 |
| 篇 | N1 | N1 |
| 篠 | N1 | N1 |
| 篤 | N1 | N1 |
| 篭 | N1 | N1 |
| 簑 | N1 | N1 |
| 簗 | N1 | N1 |
| 簿 | N1 | N1 |
| 籍 | N2 | N2 |
| 粉 | N2 | N2 |
| 粒 | N2 | N2 |
| 粕 | N1 | N1 |
| 粘 | N1 | N1 |
| 粛 | N1 | N1 |
| 粟 | N1 | N1 |
| 粥 | N1 | N1 |
| 精 | N3 | N3 |
| 糖 | N1 | N1 |
| 糞 | N1 | N1 |
| 糧 | N1 | N1 |
| 糸 | N2 | N2 |
| 系 | N1 | N1 |
| 糾 | N1 | N1 |
| 紀 | N1 | N1 |
| 紅 | N2 | N2 |
| 紋 | N1 | N1 |
| 純 | N2 | N2 |
| 紘 | N1 | N1 |
| 級 | N1 | N1 |
| 紛 | N1 | N1 |
| 素 | N1 | N1 |
| 紡 | N1 | N1 |
| 索 | N1 | N1 |
| 紫 | N1 | N1 |
| 累 | N1 | N1 |
| 細 | N2 | N2 |
| 紳 | N1 | N1 |
| 紺 | N1 | N1 |
| 組 | N3 | N3 |
| 絆 | N1 | N1 |
| 絞 | N1 | N1 |
| 絢 | N1 | N1 |
| 絶 | N3 | N3 |
| 絹 | N1 | N1 |
| 綜 | N1 | N1 |
| 維 | N1 | N1 |
| 綱 | N1 | N1 |
| 綴 | N1 | N1 |
| 綺 | N1 | N1 |
| 綾 | N1 | N1 |
| 綿 | N2 | N2 |
| 緋 | N1 | N1 |
| 総 | N2 | N2 |
| 緑 | N2 | N2 |
| 緒 | N3 | N3 |
| 締 | N1 | N1 |
| 緩 | N1 | N1 |
| 緻 | N1 | N1 |
| 縁 | N1 | N1 |
| 縄 | N1 | N1 |
| 縛 | N1 | N1 |
| 縞 | N1 | N1 |
| 縦 | N1 | N1 |
| 縫 | N1 | N1 |
| 繁 | N1 | N1 |
| 繊 | N1 | N1 |
| 織 | N1 | N1 |
| 繕 | N1 | N1 |
| 繭 | N1 | N1 |
| 繰 | N1 | N1 |
| 缶 | N2 | N2 |
| 置 | N3 | N3 |
| 罰 | N1 | N1 |
| 署 | N2 | N2 |
| 罵 | N1 | N1 |
| 罷 | N1 | N1 |
| 羅 | N1 | N1 |
| 羊 | N1 | N1 |
| 美 | N3 | N3 |
| 群 | N2 | N2 |
| 羽 | N2 | N2 |
| 翁 | N1 | N1 |
| 翌 | N2 | N2 |
| 翔 | N1 | N1 |
| 翠 | N1 | N1 |
| 翫 | N1 | N1 |
| 翼 | N1 | N1 |
| 耀 | N1 | N1 |
| 老 | N3 | N3 |
| 耐 | N1 | N1 |
| 耕 | N2 | N2 |
| 聖 | N1 | N1 |
| 聡 | N1 | N1 |
| 聯 | N1 | N1 |
| 聴 | N1 | N1 |
| 肇 | N1 | N1 |
| 肉 | N4 | N4 |
| 肌 | N2 | N2 |
| 肖 | N1 | N1 |
| 肝 | N1 | N1 |
| 股 | N1 | N1 |
| 肢 | N1 | N1 |
| 肥 | N1 | N1 |
| 肩 | N2 | N2 |
| 肪 | N1 | N1 |
| 肯 | N2 | N2 |
| 肺 | N1 | N1 |
| 胃 | N2 | N2 |
| 胆 | N1 | N1 |
| 背 | N3 | N3 |
| 胎 | N1 | N1 |
| 胚 | N1 | N1 |
| 胞 | N1 | N1 |
| 胡 | N1 | N1 |
| 胴 | N1 | N1 |
| 胸 | N2 | N2 |
| 能 | N3 | N3 |
| 脅 | N1 | N1 |
| 脇 | N1 | N1 |
| 脈 | N1 | N1 |
| 脊 | N1 | N1 |
| 脚 | N1 | N1 |
| 脩 | N1 | N1 |
| 脱 | N1 | N1 |
| 脳 | N2 | N2 |
| 腎 | N1 | N1 |
| 腐 | N1 | N1 |
| 腕 | N2 | N2 |
| 腫 | N1 | N1 |
| 腰 | N2 | N2 |
| 腸 | N1 | N1 |
| 腹 | N3 | N3 |
| 膚 | N2 | N2 |
| 膜 | N1 | N1 |
| 膝 | N1 | N1 |
| 膠 | N1 | N1 |
| 膨 | N1 | N1 |
| 膳 | N1 | N1 |
| 臓 | N2 | N2 |
| 臣 | N2 | N2 |
| 臨 | N1 | N1 |
| 臭 | N1 | N1 |
| 致 | N1 | N1 |
| 臼 | N1 | N1 |
| 興 | N1 | N1 |
| 舌 | N1 | N1 |
| 舎 | N1 | N1 |
| 舗 | N1 | N1 |
| 舘 | N1 | N1 |
| 舛 | N1 | N1 |
| 舜 | N1 | N1 |
| 舞 | N3 | N3 |
| 舟 | N2 | N2 |
| 舩 | N1 | N1 |
| 航 | N2 | N2 |
| 般 | N2 | N2 |
| 舵 | N1 | N1 |
| 舶 | N1 | N1 |
| 船 | N3 | N3 |
| 艇 | N1 | N1 |
| 艦 | N1 | N1 |
| 艶 | N1 | N1 |
| 芋 | N1 | N1 |
| 芙 | N1 | N1 |
| 芝 | N1 | N1 |
| 芥 | N1 | N1 |
| 芦 | N1 | N1 |
| 芭 | N1 | N1 |
| 芯 | N1 | N1 |
| 芳 | N1 | N1 |
| 芹 | N1 | N1 |
| 芽 | N1 | N1 |
| 苅 | N1 | N1 |
| 苑 | N1 | N1 |
| 苗 | N1 | N1 |
| 苦 | N3 | N3 |
| 苫 | N1 | N1 |
| 茂 | N1 | N1 |
| 茅 | N1 | N1 |
| 茎 | N1 | N1 |
| 茗 | N1 | N1 |
| 茜 | N1 | N1 |
| 茨 | N1 | N1 |
| 茶 | N4 | N4 |
| 草 | N3 | N3 |
| 荏 | N1 | N1 |
| 荘 | N1 | N1 |
| 荻 | N1 | N1 |
| 菅 | N1 | N1 |
| 菊 | N1 | N1 |
| 菌 | N1 | N1 |
| 菓 | N2 | N2 |
| 菜 | N2 | N2 |
| 菩 | N1 | N1 |
| 華 | N1 | N1 |
| 菱 | N1 | N1 |
| 萌 | N1 | N1 |
| 萩 | N1 | N1 |
| 萬 | N1 | N1 |
| 萱 | N1 | N1 |
| 葉 | N3 | N3 |
| 葛 | N1 | N1 |
| 葦 | N1 | N1 |
| 葬 | N1 | N1 |
| 葵 | N1 | N1 |
| 蒋 | N1 | N1 |
| 蒔 | N1 | N1 |
| 蒙 | N1 | N1 |
| 蒲 | N1 | N1 |
| 蒸 | N2 | N2 |
| 蒼 | N1 | N1 |
| 蓄 | N1 | N1 |
| 蓋 | N1 | N1 |
| 蓮 | N1 | N1 |
| 蓼 | N1 | N1 |
| 蔑 | N1 | N1 |
| 蔡 | N1 | N1 |
| 蔦 | N1 | N1 |
| 蔭 | N1 | N1 |
| 蔵 | N2 | N2 |
| 蕃 | N1 | N1 |
| 蕉 | N1 | N1 |
| 蕨 | N1 | N1 |
| 薔 | N1 | N1 |
| 薦 | N1 | N1 |
| 薩 | N1 | N1 |
| 薪 | N1 | N1 |
| 薫 | N1 | N1 |
| 薮 | N1 | N1 |
| 藁 | N1 | N1 |
| 藍 | N1 | N1 |
| 藏 | N1 | N1 |
| 藝 | N1 | N1 |
| 藤 | N1 | N1 |
| 藩 | N1 | N1 |
| 藻 | N1 | N1 |
| 蘇 | N1 | N1 |
| 蘭 | N1 | N1 |
| 虎 | N1 | N1 |
| 虐 | N1 | N1 |
| 虚 | N1 | N1 |
| 虜 | N1 | N1 |
| 虫 | N2 | N2 |
| 虹 | N1 | N1 |
| 蚊 | N1 | N1 |
| 蚕 | N1 | N1 |
| 蛇 | N1 | N1 |
| 蛋 | N1 | N1 |
| 蛍 | N1 | N1 |
| 蛭 | N1 | N1 |
| 蛮 | N1 | N1 |
| 蜂 | N1 | N1 |
| 蜜 | N1 | N1 |
| 蜷 | N1 | N1 |
| 蝶 | N1 | N1 |
| 融 | N1 | N1 |
| 蟹 | N1 | N1 |
| 血 | N2 | N2 |
| 衆 | N1 | N1 |
| 街 | N1 | N1 |
| 衛 | N1 | N1 |
| 衝 | N1 | N1 |
| 衡 | N1 | N1 |
| 表 | N3 | N3 |
| 衰 | N1 | N1 |
| 衷 | N1 | N1 |
| 袁 | N1 | N1 |
| 袖 | N1 | N1 |
| 被 | N2 | N2 |
| 袴 | N1 | N1 |
| 裂 | N1 | N1 |
| 裕 | N1 | N1 |
| 裸 | N1 | N1 |
| 製 | N1 | N1 |
| 裾 | N1 | N1 |
| 複 | N2 | N2 |
| 褐 | N1 | N1 |
| 褒 | N1 | N1 |
| 襄 | N1 | N1 |
| 襟 | N1 | N1 |
| 襲 | N1 | N1 |
| 西 | N5 | N5 |
| 要 | N3 | N3 |
| 覆 | N1 | N1 |
| 覇 | N1 | N1 |
| 視 | N1 | N1 |
| 覧 | N1 | N1 |
| 角 | N2 | N2 |
| 解 | N3 | N3 |
| 触 | N2 | N2 |
| 訂 | N1 | N1 |
| 訃 | N1 | N1 |
| 訓 | N2 | N2 |
| 訟 | N1 | N1 |
| 訪 | N3 | N3 |
| 許 | N3 | N3 |
| 訴 | N1 | N1 |
| 診 | N1 | N1 |
| 詐 | N1 | N1 |
| 詔 | N1 | N1 |
| 詞 | N2 | N2 |
| 詠 | N1 | N1 |
| 詩 | N1 | N1 |
| 詫 | N1 | N1 |
| 詰 | N2 | N2 |
| 該 | N1 | N1 |
| 詳 | N1 | N1 |
| 誇 | N1 | N1 |
| 誉 | N1 | N1 |
| 誓 | N1 | N1 |
| 誕 | N1 | N1 |
| 誘 | N1 | N1 |
| 誠 | N1 | N1 |
| 誰 | N3 | N3 |
| 談 | N3 | N3 |
| 請 | N1 | N1 |
| 諌 | N1 | N1 |
| 諏 | N1 | N1 |
| 諜 | N1 | N1 |
| 諭 | N1 | N1 |
| 諮 | N1 | N1 |
| 諸 | N2 | N2 |
| 諾 | N1 | N1 |
| 謀 | N1 | N1 |
| 謄 | N1 | N1 |
| 謎 | N1 | N1 |
| 謙 | N1 | N1 |
| 講 | N2 | N2 |
| 謡 | N1 | N1 |
| 謳 | N1 | N1 |
| 謹 | N1 | N1 |
| 識 | N3 | N3 |
| 譜 | N1 | N1 |
| 譲 | N1 | N1 |
| 護 | N1 | N1 |
| 讃 | N1 | N1 |
| 谷 | N2 | N2 |
| 豆 | N1 | N1 |
| 豊 | N2 | N2 |
| 豚 | N1 | N1 |
| 象 | N2 | N2 |
| 豪 | N1 | N1 |
| 貝 | N2 | N2 |
| 貞 | N1 | N1 |
| 貢 | N1 | N1 |
| 貨 | N2 | N2 |
| 販 | N2 | N2 |
| 貫 | N1 | N1 |
| 貯 | N2 | N2 |
| 貰 | N1 | N1 |
| 費 | N3 | N3 |
| 貿 | N2 | N2 |
| 賀 | N1 | N1 |
| 賄 | N1 | N1 |
| 賊 | N1 | N1 |
| 賓 | N1 | N1 |
| 賜 | N1 | N1 |
| 賠 | N1 | N1 |
| 賢 | N2 | N2 |
| 質 | N4 | N4 |
| 賭 | N1 | N1 |
| 購 | N1 | N1 |
| 贅 | N1 | N1 |
| 贈 | N2 | N2 |
| 贋 | N1 | N1 |
| 赦 | N1 | N1 |
| 赳 | N1 | N1 |
| 赴 | N1 | N1 |
| 起 | N4 | N4 |
| 超 | N2 | N2 |
| 趙 | N1 | N1 |
| 趣 | N1 | N1 |
| 距 | N1 | N1 |
| 路 | N3 | N3 |
| 跳 | N1 | N1 |
| 践 | N1 | N1 |
| 踏 | N1 | N1 |
| 蹄 | N1 | N1 |
| 蹴 | N1 | N1 |
| 躍 | N1 | N1 |
| 身 | N3 | N3 |
| 車 | N5 | N5 |
| 軌 | N1 | N1 |
| 軒 | N2 | N2 |
| 軟 | N2 | N2 |
| 軸 | N1 | N1 |
| 較 | N1 | N1 |
| 載 | N1 | N1 |
| 輔 | N1 | N1 |
| 輝 | N1 | N1 |
| 輩 | N1 | N1 |
| 輪 | N2 | N2 |
| 轄 | N1 | N1 |
| 轍 | N1 | N1 |
| 轟 | N1 | N1 |
| 辛 | N2 | N2 |
| 辰 | N1 | N1 |
| 辱 | N1 | N1 |
| 農 | N2 | N2 |
| 辺 | N2 | N2 |
| 辻 | N1 | N1 |
| 迅 | N1 | N1 |
| 迎 | N3 | N3 |
| 近 | N4 | N4 |
| 迦 | N1 | N1 |
| 迭 | N1 | N1 |
| 述 | N2 | N2 |
| 迷 | N3 | N3 |
| 退 | N3 | N3 |
| 逃 | N3 | N3 |
| 逆 | N2 | N2 |
| 透 | N1 | N1 |
| 逐 | N1 | N1 |
| 逓 | N1 | N1 |
| 途 | N3 | N3 |
| 逗 | N1 | N1 |
| 逝 | N1 | N1 |
| 造 | N2 | N2 |
| 逢 | N1 | N1 |
| 逮 | N1 | N1 |
| 週 | N5 | N5 |
| 進 | N3 | N3 |
| 逸 | N1 | N1 |
| 遂 | N1 | N1 |
| 遅 | N3 | N3 |
| 遇 | N1 | N1 |
| 遊 | N3 | N3 |
| 遍 | N1 | N1 |
| 道 | N5 | N5 |
| 達 | N3 | N3 |
| 遣 | N1 | N1 |
| 遥 | N1 | N1 |
| 適 | N3 | N3 |
| 遮 | N1 | N1 |
| 遷 | N1 | N1 |
| 遼 | N1 | N1 |
| 還 | N1 | N1 |
| 邑 | N1 | N1 |
| 那 | N1 | N1 |
| 邦 | N1 | N1 |
| 邪 | N1 | N1 |
| 邸 | N1 | N1 |
| 郁 | N1 | N1 |
| 郊 | N2 | N2 |
| 郎 | N1 | N1 |
| 郡 | N1 | N1 |
| 郭 | N1 | N1 |
| 郵 | N2 | N2 |
| 郷 | N1 | N1 |
| 鄒 | N1 | N1 |
| 鄭 | N1 | N1 |
| 酉 | N1 | N1 |
| 酌 | N1 | N1 |
| 酒 | N3 | N3 |
| 酔 | N1 | N1 |
| 酢 | N1 | N1 |
| 酪 | N1 | N1 |
| 酬 | N1 | N1 |
| 酵 | N1 | N1 |
| 酷 | N1 | N1 |
| 酸 | N1 | N1 |
| 醍 | N1 | N1 |
| 醜 | N1 | N1 |
| 醤 | N1 | N1 |
| 醸 | N1 | N1 |
| 釈 | N1 | N1 |
| 里 | N1 | N1 |
| 野 | N4 | N4 |
| 金 | N5 | N5 |
| 釘 | N1 | N1 |
| 釜 | N1 | N1 |
| 針 | N2 | N2 |
| 釣 | N1 | N1 |
| 釧 | N1 | N1 |
| 鈍 | N2 | N2 |
| 鈴 | N1 | N1 |
| 鉄 | N2 | N2 |
| 鉛 | N1 | N1 |
| 鉢 | N1 | N1 |
| 鉱 | N2 | N2 |
| 鉾 | N1 | N1 |
| 銀 | N3 | N3 owner override |
| 銃 | N1 | N1 |
| 銕 | N1 | N1 |
| 銘 | N1 | N1 |
| 銚 | N1 | N1 |
| 銭 | N1 | N1 |
| 鋭 | N2 | N2 |
| 鋳 | N1 | N1 |
| 鋼 | N1 | N1 |
| 錠 | N1 | N1 |
| 錦 | N1 | N1 |
| 錫 | N1 | N1 |
| 錬 | N1 | N1 |
| 錯 | N1 | N1 |
| 録 | N2 | N2 |
| 鍋 | N1 | N1 |
| 鍛 | N1 | N1 |
| 鍵 | N1 | N1 |
| 鍼 | N1 | N1 |
| 鍾 | N1 | N1 |
| 鎌 | N1 | N1 |
| 鎖 | N1 | N1 |
| 鎮 | N1 | N1 |
| 鏡 | N1 | N1 |
| 鐘 | N1 | N1 |
| 門 | N2 | N2 |
| 閑 | N1 | N1 |
| 関 | N3 | N3 |
| 閣 | N1 | N1 |
| 閥 | N1 | N1 |
| 閲 | N1 | N1 |
| 闇 | N1 | N1 |
| 闊 | N1 | N1 |
| 闘 | N1 | N1 |
| 阜 | N1 | N1 |
| 阪 | N3 | N3 |
| 防 | N2 | N2 |
| 阻 | N1 | N1 |
| 阿 | N1 | N1 |
| 附 | N1 | N1 |
| 限 | N3 | N3 |
| 陛 | N1 | N1 |
| 院 | N4 | N4 |
| 陣 | N1 | N1 |
| 除 | N3 | N3 |
| 陥 | N1 | N1 |
| 陪 | N1 | N1 |
| 陰 | N1 | N1 |
| 陳 | N1 | N1 |
| 陵 | N1 | N1 |
| 陶 | N1 | N1 |
| 陸 | N2 | N2 |
| 険 | N3 | N3 |
| 陽 | N3 | N3 |
| 隅 | N2 | N2 |
| 隆 | N1 | N1 |
| 隈 | N1 | N1 |
| 隊 | N1 | N1 |
| 階 | N2 | N2 |
| 随 | N1 | N1 |
| 隔 | N1 | N1 |
| 障 | N1 | N1 |
| 隠 | N1 | N1 |
| 隣 | N1 | N1 |
| 隷 | N1 | N1 |
| 隻 | N2 | N2 |
| 隼 | N1 | N1 |
| 雀 | N1 | N1 |
| 雁 | N1 | N1 |
| 雄 | N1 | N1 |
| 雅 | N1 | N1 |
| 雇 | N2 | N2 |
| 雌 | N1 | N1 |
| 雛 | N1 | N1 |
| 雫 | N1 | N1 |
| 雰 | N1 | N1 |
| 雲 | N2 | N2 |
| 零 | N2 | N2 |
| 電 | N5 | N5 |
| 需 | N1 | N1 |
| 霊 | N1 | N1 |
| 霜 | N1 | N1 |
| 霞 | N1 | N1 |
| 霧 | N1 | N1 |
| 露 | N1 | N1 |
| 靖 | N1 | N1 |
| 非 | N3 | N3 |
| 革 | N2 | N2 |
| 靴 | N3 | N3 |
| 鞍 | N1 | N1 |
| 韓 | N1 | N1 |
| 韮 | N1 | N1 |
| 韻 | N1 | N1 |
| 響 | N1 | N1 |
| 頃 | N1 | N1 |
| 項 | N1 | N1 |
| 順 | N2 | N2 |
| 須 | N1 | N1 |
| 頑 | N1 | N1 |
| 頒 | N1 | N1 |
| 領 | N2 | N2 |
| 頚 | N1 | N1 |
| 頬 | N1 | N1 |
| 頻 | N1 | N1 |
| 額 | N2 | N2 |
| 顕 | N1 | N1 |
| 類 | N3 | N3 |
| 顧 | N1 | N1 |
| 風 | N4 | N4 |
| 飯 | N4 | N4 |
| 餅 | N1 | N1 |
| 餌 | N1 | N1 |
| 餓 | N1 | N1 |
| 館 | N4 | N4 |
| 饗 | N1 | N1 |
| 香 | N2 | N2 |
| 馨 | N1 | N1 |
| 馬 | N3 | N3 |
| 駅 | N5 | N5 |
| 駆 | N1 | N1 |
| 駐 | N2 | N2 |
| 駒 | N1 | N1 |
| 駿 | N1 | N1 |
| 騎 | N1 | N1 |
| 騒 | N1 | N1 |
| 騰 | N1 | N1 |
| 骨 | N2 | N2 |
| 髄 | N1 | N1 |
| 髪 | N3 | N3 |
| 鬼 | N1 | N1 |
| 魁 | N1 | N1 |
| 魂 | N1 | N1 |
| 魅 | N1 | N1 |
| 魏 | N1 | N1 |
| 魔 | N1 | N1 |
| 魚 | N5 | N5 |
| 魯 | N1 | N1 |
| 鮎 | N1 | N1 |
| 鮫 | N1 | N1 |
| 鮭 | N1 | N1 |
| 鯉 | N1 | N1 |
| 鯛 | N1 | N1 |
| 鯨 | N1 | N1 |
| 鱒 | N1 | N1 |
| 鱗 | N1 | N1 |
| 鳩 | N1 | N1 |
| 鳳 | N1 | N1 |
| 鳴 | N3 | N3 |
| 鴈 | N1 | N1 |
| 鴎 | N1 | N1 |
| 鴨 | N1 | N1 |
| 鴻 | N1 | N1 |
| 鵜 | N1 | N1 |
| 鵠 | N1 | N1 |
| 鵬 | N1 | N1 |
| 鶏 | N1 | N1 |
| 鶴 | N1 | N1 |
| 鷲 | N1 | N1 |
| 鷹 | N1 | N1 |
| 鷺 | N1 | N1 |
| 鹿 | N1 | N1 |
| 麓 | N1 | N1 |
| 麗 | N1 | N1 |
| 麦 | N2 | N2 |
| 麹 | N1 | N1 |
| 麺 | N1 | N1 |
| 黄 | N2 | N2 |
| 黎 | N1 | N1 |
| 黒 | N4 | N4 |
| 黙 | N1 | N1 |
| 黛 | N1 | N1 |
| 鼓 | N1 | N1 |
| 鼻 | N2 | N2 |
| 齢 | N2 | N2 |
| 龍 | N1 | N1 |

## EXTRA

Current app kanji not found in the candidate canonical N1-N5 map. Owner should decide delete vs keep as bonus.

| Kanji | Current placement |
| --- | --- |
| 佚 | N2 L09 (n2/lesson_09.json) |
| 嗚 | N1 L01 (n1/lesson_01.json) |
| 垢 | N1 L02 (n1/lesson_02.json) |
| 宛 | N1 L09 (n1/lesson_09.json)<br>N2 L03 (n2/lesson_03.json) |
| 弄 | N1 L20 (n1/lesson_20.json) |
| 戚 | N3 L14 (n3/lesson_14.json) |
| 旦 | N2 L09 (n2/lesson_09.json) |
| 昧 | N1 L02 (n1/lesson_02.json) |
| 曖 | N1 L02 (n1/lesson_02.json) |
| 炙 | N1 L10 (n1/lesson_10.json) |
| 羨 | N2 L15 (n2/lesson_15.json) |
| 苛 | N1 L19 (n1/lesson_19.json) |
| 誂 | N1 L08 (n1/lesson_08.json) |
| 顎 | N1 L05 (n1/lesson_05.json) |
| 鼾 | N1 L25 (n1/lesson_25.json) |

## Phase 1 Notes

- If owner approves the override policy, Phase 1 should move/dedupe current entries first, preserving existing `vi-source-verified` metadata.
- Missing rows require source-verified metadata from KANJIDIC2 + Unihan + Wiktionary/Hán-Việt references as needed. Do not add `vi-human-approved`.
- Add guards before data rewrite: cross-level duplicate fail test and per-level canonical diff test based on the approved canonical source artifact.
- Because source conflict is material, do not hard-code these candidate lists into tests until the owner approves this audit policy.
