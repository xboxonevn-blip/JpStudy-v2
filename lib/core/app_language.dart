enum AppLanguage {
  en,
  vi,
  ja,
}

extension AppLanguageLabels on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.en:
        return 'English';
      case AppLanguage.vi:
        return 'Tiếng Việt';
      case AppLanguage.ja:
        return '日本語';
    }
  }

  String get shortCode {
    switch (this) {
      case AppLanguage.en:
        return 'EN';
      case AppLanguage.vi:
        return 'VI';
      case AppLanguage.ja:
        return 'JA';
    }
  }

  String get levelMenuTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Select JLPT level';
      case AppLanguage.vi:
        return 'Chọn cấp JLPT';
      case AppLanguage.ja:
        return 'JLPTレベルを選択';
    }
  }

  String get levelMenuSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Pick a level to tailor quizzes and exams.';
      case AppLanguage.vi:
        return 'Chọn cấp để cá nhân hóa quiz và thi thử.';
      case AppLanguage.ja:
        return 'レベルを選んでクイズと模試を最適化します。';
    }
  }

  String get changeLevelLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Change level';
      case AppLanguage.vi:
        return 'Đổi cấp';
      case AppLanguage.ja:
        return 'レベル変更';
    }
  }

  String get backToLevelsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Back to levels';
      case AppLanguage.vi:
        return 'Về chọn cấp';
      case AppLanguage.ja:
        return 'レベル選択へ';
    }
  }

  String get languageMenuLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Language';
      case AppLanguage.vi:
        return 'Ngôn ngữ';
      case AppLanguage.ja:
        return '言語';
    }
  }

  String get levelLabelPrefix {
    switch (this) {
      case AppLanguage.en:
        return 'Level: ';
      case AppLanguage.vi:
        return 'Cấp: ';
      case AppLanguage.ja:
        return 'レベル: ';
    }
  }

  String get mvpModulesTitle {
    switch (this) {
      case AppLanguage.en:
        return 'MVP modules';
      case AppLanguage.vi:
        return 'Module MVP';
      case AppLanguage.ja:
        return 'MVPモジュール';
    }
  }

  String get lessonPickerTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Choose lessons';
      case AppLanguage.vi:
        return 'Chọn bài học';
      case AppLanguage.ja:
        return 'レッスンを選択';
    }
  }

  String get filterAllLabel {
    switch (this) {
      case AppLanguage.en:
        return 'All';
      case AppLanguage.vi:
        return 'Tất cả';
      case AppLanguage.ja:
        return 'すべて';
    }
  }

  String get recentItemsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Recent items';
      case AppLanguage.vi:
        return 'Các mục gần đây';
      case AppLanguage.ja:
        return '最近の項目';
    }
  }

  String get searchFolderHint {
    switch (this) {
      case AppLanguage.en:
        return 'Search in this folder';
      case AppLanguage.vi:
        return 'Tìm kiếm thư mục này';
      case AppLanguage.ja:
        return 'このフォルダ内を検索';
    }
  }

  String lessonTitle(int index) {
    switch (this) {
      case AppLanguage.en:
        return 'Minna No Nihongo $index';
      case AppLanguage.vi:
        return 'Minna No Nihongo $index';
      case AppLanguage.ja:
        return 'みんなの日本語 $index';
    }
  }

  String lessonSubtitle(int termCount) {
    switch (this) {
      case AppLanguage.en:
        return 'Set • $termCount terms';
      case AppLanguage.vi:
        return 'Học phần • $termCount thuật ngữ';
      case AppLanguage.ja:
        return '学習セット・$termCount 語';
    }
  }

  String get savedLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Saved';
      case AppLanguage.vi:
        return 'Đã lưu';
      case AppLanguage.ja:
        return '保存済み';
    }
  }

  String get groupLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Group';
      case AppLanguage.vi:
        return 'Nhóm';
      case AppLanguage.ja:
        return 'グループ';
    }
  }

  String lessonLearnersLabel(int people, int days) {
    switch (this) {
      case AppLanguage.en:
        return '$people learners in last $days days';
      case AppLanguage.vi:
        return '$people người học trong $days ngày qua';
      case AppLanguage.ja:
        return '過去$days日で$people人が学習';
    }
  }

  String lessonRatingLabel(double rating, int reviews) {
    final ratingText = rating.toStringAsFixed(1);
    switch (this) {
      case AppLanguage.en:
        return '$ratingText ($reviews reviews)';
      case AppLanguage.vi:
        return '$ratingText ($reviews đánh giá)';
      case AppLanguage.ja:
        return '$ratingText（$reviews件）';
    }
  }

  String get lastStudiedSample {
    switch (this) {
      case AppLanguage.en:
        return '2 hours ago';
      case AppLanguage.vi:
        return '2 giờ trước';
      case AppLanguage.ja:
        return '2時間前';
    }
  }

  String lastStudiedLabel(String timeAgo) {
    switch (this) {
      case AppLanguage.en:
        return 'Last studied: $timeAgo';
      case AppLanguage.vi:
        return 'Lần học cuối: $timeAgo';
      case AppLanguage.ja:
        return '最後の学習: $timeAgo';
    }
  }

  String get copySetLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Make a copy';
      case AppLanguage.vi:
        return 'Tạo một bản sao';
      case AppLanguage.ja:
        return 'コピーを作成';
    }
  }

  String get resetProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Reset progress';
      case AppLanguage.vi:
        return 'Đặt lại tiến độ';
      case AppLanguage.ja:
        return '進捗をリセット';
    }
  }

  String get combineSetLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Combine';
      case AppLanguage.vi:
        return 'Ghép';
      case AppLanguage.ja:
        return '結合';
    }
  }

  String get reportLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Report';
      case AppLanguage.vi:
        return 'Báo cáo';
      case AppLanguage.ja:
        return '報告';
    }
  }

  String get flashcardsAction {
    switch (this) {
      case AppLanguage.en:
        return 'Flashcards';
      case AppLanguage.vi:
        return 'Thẻ ghi nhớ';
      case AppLanguage.ja:
        return '単語カード';
    }
  }

  String get learnAction {
    switch (this) {
      case AppLanguage.en:
        return 'Learn';
      case AppLanguage.vi:
        return 'Học';
      case AppLanguage.ja:
        return '学習';
    }
  }

  String get testAction {
    switch (this) {
      case AppLanguage.en:
        return 'Test';
      case AppLanguage.vi:
        return 'Kiểm tra';
      case AppLanguage.ja:
        return 'テスト';
    }
  }

  String get matchAction {
    switch (this) {
      case AppLanguage.en:
        return 'Match';
      case AppLanguage.vi:
        return 'Khớp thẻ';
      case AppLanguage.ja:
        return 'マッチ';
    }
  }

  String get blastAction {
    switch (this) {
      case AppLanguage.en:
        return 'Blast';
      case AppLanguage.vi:
        return 'Blast';
      case AppLanguage.ja:
        return 'Blast';
    }
  }

  String get combineAction {
    switch (this) {
      case AppLanguage.en:
        return 'Combine';
      case AppLanguage.vi:
        return 'Ghép thẻ';
      case AppLanguage.ja:
        return 'カード結合';
    }
  }

  String get showHintsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Show hints';
      case AppLanguage.vi:
        return 'Hiển thị gợi ý';
      case AppLanguage.ja:
        return 'ヒントを表示';
    }
  }

  String get trackProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Track progress';
      case AppLanguage.vi:
        return 'Theo dõi tiến độ';
      case AppLanguage.ja:
        return '進捗を追跡';
    }
  }

  String get shortcutLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Shortcut';
      case AppLanguage.vi:
        return 'Phím tắt';
      case AppLanguage.ja:
        return 'ショートカット';
    }
  }

  String get shortcutInstruction {
    switch (this) {
      case AppLanguage.en:
        return 'Press space or tap the card to flip.';
      case AppLanguage.vi:
        return 'Nhấn phím cách hoặc nhấp vào thẻ để lật.';
      case AppLanguage.ja:
        return 'スペースキーまたはカードをタップして裏返します。';
    }
  }

  String get audioComingSoon {
    switch (this) {
      case AppLanguage.en:
        return 'Audio will be added later.';
      case AppLanguage.vi:
        return 'Âm thanh sẽ được thêm sau.';
      case AppLanguage.ja:
        return '音声は後で追加されます。';
    }
  }

  String lessonCountLabel(int count) {
    switch (this) {
      case AppLanguage.en:
        return '$count lessons';
      case AppLanguage.vi:
        return '$count bài học';
      case AppLanguage.ja:
        return '$count レッスン';
    }
  }

  String get vocabTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Flashcards + SRS';
      case AppLanguage.vi:
        return 'Flashcard + SRS';
      case AppLanguage.ja:
        return 'フラッシュカード + SRS';
    }
  }

  String get vocabSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Review vocabulary with scheduling.';
      case AppLanguage.vi:
        return 'Ôn từ vựng theo lịch học.';
      case AppLanguage.ja:
        return 'スケジュールで語彙を復習。';
    }
  }

  String get grammarTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Grammar Quiz';
      case AppLanguage.vi:
        return 'Quiz ngữ pháp';
      case AppLanguage.ja:
        return '文法クイズ';
    }
  }

  String grammarSubtitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level practice sets.';
      case AppLanguage.vi:
        return 'Bộ luyện tập $level.';
      case AppLanguage.ja:
        return '$level 練習セット。';
    }
  }

  String get examTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Mock Exam';
      case AppLanguage.vi:
        return 'Thi thử';
      case AppLanguage.ja:
        return '模擬試験';
    }
  }

  String examSubtitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level timer, scoring, and review.';
      case AppLanguage.vi:
        return '$level có hẹn giờ, chấm điểm, và review.';
      case AppLanguage.ja:
        return '$level タイマー、採点、復習。';
    }
  }

  String get progressTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Progress';
      case AppLanguage.vi:
        return 'Tiến độ';
      case AppLanguage.ja:
        return '進捗';
    }
  }

  String get progressSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Streak, XP, and basic stats.';
      case AppLanguage.vi:
        return 'Streak, XP, và thống kê cơ bản.';
      case AppLanguage.ja:
        return '連続学習、XP、基本統計。';
    }
  }

  String get vocabScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Vocab review flow will live here.';
      case AppLanguage.vi:
        return 'Luồng ôn từ vựng sẽ hiển thị ở đây.';
      case AppLanguage.ja:
        return '語彙復習フローはここに表示されます。';
    }
  }

  String get selectLevelToViewVocab {
    switch (this) {
      case AppLanguage.en:
        return 'Select a level to see vocab.';
      case AppLanguage.vi:
        return 'Hãy chọn cấp để xem từ vựng.';
      case AppLanguage.ja:
        return '単語を見るにはレベルを選択してください。';
    }
  }

  String get vocabPreviewTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Sample vocab';
      case AppLanguage.vi:
        return 'Từ vựng mẫu';
      case AppLanguage.ja:
        return 'サンプル単語';
    }
  }

  String get loadErrorLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Failed to load data.';
      case AppLanguage.vi:
        return 'Tải dữ liệu thất bại.';
      case AppLanguage.ja:
        return 'データの読み込みに失敗しました。';
    }
  }

  String get grammarScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Grammar quiz flow will live here.';
      case AppLanguage.vi:
        return 'Luồng quiz ngữ pháp sẽ hiển thị ở đây.';
      case AppLanguage.ja:
        return '文法クイズのフローはここに表示されます。';
    }
  }

  String get examScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Mock exam flow will live here.';
      case AppLanguage.vi:
        return 'Luồng thi thử sẽ hiển thị ở đây.';
      case AppLanguage.ja:
        return '模擬試験のフローはここに表示されます。';
    }
  }

  String get progressScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Progress and streak view will live here.';
      case AppLanguage.vi:
        return 'Tiến độ và streak sẽ hiển thị ở đây.';
      case AppLanguage.ja:
        return '進捗と連続学習はここに表示されます。';
    }
  }

  String get n3OnlyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'N3 only';
      case AppLanguage.vi:
        return 'Chỉ N3';
      case AppLanguage.ja:
        return 'N3のみ';
    }
  }
}
