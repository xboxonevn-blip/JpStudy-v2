# 🚀 JpStudy-v2 Roadmap (v2.3: Chiến lược Pro Max & Tối ưu Trải nghiệm)

## 🌟 Tầm nhìn (Vision)

Xây dựng nền tảng học tiếng Nhật toàn diện nhất, kết hợp tinh hoa từ các ứng dụng hàng đầu nhưng vẫn duy trì triết lý **"Zero-Cost Architecture" (Vận hành 0đ)**:

*   **🧠 Logic Anki/Quizlet:** Thuật toán SRS mạnh mẽ, chế độ học đa dạng. - ✅ Done
*   **🏗️ Cấu trúc LingoDeer:** Lộ trình học bài bản (Curriculum) + Gamification. - ✅ Done
*   **🧬 Chuyên sâu Bunpro:** Ngữ pháp Ghost Reviews. - ✅ Done
*   **📰 Immersion (Todaii/Migii):** MVP đọc bài mẫu + lưu từ mới. - 🚧 Partial

---

## 📊 Tổng quan Tiến độ (Build Status)

| Phase | Trọng tâm | Trạng thái | Dự kiến |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Foundation** (Anki Logic) | ✅ 100% | Done |
| **Phase 2** | **Structure** (LingoDeer Style) | ✅ 95% | Done |
| **Phase 2.5** | **Visual Polish & Mnemonics** | ✅ 80% | In Progress |
| **Phase 3** | **Immersion & Refinement** | 🚧 40% | Feb 2026 |
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
    - **Clay UI System:** Design system Claymorphism thống nhất. - ✅ Done
    - **Daily Reminders & Backup:** Nhắc học + Tự động sao lưu. - ✅ Done

- **🚧/📅 Còn thiếu / đang phát triển:**
    - **Ghost Reviews (UI Integration):** Cần tích hợp sâu hơn vào Dashboard và luồng học chính. - 🚧 Partial
    - **Immersion Reader:** Đọc bài mẫu, tra từ (tap-to-lookup), lưu SRS. - 🚧 Partial (Có Logic & UI cơ bản)
    - **Handwriting (Viết Kanji):** Canvas viết tay & nhận diện nét. - 📅 Planned
    - **Writer Mode:** Mới chỉ có điền từ (typing), chưa có viết tay. - 🧪 Basic
    - **Mock Exams:** Đề thi thử (N5/N4) mô phỏng áp lực thời gian. - 🚧 Partial (Có khung sườn)

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

### 4. ✍️ Write (Viết) — 📅 Planned
*   **Current:** Write-mode dạng fill-blank (typing). - 🧪 Basic
*   **Next:** Handwriting Recognition & Stroke Order. - 📅 Planned

### 5. 👻 Ghost Review (Ôn Lỗi Sai) — 🚧 Partial
*   **Current:** Logic backend đã xong, màn hình review cơ bản đã có. - ✅ Done
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
    *   Offline Article Reader (Đọc bài mẫu offline). - 🚧 Partial
    *   Tap-to-lookup (Tra từ nhanh). - 🚧 Partial
    *   Quick-add SRS (Lưu từ vào Flashcard). - ✅ Done
*   **3.2 Ghost Review Integration:**
    *   Hoàn thiện UI cho Ghost Review. - 🚧 Partial
    *   Kết nối Ghost Review vào Practice Hub. - ✅ Done
*   **3.3 Mock Exam Suite:**
    *   Hoàn thiện UI thi thử (Timer, Progress Bar). - 🚧 Partial
    *   Chấm điểm & Review kết quả. - 📅 Planned

### 📅 Phase 4: Expansion & AI (Q2 2026)
**Trọng tâm:** Công nghệ nâng cao và mở rộng cộng đồng.

*   **Handwriting:** Nhận diện chữ viết tay.
*   **FSRS Algorithm:** Nâng cấp thuật toán SRS hiện đại.
*   **AI Pronunciation:** Check phát âm.
*   **Community:** Chia sẻ bộ từ vựng (Share Decks).

---

## ⚡ Ưu Tiên Tiếp Theo (Next Steps)

1.  🛠 **Immersion Polish:** Hoàn thiện giao diện đọc bài & tra từ.
2.  👻 **Ghost Review UI:** Đồng bộ giao diện Claymorphism cho màn hình Ghost Review.
3.  🧪 **Mock Exam:** Chạy thử nghiệm đề thi N4 đầy đủ.
