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
| **Phase 2.5** | **Flashcard & Review Fix** | Anki & Quizlet Standard | ✅ Finished | Q1 2026 |
| **Phase 3** | **Immersion** | Todaii / Easy Japanese | 📅 | Q2 2026 |
| **Phase 4** | **Mastery** | Migii JLPT | 📅 | Q3 2026 |

---

## ✅ Phase 1: Foundation (Nền tảng Từ vựng & SRS) — 100% Complete

*(Đã hoàn thành)*

---

## 🚧 Phase 2: Structure + Retention Loop (Ngữ pháp & Kanji chuyên sâu + UI giữ chân)

*(Giữ nguyên nội dung cũ...)*

**Mục tiêu Phase 2 mới:** Không chỉ “có dữ liệu”, mà phải giữ chân lâu + học hiệu quả bằng vòng lặp:
**Learn → Review (SRS) → Practice → Fix Mistakes → Continue**

### 2.0 Global UX Upgrade (Giữ chân người dùng toàn app) — NEW ✅

#### 2.0.1 “Continue Button” (Auto Next Best Action) — COMPLETED ✅
*   Thêm **Continue** ở Path/Home/Lesson.
*   **Ưu tiên:** Grammar Due > Vocab Due > Kanji Due > Practice Mixed > Next Lesson.
*   Hiển thị rõ: *“Continue: Grammar Review (5) / Fix Mistakes (2)…”*

#### 2.0.2 Mini Dashboard (Header card) — COMPLETED ✅
*   Daily goal (5–10 phút/ngày) + Streak + Due counters.
*   Due: Flashcards X | Grammar Y | Kanji Z.
*   Reward sau session: XP + streak + mastery tăng.

#### 2.0.3 Mistake Bank (Kho lỗi) — COMPLETED ✅
*   Mọi câu sai (Review/Practice) → tự vào **Mistake Bank**.
*   Tab “Fix Mistakes (n)” trong từng module và/hoặc dashboard.
*   Rule clear: đúng 2 lần liên tiếp → remove.

#### 2.0.4 Vocab SRS Global Review — COMPLETED ✅
*   Ôn tập từ vựng toàn diện (Global).
*   Màn hình ôn tập chuyên biệt với 4 mức độ (Again, Hard, Good, Easy).

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

### 2.4 Data Safety (An toàn dữ liệu) — CRITICAL NEW
*   **Import/Export:** Sao lưu toàn bộ tiến độ (database + preferences) ra file `.zip` hoặc `.json`.
*   **Auto Backup:** Tự động backup cục bộ định kỳ.

---

## 🔄 Phase 2.5: Flashcard & Review Overhaul (Cải tổ UI/UX Flashcard & Review)

**Mục tiêu:** Đưa trải nghiệm học về chuẩn **Quizlet** (học) và **Anki** (ôn tập), loại bỏ các thao tác thừa và giải quyết vấn đề logic Review.

### 1. 🃏 Flashcard UI (Chế độ Học) - Quizlet Style
**Mục tiêu:** Tạo môi trường học tập trung, không áp lực chấm điểm ngay lập tức.
*   **[Action] Thay đổi điều hướng:**
    *   Loại bỏ hoàn toàn cơ chế "Vuốt thẻ" (Swipe) kiểu Tinder.
    *   Thêm thanh điều hướng (Bottom Bar) với 2 nút lớn: **[← Trước/Previous]** và **[Sau/Next →]**.
    *   Cho phép lật thẻ bằng cách chạm vào bất kỳ đâu trên thẻ.
*   **[Action] Làm sạch giao diện (Clean UI):**
    *   Xóa bỏ các icon trạng thái "Đã thuộc/Cần học" (Checkmarks/Stars) trên mặt thẻ.
    *   Chuyển nút "Đánh dấu sao" (Star/Mark) lên góc trên bên phải, thiết kế nhỏ gọn tinh tế.
    *   Chỉ hiển thị nội dung học (Từ vựng/Nghĩa) làm trung tâm.

### 2. 🧠 Review Logic (Chế độ Ôn tập) - Anki Standard
**Mục tiêu:** Đảm bảo tính năng Review hoạt động đúng logic SRS (Lặp lại ngắt quãng).
*   **[Fix] Khởi tạo SRS (Initialize SRS):**
    *   Thêm nút **"Bắt đầu học" (Start Learning)** ở màn hình Lesson Detail nếu từ vựng chưa có trong hàng đợi SRS.
    *   Logic: Khi bấm "Start Learning", hệ thống sẽ nạp toàn bộ từ vựng của bài học đó vào SRS (Review Queue) với trạng thái ban đầu.
*   **[Fix] Xử lý trạng thái rỗng:**
    *   Nếu Review Queue trống (người dùng chưa học bài nào), hiển thị thông báo hướng dẫn rõ ràng: *"Bạn chưa có thẻ nào cần ôn tập. Hãy bắt đầu học bài mới!"*.

### 3. 🎨 Visual Polish & Consistency
*   **Claymorphism:** Áp dụng phong cách UI hiện tại (Clay) cho các nút điều hướng mới để đồng bộ.
*   **Shortcuts:** Hỗ trợ phím tắt (Mũi tên trái/phải/Space) để lật và chuyển thẻ trên Desktop.

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
2.  ✅ **Flashcard UI Overhaul** (Quizlet Style)
3.  ✅ **Review Logic Fix** (Start Learning Button)
4.  ✅ **Grammar Review (Ghost Reviews)** dạng session + MCQ mini
5.  ✅ **Data Safety (Backup/Restore)**

*Sau đó mới đến:*
*   Kanji Stroke Order
*   Immersion reader
*   JLPT full mock
