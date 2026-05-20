# Kanji Level Audit 2026-05-20

Source: QA-A-027 master mapping from owner-provided local canonical ebooks; banned websites not accessed.

## Summary

- Current app placements scanned: 929
- Master kanji selected: 2114
- MOVE rows: 421
- DUPLICATE rows: 196
- MISSING rows: 1556
- EXTRA rows: 80

## Post-Apply Validation

- App kanji entries after rewrite: 2114
- Counts after rewrite: N5 103, N4 178, N3 316, N2 461, N1 1056
- MOVE rows after rewrite: 0
- DUPLICATE rows after rewrite: 0
- MISSING rows after rewrite: 0
- EXTRA rows after rewrite: 0
- Spot-check placements: 海 N5, 帰 N5, 親 N4, 銀 N3, 重 N3, 議 N2
- Guard: `test/data/content/kanji_canonical_mapping_test.dart`

## MOVE

| kanji | from | toLevel |
| --- | --- | --- |
| 愛 | N1 lesson 1 | N3 |
| 悪 | N1 lesson 4, N2 lesson 8, N5 lesson 15 | N3 |
| 圧 | N1 lesson 8 | N2 |
| 宛 | N1 lesson 9 | N2 |
| 安 | N1 lesson 14, N2 lesson 5, N3 lesson 20 | N5 |
| 暗 | N1 lesson 13, N2 lesson 13 | N5 |
| 案 | N1 lesson 13 | N2 |
| 以 | N2 lesson 7, N4 lesson 34 | N3 |
| 位 | N1 lesson 21 | N3 |
| 依 | N1 lesson 14 | N2 |
| 偉 | N4 lesson 28 | N2 |
| 委 | N1 lesson 20 | N2 |
| 威 | N2 lesson 11 | N1 |
| 意 | N1 lesson 17, N2 lesson 6, N4 lesson 35 | N3 |
| 易 | N2 lesson 5 | N3 |
| 異 | N1 lesson 18 | N2 |
| 移 | N1 lesson 19, N2 lesson 10 | N3 |
| 緯 | N2 lesson 10 | N1 |
| 衣 | N2 lesson 8 | N1 |
| 違 | N1 lesson 17 | N2 |
| 井 | N1 lesson 14 | N2 |
| 域 | N1 lesson 16 | N2 |
| 育 | N1 lesson 18, N2 lesson 7, N3 lesson 13, N3 lesson 14 | N4 |
| 一 | N1 lesson 22, N2 lesson 8 | N5 |
| 員 | N5 lesson 14 | N3 |
| 引 | N2 lesson 11, N5 lesson 18 | N3 |
| 運 | N2 lesson 15 | N4 |
| 営 | N1 lesson 24 | N2 |
| 映 | N2 lesson 13 | N4 |
| 栄 | N3 lesson 7 | N2 |
| 英 | N2 lesson 16 | N4 |
| 益 | N3 lesson 21 | N2 |
| 円 | N2 lesson 17 | N5 |
| 園 | N2 lesson 17, N5 lesson 24 | N4 |
| 援 | N3 lesson 14 | N2 |
| 煙 | N4 lesson 32 | N2 |
| 遠 | N2 lesson 18 | N4 |
| 汚 | N3 lesson 25, N4 lesson 29 | N2 |
| 押 | N2 lesson 21, N4 lesson 37 | N3 |
| 欧 | N2 lesson 19 | N3 |
| 王 | N2 lesson 19 | N4 |
| 屋 | N2 lesson 21 | N4 |
| 卸 | N2 lesson 24 | N1 |
| 温 | N2 lesson 25 | N3 |
| 化 | N1 lesson 8, N3 lesson 4, N3 lesson 24 | N2 |
| 何 | N1 lesson 16 | N5 |
| 価 | N3 lesson 6 | N2 |
| 加 | N1 lesson 15, N4 lesson 38 | N2 |
| 家 | N1 lesson 15 | N4 |
| 科 | N1 lesson 3, N3 lesson 17, N5 lesson 16 | N4 |
| 歌 | N5 lesson 9, N5 lesson 18 | N4 |
| 河 | N2 lesson 15 | N3 |
| 花 | N2 lesson 7 | N5 |
| 課 | N3 lesson 13 | N2 |
| 過 | N1 lesson 11 | N2 |
| 画 | N3 lesson 2 | N4 |
| 会 | N2 lesson 17, N5 lesson 1, N5 lesson 7, N5 lesson 13 | N4 |
| 回 | N1 lesson 9, N5 lesson 22 | N3 |
| 壊 | N4 lesson 29 | N2 |
| 怪 | N2 lesson 4 | N1 |
| 改 | N1 lesson 12 | N2 |
| 灰 | N1 lesson 4 | N2 |
| 開 | N3 lesson 17, N5 lesson 14 | N4 |
| 外 | N1 lesson 17, N2 lesson 6 | N5 |
| 害 | N3 lesson 11 | N2 |
| 各 | N2 lesson 23 | N3 |
| 確 | N4 lesson 40 | N3 |
| 学 | N3 lesson 4 | N5 |
| 楽 | N5 lesson 9 | N4 |
| 掛 | N4 lesson 30 | N2 |
| 活 | N1 lesson 18 | N3 |
| 乾 | N4 lesson 44 | N2 |
| 漢 | N5 lesson 9 | N4 |
| 環 | N3 lesson 3 | N2 |
| 甘 | N1 lesson 10 | N2 |
| 簡 | N4 lesson 44 | N2 |
| 間 | N1 lesson 1 | N5 |
| 顔 | N5 lesson 16 | N3 |
| 願 | N4 lesson 41 | N3 |
| 危 | N1 lesson 11, N2 lesson 4, N4 lesson 32 | N3 |
| 喜 | N4 lesson 47 | N3 |
| 機 | N4 lesson 41 | N3 |
| 帰 | N2 lesson 20 | N5 |
| 気 | N1 lesson 8 | N5 |
| 祈 | N1 lesson 25 | N2 |
| 儀 | N2 lesson 22 | N1 |
| 議 | N1 lesson 18, N3 lesson 22 | N2 |
| 急 | N5 lesson 22 | N4 |
| 泣 | N4 lesson 44 | N3 |
| 挙 | N1 lesson 23 | N2 |
| 教 | N2 lesson 23, N3 lesson 13, N5 lesson 7 | N4 |
| 業 | N5 lesson 13 | N3 |
| 禁 | N4 lesson 32 | N3 |
| 筋 | N1 lesson 12 | N2 |
| 緊 | N3 lesson 20 | N2 |
| 区 | N5 lesson 21 | N3 |
| 具 | N1 lesson 10, N2 lesson 16, N4 lesson 27 | N3 |
| 空 | N1 lesson 4 | N4 |
| 軍 | N1 lesson 18 | N3 |
| 兄 | N5 lesson 24 | N4 |
| 景 | N4 lesson 27 | N2 |
| 計 | N3 lesson 2 | N4 |
| 軽 | N5 lesson 15 | N4 |
| 芸 | N2 lesson 17 | N3 |
| 劇 | N3 lesson 12 | N2 |
| 決 | N4 lesson 30 | N3 |
| 健 | N3 lesson 7 | N2 |
| 建 | N4 lesson 27 | N3 |
| 見 | N1 lesson 19 | N5 |
| 験 | N3 lesson 17 | N4 |
| 減 | N1 lesson 15, N4 lesson 43 | N2 |
| 源 | N3 lesson 3 | N2 |
| 現 | N1 lesson 12 | N3 |
| 言 | N1 lesson 15, N2 lesson 6, N3 lesson 4 | N5 |
| 呼 | N1 lesson 1, N4 lesson 36 | N3 |
| 戸 | N2 lesson 3 | N3 |
| 後 | N1 lesson 5, N2 lesson 7, N5 lesson 10 | N4 |
| 語 | N3 lesson 4 | N4 |
| 誤 | N1 lesson 11 | N2 |
| 交 | N3 lesson 4, N3 lesson 10 | N4 |
| 光 | N1 lesson 25 | N4 |
| 公 | N5 lesson 24 | N4 |
| 厚 | N2 lesson 2, N4 lesson 42 | N3 |
| 口 | N1 lesson 8, N2 lesson 14 | N5 |
| 向 | N1 lesson 19 | N3 |
| 康 | N3 lesson 7 | N2 |
| 更 | N1 lesson 25, N3 lesson 1 | N2 |
| 洪 | N3 lesson 11 | N2 |
| 港 | N4 lesson 31 | N2 |
| 考 | N3 lesson 1, N5 lesson 25 | N4 |
| 荒 | N2 lesson 4 | N1 |
| 行 | N1 lesson 17, N2 lesson 15, N3 lesson 24 | N5 |
| 降 | N2 lesson 7 | N4 |
| 合 | N1 lesson 2, N2 lesson 13 | N4 |
| 国 | N5 lesson 13 | N4 |
| 込 | N1 lesson 17, N4 lesson 38 | N2 |
| 今 | N1 lesson 25 | N5 |
| 困 | N4 lesson 41 | N3 |
| 恨 | N2 lesson 15 | N1 |
| 混 | N4 lesson 42 | N2 |
| 左 | N3 lesson 1 | N5 |
| 歳 | N4 lesson 31 | N2 |
| 済 | N3 lesson 21 | N4 |
| 災 | N3 lesson 11 | N2 |
| 裁 | N3 lesson 18 | N2 |
| 際 | N3 lesson 25 | N2 |
| 在 | N2 lesson 5 | N3 |
| 財 | N3 lesson 21 | N2 |
| 昨 | N2 lesson 9 | N3 |
| 撮 | N3 lesson 12 | N1 |
| 殺 | N1 lesson 13 | N2 |
| 雑 | N3 lesson 9 | N2 |
| 参 | N3 lesson 1, N4 lesson 50 | N2 |
| 算 | N1 lesson 13 | N3 |
| 伺 | N4 lesson 49 | N2 |
| 始 | N5 lesson 17 | N4 |
| 姉 | N2 lesson 10, N5 lesson 24 | N4 |
| 市 | N1 lesson 21, N5 lesson 21 | N4 |
| 指 | N2 lesson 24 | N3 |
| 止 | N5 lesson 20 | N4 |
| 死 | N4 lesson 39 | N3 |
| 私 | N1 lesson 7 | N4 |
| 紙 | N5 lesson 7 | N4 |
| 試 | N3 lesson 16 | N4 |
| 誌 | N3 lesson 9 | N2 |
| 資 | N3 lesson 3 | N2 |
| 飼 | N4 lesson 27 | N2 |
| 事 | N5 lesson 13 | N3 |
| 児 | N2 lesson 7 | N3 |
| 字 | N1 lesson 3 | N5 |
| 持 | N2 lesson 13 | N4 |
| 時 | N1 lesson 24 | N5 |
| 治 | N2 lesson 21, N3 lesson 7, N3 lesson 23 | N4 |
| 辞 | N2 lesson 22 | N3 |
| 式 | N4 lesson 40 | N3 |
| 失 | N4 lesson 41 | N3 |
| 室 | N2 lesson 25 | N4 |
| 実 | N4 lesson 28 | N3 |
| 社 | N5 lesson 1, N5 lesson 13 | N4 |
| 者 | N5 lesson 13 | N3 |
| 謝 | N3 lesson 22, N4 lesson 45 | N2 |
| 借 | N5 lesson 7 | N3 |
| 主 | N1 lesson 15 | N4 |
| 取 | N2 lesson 12, N4 lesson 37 | N3 |
| 守 | N4 lesson 33, N4 lesson 46 | N3 |
| 手 | N2 lesson 23 | N5 |
| 首 | N5 lesson 16 | N3 |
| 受 | N2 lesson 12 | N3 |
| 就 | N3 lesson 5 | N2 |
| 終 | N5 lesson 17 | N4 |
| 習 | N5 lesson 7 | N4 |
| 集 | N1 lesson 8 | N4 |
| 住 | N1 lesson 19, N2 lesson 8, N3 lesson 15, N5 lesson 21 | N4 |
| 重 | N2 lesson 24, N5 lesson 15 | N3 |
| 宿 | N3 lesson 10 | N4 |
| 出 | N1 lesson 15, N2 lesson 6 | N5 |
| 処 | N1 lesson 7 | N2 |
| 所 | N5 lesson 21 | N4 |
| 女 | N1 lesson 9, N2 lesson 19 | N5 |
| 召 | N4 lesson 49 | N2 |
| 商 | N1 lesson 4 | N3 |
| 将 | N3 lesson 2 | N2 |
| 小 | N2 lesson 22 | N5 |
| 招 | N4 lesson 36 | N2 |
| 消 | N2 lesson 13, N4 lesson 29 | N3 |
| 焼 | N4 lesson 39 | N3 |
| 笑 | N1 lesson 6, N4 lesson 44 | N3 |
| 証 | N1 lesson 3 | N2 |
| 上 | N1 lesson 4, N2 lesson 15 | N5 |
| 場 | N5 lesson 14 | N4 |
| 飾 | N3 lesson 24, N4 lesson 30 | N2 |
| 植 | N2 lesson 12, N4 lesson 30 | N3 |
| 食 | N2 lesson 8, N3 lesson 19 | N5 |
| 信 | N4 lesson 45 | N3 |
| 寝 | N1 lesson 5 | N3 |
| 審 | N3 lesson 16 | N1 |
| 心 | N1 lesson 23, N5 lesson 16 | N4 |
| 新 | N3 lesson 9 | N5 |
| 申 | N4 lesson 38 | N2 |
| 親 | N2 lesson 24, N5 lesson 23 | N4 |
| 震 | N3 lesson 11 | N2 |
| 人 | N1 lesson 4, N2 lesson 25 | N5 |
| 図 | N1 lesson 24 | N5 |
| 制 | N3 lesson 18 | N2 |
| 性 | N1 lesson 20 | N3 |
| 成 | N1 lesson 17, N5 lesson 19 | N3 |
| 生 | N1 lesson 16, N2 lesson 6 | N5 |
| 声 | N5 lesson 16 | N4 |
| 青 | N2 lesson 1 | N4 |
| 静 | N1 lesson 14 | N4 |
| 斉 | N2 lesson 9 | N1 |
| 惜 | N2 lesson 22 | N1 |
| 戚 | N3 lesson 14 | N1 |
| 昔 | N4 lesson 27 | N3 |
| 石 | N4 lesson 36 | N5 |
| 責 | N3 lesson 5 | N2 |
| 赤 | N1 lesson 3 | N4 |
| 切 | N1 lesson 23, N2 lesson 15, N5 lesson 23 | N4 |
| 接 | N2 lesson 19 | N3 |
| 折 | N4 lesson 45 | N3 |
| 節 | N3 lesson 3, N3 lesson 8 | N2 |
| 戦 | N1 lesson 18 | N3 |
| 扇 | N2 lesson 1 | N1 |
| 浅 | N1 lesson 6 | N3 |
| 洗 | N2 lesson 23, N5 lesson 18 | N3 |
| 染 | N3 lesson 25 | N1 |
| 煎 | N2 lesson 11 | N1 |
| 線 | N5 lesson 22 | N3 |
| 羨 | N2 lesson 15 | N1 |
| 選 | N4 lesson 28 | N3 |
| 鮮 | N1 lesson 6, N3 lesson 19 | N2 |
| 前 | N1 lesson 7, N5 lesson 10 | N4 |
| 然 | N1 lesson 20 | N4 |
| 祖 | N3 lesson 8 | N2 |
| 粗 | N2 lesson 4 | N1 |
| 奏 | N3 lesson 12 | N1 |
| 想 | N1 lesson 1 | N3 |
| 早 | N5 lesson 15 | N4 |
| 争 | N1 lesson 12, N2 lesson 5 | N3 |
| 相 | N1 lesson 1 | N3 |
| 装 | N1 lesson 19, N3 lesson 24 | N2 |
| 走 | N5 lesson 18 | N4 |
| 増 | N4 lesson 43 | N3 |
| 憎 | N1 lesson 2 | N2 |
| 測 | N4 lesson 40 | N3 |
| 足 | N2 lesson 2 | N5 |
| 続 | N4 lesson 31 | N3 |
| 存 | N1 lesson 20, N4 lesson 49 | N3 |
| 他 | N1 lesson 7 | N3 |
| 多 | N1 lesson 18 | N5 |
| 打 | N2 lesson 13, N4 lesson 45 | N3 |
| 駄 | N3 lesson 3 | N1 |
| 体 | N2 lesson 16 | N5 |
| 対 | N1 lesson 1, N2 lesson 19 | N3 |
| 怠 | N2 lesson 21 | N1 |
| 替 | N3 lesson 24, N4 lesson 43 | N2 |
| 袋 | N4 lesson 29 | N3 |
| 貸 | N5 lesson 7 | N3 |
| 代 | N2 lesson 20, N5 lesson 14 | N3 |
| 大 | N2 lesson 20 | N5 |
| 単 | N4 lesson 44 | N3 |
| 旦 | N2 lesson 9 | N1 |
| 短 | N5 lesson 15 | N4 |
| 暖 | N2 lesson 2, N4 lesson 43 | N3 |
| 段 | N2 lesson 9 | N3 |
| 値 | N1 lesson 7 | N2 |
| 地 | N1 lesson 11, N2 lesson 8, N5 lesson 13 | N4 |
| 着 | N2 lesson 23, N3 lesson 24 | N4 |
| 中 | N2 lesson 25 | N5 |
| 昼 | N5 lesson 17 | N4 |
| 注 | N4 lesson 36 | N3 |
| 著 | N1 lesson 22 | N2 |
| 張 | N3 lesson 20, N4 lesson 30 | N2 |
| 朝 | N5 lesson 17 | N1 |
| 長 | N2 lesson 18 | N5 |
| 頂 | N1 lesson 21 | N2 |
| 鳥 | N4 lesson 27 | N5 |
| 賃 | N3 lesson 15 | N2 |
| 津 | N3 lesson 11 | N2 |
| 追 | N2 lesson 18 | N3 |
| 通 | N2 lesson 20, N3 lesson 10 | N4 |
| 定 | N1 lesson 14, N2 lesson 10 | N3 |
| 弟 | N5 lesson 24 | N4 |
| 天 | N1 lesson 10 | N4 |
| 転 | N2 lesson 10, N5 lesson 22 | N3 |
| 伝 | N2 lesson 23, N4 lesson 38 | N3 |
| 渡 | N4 lesson 48 | N2 |
| 都 | N5 lesson 21 | N4 |
| 度 | N2 lesson 10 | N3 |
| 倒 | N4 lesson 39 | N3 |
| 投 | N4 lesson 45 | N3 |
| 東 | N1 lesson 6 | N5 |
| 当 | N1 lesson 7 | N4 |
| 統 | N3 lesson 8 | N2 |
| 頭 | N5 lesson 16 | N3 |
| 動 | N1 lesson 24, N4 lesson 32 | N2 |
| 同 | N1 lesson 22, N5 lesson 13 | N4 |
| 導 | N3 lesson 13 | N2 |
| 憧 | N2 lesson 2 | N1 |
| 特 | N5 lesson 22 | N4 |
| 突 | N2 lesson 18 | N3 |
| 届 | N4 lesson 48 | N2 |
| 難 | N1 lesson 12, N2 lesson 5 | N3 |
| 日 | N1 lesson 5, N2 lesson 9 | N5 |
| 入 | N2 lesson 11 | N5 |
| 認 | N4 lesson 40 | N3 |
| 熱 | N4 lesson 28 | N3 |
| 年 | N2 lesson 9 | N5 |
| 波 | N4 lesson 27 | N2 |
| 破 | N4 lesson 46 | N2 |
| 拝 | N4 lesson 49 | N2 |
| 配 | N3 lesson 6, N4 lesson 48 | N2 |
| 売 | N2 lesson 15 | N4 |
| 伯 | N2 lesson 22 | N1 |
| 白 | N1 lesson 3, N2 lesson 1 | N4 |
| 薄 | N4 lesson 42 | N2 |
| 発 | N3 lesson 17, N5 lesson 13 | N4 |
| 晩 | N5 lesson 17 | N4 |
| 彼 | N1 lesson 6, N4 lesson 33 | N3 |
| 悲 | N4 lesson 47 | N3 |
| 避 | N3 lesson 11 | N1 |
| 飛 | N4 lesson 41 | N3 |
| 標 | N3 lesson 2 | N2 |
| 評 | N3 lesson 6 | N2 |
| 病 | N5 lesson 16 | N4 |
| 品 | N3 lesson 6 | N1 |
| 不 | N3 lesson 20, N5 lesson 23 | N4 |
| 付 | N2 lesson 6 | N3 |
| 府 | N5 lesson 21 | N4 |
| 父 | N2 lesson 22 | N5 |
| 部 | N1 lesson 22 | N4 |
| 復 | N2 lesson 19 | N1 |
| 沸 | N4 lesson 42 | N1 |
| 物 | N2 lesson 4 | N5 |
| 分 | N1 lesson 22, N2 lesson 7 | N5 |
| 文 | N2 lesson 16, N3 lesson 4, N3 lesson 6 | N4 |
| 聞 | N3 lesson 9 | N5 |
| 柄 | N1 lesson 2 | N2 |
| 並 | N4 lesson 30 | N2 |
| 米 | N2 lesson 20 | N1 |
| 別 | N1 lesson 22, N4 lesson 47 | N2 |
| 変 | N1 lesson 1, N4 lesson 43 | N3 |
| 返 | N2 lesson 14 | N3 |
| 便 | N5 lesson 23 | N4 |
| 歩 | N1 lesson 11, N5 lesson 18 | N4 |
| 補 | N2 lesson 21 | N3 |
| 母 | N2 lesson 24 | N5 |
| 包 | N4 lesson 42 | N1 |
| 方 | N1 lesson 7, N2 lesson 1 | N5 |
| 法 | N4 lesson 35 | N3 |
| 飽 | N2 lesson 1 | N1 |
| 坊 | N1 lesson 5 | N2 |
| 翻 | N3 lesson 22 | N1 |
| 凡 | N2 lesson 20 | N1 |
| 妹 | N2 lesson 11, N5 lesson 24 | N4 |
| 味 | N1 lesson 6, N2 lesson 2, N3 lesson 19 | N4 |
| 未 | N1 lesson 25 | N3 |
| 民 | N1 lesson 25, N3 lesson 15 | N2 |
| 眠 | N3 lesson 7, N4 lesson 44 | N2 |
| 夢 | N4 lesson 27 | N3 |
| 無 | N2 lesson 14 | N3 |
| 名 | N2 lesson 3 | N5 |
| 明 | N1 lesson 3, N2 lesson 1, N3 lesson 17 | N5 |
| 面 | N1 lesson 22 | N3 |
| 木 | N2 lesson 12 | N1 |
| 目 | N1 lesson 23, N3 lesson 2 | N5 |
| 戻 | N4 lesson 30 | N2 |
| 問 | N5 lesson 14 | N4 |
| 夜 | N5 lesson 17 | N4 |
| 約 | N4 lesson 46 | N3 |
| 薬 | N5 lesson 16 | N4 |
| 訳 | N1 lesson 15 | N3 |
| 油 | N1 lesson 10 | N4 |
| 輸 | N4 lesson 36 | N2 |
| 予 | N1 lesson 11, N4 lesson 30 | N3 |
| 余 | N1 lesson 14 | N2 |
| 揚 | N2 lesson 1 | N1 |
| 用 | N2 lesson 20 | N3 |
| 踊 | N4 lesson 28 | N2 |
| 養 | N3 lesson 7 | N2 |
| 来 | N3 lesson 2 | N5 |
| 頼 | N3 lesson 14, N4 lesson 36 | N2 |
| 雷 | N1 lesson 16 | N2 |
| 落 | N2 lesson 23, N4 lesson 29 | N3 |
| 利 | N3 lesson 21, N5 lesson 23 | N4 |
| 理 | N3 lesson 19 | N4 |
| 離 | N3 lesson 14 | N2 |
| 流 | N2 lesson 9 | N3 |
| 留 | N4 lesson 33 | N3 |
| 料 | N3 lesson 19 | N4 |
| 療 | N3 lesson 7 | N2 |
| 良 | N1 lesson 14, N5 lesson 8 | N3 |
| 量 | N4 lesson 42 | N3 |
| 力 | N1 lesson 9, N2 lesson 12, N3 lesson 2, N5 lesson 11, N5 lesson 14 | N4 |
| 冷 | N4 lesson 43 | N3 |
| 礼 | N4 lesson 41 | N3 |
| 歴 | N3 lesson 23 | N4 |
| 連 | N1 lesson 23, N4 lesson 46 | N3 |
| 論 | N3 lesson 9 | N2 |
| 和 | N2 lesson 16 | N3 |
| 炒 | N2 lesson 11 | N1 |

## DUPLICATE

| kanji | placements | keepLevel |
| --- | --- | --- |
| 悪 | N1 lesson 4, N2 lesson 8, N5 lesson 15 | N3 |
| 圧 | N1 lesson 8, N2 lesson 3 | N2 |
| 宛 | N1 lesson 9, N2 lesson 3 | N2 |
| 安 | N1 lesson 14, N2 lesson 5, N3 lesson 20, N5 lesson 8 | N5 |
| 暗 | N1 lesson 13, N2 lesson 13, N5 lesson 15 | N5 |
| 案 | N1 lesson 13, N2 lesson 6 | N2 |
| 以 | N2 lesson 7, N4 lesson 34 | N3 |
| 偉 | N2 lesson 16, N4 lesson 28 | N2 |
| 意 | N1 lesson 17, N2 lesson 6, N4 lesson 35 | N3 |
| 移 | N1 lesson 19, N2 lesson 10 | N3 |
| 緯 | N1 lesson 17, N2 lesson 10 | N1 |
| 衣 | N1 lesson 19, N2 lesson 8 | N1 |
| 井 | N1 lesson 14, N2 lesson 10 | N2 |
| 育 | N1 lesson 18, N2 lesson 7, N3 lesson 13, N3 lesson 14, N4 lesson 37 | N4 |
| 一 | N1 lesson 22, N2 lesson 8, N5 lesson 2 | N5 |
| 引 | N2 lesson 11, N5 lesson 18 | N3 |
| 運 | N2 lesson 15, N4 lesson 32, N4 lesson 34 | N4 |
| 円 | N2 lesson 17, N5 lesson 2 | N5 |
| 園 | N2 lesson 17, N5 lesson 24 | N4 |
| 援 | N2 lesson 19, N3 lesson 14 | N2 |
| 煙 | N2 lesson 18, N4 lesson 32 | N2 |
| 汚 | N3 lesson 25, N4 lesson 29 | N2 |
| 押 | N2 lesson 21, N4 lesson 37 | N3 |
| 屋 | N2 lesson 21, N4 lesson 34 | N4 |
| 化 | N1 lesson 8, N3 lesson 4, N3 lesson 24 | N2 |
| 何 | N1 lesson 16, N5 lesson 1, N5 lesson 12 | N5 |
| 加 | N1 lesson 15, N4 lesson 38 | N2 |
| 科 | N1 lesson 3, N3 lesson 17, N5 lesson 16 | N4 |
| 歌 | N5 lesson 9, N5 lesson 18 | N4 |
| 会 | N2 lesson 17, N5 lesson 1, N5 lesson 7, N5 lesson 13 | N4 |
| 回 | N1 lesson 9, N5 lesson 22 | N3 |
| 改 | N1 lesson 12, N2 lesson 5 | N2 |
| 開 | N3 lesson 17, N5 lesson 14 | N4 |
| 外 | N1 lesson 17, N2 lesson 6, N5 lesson 10 | N5 |
| 学 | N3 lesson 4, N5 lesson 1, N5 lesson 12 | N5 |
| 掛 | N2 lesson 18, N4 lesson 30 | N2 |
| 甘 | N1 lesson 10, N2 lesson 4 | N2 |
| 間 | N1 lesson 1, N5 lesson 10 | N5 |
| 危 | N1 lesson 11, N2 lesson 4, N4 lesson 32 | N3 |
| 機 | N3 lesson 17, N4 lesson 41 | N3 |
| 議 | N1 lesson 18, N3 lesson 22 | N2 |
| 挙 | N1 lesson 23, N2 lesson 2 | N2 |
| 教 | N2 lesson 23, N3 lesson 13, N5 lesson 7 | N4 |
| 九 | N5 lesson 2, N5 lesson 5 | N5 |
| 具 | N1 lesson 10, N2 lesson 16, N4 lesson 27 | N3 |
| 空 | N1 lesson 4, N4 lesson 31 | N4 |
| 芸 | N2 lesson 17, N3 lesson 12 | N3 |
| 劇 | N2 lesson 17, N3 lesson 12 | N2 |
| 決 | N3 lesson 16, N4 lesson 30 | N3 |
| 見 | N1 lesson 19, N5 lesson 6 | N5 |
| 減 | N1 lesson 15, N4 lesson 43 | N2 |
| 言 | N1 lesson 15, N2 lesson 6, N3 lesson 4 | N5 |
| 呼 | N1 lesson 1, N4 lesson 36 | N3 |
| 五 | N5 lesson 2, N5 lesson 4 | N5 |
| 後 | N1 lesson 5, N2 lesson 7, N5 lesson 10 | N4 |
| 交 | N3 lesson 4, N3 lesson 10 | N4 |
| 厚 | N2 lesson 2, N4 lesson 42 | N3 |
| 口 | N1 lesson 8, N2 lesson 14, N5 lesson 11 | N5 |
| 更 | N1 lesson 25, N3 lesson 1 | N2 |
| 考 | N3 lesson 1, N4 lesson 31, N4 lesson 34, N5 lesson 25 | N4 |
| 荒 | N1 lesson 11, N2 lesson 4 | N1 |
| 行 | N1 lesson 17, N2 lesson 15, N3 lesson 24, N5 lesson 1 | N5 |
| 降 | N2 lesson 7, N4 lesson 37 | N4 |
| 合 | N1 lesson 2, N2 lesson 13, N4 lesson 33 | N4 |
| 込 | N1 lesson 17, N2 lesson 24, N4 lesson 38 | N2 |
| 困 | N3 lesson 25, N4 lesson 41 | N3 |
| 左 | N3 lesson 1, N5 lesson 10 | N5 |
| 参 | N2 lesson 24, N3 lesson 1, N4 lesson 50 | N2 |
| 山 | N5 lesson 3, N5 lesson 19 | N5 |
| 四 | N5 lesson 2, N5 lesson 4 | N5 |
| 姉 | N2 lesson 10, N5 lesson 24 | N4 |
| 市 | N1 lesson 21, N5 lesson 21 | N4 |
| 私 | N1 lesson 7, N4 lesson 26 | N4 |
| 字 | N1 lesson 3, N5 lesson 9 | N5 |
| 治 | N2 lesson 21, N3 lesson 7, N3 lesson 23 | N4 |
| 七 | N5 lesson 2, N5 lesson 5 | N5 |
| 社 | N5 lesson 1, N5 lesson 13 | N4 |
| 謝 | N3 lesson 22, N4 lesson 45 | N2 |
| 取 | N2 lesson 12, N4 lesson 37 | N3 |
| 守 | N4 lesson 33, N4 lesson 46 | N3 |
| 手 | N2 lesson 23, N5 lesson 7, N5 lesson 11, N5 lesson 14 | N5 |
| 集 | N1 lesson 8, N4 lesson 47 | N4 |
| 住 | N1 lesson 19, N2 lesson 8, N3 lesson 15, N5 lesson 21 | N4 |
| 十 | N5 lesson 2, N5 lesson 5 | N5 |
| 重 | N2 lesson 24, N5 lesson 15 | N3 |
| 出 | N1 lesson 15, N2 lesson 6 | N5 |
| 女 | N1 lesson 9, N2 lesson 19, N5 lesson 11 | N5 |
| 小 | N2 lesson 22, N5 lesson 8 | N5 |
| 消 | N2 lesson 13, N4 lesson 29 | N3 |
| 笑 | N1 lesson 6, N4 lesson 44 | N3 |
| 上 | N1 lesson 4, N2 lesson 15, N5 lesson 10 | N5 |
| 飾 | N3 lesson 24, N4 lesson 30 | N2 |
| 植 | N2 lesson 12, N4 lesson 30 | N3 |
| 食 | N2 lesson 8, N3 lesson 19, N5 lesson 6 | N5 |
| 心 | N1 lesson 23, N5 lesson 16 | N4 |
| 新 | N3 lesson 9, N5 lesson 8, N5 lesson 14 | N5 |
| 親 | N2 lesson 24, N5 lesson 23 | N4 |
| 人 | N1 lesson 4, N2 lesson 25, N5 lesson 1, N5 lesson 11 | N5 |
| 成 | N1 lesson 17, N5 lesson 19 | N3 |
| 生 | N1 lesson 16, N2 lesson 6, N5 lesson 1, N5 lesson 12 | N5 |
| 声 | N4 lesson 27, N5 lesson 16 | N4 |
| 静 | N1 lesson 14, N4 lesson 32 | N4 |
| 切 | N1 lesson 23, N2 lesson 15, N5 lesson 23 | N4 |
| 接 | N2 lesson 19, N3 lesson 5 | N3 |
| 節 | N3 lesson 3, N3 lesson 8 | N2 |
| 先 | N5 lesson 1, N5 lesson 12 | N5 |
| 戦 | N1 lesson 18, N3 lesson 23 | N3 |
| 洗 | N2 lesson 23, N5 lesson 18 | N3 |
| 選 | N3 lesson 16, N4 lesson 28 | N3 |
| 鮮 | N1 lesson 6, N3 lesson 19 | N2 |
| 前 | N1 lesson 7, N5 lesson 10 | N4 |
| 粗 | N1 lesson 12, N2 lesson 4 | N1 |
| 争 | N1 lesson 12, N2 lesson 5, N3 lesson 23 | N3 |
| 装 | N1 lesson 19, N3 lesson 24 | N2 |
| 足 | N2 lesson 2, N5 lesson 11 | N5 |
| 存 | N1 lesson 20, N4 lesson 49 | N3 |
| 多 | N1 lesson 18, N5 lesson 15 | N5 |
| 打 | N2 lesson 13, N4 lesson 45 | N3 |
| 体 | N2 lesson 16, N5 lesson 16 | N5 |
| 対 | N1 lesson 1, N2 lesson 19 | N3 |
| 替 | N3 lesson 24, N4 lesson 43 | N2 |
| 貸 | N3 lesson 15, N5 lesson 7 | N3 |
| 代 | N2 lesson 20, N5 lesson 14 | N3 |
| 大 | N2 lesson 20, N5 lesson 1, N5 lesson 8 | N5 |
| 暖 | N2 lesson 2, N4 lesson 43 | N3 |
| 地 | N1 lesson 11, N2 lesson 8, N5 lesson 13 | N4 |
| 着 | N2 lesson 23, N3 lesson 24, N4 lesson 31 | N4 |
| 中 | N2 lesson 25, N5 lesson 10 | N5 |
| 注 | N3 lesson 6, N4 lesson 36 | N3 |
| 著 | N1 lesson 22, N2 lesson 5 | N2 |
| 張 | N2 lesson 11, N3 lesson 20, N4 lesson 30 | N2 |
| 朝 | N1 lesson 5, N5 lesson 17 | N1 |
| 長 | N2 lesson 18, N5 lesson 15 | N5 |
| 通 | N2 lesson 20, N3 lesson 10, N4 lesson 28 | N4 |
| 定 | N1 lesson 14, N2 lesson 10 | N3 |
| 転 | N2 lesson 10, N5 lesson 22 | N3 |
| 伝 | N2 lesson 23, N3 lesson 8, N4 lesson 38 | N3 |
| 投 | N3 lesson 21, N4 lesson 45 | N3 |
| 動 | N1 lesson 24, N4 lesson 32 | N2 |
| 同 | N1 lesson 22, N5 lesson 13 | N4 |
| 憧 | N1 lesson 5, N2 lesson 2 | N1 |
| 難 | N1 lesson 12, N2 lesson 5, N3 lesson 11, N3 lesson 25 | N3 |
| 日 | N1 lesson 5, N2 lesson 9, N5 lesson 1, N5 lesson 3 | N5 |
| 拝 | N2 lesson 20, N4 lesson 49 | N2 |
| 配 | N3 lesson 6, N4 lesson 48 | N2 |
| 売 | N2 lesson 15, N4 lesson 28 | N4 |
| 白 | N1 lesson 3, N2 lesson 1 | N4 |
| 薄 | N2 lesson 13, N4 lesson 42 | N2 |
| 八 | N5 lesson 2, N5 lesson 5 | N5 |
| 発 | N3 lesson 17, N5 lesson 13 | N4 |
| 彼 | N1 lesson 6, N4 lesson 33 | N3 |
| 悲 | N3 lesson 20, N4 lesson 47 | N3 |
| 不 | N3 lesson 20, N5 lesson 23 | N4 |
| 父 | N2 lesson 22, N5 lesson 12 | N5 |
| 分 | N1 lesson 22, N2 lesson 7 | N5 |
| 文 | N2 lesson 16, N3 lesson 4, N3 lesson 6, N4 lesson 35 | N4 |
| 聞 | N3 lesson 9, N5 lesson 6 | N5 |
| 平 | N3 lesson 23, N3 lesson 25 | N3 |
| 別 | N1 lesson 22, N4 lesson 47 | N2 |
| 変 | N1 lesson 1, N4 lesson 43 | N3 |
| 返 | N2 lesson 14, N3 lesson 6 | N3 |
| 歩 | N1 lesson 11, N5 lesson 18 | N4 |
| 母 | N2 lesson 24, N5 lesson 12 | N5 |
| 方 | N1 lesson 7, N2 lesson 1, N5 lesson 1, N5 lesson 14 | N5 |
| 法 | N3 lesson 1, N3 lesson 18, N4 lesson 35 | N3 |
| 本 | N5 lesson 1, N5 lesson 12 | N5 |
| 凡 | N1 lesson 12, N2 lesson 20 | N1 |
| 妹 | N2 lesson 11, N5 lesson 24 | N4 |
| 味 | N1 lesson 6, N2 lesson 2, N3 lesson 19, N4 lesson 35 | N4 |
| 民 | N1 lesson 25, N3 lesson 15 | N2 |
| 眠 | N3 lesson 7, N4 lesson 44 | N2 |
| 無 | N2 lesson 14, N3 lesson 3 | N3 |
| 名 | N2 lesson 3, N5 lesson 1 | N5 |
| 明 | N1 lesson 3, N2 lesson 1, N3 lesson 17, N5 lesson 15 | N5 |
| 面 | N1 lesson 22, N3 lesson 5 | N3 |
| 目 | N1 lesson 23, N3 lesson 2, N5 lesson 11 | N5 |
| 約 | N3 lesson 3, N3 lesson 10, N4 lesson 46 | N3 |
| 訳 | N1 lesson 15, N3 lesson 22 | N3 |
| 油 | N1 lesson 10, N4 lesson 36 | N4 |
| 友 | N5 lesson 7, N5 lesson 12 | N5 |
| 予 | N1 lesson 11, N3 lesson 10, N4 lesson 30 | N3 |
| 余 | N1 lesson 14, N2 lesson 4 | N2 |
| 来 | N3 lesson 2, N5 lesson 1 | N5 |
| 頼 | N3 lesson 14, N4 lesson 36 | N2 |
| 落 | N2 lesson 23, N4 lesson 29 | N3 |
| 利 | N3 lesson 21, N5 lesson 23 | N4 |
| 流 | N2 lesson 9, N3 lesson 4, N3 lesson 24 | N3 |
| 留 | N3 lesson 4, N4 lesson 33 | N3 |
| 良 | N1 lesson 14, N5 lesson 8 | N3 |
| 力 | N1 lesson 9, N2 lesson 12, N3 lesson 2, N5 lesson 11, N5 lesson 14 | N4 |
| 冷 | N3 lesson 1, N4 lesson 43 | N3 |
| 礼 | N3 lesson 8, N4 lesson 41 | N3 |
| 連 | N1 lesson 23, N3 lesson 22, N4 lesson 46 | N3 |
| 六 | N5 lesson 2, N5 lesson 4 | N5 |
| 和 | N2 lesson 16, N3 lesson 23 | N3 |
| 炒 | N1 lesson 21, N2 lesson 11 | N1 |

## MISSING

| kanji | toLevel |
| --- | --- |
| 哀 | N1 |
| 挨 | N1 |
| 逢 | N1 |
| 葵 | N1 |
| 握 | N2 |
| 斡 | N1 |
| 絢 | N1 |
| 鮎 | N1 |
| 按 | N1 |
| 闇 | N1 |
| 囲 | N2 |
| 尉 | N1 |
| 慰 | N1 |
| 為 | N1 |
| 畏 | N1 |
| 胃 | N2 |
| 萎 | N1 |
| 謂 | N1 |
| 医 | N3 |
| 亥 | N1 |
| 磯 | N1 |
| 壱 | N1 |
| 逸 | N1 |
| 茨 | N2 |
| 芋 | N1 |
| 鰯 | N1 |
| 印 | N2 |
| 咽 | N1 |
| 因 | N2 |
| 姻 | N1 |
| 淫 | N1 |
| 蔭 | N1 |
| 院 | N4 |
| 陰 | N1 |
| 隠 | N1 |
| 韻 | N1 |
| 宇 | N2 |
| 迂 | N1 |
| 卯 | N1 |
| 窺 | N1 |
| 丑 | N1 |
| 臼 | N1 |
| 渦 | N1 |
| 嘘 | N1 |
| 唄 | N1 |
| 鰻 | N1 |
| 瓜 | N1 |
| 噂 | N1 |
| 云 | N4 |
| 餌 | N1 |
| 影 | N2 |
| 永 | N3 |
| 衛 | N2 |
| 詠 | N1 |
| 鋭 | N2 |
| 駅 | N4 |
| 悦 | N1 |
| 閲 | N1 |
| 怨 | N1 |
| 炎 | N2 |
| 猿 | N1 |
| 縁 | N1 |
| 艶 | N1 |
| 鉛 | N1 |
| 塩 | N3 |
| 凹 | N1 |
| 奥 | N4 |
| 旺 | N1 |
| 横 | N3 |
| 殴 | N2 |
| 翁 | N1 |
| 襖 | N1 |
| 鴎 | N1 |
| 黄 | N4 |
| 岡 | N2 |
| 沖 | N2 |
| 億 | N3 |
| 憶 | N2 |
| 臆 | N1 |
| 桶 | N1 |
| 牡 | N1 |
| 俺 | N1 |
| 穏 | N1 |
| 佳 | N1 |
| 可 | N3 |
| 夏 | N4 |
| 嫁 | N1 |
| 果 | N3 |
| 架 | N1 |
| 火 | N5 |
| 禍 | N1 |
| 稼 | N2 |
| 箇 | N1 |
| 華 | N2 |
| 菓 | N2 |
| 嘩 | N1 |
| 貨 | N2 |
| 霞 | N1 |
| 蚊 | N1 |
| 我 | N2 |
| 牙 | N1 |
| 芽 | N1 |
| 賀 | N1 |
| 駕 | N1 |
| 解 | N3 |
| 快 | N2 |
| 悔 | N1 |
| 戒 | N1 |
| 拐 | N1 |
| 海 | N5 |
| 界 | N4 |
| 皆 | N2 |
| 芥 | N1 |
| 蟹 | N1 |
| 階 | N3 |
| 貝 | N1 |
| 劾 | N1 |
| 咳 | N1 |
| 崖 | N1 |
| 慨 | N1 |
| 涯 | N1 |
| 蓋 | N1 |
| 街 | N2 |
| 該 | N1 |
| 骸 | N1 |
| 垣 | N1 |
| 柿 | N1 |
| 嚇 | N1 |
| 拡 | N2 |
| 格 | N3 |
| 殻 | N1 |
| 獲 | N1 |
| 穫 | N1 |
| 郭 | N1 |
| 革 | N2 |
| 岳 | N1 |
| 額 | N2 |
| 笠 | N1 |
| 割 | N2 |
| 喝 | N1 |
| 滑 | N1 |
| 葛 | N1 |
| 褐 | N1 |
| 轄 | N1 |
| 且 | N1 |
| 鰹 | N1 |
| 叶 | N1 |
| 株 | N2 |
| 釜 | N1 |
| 鎌 | N1 |
| 噛 | N1 |
| 鴨 | N1 |
| 粥 | N1 |
| 刈 | N1 |
| 瓦 | N1 |
| 寒 | N4 |
| 刊 | N2 |
| 勘 | N1 |
| 勧 | N2 |
| 巻 | N2 |
| 喚 | N1 |
| 堪 | N1 |
| 姦 | N1 |
| 完 | N2 |
| 寛 | N1 |
| 干 | N3 |
| 幹 | N1 |
| 慣 | N2 |
| 憾 | N1 |
| 換 | N2 |
| 柑 | N1 |
| 棺 | N1 |
| 款 | N1 |
| 歓 | N1 |
| 汗 | N3 |
| 監 | N1 |
| 看 | N2 |
| 竿 | N1 |
| 管 | N3 |
| 缶 | N3 |
| 肝 | N1 |
| 艦 | N1 |
| 貫 | N1 |
| 還 | N1 |
| 関 | N3 |
| 陥 | N1 |
| 韓 | N1 |
| 館 | N4 |
| 丸 | N4 |
| 含 | N2 |
| 玩 | N1 |
| 眼 | N2 |
| 岩 | N5 |
| 雁 | N1 |
| 頑 | N2 |
| 企 | N2 |
| 伎 | N1 |
| 器 | N3 |
| 基 | N2 |
| 奇 | N1 |
| 嬉 | N1 |
| 寄 | N2 |
| 希 | N3 |
| 忌 | N1 |
| 揮 | N1 |
| 机 | N3 |
| 期 | N3 |
| 棋 | N1 |
| 棄 | N1 |
| 汽 | N1 |
| 畿 | N1 |
| 紀 | N1 |
| 起 | N3 |
| 軌 | N1 |
| 輝 | N1 |
| 騎 | N1 |
| 鬼 | N1 |
| 偽 | N1 |
| 宜 | N1 |
| 擬 | N1 |
| 犠 | N1 |
| 蟻 | N1 |
| 誼 | N1 |
| 菊 | N2 |
| 吃 | N1 |
| 詰 | N2 |
| 杵 | N1 |
| 却 | N1 |
| 客 | N4 |
| 脚 | N2 |
| 虐 | N1 |
| 逆 | N3 |
| 丘 | N2 |
| 久 | N3 |
| 休 | N5 |
| 及 | N1 |
| 吸 | N3 |
| 宮 | N1 |
| 救 | N3 |
| 求 | N3 |
| 球 | N3 |
| 究 | N4 |
| 窮 | N1 |
| 糾 | N1 |
| 旧 | N3 |
| 牛 | N5 |
| 去 | N4 |
| 居 | N2 |
| 巨 | N3 |
| 拠 | N1 |
| 虚 | N1 |
| 許 | N3 |
| 距 | N2 |
| 漁 | N2 |
| 魚 | N5 |
| 享 | N1 |
| 供 | N3 |
| 競 | N2 |
| 共 | N2 |
| 協 | N2 |
| 叫 | N2 |
| 喬 | N1 |
| 境 | N2 |
| 強 | N4 |
| 怯 | N1 |
| 恐 | N2 |
| 恭 | N1 |
| 橋 | N3 |
| 況 | N2 |
| 狂 | N1 |
| 狭 | N2 |
| 胸 | N2 |
| 興 | N1 |
| 郷 | N1 |
| 鏡 | N2 |
| 響 | N2 |
| 凝 | N1 |
| 暁 | N1 |
| 局 | N3 |
| 曲 | N3 |
| 極 | N2 |
| 玉 | N4 |
| 僅 | N1 |
| 勤 | N2 |
| 錦 | N1 |
| 琴 | N1 |
| 禽 | N1 |
| 芹 | N1 |
| 菌 | N2 |
| 襟 | N1 |
| 謹 | N1 |
| 近 | N4 |
| 金 | N5 |
| 吟 | N1 |
| 銀 | N3 |
| 句 | N2 |
| 苦 | N3 |
| 駆 | N1 |
| 駒 | N1 |
| 愚 | N1 |
| 虞 | N1 |
| 喰 | N1 |
| 寓 | N1 |
| 遇 | N1 |
| 隅 | N2 |
| 串 | N1 |
| 櫛 | N1 |
| 屑 | N1 |
| 屈 | N2 |
| 窟 | N1 |
| 靴 | N2 |
| 窪 | N1 |
| 隈 | N1 |
| 栗 | N1 |
| 繰 | N1 |
| 桑 | N1 |
| 勲 | N1 |
| 薫 | N1 |
| 訓 | N2 |
| 群 | N2 |
| 郡 | N1 |
| 傾 | N2 |
| 刑 | N2 |
| 啓 | N1 |
| 契 | N2 |
| 形 | N3 |
| 径 | N1 |
| 慶 | N1 |
| 憩 | N1 |
| 掲 | N1 |
| 携 | N3 |
| 桂 | N1 |
| 渓 | N1 |
| 系 | N1 |
| 繋 | N1 |
| 罫 | N1 |
| 茎 | N1 |
| 蛍 | N1 |
| 鶏 | N1 |
| 迎 | N3 |
| 鯨 | N1 |
| 撃 | N2 |
| 激 | N2 |
| 桁 | N1 |
| 傑 | N1 |
| 欠 | N3 |
| 潔 | N2 |
| 穴 | N2 |
| 血 | N3 |
| 訣 | N1 |
| 月 | N5 |
| 件 | N3 |
| 倹 | N1 |
| 倦 | N1 |
| 券 | N2 |
| 喧 | N1 |
| 圏 | N1 |
| 堅 | N2 |
| 憲 | N1 |
| 懸 | N1 |
| 拳 | N1 |
| 捲 | N1 |
| 検 | N3 |
| 権 | N2 |
| 牽 | N1 |
| 犬 | N1 |
| 研 | N4 |
| 絹 | N1 |
| 肩 | N2 |
| 謙 | N1 |
| 賢 | N2 |
| 軒 | N2 |
| 遣 | N1 |
| 険 | N3 |
| 顕 | N1 |
| 元 | N5 |
| 厳 | N2 |
| 幻 | N1 |
| 玄 | N2 |
| 絃 | N1 |
| 諺 | N1 |
| 限 | N2 |
| 個 | N3 |
| 固 | N2 |
| 姑 | N1 |
| 孤 | N1 |
| 己 | N1 |
| 弧 | N1 |
| 故 | N1 |
| 枯 | N2 |
| 湖 | N1 |
| 狐 | N1 |
| 糊 | N1 |
| 袴 | N1 |
| 股 | N1 |
| 胡 | N1 |
| 誇 | N1 |
| 雇 | N2 |
| 鼓 | N1 |
| 互 | N2 |
| 娯 | N1 |
| 悟 | N1 |
| 檎 | N1 |
| 瑚 | N1 |
| 碁 | N1 |
| 護 | N2 |
| 乞 | N1 |
| 鯉 | N1 |
| 侯 | N1 |
| 効 | N3 |
| 勾 | N1 |
| 后 | N1 |
| 喉 | N1 |
| 孝 | N1 |
| 工 | N4 |
| 幸 | N3 |
| 恒 | N1 |
| 抗 | N1 |
| 拘 | N1 |
| 控 | N1 |
| 攻 | N2 |
| 杭 | N1 |
| 梗 | N1 |
| 構 | N3 |
| 江 | N2 |
| 溝 | N1 |
| 甲 | N1 |
| 皇 | N1 |
| 硬 | N2 |
| 稿 | N1 |
| 紅 | N2 |
| 絞 | N1 |
| 綱 | N1 |
| 腔 | N1 |
| 膏 | N1 |
| 航 | N2 |
| 衡 | N1 |
| 講 | N3 |
| 貢 | N1 |
| 購 | N2 |
| 郊 | N1 |
| 酵 | N1 |
| 鉱 | N2 |
| 鋼 | N2 |
| 香 | N2 |
| 剛 | N1 |
| 壕 | N1 |
| 拷 | N1 |
| 豪 | N1 |
| 克 | N1 |
| 刻 | N2 |
| 穀 | N1 |
| 酷 | N1 |
| 黒 | N4 |
| 獄 | N1 |
| 忽 | N1 |
| 惚 | N1 |
| 骨 | N2 |
| 墾 | N1 |
| 婚 | N3 |
| 懇 | N1 |
| 昏 | N1 |
| 昆 | N1 |
| 根 | N3 |
| 痕 | N1 |
| 紺 | N2 |
| 魂 | N1 |
| 佐 | N1 |
| 唆 | N1 |
| 差 | N3 |
| 査 | N3 |
| 沙 | N1 |
| 砂 | N2 |
| 詐 | N1 |
| 座 | N3 |
| 債 | N2 |
| 催 | N2 |
| 最 | N3 |
| 塞 | N1 |
| 妻 | N4 |
| 宰 | N1 |
| 彩 | N2 |
| 才 | N4 |
| 採 | N2 |
| 栽 | N1 |
| 犀 | N1 |
| 砕 | N1 |
| 砦 | N1 |
| 斎 | N1 |
| 細 | N4 |
| 載 | N1 |
| 剤 | N2 |
| 冴 | N1 |
| 坂 | N3 |
| 阪 | N2 |
| 咲 | N4 |
| 崎 | N2 |
| 埼 | N2 |
| 搾 | N1 |
| 柵 | N1 |
| 策 | N2 |
| 錯 | N1 |
| 桜 | N2 |
| 鮭 | N1 |
| 刷 | N2 |
| 察 | N2 |
| 拶 | N1 |
| 擦 | N1 |
| 札 | N2 |
| 鯖 | N1 |
| 錆 | N1 |
| 鮫 | N1 |
| 皿 | N4 |
| 傘 | N2 |
| 惨 | N1 |
| 撒 | N1 |
| 散 | N2 |
| 桟 | N1 |
| 珊 | N1 |
| 産 | N3 |
| 蚕 | N1 |
| 讃 | N1 |
| 酸 | N1 |
| 斬 | N1 |
| 仕 | N3 |
| 刺 | N2 |
| 司 | N2 |
| 嗣 | N1 |
| 士 | N2 |
| 師 | N3 |
| 志 | N1 |
| 支 | N3 |
| 施 | N1 |
| 旨 | N1 |
| 枝 | N2 |
| 氏 | N2 |
| 獅 | N1 |
| 糸 | N4 |
| 肢 | N1 |
| 視 | N2 |
| 詞 | N2 |
| 詩 | N2 |
| 諮 | N1 |
| 雌 | N1 |
| 似 | N2 |
| 侍 | N1 |
| 寺 | N5 |
| 次 | N3 |
| 滋 | N1 |
| 璽 | N1 |
| 磁 | N1 |
| 而 | N1 |
| 蒔 | N1 |
| 鹿 | N2 |
| 識 | N3 |
| 軸 | N1 |
| 叱 | N1 |
| 嫉 | N1 |
| 湿 | N2 |
| 漆 | N1 |
| 疾 | N1 |
| 質 | N4 |
| 偲 | N1 |
| 縞 | N1 |
| 射 | N2 |
| 捨 | N3 |
| 赦 | N1 |
| 斜 | N2 |
| 煮 | N1 |
| 車 | N5 |
| 遮 | N1 |
| 邪 | N1 |
| 勺 | N1 |
| 尺 | N1 |
| 灼 | N1 |
| 釈 | N1 |
| 錫 | N1 |
| 寂 | N1 |
| 弱 | N4 |
| 朱 | N1 |
| 狩 | N1 |
| 珠 | N1 |
| 種 | N3 |
| 腫 | N1 |
| 趣 | N1 |
| 酒 | N4 |
| 儒 | N1 |
| 寿 | N1 |
| 授 | N3 |
| 樹 | N1 |
| 囚 | N1 |
| 宗 | N2 |
| 修 | N2 |
| 愁 | N1 |
| 秀 | N1 |
| 秋 | N4 |
| 臭 | N1 |
| 衆 | N2 |
| 週 | N3 |
| 酬 | N1 |
| 醜 | N1 |
| 充 | N2 |
| 柔 | N2 |
| 渋 | N2 |
| 獣 | N1 |
| 銃 | N2 |
| 淑 | N1 |
| 祝 | N3 |
| 粛 | N1 |
| 熟 | N2 |
| 述 | N2 |
| 俊 | N1 |
| 春 | N4 |
| 竣 | N1 |
| 駿 | N1 |
| 循 | N1 |
| 殉 | N1 |
| 準 | N3 |
| 潤 | N1 |
| 盾 | N1 |
| 純 | N2 |
| 遵 | N1 |
| 醇 | N1 |
| 順 | N3 |
| 初 | N3 |
| 庶 | N1 |
| 緒 | N2 |
| 署 | N2 |
| 諸 | N1 |
| 助 | N3 |
| 叙 | N1 |
| 序 | N2 |
| 除 | N2 |
| 傷 | N2 |
| 償 | N1 |
| 匠 | N1 |
| 唱 | N1 |
| 嘗 | N1 |
| 奨 | N1 |
| 娼 | N1 |
| 宵 | N1 |
| 尚 | N1 |
| 床 | N2 |
| 彰 | N1 |
| 抄 | N1 |
| 掌 | N1 |
| 昭 | N2 |
| 松 | N2 |
| 渉 | N1 |
| 照 | N2 |
| 症 | N2 |
| 省 | N2 |
| 硝 | N1 |
| 礁 | N1 |
| 称 | N1 |
| 章 | N2 |
| 蕉 | N1 |
| 衝 | N1 |
| 訟 | N1 |
| 詔 | N1 |
| 詳 | N2 |
| 象 | N2 |
| 障 | N1 |
| 丈 | N1 |
| 乗 | N4 |
| 冗 | N2 |
| 剰 | N1 |
| 城 | N2 |
| 壌 | N1 |
| 嬢 | N1 |
| 条 | N2 |
| 杖 | N1 |
| 浄 | N2 |
| 状 | N2 |
| 畳 | N2 |
| 譲 | N1 |
| 醸 | N1 |
| 錠 | N1 |
| 嘱 | N1 |
| 殖 | N1 |
| 触 | N2 |
| 辱 | N1 |
| 尻 | N1 |
| 伸 | N3 |
| 侵 | N2 |
| 唇 | N1 |
| 娠 | N1 |
| 慎 | N1 |
| 振 | N2 |
| 浸 | N1 |
| 深 | N3 |
| 疹 | N1 |
| 紳 | N1 |
| 臣 | N3 |
| 芯 | N1 |
| 薪 | N1 |
| 診 | N2 |
| 身 | N3 |
| 辛 | N2 |
| 進 | N3 |
| 針 | N2 |
| 仁 | N1 |
| 刃 | N1 |
| 尋 | N1 |
| 甚 | N1 |
| 腎 | N1 |
| 訊 | N1 |
| 迅 | N1 |
| 陣 | N1 |
| 笥 | N1 |
| 須 | N1 |
| 酢 | N2 |
| 吹 | N2 |
| 垂 | N1 |
| 帥 | N1 |
| 推 | N1 |
| 水 | N5 |
| 炊 | N1 |
| 衰 | N1 |
| 酔 | N3 |
| 随 | N1 |
| 髄 | N1 |
| 崇 | N1 |
| 嵩 | N1 |
| 枢 | N1 |
| 雛 | N1 |
| 据 | N1 |
| 杉 | N2 |
| 雀 | N1 |
| 裾 | N1 |
| 澄 | N1 |
| 寸 | N4 |
| 世 | N4 |
| 畝 | N1 |
| 是 | N1 |
| 凄 | N1 |
| 勢 | N2 |
| 姓 | N2 |
| 征 | N1 |
| 整 | N2 |
| 星 | N4 |
| 晴 | N4 |
| 正 | N4 |
| 清 | N2 |
| 牲 | N1 |
| 盛 | N2 |
| 精 | N2 |
| 製 | N2 |
| 西 | N5 |
| 誠 | N1 |
| 誓 | N1 |
| 請 | N1 |
| 逝 | N1 |
| 醒 | N1 |
| 隻 | N1 |
| 斥 | N1 |
| 析 | N1 |
| 積 | N3 |
| 籍 | N2 |
| 蹟 | N1 |
| 拙 | N1 |
| 摂 | N1 |
| 窃 | N1 |
| 絶 | N2 |
| 舌 | N2 |
| 仙 | N1 |
| 宣 | N1 |
| 専 | N2 |
| 栓 | N1 |
| 潜 | N1 |
| 穿 | N1 |
| 繊 | N1 |
| 腺 | N1 |
| 舛 | N1 |
| 薦 | N1 |
| 詮 | N1 |
| 践 | N1 |
| 銭 | N1 |
| 閃 | N1 |
| 善 | N2 |
| 全 | N3 |
| 禅 | N1 |
| 噌 | N1 |
| 塑 | N1 |
| 措 | N1 |
| 狙 | N1 |
| 疎 | N1 |
| 礎 | N1 |
| 租 | N1 |
| 素 | N2 |
| 組 | N3 |
| 蘇 | N1 |
| 阻 | N1 |
| 遡 | N1 |
| 創 | N1 |
| 双 | N2 |
| 叢 | N1 |
| 倉 | N1 |
| 喪 | N1 |
| 壮 | N1 |
| 層 | N2 |
| 捜 | N2 |
| 掃 | N2 |
| 曹 | N1 |
| 巣 | N2 |
| 槍 | N1 |
| 漕 | N1 |
| 燥 | N2 |
| 痩 | N1 |
| 窓 | N3 |
| 総 | N2 |
| 綜 | N1 |
| 聡 | N1 |
| 草 | N4 |
| 荘 | N2 |
| 葬 | N1 |
| 蒼 | N1 |
| 藻 | N1 |
| 霜 | N1 |
| 騒 | N2 |
| 像 | N2 |
| 蔵 | N2 |
| 贈 | N2 |
| 造 | N3 |
| 促 | N1 |
| 即 | N2 |
| 息 | N3 |
| 捉 | N1 |
| 俗 | N1 |
| 属 | N1 |
| 賊 | N1 |
| 袖 | N1 |
| 其 | N1 |
| 揃 | N1 |
| 孫 | N2 |
| 尊 | N2 |
| 損 | N2 |
| 太 | N3 |
| 汰 | N1 |
| 堕 | N1 |
| 妥 | N3 |
| 惰 | N1 |
| 楕 | N1 |
| 陀 | N1 |
| 耐 | N1 |
| 態 | N2 |
| 泰 | N1 |
| 滞 | N2 |
| 胎 | N1 |
| 苔 | N1 |
| 退 | N3 |
| 逮 | N1 |
| 隊 | N2 |
| 鯛 | N1 |
| 台 | N1 |
| 第 | N3 |
| 鷹 | N1 |
| 滝 | N2 |
| 托 | N1 |
| 択 | N1 |
| 拓 | N1 |
| 沢 | N2 |
| 濁 | N1 |
| 茸 | N1 |
| 凧 | N1 |
| 但 | N1 |
| 達 | N3 |
| 辰 | N1 |
| 奪 | N1 |
| 脱 | N2 |
| 棚 | N1 |
| 谷 | N4 |
| 狸 | N1 |
| 鱈 | N1 |
| 樽 | N1 |
| 誰 | N2 |
| 嘆 | N1 |
| 担 | N3 |
| 探 | N3 |
| 淡 | N1 |
| 炭 | N2 |
| 端 | N2 |
| 綻 | N1 |
| 胆 | N1 |
| 誕 | N2 |
| 鍛 | N1 |
| 団 | N3 |
| 弾 | N1 |
| 断 | N3 |
| 談 | N3 |
| 知 | N4 |
| 智 | N1 |
| 稚 | N1 |
| 置 | N3 |
| 致 | N2 |
| 遅 | N4 |
| 畜 | N2 |
| 筑 | N1 |
| 逐 | N1 |
| 秩 | N2 |
| 窒 | N1 |
| 茶 | N5 |
| 嫡 | N1 |
| 仲 | N3 |
| 忠 | N1 |
| 抽 | N1 |
| 虫 | N4 |
| 衷 | N1 |
| 酎 | N1 |
| 鋳 | N1 |
| 駐 | N2 |
| 猪 | N1 |
| 丁 | N2 |
| 兆 | N1 |
| 寵 | N1 |
| 帳 | N2 |
| 庁 | N2 |
| 弔 | N1 |
| 懲 | N1 |
| 暢 | N1 |
| 潮 | N1 |
| 聴 | N1 |
| 脹 | N1 |
| 腸 | N1 |
| 蝶 | N1 |
| 超 | N2 |
| 跳 | N1 |
| 勅 | N1 |
| 捗 | N1 |
| 直 | N3 |
| 朕 | N1 |
| 沈 | N2 |
| 珍 | N2 |
| 鎮 | N1 |
| 陳 | N1 |
| 墜 | N1 |
| 椎 | N1 |
| 掴 | N2 |
| 漬 | N1 |
| 辻 | N1 |
| 潰 | N1 |
| 吊 | N1 |
| 亭 | N1 |
| 低 | N4 |
| 停 | N2 |
| 偵 | N1 |
| 剃 | N1 |
| 呈 | N1 |
| 堤 | N1 |
| 帝 | N1 |
| 底 | N3 |
| 庭 | N2 |
| 廷 | N1 |
| 抵 | N1 |
| 挺 | N1 |
| 提 | N1 |
| 梯 | N1 |
| 程 | N3 |
| 締 | N1 |
| 艇 | N1 |
| 訂 | N1 |
| 蹄 | N1 |
| 逓 | N1 |
| 邸 | N1 |
| 泥 | N3 |
| 摘 | N1 |
| 擢 | N1 |
| 滴 | N2 |
| 的 | N3 |
| 笛 | N1 |
| 適 | N2 |
| 溺 | N1 |
| 徹 | N2 |
| 迭 | N1 |
| 鉄 | N4 |
| 典 | N3 |
| 展 | N2 |
| 店 | N4 |
| 添 | N1 |
| 纏 | N1 |
| 貼 | N1 |
| 点 | N3 |
| 殿 | N2 |
| 田 | N5 |
| 電 | N5 |
| 吐 | N2 |
| 妬 | N1 |
| 徒 | N3 |
| 登 | N3 |
| 賭 | N1 |
| 途 | N2 |
| 土 | N5 |
| 奴 | N1 |
| 党 | N2 |
| 冬 | N4 |
| 凍 | N2 |
| 刀 | N4 |
| 唐 | N1 |
| 島 | N3 |
| 悼 | N1 |
| 搭 | N1 |
| 桃 | N1 |
| 棟 | N1 |
| 盗 | N2 |
| 淘 | N1 |
| 湯 | N3 |
| 灯 | N2 |
| 痘 | N1 |
| 筒 | N2 |
| 到 | N2 |
| 藤 | N2 |
| 謄 | N1 |
| 豆 | N3 |
| 逃 | N2 |
| 透 | N1 |
| 陶 | N1 |
| 騰 | N1 |
| 働 | N4 |
| 堂 | N2 |
| 洞 | N2 |
| 瞳 | N1 |
| 童 | N1 |
| 道 | N3 |
| 得 | N2 |
| 徳 | N1 |
| 督 | N1 |
| 篤 | N1 |
| 毒 | N2 |
| 独 | N3 |
| 栃 | N2 |
| 凸 | N1 |
| 酉 | N1 |
| 屯 | N1 |
| 沌 | N1 |
| 豚 | N2 |
| 頓 | N1 |
| 呑 | N1 |
| 曇 | N1 |
| 奈 | N2 |
| 那 | N1 |
| 乍 | N4 |
| 凪 | N1 |
| 謎 | N1 |
| 鍋 | N1 |
| 馴 | N1 |
| 縄 | N1 |
| 汝 | N1 |
| 尼 | N1 |
| 弐 | N1 |
| 匂 | N1 |
| 肉 | N5 |
| 虹 | N1 |
| 尿 | N1 |
| 妊 | N2 |
| 忍 | N1 |
| 濡 | N1 |
| 寧 | N1 |
| 猫 | N2 |
| 念 | N3 |
| 撚 | N1 |
| 燃 | N3 |
| 粘 | N1 |
| 乃 | N1 |
| 之 | N1 |
| 悩 | N3 |
| 濃 | N2 |
| 能 | N3 |
| 脳 | N2 |
| 膿 | N1 |
| 農 | N3 |
| 覗 | N1 |
| 巴 | N4 |
| 把 | N1 |
| 覇 | N1 |
| 派 | N1 |
| 琶 | N1 |
| 罵 | N1 |
| 芭 | N1 |
| 馬 | N1 |
| 俳 | N2 |
| 廃 | N1 |
| 排 | N1 |
| 杯 | N3 |
| 背 | N3 |
| 肺 | N1 |
| 培 | N1 |
| 媒 | N1 |
| 梅 | N2 |
| 煤 | N1 |
| 賠 | N1 |
| 陪 | N1 |
| 秤 | N1 |
| 萩 | N1 |
| 剥 | N1 |
| 博 | N2 |
| 拍 | N2 |
| 柏 | N1 |
| 箔 | N1 |
| 粕 | N1 |
| 舶 | N1 |
| 漠 | N1 |
| 爆 | N2 |
| 縛 | N1 |
| 莫 | N1 |
| 麦 | N4 |
| 肌 | N2 |
| 髪 | N2 |
| 伐 | N1 |
| 抜 | N2 |
| 鳩 | N1 |
| 伴 | N1 |
| 判 | N3 |
| 半 | N5 |
| 反 | N4 |
| 帆 | N1 |
| 斑 | N1 |
| 板 | N3 |
| 氾 | N1 |
| 汎 | N1 |
| 版 | N2 |
| 班 | N1 |
| 畔 | N1 |
| 繁 | N1 |
| 般 | N2 |
| 販 | N2 |
| 範 | N1 |
| 煩 | N1 |
| 挽 | N1 |
| 番 | N1 |
| 蛮 | N1 |
| 卑 | N1 |
| 妃 | N1 |
| 庇 | N1 |
| 扉 | N1 |
| 批 | N2 |
| 披 | N1 |
| 斐 | N1 |
| 比 | N2 |
| 泌 | N1 |
| 疲 | N2 |
| 皮 | N3 |
| 秘 | N1 |
| 罷 | N1 |
| 肥 | N1 |
| 被 | N2 |
| 誹 | N1 |
| 費 | N3 |
| 非 | N3 |
| 樋 | N1 |
| 尾 | N1 |
| 琵 | N1 |
| 眉 | N1 |
| 美 | N2 |
| 彦 | N1 |
| 膝 | N1 |
| 肘 | N1 |
| 必 | N3 |
| 筆 | N3 |
| 姫 | N1 |
| 紐 | N1 |
| 氷 | N3 |
| 漂 | N1 |
| 瓢 | N1 |
| 票 | N2 |
| 表 | N3 |
| 豹 | N1 |
| 廟 | N1 |
| 描 | N1 |
| 苗 | N1 |
| 錨 | N1 |
| 蛭 | N1 |
| 浜 | N2 |
| 瀕 | N1 |
| 敏 | N1 |
| 瓶 | N2 |
| 埠 | N1 |
| 富 | N3 |
| 布 | N3 |
| 怖 | N2 |
| 扶 | N1 |
| 敷 | N2 |
| 斧 | N1 |
| 普 | N2 |
| 符 | N2 |
| 腐 | N1 |
| 膚 | N1 |
| 赴 | N1 |
| 附 | N1 |
| 侮 | N1 |
| 武 | N2 |
| 舞 | N2 |
| 封 | N2 |
| 風 | N4 |
| 伏 | N1 |
| 副 | N3 |
| 幅 | N2 |
| 服 | N4 |
| 腹 | N2 |
| 払 | N2 |
| 吻 | N1 |
| 噴 | N2 |
| 墳 | N1 |
| 憤 | N1 |
| 焚 | N1 |
| 奮 | N1 |
| 糞 | N1 |
| 紛 | N1 |
| 雰 | N1 |
| 併 | N1 |
| 兵 | N3 |
| 幣 | N1 |
| 弊 | N1 |
| 蔽 | N1 |
| 頁 | N4 |
| 壁 | N2 |
| 癖 | N1 |
| 瞥 | N1 |
| 蔑 | N1 |
| 偏 | N1 |
| 片 | N2 |
| 辺 | N4 |
| 遍 | N1 |
| 勉 | N4 |
| 娩 | N1 |
| 弁 | N1 |
| 捕 | N2 |
| 甫 | N1 |
| 穂 | N1 |
| 募 | N2 |
| 墓 | N1 |
| 慕 | N1 |
| 暮 | N2 |
| 菩 | N1 |
| 倣 | N1 |
| 俸 | N1 |
| 宝 | N2 |
| 崩 | N2 |
| 抱 | N2 |
| 捧 | N1 |
| 泡 | N2 |
| 砲 | N2 |
| 縫 | N1 |
| 胞 | N1 |
| 芳 | N1 |
| 萌 | N1 |
| 蜂 | N1 |
| 訪 | N2 |
| 豊 | N3 |
| 邦 | N1 |
| 乏 | N1 |
| 亡 | N3 |
| 傍 | N1 |
| 妨 | N1 |
| 帽 | N2 |
| 忘 | N3 |
| 忙 | N2 |
| 某 | N1 |
| 冒 | N1 |
| 紡 | N1 |
| 肪 | N2 |
| 膨 | N1 |
| 謀 | N1 |
| 貌 | N1 |
| 貿 | N3 |
| 防 | N2 |
| 北 | N5 |
| 僕 | N2 |
| 墨 | N1 |
| 撲 | N1 |
| 牧 | N2 |
| 睦 | N1 |
| 勃 | N1 |
| 没 | N1 |
| 殆 | N1 |
| 堀 | N1 |
| 幌 | N1 |
| 奔 | N1 |
| 盆 | N1 |
| 摩 | N1 |
| 磨 | N1 |
| 魔 | N1 |
| 幕 | N1 |
| 枕 | N1 |
| 鱒 | N1 |
| 又 | N1 |
| 抹 | N1 |
| 沫 | N1 |
| 迄 | N1 |
| 繭 | N1 |
| 慢 | N1 |
| 満 | N3 |
| 漫 | N1 |
| 蔓 | N1 |
| 魅 | N1 |
| 岬 | N1 |
| 密 | N1 |
| 蜜 | N1 |
| 脈 | N2 |
| 妙 | N1 |
| 務 | N2 |
| 霧 | N1 |
| 冥 | N1 |
| 命 | N2 |
| 盟 | N2 |
| 迷 | N2 |
| 鳴 | N4 |
| 滅 | N1 |
| 麺 | N1 |
| 摸 | N1 |
| 模 | N1 |
| 茂 | N1 |
| 妄 | N1 |
| 毛 | N4 |
| 猛 | N1 |
| 耗 | N1 |
| 蒙 | N1 |
| 儲 | N1 |
| 餅 | N1 |
| 尤 | N1 |
| 籾 | N1 |
| 紋 | N1 |
| 門 | N5 |
| 也 | N4 |
| 爺 | N2 |
| 野 | N4 |
| 弥 | N1 |
| 矢 | N4 |
| 厄 | N1 |
| 役 | N3 |
| 躍 | N1 |
| 靖 | N1 |
| 柳 | N1 |
| 愉 | N1 |
| 諭 | N1 |
| 悠 | N1 |
| 憂 | N1 |
| 柚 | N1 |
| 湧 | N1 |
| 猶 | N1 |
| 由 | N3 |
| 裕 | N1 |
| 誘 | N2 |
| 遊 | N2 |
| 郵 | N2 |
| 雄 | N1 |
| 融 | N2 |
| 与 | N4 |
| 誉 | N1 |
| 幼 | N3 |
| 妖 | N1 |
| 容 | N3 |
| 庸 | N1 |
| 洋 | N4 |
| 溶 | N2 |
| 羊 | N2 |
| 葉 | N3 |
| 要 | N3 |
| 謡 | N1 |
| 抑 | N1 |
| 欲 | N3 |
| 沃 | N1 |
| 浴 | N3 |
| 翌 | N3 |
| 翼 | N1 |
| 淀 | N1 |
| 羅 | N1 |
| 裸 | N1 |
| 酪 | N1 |
| 乱 | N2 |
| 卵 | N3 |
| 嵐 | N2 |
| 欄 | N1 |
| 濫 | N1 |
| 藍 | N1 |
| 蘭 | N1 |
| 覧 | N2 |
| 吏 | N4 |
| 履 | N1 |
| 李 | N1 |
| 梨 | N2 |
| 璃 | N1 |
| 痢 | N1 |
| 里 | N4 |
| 陸 | N3 |
| 率 | N3 |
| 掠 | N1 |
| 略 | N2 |
| 溜 | N1 |
| 硫 | N1 |
| 粒 | N2 |
| 隆 | N1 |
| 竜 | N1 |
| 龍 | N1 |
| 侶 | N1 |
| 慮 | N1 |
| 虜 | N1 |
| 了 | N2 |
| 僚 | N2 |
| 両 | N2 |
| 凌 | N1 |
| 梁 | N1 |
| 猟 | N1 |
| 瞭 | N1 |
| 糧 | N1 |
| 陵 | N1 |
| 領 | N2 |
| 緑 | N4 |
| 倫 | N1 |
| 厘 | N1 |
| 淋 | N1 |
| 臨 | N1 |
| 輪 | N2 |
| 隣 | N2 |
| 瑠 | N1 |
| 塁 | N1 |
| 累 | N1 |
| 類 | N3 |
| 令 | N2 |
| 例 | N3 |
| 励 | N2 |
| 隷 | N1 |
| 零 | N1 |
| 霊 | N1 |
| 麗 | N1 |
| 齢 | N2 |
| 暦 | N1 |
| 烈 | N1 |
| 裂 | N1 |
| 廉 | N1 |
| 恋 | N3 |
| 簾 | N1 |
| 蓮 | N1 |
| 呂 | N1 |
| 炉 | N1 |
| 賂 | N1 |
| 露 | N1 |
| 廊 | N2 |
| 楼 | N1 |
| 浪 | N1 |
| 漏 | N1 |
| 牢 | N1 |
| 狼 | N1 |
| 老 | N3 |
| 聾 | N1 |
| 蝋 | N1 |
| 麓 | N1 |
| 録 | N3 |
| 賄 | N1 |
| 惑 | N1 |
| 鷲 | N1 |
| 鰐 | N1 |
| 詫 | N1 |
| 藁 | N1 |
| 湾 | N2 |
| 腕 | N2 |
| 乂 | N1 |
| 傲 | N1 |
| 儿 | N1 |
| 冖 | N1 |
| 几 | N1 |
| 凵 | N1 |
| 刹 | N1 |
| 匚 | N4 |
| 卩 | N1 |
| 厂 | N1 |
| 咸 | N1 |
| 咬 | N1 |
| 喘 | N1 |
| 喩 | N1 |
| 嗅 | N1 |
| 嗜 | N1 |
| 嗽 | N1 |
| 囁 | N1 |
| 囃 | N1 |
| 埣 | N1 |
| 毀 | N1 |
| 夂 | N4 |
| 奢 | N1 |
| 姜 | N1 |
| 娶 | N1 |
| 宀 | N4 |
| 它 | N1 |
| 尢 | N1 |
| 尸 | N1 |
| 嵌 | N1 |
| 巫 | N1 |
| 并 | N1 |
| 广 | N4 |
| 廾 | N1 |
| 彙 | N1 |
| 彡 | N1 |
| 恣 | N1 |
| 惧 | N1 |
| 愕 | N1 |
| 慄 | N1 |
| 憬 | N1 |
| 戈 | N1 |
| 戌 | N1 |
| 扁 | N1 |
| 拗 | N1 |
| 拉 | N1 |
| 摯 | N1 |
| 攵 | N1 |
| 旡 | N1 |
| 曰 | N1 |
| 曷 | N1 |
| 橙 | N1 |
| 鬱 | N1 |
| 殳 | N1 |
| 毋 | N4 |
| 洒 | N1 |
| 涎 | N1 |
| 爛 | N1 |
| 爰 | N1 |
| 猥 | N1 |
| 璧 | N1 |
| 痰 | N1 |
| 瘍 | N1 |
| 皺 | N1 |
| 眩 | N1 |
| 瞑 | N1 |
| 箋 | N1 |
| 絆 | N1 |
| 綺 | N1 |
| 緻 | N1 |
| 縺 | N1 |
| 罠 | N1 |
| 羞 | N1 |
| 翔 | N1 |
| 脛 | N1 |
| 苺 | N1 |
| 茹 | N1 |
| 萬 | N1 |
| 虍 | N1 |
| 褻 | N1 |
| 訃 | N1 |
| 諧 | N1 |
| 謗 | N1 |
| 貪 | N1 |
| 踪 | N1 |
| 辣 | N1 |
| 錮 | N1 |
| 隶 | N1 |
| 隹 | N1 |
| 靄 | N1 |
| 颯 | N1 |
| 鯰 | N1 |
| 鹵 | N1 |
| 刂 | N1 |
| 夆 | N1 |
| 媸 | N1 |
| 彐 | N4 |
| 灬 | N4 |
| 䒑 | N1 |
| 辶 | N4 |
| 阝 | N1 |

## EXTRA

| kanji | placements |
| --- | --- |
| 伊 | N1 lesson 14 |
| 右 | N3 lesson 1, N5 lesson 10 |
| 雨 | N1 lesson 10, N2 lesson 3, N5 lesson 20 |
| 液 | N2 lesson 16 |
| 演 | N2 lesson 17, N3 lesson 12 |
| 恩 | N2 lesson 25 |
| 械 | N3 lesson 17 |
| 絵 | N1 lesson 10, N2 lesson 16, N5 lesson 9 |
| 顎 | N1 lesson 5 |
| 鑑 | N3 lesson 12 |
| 幾 | N1 lesson 18, N2 lesson 7 |
| 季 | N3 lesson 8 |
| 飢 | N2 lesson 12 |
| 疑 | N4 lesson 45 |
| 京 | N5 lesson 21 |
| 驚 | N2 lesson 23, N4 lesson 47 |
| 経 | N1 lesson 17, N3 lesson 21 |
| 継 | N1 lesson 9 |
| 県 | N5 lesson 21 |
| 原 | N4 lesson 36 |
| 古 | N1 lesson 25, N5 lesson 8 |
| 広 | N5 lesson 15 |
| 作 | N3 lesson 1 |
| 史 | N3 lesson 23 |
| 思 | N2 lesson 24 |
| 示 | N1 lesson 13 |
| 耳 | N5 lesson 11 |
| 自 | N5 lesson 13 |
| 写 | N2 lesson 14 |
| 拾 | N4 lesson 37 |
| 叔 | N2 lesson 22 |
| 粧 | N3 lesson 24 |
| 色 | N4 lesson 27 |
| 睡 | N3 lesson 7 |
| 政 | N3 lesson 23 |
| 税 | N3 lesson 21 |
| 績 | N3 lesson 13 |
| 跡 | N1 lesson 9, N2 lesson 2 |
| 雪 | N5 lesson 20 |
| 川 | N5 lesson 3 |
| 操 | N1 lesson 11 |
| 送 | N2 lesson 21, N3 lesson 6, N5 lesson 7 |
| 遭 | N2 lesson 1 |
| 則 | N3 lesson 18 |
| 束 | N4 lesson 46 |
| 族 | N3 lesson 14 |
| 卒 | N3 lesson 13 |
| 村 | N5 lesson 21 |
| 帯 | N1 lesson 23, N2 lesson 25 |
| 題 | N3 lesson 13 |
| 宅 | N3 lesson 15, N4 lesson 48 |
| 託 | N1 lesson 20 |
| 築 | N3 lesson 15 |
| 町 | N5 lesson 21 |
| 痛 | N1 lesson 21 |
| 怒 | N1 lesson 16, N3 lesson 20, N4 lesson 47 |
| 答 | N4 lesson 39 |
| 銅 | N1 lesson 3 |
| 如 | N1 lesson 16 |
| 敗 | N1 lesson 24 |
| 倍 | N4 lesson 42 |
| 否 | N1 lesson 15 |
| 碑 | N1 lesson 19 |
| 貧 | N3 lesson 25 |
| 婦 | N3 lesson 14 |
| 編 | N2 lesson 4 |
| 呆 | N1 lesson 4 |
| 毎 | N5 lesson 12 |
| 万 | N5 lesson 2 |
| 有 | N1 lesson 12, N2 lesson 5, N5 lesson 23 |
| 様 | N1 lesson 13, N3 lesson 1, N4 lesson 49 |
| 絡 | N4 lesson 46 |
| 律 | N1 lesson 23, N3 lesson 18 |
| 旅 | N3 lesson 10, N5 lesson 9 |
| 練 | N3 lesson 16 |
| 労 | N1 lesson 21 |
| 佚 | N2 lesson 9 |
| 嗚 | N1 lesson 1 |
| 炙 | N1 lesson 10 |
| 誂 | N1 lesson 8 |
