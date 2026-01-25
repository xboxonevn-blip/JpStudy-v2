# 🚀 JpStudy-v2 Roadmap (v2.3: Chiến lược Pro Max & Tối ưu Trải nghiệm)

## 🌟 Tầm nhìn (Vision)

Xây dựng nền tảng học tiếng Nhật toàn diện nhất, kết hợp tinh hoa từ các ứng dụng hàng đầu nhưng vẫn duy trì triết lý **"Zero-Cost Architecture" (Vận hành 0đ)**:

*   **🧠 Logic Anki/Quizlet:** Thuật toán SRS mạnh mẽ, chế độ học đa dạng. - ✅ Done
*   **🏗️ Cấu trúc LingoDeer:** Lộ trình học bài bản (Curriculum) + Gamification. - ✅ Done
*   **🧬 Chuyên sâu Bunpro:** Ngữ pháp Ghost Reviews. - ✅ Done
*   **📰 Immersion (Todaii/Migii):** Đọc báo và luyện đề thực chiến. - 📅 Planned

---

## 📊 Tổng quan Tiến độ (Build Status)

| Phase | Trọng tâm | Trạng thái | Dự kiến |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Foundation** (Anki Logic) | ✅ 100% | Done |
| **Phase 2** | **Structure** (LingoDeer Style) | ✅ 95% | Q1 2026 |
| **Phase 2.5** | **Visual Polish & Mnemonics** | 🚧 40% | In Progress |
| **Phase 3** | **Data Safety & Enrichment** | 🚧 10% | Feb 2026 |
| **Phase 4** | **Mastery & Immersion** | 📅 0% | Q2 2026 |

---

## 🧭 Các phần chưa thấy triển khai đầy đủ (đối chiếu codebase hiện tại)

Ký hiệu trạng thái: ✅ Done | 🚧 Partial | 📅 Planned | 🧪 Basic.

Mục này giúp theo dõi nhanh những hạng mục vẫn **chưa có hoặc chỉ mới ở mức stub/placeholder** trong code. Các mục chi tiết vẫn giữ ở phần dưới.

- **Test:** Adaptive Testing, Phân tích lỗi (đã triển khai). - ✅ Done
- **Match:** Time Attack Blitz (đã triển khai). - ✅ Done
- **Write (viết tay Kanji):** chưa có canvas viết tay, stroke order animation, recognition; hiện mới có write-mode dạng fill-blank. - 📅 Planned
- **Kanji Mastery:** Radical Explorer, Jukugo Blitz, Kanji UI upgrade, Kanji Stroke Order. - 📅 Planned
- **Visual Polish:** Particle effects, Glassmorphism overlay. - 📅 Planned
- **Data Safety:** Auto-backup local (mới có export/import thủ công). - 🚧 Partial
- **UX Fixes:** Auto-save state khi đang làm bài, Empty states mascot. - 📅 Planned
- **SRS Advanced:** FSRS, Leech protection, Intra-day learning, Load balancing. - 📅 Planned
- **Immersion:** Easy News, tap-to-lookup, quick-add SRS, furigana toggle. - 📅 Planned
- **Mastery & Immersion:** Full/Adaptive Mock Tests, Skill analytics, Pressure simulator. - 📅 Planned
- **Ghost Reviews (Advanced):** tự động hoá ôn lại điểm ngữ pháp sai trong ngữ cảnh đọc báo/đề. - 📅 Planned

Ghi chú: một số logic Ghost Review ngữ pháp hiện vẫn ở mức đơn giản (stub) trong code.

---

## 🛠️ Trạng thái Tính năng Core (Pro Max Upgrade)

Dựa trên đối soát codebase, đây là kế hoạch nâng cấp 4 chế độ luyện tập chính:

### 1. 📖 Learn (Học Tập) — ✅ Done
*   **Hiện tại:** Trắc nghiệm, Đúng/Sai, Điền khuyết cơ bản. - ✅ Done
*   **Pro Max Upgrade:**
    *   **Guided Interaction:** Học qua ngữ cảnh (Contextual Learning). - ✅ Done
    *   **Mnemonic Support:** Bổ sung câu chuyện gợi nhớ Kanji (Done for N5/N4). - ✅ Done

### 2. 📝 Test (Kiểm Tra) — ✅ Done
*   **Hiện tại:** Có timer, flagging, lưu lịch sử bài test. - ✅ Done
*   **Pro Max Upgrade:**
    *   **Adaptive Testing:** Tự động lặp lại các câu sai ở định dạng khác (Space Repetition trong cùng buổi test). - ✅ Done
    *   **Phân tích lỗi:** Gợi ý bài học liên quan khi user sai nhiều ở một mảng kiến thức. - ✅ Done

### 3. 🧩 Match (Nối Từ) — ✅ Done
*   **Hiện tại:** Lưới thẻ 3x3, có combo logic và ghi điểm XP. - ✅ Done
*   **Pro Max Upgrade:**
    *   **Time Attack Blitz:** Chế độ đua tốc độ với hiệu ứng vật lý (Particle effects). - ✅ Done

### 4. ✍️ Write (Viết) — 📅 Planned
*   **Mục tiêu:** Canvas vẽ tay Kanji thực tế. - 📅 Planned
*   **Pro Max Features:**
    *   **Stroke Order Animation:** Hướng dẫn nét vẽ mờ bên dưới. - 📅 Planned
    *   **Recognition Logic:** Tự động kiểm tra nét vẽ (Basic overlay comparison). - 📅 Planned

---

## 📅 Chi tiết các Phase

### ✅ Phase 1: Foundation (Nền tảng Từ vựng & SRS) — 100% Complete
**Mục tiêu:** Xây dựng hạ tầng dữ liệu và lõi thuật toán ghi nhớ.
*   **Hạ tầng dữ liệu (Infrastructure):**
    *   **SQLite Core:** Sử dụng Drift làm engine lưu trữ offline hoàn toàn. - ✅ Done
    *   **Smart Seeding:** Cơ chế nạp dữ liệu nhanh (Transaction + Version Check). - ✅ Done
    *   **Local Persistence:** Đảm bảo mọi tiến độ học tập được lưu cục bộ an toàn. - ✅ Done
*   **Thuật toán Ghi nhớ (SRS Logic):**
    *   **Anki Algorithm:** Thuật toán lặp lại ngắt quãng chuẩn (Interval, ease factor). - ✅ Done
    *   **4 Nút ôn tập:** Again, Hard, Good, Easy với logic tính toán ngày tái khám chính xác. - ✅ Done
    *   **Vocabulary SRS:** Theo dõi mức độ thuộc lòng của từng từ vựng riêng lẻ. - ✅ Done
*   **Trải nghiệm Flashcard:**
    *   **Card Flip:** Hiệu ứng lật thẻ mượt mà cho mặt Kanji/Nghĩa. - ✅ Done
    *   **Navigation:** Nút Previous/Next và phím tắt (Space/Arrows). - ✅ Done

### ✅ Phase 2: Structure + Retention Loop (Lộ trình & Ngữ pháp) — 95% Done
**Mục tiêu:** Tạo vòng lặp học tập có định hướng và mở rộng sang Ngữ pháp.
*   **Lộ trình học tập (Learning Path):**
    *   **Unit Map:** Bản đồ bài học trực quan từ Bài 1 đến Bài 50. - ✅ Done
    *   **Lesson Detail:** Màn hình chi tiết bài học với danh sách Từ vựng/Ngữ pháp/Kanji. - ✅ Done
    *   **Continue Button:** Thuật toán tìm bài học/buổi ôn tập cần ưu tiên nhất. - ✅ Done
*   **Hệ thống Ngữ pháp (Grammar System):**
    *   **Grammar DB:** Đầy đủ dữ liệu N5/N4 (Cấu trúc, Giải thích, Ví dụ). - ✅ Done
    *   **Localization:** Đã dịch 100% sang Tiếng Việt (Titles, Explanations, Examples). - ✅ Done
    *   **Ghost Reviews:** Cơ chế ôn tập lại các điểm ngữ pháp bị sai (giống Bunpro). - 🧪 Basic (đã có, còn đơn giản)
    *   **Diverse Exercises:** Trắc nghiệm, Điền khuyết, Sắp xếp câu (Sentence Builder). - ✅ Done
*   **Tối ưu UX & Phụ trợ:**
    *   **Mini Dashboard:** Hiển thị số lượng từ Due (cần ôn) và Streak ngày học. - ✅ Done
    *   **Mistake Bank:** Tự động lưu các câu sai vào "Ngân hàng lỗi sai". - ✅ Done
    *   **Localization:** Hệ thống chuyển đổi ngôn ngữ Việt/Anh toàn diện. - ✅ Done

### 🚧 Phase 2.5: Kanji Mastery & Visual Polish — 🚧 In Progress
**Mục tiêu:** Biến Kanji thành những mảnh ghép logic thay vì hình vẽ trừu tượng.
*   **Kanji Mastery (Học thuật):**
    *   **Kanji Data:** Đã nạp dữ liệu N5/N4. - ✅ Done
    *   **Mnemonic Stories:** Hỗ trợ câu chuyện gợi nhớ (100% N5/N4) và hiển thị trên Flashcard. - ✅ Done
    *   **Radical Explorer:** Bóc tách Kanji thành các bộ thủ thành phần để dễ nhớ. - 📅 Planned
    *   **Jukugo Blitz:** Chế độ luyện tập ghép Kanji thành từ vựng (Compound words). - 📅 Planned
*   **Tương tác & Visual (Juicy UI):**
    *   **Claymorphism UI:** Đồng bộ giao diện mềm mại cho Dashboard & Flashcards. - ✅ Done
    *   **Particle Effects:** Hiệu ứng bắn hạt (Confetti/Particles) khi chọn "Easy" hoặc hoàn thành chuỗi đúng (Dopamine loop). - 📅 Planned
    *   **Stroke Order:** Hướng dẫn vẽ nét Kanji (Animation & Canvas tô màu). - 📅 Planned
    *   **Glassmorphism Overlay:** Hiệu ứng làm nổi bật bộ thủ khi user chạm vào chữ Kanji. - 📅 Planned

### 🚧 Phase 3: Data Safety & Advanced Interaction (Next Priority)
*   **3.1 An toàn dữ liệu:**
    *   Import/Export Database ra file (Đảm bảo học tập 10 năm không mất dữ liệu). - ✅ Done
    *   Auto-backup local. - 📅 Planned
*   **3.2 Kanji Mastery:**
    *   **Kanji UI Upgrade:** Đồng bộ giao diện Kanji chuyên sâu như Flashcard. - 📅 Planned
    *   **Kanji Stroke Order:** Tích hợp bộ vẽ nét. - 📅 Planned
*   **3.3 UI Thừa hành (UX Fixes):**
    *   **Auto-save state:** Đang làm bài bấm thoát ra vẫn giữ được tiến độ. - 📅 Planned
    *   **Empty States:** Thêm Mascot cổ vũ khi hoàn thành bài học. - 📅 Planned
*   **3.4 SRS Advanced Logic (Tối ưu Trí nhớ):**
    *   **FSRS Algorithm:** Chuyển đổi từ SM-2 sang mô hình FSRS (hiện đại như Anki mới). - 📅 Planned
    *   **Leech Protection:** Tự động phát hiện và xử lý các từ vựng "khó nuốt" (sai quá nhiều lần). - 📅 Planned
    *   **Intra-day Learning:** Thiết lập các bước học trong ngày (1p -> 10p -> 1h) cho từ mới hoặc từ vừa sai. - 📅 Planned
    *   **Load Balancing (Fuzzy):** Điều tiết lượng bài ôn tập hàng ngày để tránh quá tải. - 📅 Planned

### 📅 Phase 4: Mastery & Immersion (Giai đoạn Bứt phá)
**Mục tiêu:** Chuyển đổi từ "Học" sang "Dùng" và chinh phục thực chiến JLPT.

*   **4.1 Immersion (Trạm đọc Thông minh - News Reader):**
    *   **Easy News Integration:** Đọc báo NHK News Web Easy trực tiếp (Offline cache). - 📅 Planned
    *   **Tap-to-lookup:** Chạm vào bất kỳ từ/cụm từ nào để tra nghĩa tức thì. - 📅 Planned
    *   **Quick-add SRS:** Lưu từ mới từ bài báo vào bộ thẻ ôn tập với 1 chạm. - 📅 Planned
    *   **Furigana Toggle:** Tự động điều chỉnh Furigana theo trình độ user. - 📅 Planned
*   **4.2 Mastery (Sát thủ JLPT - Mock Exam Suite):**
    *   **Full Mock Tests:** Bộ đề thi mô phỏng định dạng JLPT chuẩn (N5 -> N3). - 📅 Planned
    *   **Adaptive Mock Tests:** Tự động đề xuất ôn tập lại các mảng kiến thức bị hổng sau bài thi. - 📅 Planned
    *   **Skill Analytics:** Biểu đồ phân tích kỹ năng (Đọc hiểu, Từ vựng, Ngữ pháp). - 📅 Planned
    *   **Pressure Simulator:** Chế độ thi có áp lực thời gian thực. - 📅 Planned
*   **4.3 Ghost Reviews (Advanced):**
    *   Tự động hóa việc ôn tập các điểm ngữ pháp user thường xuyên làm sai trong lúc đọc báo hoặc làm đề. - 📅 Planned

---

## ⚡ Ưu Tiên Tiếp Theo (Next Steps)

1.  🚧 **Auto-backup local:** Hoàn thiện backup tự động cho dữ liệu học. - 🚧 Partial
2.  📚 **Rà soát N4 Vocab:** Đối soát đủ số lượng/độ phủ từ vựng N4 cho bài 26-50. - 📅 Planned
3.  🎨 **Refactor Training UI:** Thay đổi màu sắc/điều hướng cho 4 mode (Learn/Test/Match/Write) theo tone màu Pro Max. - 📅 Planned

---

## 🧩 Tech Stack
*   **Framework:** Flutter (Windows focus). - ✅ Done
*   **State:** Riverpod. - ✅ Done
*   **DB:** Drift (SQLite) - Offline first. - ✅ Done
*   **UI Style:** Custom Claymorphism (No violet/purple ban). - ✅ Done
