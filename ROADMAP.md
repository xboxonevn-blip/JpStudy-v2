# 🚀 JpStudy-v2 Roadmap (v2.3: Chiến lược Pro Max & Tối ưu Trải nghiệm)

## 🌟 Tầm nhìn (Vision)

Xây dựng nền tảng học tiếng Nhật toàn diện nhất, kết hợp tinh hoa từ các ứng dụng hàng đầu nhưng vẫn duy trì triết lý **"Zero-Cost Architecture" (Vận hành 0đ)**:

*   **🧠 Logic Anki/Quizlet:** Thuật toán SRS mạnh mẽ, chế độ học đa dạng. - ✅ Done
*   **🏗️ Cấu trúc LingoDeer:** Lộ trình học bài bản (Curriculum) + Gamification. - ✅ Done
*   **🧬 Chuyên sâu Bunpro:** Ngữ pháp Ghost Reviews. - ✅ Done
*   **📰 Immersion (Todaii/Migii):** MVP đọc bài mẫu + lưu từ mới. - ✅ Done

---

## 📊 Tổng quan Tiến độ (Build Status)

| Phase | Trọng tâm | Trạng thái | Dự kiến |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Foundation** (Anki Logic) | ✅ 100% | Done |
| **Phase 2** | **Structure** (LingoDeer Style) | ✅ 95% | Done |
| **Phase 2.5** | **Visual Polish & Mnemonics** | ✅ 80% | In Progress |
| **Phase 3** | **Immersion & Refinement** | 🚧 85% | Feb 2026 |
| **Phase 4** | **Expansion & AI** | 🧪 10% | Q2 2026 |

---

## 🧭 Đối chiếu codebase (Reality check)

Ký hiệu trạng thái: ✅ Done | 🚧 Partial | 📅 Planned | 🧪 Basic.

Mục này giúp đối chiếu nhanh roadmap ↔ codebase: những thứ **đã có nhưng chưa ghi**, và những thứ **còn thiếu/chưa hoàn thiện**.

- **✅ Đã hoàn thành (Implemented):**
    - **Offline TTS:** Đọc mẫu câu/từ vựng (Android/iOS/Windows). - ✅ Done
    - **Ghost Reviews (Logic):** Backend scheduling & logic chọn bài ôn. - ✅ Done
    - **Practice Hub:** Trung tâm truy cập nhanh các mode luyện tập. - ✅ Done
    - **Kanji Dash:** mini-game tăng tốc phản xạ. - ✅ Done
    - **Exam/Quiz Screen:** quiz nhanh 10 câu. - ✅ Done
    - **Ghost Reviews (UI Integration):** Tích hợp Dashboard + luồng học chính. - ✅ Done
    - **Immersion Reader:** Đọc bài mẫu, tra từ, lưu SRS. - ✅ Done
    - **Handwriting (Viết Kanji):** Canvas viết tay + nhận diện nét (MVP). - ✅ Done
    - **Writer Mode:** Typing + viết tay Kanji. - ✅ Done
    - **Mock Exams:** Đề thi thử N5/N4 có timer, chấm điểm, review. - ✅ Done
    - **Clay UI System:** Design system Claymorphism thống nhất. - ✅ Done
    - **Daily Reminders & Backup:** Nhắc học + Tự động sao lưu. - ✅ Done

- **🚧/📅 Còn thiếu / đang phát triển:**
    - **Ghost Reviews (Auto Trigger):** Kích hoạt từ bài đọc/test khi trả lời sai. - 🚧 Partial
    - **Handwriting nâng cao:** Thứ tự nét + nhận diện chính xác hơn. - 📅 Planned

---

## 🛠️ Trạng thái Tính năng Core (Pro Max Upgrade)

### 1. 📖 Learn (Học Tập) — ✅ Done
*   **Guided Interaction:** Học qua ngữ cảnh (Contextual Learning). - ✅ Done
*   **Mnemonic Support:** Bổ sung câu chuyện gợi nhớ Kanji (Done for N5/N4). - ✅ Done

### 2. 📝 Test (Kiểm Tra) — ✅ Done
*   **Adaptive Testing:** Tự động lặp lại các câu sai. - ✅ Done
*   **Test Analysis:** Phân tích lỗi sai & gợi ý ôn tập. - ✅ Done

### 3. 🧩 Match (Nối Từ) — ✅ Done
*   **Time Attack Blitz:** Đua tốc độ với hiệu ứng vật lý. - ✅ Done

### 4. ✍️ Write (Viết) — ✅ Done (MVP)
*   **Current:** Write-mode typing + viết tay Kanji (canvas + check nét). - ✅ Done
*   **Next:** Stroke order & nhận diện nâng cao. - 📅 Planned

### 5. 👻 Ghost Review (Ôn Lỗi Sai) — 🚧 Partial
*   **Current:** Logic backend + UI tích hợp Dashboard/Practice Hub. - ✅ Done
*   **Next:** Tự động kích hoạt Ghost Review khi làm sai trong bài đọc/test. - 🚧 Partial

---

## 📅 Chi tiết các Phase (Updated)

### ✅ Phase 1 & 2: Core Foundation & Structure — Completed
*   Hạ tầng dữ liệu (Drift/SQLite).
*   Thuật toán SRS (Anki-like).
*   Lộ trình bài học (Lesson 1-50).
*   Ngữ pháp & Từ vựng N5/N4.
*   Localization (Việt/Anh).

### 🚧 Phase 3: Immersion & Refinement (Mục tiêu hiện tại)
**Trọng tâm:** Ổn định tính năng mới và hoàn thiện trải nghiệm đọc hiểu/ôn tập.

*   **3.1 Immersion (Trạm đọc):**
    *   Offline Article Reader (Đọc bài mẫu offline). - ✅ Done
    *   Tap-to-lookup (Tra từ nhanh). - ✅ Done
    *   Quick-add SRS (Lưu từ vào Flashcard). - ✅ Done
*   **3.2 Ghost Review Integration:**
    *   Hoàn thiện UI cho Ghost Review. - ✅ Done
    *   Kết nối Ghost Review vào Practice Hub. - ✅ Done
*   **3.3 Mock Exam Suite:**
    *   Hoàn thiện UI thi thử (Timer, Progress Bar). - ✅ Done
    *   Chấm điểm & Review kết quả. - ✅ Done

### 📅 Phase 4: Expansion & AI (Q2 2026)
**Trọng tâm:** Công nghệ nâng cao và mở rộng cộng đồng.

*   **Handwriting:** Nhận diện chữ viết tay.
*   **FSRS Algorithm:** Nâng cấp thuật toán SRS hiện đại.
*   **AI Pronunciation:** Check phát âm.
*   **Community:** Chia sẻ bộ từ vựng (Share Decks).

---

## ✅ UI Walkthrough Checklist (QA nhanh)

**Ghost Review**
- Mở Home → thấy banner “Ôn lỗi” khi có ghost; nhấn “Ôn ngay” đi vào Ghost Practice.
- Practice Hub hiển thị tile Ghost Review có badge số lượng.
- Mini Dashboard hiển thị count Ghost Reviews.

**Immersion Reader**
- Practice Hub → Immersion → mở bài NHK + bật/tắt Furigana.
- Tap từ có nghĩa → modal hiển thị nghĩa → Add to SRS.
- Từ đã lưu đổi màu + không cho add lại.

**Handwriting (Write Mode)**
- Vào Lesson → Write → chọn “Viết tay”.
- Canvas hiện gợi ý chữ, toggle guide, Undo/Clear hoạt động.
- Check đánh giá theo số nét + summary cuối phiên.

**Mock Exam**
- Practice Hub → Mock Exam → chọn N5/N4.
- Config có time limit mặc định; vào Test thấy timer + progress.
- Nộp bài → Result + Review Answers hiển thị đúng.

---

## ⚡ Ưu Tiên Tiếp Theo (Next Steps)

1.  ✍️ **Handwriting nâng cao:** Thứ tự nét + nhận diện chính xác hơn.
2.  🧠 **FSRS Upgrade:** Nâng cấp thuật toán SRS hiện đại.
3.  📰 **Immersion mở rộng:** Thêm nguồn bài đọc & từ điển.
