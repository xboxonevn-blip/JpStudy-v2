# 🚀 JpStudy-v2 Roadmap (v2.4: Smart Immersion & Cloud Ecosystem)

## 🌟 Tầm nhìn (Vision)
Xây dựng nền tảng học tiếng Nhật "All-in-One", kết hợp thuật toán thông minh (FSRS), trải nghiệm đắm mình (Immersion) và kết nối cộng đồng, duy trì triết lý **"Zero-Cost Architecture"**.

---

## 📊 Tổng quan Tiến độ (Build Status)

| Phase | Trọng tâm | Trạng thái | Dự kiến |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Foundation** (Anki Logic) | ✅ 100% | Completed |
| **Phase 2** | **Structure & Visuals** (LingoDeer + Clay UI) | ✅ 100% | Completed |
| **Phase 3** | **Smart Immersion** (FSRS + Handwriting) | 🚧 98% | Feb 2026 |
| **Phase 4** | **Cloud** (Sync) | 🧪 10% | Q2 2026 |

---

## 📅 Chi tiết các Phase

### ✅ Phase 1 & 2: Core Complete (Đã hoàn tất)
*   **Hạ Tầng:** Drift/SQLite, SRS (FSRS), Localization.
*   **Học Tập:** Flashcards, Quiz, Writer Mode (MVP), Context Learning.
*   **Giao Diện:** Claymorphism UI, Particle Effects, Mascot placeholders.
*   **Tính Năng:** Immersion Reader (Offline), Ghost Reviews (UI Manual), Mock Exams (N5/N4).

---

### 🚧 Phase 3: Smart Immersion & Algorithms (Current Priority)
**Mục tiêu:** Nâng cấp "bộ não" của ứng dụng, giúp học thông minh hơn, tập trung vào trải nghiệm viết và ôn tập.

1.  **👻 Ghost Review 2.0:**
    *   [x] **Auto-Trigger:** Tự động tạo Ghost khi sai trong Learn/Review/Test/Grammar/Handwriting.
    *   [x] **Contextual Ghosts:** Lưu kèm prompt/đáp án/nguồn vào Mistake Bank.

2.  **🧠 FSRS Algorithm (Nâng cấp SRS):**
    *   [x] **Algorithm Swap:** Thay SM-2 bằng FSRS cho vocab/grammar/kanji.
    *   [x] **Retrievability:** Hiển thị xác suất nhớ trước khi chọn mức độ.

3.  **✍️ Advanced Handwriting (Trọng tâm hiện tại):**
    *   [ ] **Stroke Check v2:** Kiểm tra thứ tự nét + shape matching chính xác hơn theo quality tier (manual/curated/generated), có benchmark false-positive/false-negative.
    *   [x] **Template Engine (Starter):** Tạo engine chấm theo template nét chuẩn + bộ template khởi đầu cho Kanji phổ biến.
    *   [x] **N5 Template Coverage:** Đã phủ template cho toàn bộ Kanji N5 (manual + generated baseline).
    *   [x] **N5 Manual Pack v1:** Nâng cấp bộ template thủ công cho nhóm Kanji nền tảng tần suất cao.
    *   [x] **N5 Manual Pack v2:** Thêm 20-30 Kanji N5 vào manual pack (đợt mở rộng).
    *   [x] **N4 Baseline Coverage:** Mở rộng template baseline cho toàn bộ Kanji N4 (generated, có metadata quality/level).
    *   [x] **N4 Curated/Manual Seed:** Khởi tạo curated pack + manual seed cho N4 để rollout theo độ tin cậy.
    *   [x] **N4 Promotion Wave 3:** Promote curated → manual theo ưu tiên Mistake Bank (có fallback lesson/stroke).
    *   [x] **Kanji Ghost:** Gom nhóm Kanji hay sai để luyện tập trung.

4.  **📚 Immersion UX (Mới):**
    *   [x] **Mark as Learned:** Đánh dấu bài đã hoàn thành (Progress tracking).
    *   [x] **Auto Scroll:** Tự động cuộn trang (Hands-free reading).

---

### ☁️ Phase 4: Cloud Ecosystem
**Mục tiêu:** Mở rộng trải nghiệm đa nền tảng

1.  **☁️ Cloud Sync (Free):**
    *   [ ] **Google Drive Backup:** Sync file database qua Google Drive API (Android/Windows).
    *   [x] **Export/Import:** Xuất/Nhập dữ liệu tiến độ (JSON/Zip).


---

## ✅ Feature Verification Checklist (QA)

| Feature | Status | Notes |
| :--- | :--- | :--- |
| **Clay UI System** | ✅ Done | Unified Theme, Buttons, Cards. |
| **Shadowing/TTS** | ✅ Done | Offline TTS windows/android. |
| **Writer Mode** | ✅ Done | Canvas drawing (Basic). |
| **Ghost Practice** | ✅ Done | Gamified with particles. |
| **Mock Exam** | ✅ Done | Timer, Scoring, Review. |
| **Immersion Reader Enhancements** | ✅ Done | Read-status + Auto-scroll + SRS add-word flow. |
| **Handwriting Check** | 🚧 Partial | Đã có chấm điểm stroke/shape/order heuristic; cần dữ liệu nét chuẩn để tăng độ chính xác. |

---

## 🧪 UI Walkthrough Checklists
> **QA Owner:** Project maintainer
> **Next full walkthrough target:** 2026-02-05


### Ghost Review
- [ ] Mở Ghost Review từ Practice Hub hoặc banner.
- [ ] Kiểm tra hiển thị ngữ cảnh (prompt/đáp án/nguồn).
- [ ] Bấm Practice và xác nhận lỗi giảm sau khi làm đúng.

### Immersion Reader
- [ ] Mở Immersion Reader (NHK/Local), tải bài.
    - [ ] Tap từ để tra nghĩa; thêm vào SRS; kiểm tra trạng thái đã lưu.
    - [ ] Bật/tắt Furigana và bản dịch.
    - [ ] Đánh dấu đã học (Mark as Learned).
    - [ ] Thử tính năng tự động cuộn (Auto Scroll).

### Handwriting
- [ ] Vào Write Mode ở Handwriting.
- [ ] Vẽ nét, kiểm tra kết quả; xác nhận SRS cập nhật.
- [ ] Sai thì tạo Mistake (Kanji).

### Mock Exam
- [ ] Bắt đầu đề N5/N4; kiểm tra timer và flow.
- [ ] Hoàn thành; xem điểm & resume session.

## 🚀 Next Priority Tasks (Now / Next / Later)

### NOW (2026-02-03 -> 2026-02-10)
1. 🔥 **Đóng Phase 3 - Stroke Check v2 (ưu tiên cao nhất)**
   - Scope: nâng độ chính xác kiểm tra thứ tự nét + shape matching cho nhóm N5/N4 manual/curated.
   - DoD:
     - [ ] Có bộ metric offline: Top-1 pass rate, false-positive rate theo từng quality tier.
     - [ ] Tune ngưỡng chấm theo tier `manual/curated/generated` có benchmark trước/sau.
     - [ ] Bổ sung test regression cho 20+ ca nét sai điển hình (order/shape/start-end).
     - [ ] QA walkthrough Handwriting pass toàn bộ checklist ở phần bên dưới.

### NEXT (2026-02-10 -> 2026-02-24)
2. ☁️ **Google Drive Backup MVP (Android/Windows)**
   - Scope: backup/restore DB + metadata settings, có conflict handling cơ bản.
   - DoD:
     - [ ] Backup thủ công thành công trên Android và Windows (2 thiết bị test).
     - [ ] Restore từ backup tạo lại đầy đủ progress/mistakes/SRS/settings.
     - [ ] Có versioning cho file backup + thông báo lỗi rõ ràng khi mismatch schema.
     - [ ] Có test happy path + corrupted backup path.

### LATER (sau 2026-02-24)
3. 💅 **Mock Exam Polish**
   - Scope: time pressure mode + review chi tiết sau bài.
   - DoD:
     - [ ] Có chế độ Time Pressure (config được per level N5/N4).
     - [ ] Màn review hiển thị phân tích theo phần + gợi ý ôn tập.
     - [ ] Theo dõi KPI: completion rate, average score, time spent trước/sau.

---

## 🧾 Latest Update (2026-02-03)
- ✅ Home UI/UX: làm mới Learning Path theo style tham chiếu cho cả mobile + desktop (top stats capsule + glowing lesson path + current lesson orb + CTA card), giữ nguyên luồng chức năng hiện có.
- ✅ Home UI/UX: clean-up pass theo feedback (Option 1 - Clean Product UI) cho mobile + desktop: giảm hiệu ứng glow, tăng card hierarchy, cải thiện độ đọc label/path/CTA, vẫn giữ nguyên toàn bộ route và hành vi.
- ✅ Home UI/UX: thêm Design Lab route (`/design-lab`) để xem quy trình Discover -> Visual -> Validate và theo dõi checklist trực tiếp.
- ✅ Docs: thêm `docs/uiux-progress.md` và `docs/uiux-review-checklist.md` để log tiến trình + checklist review theo vòng lặp thiết kế.
- ✅ Tooling: thêm workflow runner `tooling/run_promotion_workflow.py` để tự động chạy promote theo lịch (`app-start`/`weekly`) + gate theo `interval-days`.
- ✅ Tooling: mỗi lần promote ghi history JSON vào `tooling/reports/n4_promotion_history.json`; lưu state lịch tại `tooling/reports/n4_promotion_schedule_state.json`.
- ✅ Docs: thêm `tooling/README.md` hướng dẫn chạy schedule/force-run/report.
- ✅ Sửa toàn bộ lỗi compile hiện tại; `flutter analyze` đã sạch lỗi.
- ✅ Immersion Reader: hoàn tất đọc/đánh dấu đã đọc + auto-scroll + cập nhật UI trạng thái.
- ✅ Cải thiện Continue flow: thêm nhánh ưu tiên Kanji review.
- ✅ Cải thiện dashboard: refresh số liệu due/mistakes theo chu kỳ.
- ✅ Chuẩn hóa một phần i18n cho luồng Ghost Practice và Learning Path.
- ✅ Handwriting: nâng cấp chấm điểm với stroke count + shape fit + order heuristic.
- ✅ Handwriting: thêm template-based scoring engine (start/end/direction) + asset `stroke_templates.json` cho nhóm Kanji phổ biến.
- ✅ Handwriting: mở rộng template coverage full N5, thêm quality flag (`manual/generated`) để kiểm soát trọng số chấm.
- ✅ Handwriting: thêm manual override pack (N5 high-frequency) + asset overrides riêng để tinh chỉnh an toàn.
- ✅ Handwriting: thêm quality tier scoring (`manual/curated/generated`) để rollout template theo mức độ tin cậy.
- ✅ Handwriting: hoàn thành N5 manual pack v2 (mở rộng thêm 20-30 Kanji N5).
- ✅ Handwriting: mở rộng baseline coverage full N4, tổng template hiện tại: N5+N4.
- ✅ Handwriting: bắt đầu rollout N4 theo tier với curated pack + manual seed pack.
- ✅ Handwriting: promotion wave 3 cho N4 (curated -> manual) theo ưu tiên Mistake Bank.
- ✅ Handwriting UX: hiển thị breakdown điểm (S/Stk/Shp/Ord/Tmp) ngay sau khi Check để tune ngưỡng nhanh hơn.
- ✅ QA: thêm unit test cho template matcher + test coverage dữ liệu template (bao phủ N5/N4, kiểm tra số nét).
- ✅ Tooling: thêm script `tooling/generate_stroke_templates.py` để tái tạo baseline template ổn định cho N5/N4.
- ✅ Tooling: thêm script `tooling/promote_n4_curated_from_mistakes.py` để tự động promote curated N4 theo Mistake Bank.
- ✅ QA: thêm ngưỡng kiểm tra manual baseline N5 để tránh regress chất lượng template.
- ✅ QA: thêm ngưỡng kiểm tra curated/manual seed cho N4 để tránh regress rollout tier.
- ✅ Backup JSON: mở rộng export/import thêm mistakes, grammar/kanji SRS, progress, attempts, sessions, settings.
- ✅ Kanji Ghost: thêm nhóm luyện theo lesson trong Mistake Bank để luyện tập trung.
