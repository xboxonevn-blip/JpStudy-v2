# 🚀 JpStudy-v2 Roadmap (v2.4: Smart Immersion & Cloud Ecosystem)

## 🌟 Tầm nhìn (Vision)
Xây dựng nền tảng học tiếng Nhật "All-in-One", kết hợp thuật toán thông minh (FSRS), trải nghiệm đắm mình (Immersion) và kết nối cộng đồng, duy trì triết lý **"Zero-Cost Architecture"**.

---

## 📊 Tổng quan Tiến độ (Build Status)

| Phase | Trọng tâm | Trạng thái | Dự kiến |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Foundation** (Anki Logic) | ✅ 100% | Completed |
| **Phase 2** | **Structure & Visuals** (LingoDeer + Clay UI) | ✅ 100% | Completed |
| **Phase 3** | **Smart Immersion** (FSRS + Auto-Ghost) | ?? 70% | Feb 2026 |
| **Phase 4** | **Cloud & AI** (Sync + Gemini) | 🧪 0% | Q2 2026 |

---

## 📅 Chi tiết các Phase

### ✅ Phase 1 & 2: Core Complete (Đã hoàn tất)
*   **Hạ Tầng:** Drift/SQLite, SRS (FSRS), Localization.
*   **Học Tập:** Flashcards, Quiz, Writer Mode (MVP), Context Learning.
*   **Giao Diện:** Claymorphism UI, Particle Effects, Mascot placeholders.
*   **Tính Năng:** Immersion Reader (Offline), Ghost Reviews (UI Manual), Mock Exams (N5/N4).

---

### ?? Phase 3: Smart Immersion & Algorithms (Current Priority)
**M?c ti?u:** N?ng c?p "b? n?o" c?a ?ng d?ng, gi?p h?c th?ng minh h?n, kh?ng ch? l? ch?m ch? h?n.

1.  **?? Ghost Review 2.0 (Auto-Integration):**
    *   [x] **Auto-Trigger:** T? ??ng t?o Ghost khi sai trong Learn/Review/Test/Grammar/Handwriting.
    *   [x] **Contextual Ghosts:** L?u k?m prompt/??p ?n/ngu?n ? Mistake Bank + Ghost Review.

2.  **?? FSRS Algorithm (N?ng c?p SRS):**
    *   [x] **Algorithm Swap:** Thay SM-2 b?ng FSRS cho vocab/grammar/kanji.
    *   [x] **Retrievability:** Hi?n th? x?c su?t nh? tr??c khi ch?n m?c ??.

3.  **?? Advanced Immersion (Not in scope for Phase 3):**
    *   [ ] **Context Search:** (Deferred)
    *   [ ] **Audio Sync:** (Deferred)

---

### ☁️ Phase 4: Cloud Ecosystem & AI (Future)
**Mục tiêu:** Mở rộng trải nghiệm đa nền tảng và hỗ trợ AI.

1.  **☁️ Cloud Sync (Free):**
    *   [ ] **Google Drive Backup:** Sync file database qua Google Drive API (Android/Windows).
    *   [ ] **Cross-device:** Học trên PC, ôn trên điện thoại.

2.  **🤖 AI Assistant (Gemini Flash):**
    *   [ ] **Why Wrong?**: Giải thích tại sao chọn đáp án sai.
    *   [ ] **Story Gen**: Tạo câu chuyện ngắn từ list từ vựng đang học.

3.  **🤝 Community:**
    *   [ ] **Share Decks:** Import/Export bộ từ vựng (JSON/QR).

---

## ✅ Feature Verification Checklist (QA)

| Feature | Status | Notes |
| :--- | :--- | :--- |
| **Clay UI System** | ✅ Done | Unified Theme, Buttons, Cards. |
| **Shadowing/TTS** | ✅ Done | Offline TTS windows/android. |
| **Writer Mode** | ✅ Done | Canvas drawing (Basic). |
| **Ghost Practice** | ✅ Done | Gamified with particles. |
| **Mock Exam** | ✅ Done | Timer, Scoring, Review. |
| **Handwriting Check** | ?? Partial | Basic stroke check + SRS; recognition pending.

---

## ?? UI Walkthrough Checklists

### Ghost Review
- [ ] M? Ghost Review t? Practice Hub ho?c banner.
- [ ] Ki?m tra hi?n th? ng? c?nh (prompt/??p ?n/ngu?n).
- [ ] B?m Practice v? x?c nh?n l?i gi?m sau khi l?m ??ng.

### Immersion Reader
- [ ] M? Immersion Reader (NHK/Local), t?i b?i.
- [ ] Tap t? ?? tra ngh?a; th?m v?o SRS; ki?m tra tr?ng th?i ?? l?u.
- [ ] B?t/t?t Furigana v? b?n d?ch.

### Handwriting
- [ ] V?o Write Mode ? Handwriting.
- [ ] V? n?t, ki?m tra k?t qu?; x?c nh?n SRS c?p nh?t.
- [ ] Sai th? t?o Mistake (Kanji).

### Mock Exam
- [ ] B?t ??u ?? N5/N4; ki?m tra timer v? flow.
- [ ] Ho?n th?nh; xem ?i?m & resume session.

## ? Next Priority Tasks
1.  ?? **N?ng c?p nh?n di?n n?t:** ch?m ?i?m theo th? t?/shape n?t.
2.  ?? **Kanji Ghost UX:** gom nh?m theo b?i + filter theo due.
3.  ?? **Mock Exam polish:** chia section, pressure timer, review flow.
