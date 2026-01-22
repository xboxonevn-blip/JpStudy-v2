# 🚀 JpStudy-v2 Roadmap (v2.2 Updated: Claymorphism + Full Localization + SRS Fixes)

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
| **Phase 2** | **Structure + Retention Loop** | LingoDeer & Bunpro | ✅ 90% | Q1 2026 |
| **Phase 2.5** | **Flashcard & Visual Polish** | Anki Logic + Claymorphism | ✅ 100% | Jan 2026 |
| **Phase 3** | **Data Safety & Immersion** | Import/Export + Easy News | � Starting | Feb 2026 |
| **Phase 4** | **Mastery** | Migii JLPT | 📅 | Q2 2026 |

---

## ✅ Phase 1: Foundation (Nền tảng Từ vựng & SRS) — 100% Complete

*(Đã hoàn thành)*

---

## ✅ Phase 2: Structure + Retention Loop (Ngữ pháp & Kanji) — 90% Done

**Mục tiêu:** Giữ chân + học hiệu quả bằng vòng lặp **Learn → Review (SRS) → Practice**.

### 2.0 Global UX Upgrade ✅
*   **2.0.1 Continue Button:** ✅ Auto-suggest next action (Grammar Due > Vocab Due).
*   **2.0.2 Mini Dashboard:** ✅ Daily goal, Streak, Due counters.
*   **2.0.3 Mistake Bank:** ✅ Kho lỗi tự động.
*   **2.0.4 Vocab SRS Global Review:** ✅ Anki-style (Again/Hard/Good/Easy).

### 2.1 Grammar System (Ngữ pháp) ✅
*   **2.1.1 Database:** ✅ N5/N4 Data + Seeding fix.
*   **2.1.2 Grammar UI:** ✅ Localized (Vi/En), Structure, Meaning.
*   **2.1.3 Grammar SRS:** ✅ Ghost Reviews basic flow.
*   **2.1.4 Grammar Exercises:** ✅ Fill-in-the-blank & MCQ.

### 2.2 Kanji Mastery (Chữ Hán) — 🚧 NEXT PRIORITY
*   **2.2.1 Database:** ✅ N5/N4 Kanji data available.
*   **2.2.2 Kanji UI Upgrade:** 🚧 Cần làm UI chuyên sâu như Flashcard.
*   **2.2.3 Kanji Stroke Order:** 📅 Tính năng vẽ/viết Kanji (Chưa làm).

---

## ✅ Phase 2.5: Flashcard & Visual Polish — 100% Complete

**Mục tiêu:** Đưa trải nghiệm về chuẩn **Quizlet** (visual) và **Anki** (logic).

### 1. � Visual & UI Overhaul (Done)
*   **Claymorphism:** ✅ Áp dụng toàn bộ cho Flashcard, Review buttons, Dashboard.
*   **Localization:** ✅ Full support Việt/Anh (Speech bubbles, Menus, Labels).
*   **Mascot:** ✅ Fix vị trí hội thoại, fix ngôn ngữ.

### 2. 🃏 Flashcard & Review Logic (Done)
*   **Swipe/Navigation:** ✅ Nút Previous/Next (Quizlet style).
*   **SRS Logic:** ✅ Nút "Start Learning" (khởi tạo SRS).
*   **Review Session:** ✅ Xử lý 4 nút Review (Again/Hard/Good/Easy) đúng chuẩn Anki.
*   **Progress:** ✅ Fix lỗi reset progress khi switch mode.

---

## 🚧 Phase 3: Data Safety & Immersion (Next Focus)

### 3.1 Data Safety (An toàn dữ liệu) — CRITICAL PRIORITY
*   **Import/Export:** 📅 Sao lưu database ra file (`.backup` hoặc `.json`) để user giữ dữ liệu.
*   **Auto Backup:** 📅 Cơ chế backup tự động local.

### 3.2 Immersion (Đọc hiểu)
*   **Easy News Reader:** Đọc báo offline.
*   **Tap-to-lookup:** Tra từ điển ngay trong bài đọc.

---

## �️ Tech Stack & Quality
*   **Framework:** Flutter (Windows focus).
*   **State:** Riverpod.
*   **DB:** Drift (SQLite).
*   **Build:** Windows (`nuget`, `cmake` issues resolved ✅).
*   **Quality:** `flutter analyze` clean ✅.

---

## ⚡ Ưu Tiên Phát Triển Tiếp Theo (Next Steps)

1.  🚧 **Data Backup/Restore (Import/Export):** 
    *   *Tại sao?* User học nhiều mà mất dữ liệu là thảm họa. Cần làm ngay.
2.  🚧 **Kanji Enhancement:**
    *   Nâng cấp UI bài học Kanji (tương tự Flashcard/Grammar).
    *   Stroke Order (Vẽ nét).
3.  📅 **Immersion Reader:**
    *   Bắt đầu làm trình đọc tin tức cơ bản.
