# 🚀 JpStudy-v2 Roadmap (v2.1 Updated: UI xịn + Retention Loop + Grammar hiệu quả)

## 🌟 Tầm nhìn (Vision)

Xây dựng nền tảng học tiếng Nhật toàn diện nhất, kết hợp tinh hoa từ các ứng dụng hàng đầu nhưng vẫn miễn phí vận hành (0đ):

*   **🧠 Anki/Quizlet:** SRS mạnh, modes đa dạng.
*   **🏗️ LingoDeer/Duolingo:** Curriculum + gamification + “Continue loop”.
*   **🧬 Bunpro:** Grammar SRS chuyên sâu (Ghost Reviews).
*   **📰 Todaii/Migii:** Immersion + luyện thi JLPT thực chiến.

### 📉 Chiến lược Tối ưu Chi phí (Zero-Cost Architecture)

*   **Local-First:** chạy hoàn toàn offline (SQLite/Drift).
*   **No-Backend:** Backup/Restore file thay Cloud DB realtime.
*   **Open Data:** JMdict, Tatoeba, KanjiVG…

---

## 📅 Tổng quan Tiến độ (Phases)

| Phase | Tên gọi | Cảm hứng chính | Trạng thái | Dự kiến |
| :--- | :--- | :--- | :--- | :--- |
| **Phase 1** | **Foundation** | Anki & Quizlet | ✅ 100% | Q1 2026 |
| **Phase 2** | **Structure + Retention Loop** | LingoDeer & Bunpro + Duolingo loop | 🚧 | Q1–Q2 2026 |
| **Phase 3** | **Immersion** | Todaii / Easy Japanese | 📅 | Q2 2026 |
| **Phase 4** | **Mastery** | Migii JLPT | 📅 | Q3 2026 |

---

## ✅ Phase 1: Foundation (Nền tảng Từ vựng & SRS) — 100% Complete

*(Đã hoàn thành)*

---

## 🚧 Phase 2: Structure + Retention Loop (Ngữ pháp & Kanji chuyên sâu + UI giữ chân)

**Mục tiêu Phase 2 mới:** Không chỉ “có dữ liệu”, mà phải giữ chân lâu + học hiệu quả bằng vòng lặp:
**Learn → Review (SRS) → Practice → Fix Mistakes → Continue**

### 2.0 Global UX Upgrade (Giữ chân người dùng toàn app) — NEW ✅

#### 2.0.1 “Continue Button” (Auto Next Best Action) — HIGH IMPACT
*   Thêm **Continue** ở Path/Home/Lesson.
*   **Ưu tiên:** Grammar Due > Vocab Due > Kanji Due > Practice Mixed > Next Lesson.
*   Hiển thị rõ: *“Continue: Grammar Review (5) / Fix Mistakes (2)…”*

#### 2.0.2 Mini Dashboard (Header card) — HIGH
*   Daily goal (5–10 phút/ngày) + Streak + Due counters.
*   Due: Flashcards X | Grammar Y | Kanji Z.
*   Reward sau session: XP + streak + mastery tăng.

#### 2.0.3 Mistake Bank (Kho lỗi) — HIGH
*   Mọi câu sai (Review/Practice) → tự vào **Mistake Bank**.
*   Tab “Fix Mistakes (n)” trong từng module và/hoặc dashboard.
*   Rule clear: đúng 2 lần liên tiếp → remove.

### 2.1 Grammar System (Ngữ pháp) — ACTIVE (đã nâng cấp roadmap) ✅

#### 2.1.1 Grammar Database
*   Dữ liệu N5/N4 đầy đủ: pattern, meaning (Vi/En), structure, examples, tags.

#### 2.1.2 Grammar UI trong Lesson — UPGRADE: Learn/Review/Practice/Mistakes
*   Thay “chỉ list + expand” thành hệ chuẩn:
    *   **Learn:** danh sách ngữ pháp trong bài (card + expand).
    *   **Review (Ghost Reviews):** ôn SRS ngữ pháp.
    *   **Practice:** bài tập.
    *   **Mistakes:** sửa lỗi.
*   **Card grammar (Learn) nên có:**
    *   Title (pattern), subtitle (category/tag), example 1 dòng.
    *   Chips trạng thái: New / Learning / Due / Mastered.
    *   CTA nhanh: Add to Review + Practice.
*   **Detail (khi expand / bottom sheet):**
    *   Meaning (localized), Form/Structure, Examples (2–3), Common mistakes.
    *   Button: Review / Practice.

#### 2.1.3 Grammar SRS: Ghost Reviews — HIGH PRIORITY
*   Session nhanh: 5/10/20 items.
*   **Flow mỗi item (khuyến nghị):**
    *   Pattern + ví dụ → MCQ mini (nghĩa đúng / chọn pattern đúng).
    *   Show giải thích ngắn + next due.
*   End session: summary + XP + mastery progress.

#### 2.1.4 Grammar Exercises — Practice
*   **Fill-in-the-blank:** Ưu tiên UI Word Bank chips (nhanh, đỡ nản). Typing mode là tùy chọn.
*   **Multiple Choice:** Có “Why” 1–2 dòng (giải thích) để học thật.
*   **Mixed Practice (trộn bài) — NEW:** 70% Fill blank + 30% MCQ (giữ chân + giảm chán).

### 2.2 Kanji Mastery — PRIORITY ✅

#### 2.2.1 Kanji Database
*   N5/N4: Kanji, On/Kun, meaning, example.

#### 2.2.2 Kanji UI (đồng bộ session vibe như Flashcards/Grammar)
*   Learn/Review/Practice (tối thiểu Learn + Review).
*   Due counters + session 5/10/20.

#### 2.2.3 Kanji Stroke Order — NEXT
*   Hiển thị nét (KanjiVG).
*   Luyện vẽ (basic) + chấm đúng tương đối (optional).

### 2.3 Learning Path (Curriculum Map) — UPGRADE ✅
*   Bạn đã có Path dạng “road”, giờ nâng retention.

#### 2.3.1 Node States rõ ràng
*   Locked / Next / Completed / Perfect.
*   Hiển thị progress lesson: vocab/grammar/kanji mastered.

#### 2.3.2 Preview lesson khi click/hover
*   Lesson name + due counts + CTA “Continue”.

#### 2.3.3 Continue từ Path
*   Continue dẫn thẳng đến session đúng nhất (Grammar due, Mistakes…).

---

## 📅 Phase 3: Immersion (Đọc hiểu & Thực tế) — kế hoạch

*   Offline Easy News.
*   Tap-to-look-up (tra từ trong bài).
*   Save sentence → đưa vào SRS/mistakes.

---

## 📅 Phase 4: Mastery (Luyện thi & Đánh giá) — kế hoạch

*   JLPT Mock Tests N5–N1 (Koji, Bunpou, Dokkai).
*   Analytics (Radar/Progress).
*   Personalized weak-area training (dựa trên Mistake Bank + due).

---

## 🛠️ Tech Stack

*   Flutter + Riverpod + Drift + GoRouter + Localization.

---

## ⚡ Ưu Tiên Phát Triển Tiếp Theo (Next Steps Updated)

**Top 5 (impact cao nhất):**

1.  ✅ **Continue Button + Auto Next Best Action**
2.  ✅ **Grammar Review (Ghost Reviews)** dạng session + MCQ mini
3.  ✅ **Practice Mixed + Word Bank Fill blank**
4.  ✅ **Mistake Bank** (Fix Mistakes tab + rule clear)
5.  ✅ **Path node states + preview + Continue**

*Sau đó mới đến:*
*   Kanji Stroke Order
*   Immersion reader
*   JLPT full mock
