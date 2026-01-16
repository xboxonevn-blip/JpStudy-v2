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
