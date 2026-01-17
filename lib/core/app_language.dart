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
        return 'Ti\u1ebfng Vi\u1ec7t';
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
        return 'Ch\u1ecdn c\u1ea5p JLPT';
      case AppLanguage.ja:
        return 'JLPTレベルを選択';
    }
  }

  String get levelMenuSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Pick a level to tailor quizzes and exams.';
      case AppLanguage.vi:
        return 'Ch\u1ecdn c\u1ea5p \u0111\u1ec3 c\xe1 nh\xe2n h\xf3a quiz v\xe0 thi th\u1eed.';
      case AppLanguage.ja:
        return 'レベルを選んでクイズと模試を最適化します。';
    }
  }

  String get changeLevelLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Change level';
      case AppLanguage.vi:
        return '\u0110\u1ed5i c\u1ea5p';
      case AppLanguage.ja:
        return 'レベル変更';
    }
  }

  String get backToLevelsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Back to levels';
      case AppLanguage.vi:
        return 'V\u1ec1 ch\u1ecdn c\u1ea5p';
      case AppLanguage.ja:
        return 'レベル選択へ';
    }
  }

  String get languageMenuLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Language';
      case AppLanguage.vi:
        return 'Ng\xf4n ng\u1eef';
      case AppLanguage.ja:
        return '言語';
    }
  }

  String get levelLabelPrefix {
    switch (this) {
      case AppLanguage.en:
        return 'Level: ';
      case AppLanguage.vi:
        return 'C\u1ea5p: ';
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
        return 'Ch\u1ecdn b\xe0i h\u1ecdc';
      case AppLanguage.ja:
        return 'レッスンを選択';
    }
  }

  String lessonListTitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level · Sets';
      case AppLanguage.vi:
        return '$level B\u1ed9 h\u1ecdc ph\u1ea7n';
      case AppLanguage.ja:
        return '$level ・学習セット';
    }
  }

  String get filterAllLabel {
    switch (this) {
      case AppLanguage.en:
        return 'All';
      case AppLanguage.vi:
        return 'T\u1ea5t c\u1ea3';
      case AppLanguage.ja:
        return 'すべて';
    }
  }


  String get filterHasDataLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Has data';
      case AppLanguage.vi:
        return 'C\u00f3 d\u1eef li\u1ec7u';
      case AppLanguage.ja:
        return 'Has data';
    }
  }

  String get filterEmptyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'No data';
      case AppLanguage.vi:
        return 'Ch\u01b0a c\u00f3 d\u1eef li\u1ec7u';
      case AppLanguage.ja:
        return 'No data';
    }
  }

  String get recentItemsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Recent items';
      case AppLanguage.vi:
        return 'M\u1ee5c g\u1ea7n \u0111\xe2y';
      case AppLanguage.ja:
        return '最近の項目';
    }
  }

  String get searchFolderHint {
    switch (this) {
      case AppLanguage.en:
        return 'Search in this folder';
      case AppLanguage.vi:
        return 'T\xecm trong th\u01b0 m\u1ee5c n\xe0y';
      case AppLanguage.ja:
        return 'このフォルダ内を検索';
    }
  }

  String get searchLessonsHint {
    switch (this) {
      case AppLanguage.en:
        return 'Search lessons';
      case AppLanguage.vi:
        return 'T\xecm b\xe0i h\u1ecdc';
      case AppLanguage.ja:
        return '学習セットを検索';
    }
  }

  String get createLessonLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Create set';
      case AppLanguage.vi:
        return 'T\u1ea1o h\u1ecdc ph\u1ea7n';
      case AppLanguage.ja:
        return 'セット作成';
    }
  }

  String get sortRecentLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Recent';
      case AppLanguage.vi:
        return 'G\u1ea7n \u0111\xe2y';
      case AppLanguage.ja:
        return '最近';
    }
  }

  String get sortAzLabel {
    switch (this) {
      case AppLanguage.en:
        return 'A-Z';
      case AppLanguage.vi:
        return 'A-Z';
      case AppLanguage.ja:
        return 'A-Z';
    }
  }

  String get sortProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Progress';
      case AppLanguage.vi:
        return 'Ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '進捗';
    }
  }

  String get sortTermCountLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Term count';
      case AppLanguage.vi:
        return 'S\u1ed1 thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '語数';
    }
  }

  String termsCountLabel(int count) {
    switch (this) {
      case AppLanguage.en:
        return '$count terms';
      case AppLanguage.vi:
        return '$count thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '$count 語';
    }
  }

  String relativeTimeLabel(int minutes) {
    if (minutes < 60) {
      switch (this) {
        case AppLanguage.en:
          return '$minutes minutes ago';
        case AppLanguage.vi:
          return '$minutes ph\xfat tr\u01b0\u1edbc';
        case AppLanguage.ja:
          return '$minutes分前';
      }
    }
    if (minutes < 1440) {
      final hours = (minutes / 60).round();
      switch (this) {
        case AppLanguage.en:
          return '$hours hours ago';
        case AppLanguage.vi:
          return '$hours gi\u1edd tr\u01b0\u1edbc';
        case AppLanguage.ja:
          return '$hours時間前';
      }
    }
    final days = (minutes / 1440).round();
    switch (this) {
      case AppLanguage.en:
        return '$days days ago';
      case AppLanguage.vi:
        return '$days ng\xe0y tr\u01b0\u1edbc';
      case AppLanguage.ja:
        return '$days日前';
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
        return 'H\u1ecdc ph\u1ea7n c\xf3 $termCount thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '学習セット・$termCount 語';
    }
  }

  String get savedLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Saved';
      case AppLanguage.vi:
        return '\u0110\xe3 l\u01b0u';
      case AppLanguage.ja:
        return '保存済み';
    }
  }

  String get groupLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Group';
      case AppLanguage.vi:
        return 'Nh\xf3m';
      case AppLanguage.ja:
        return 'グループ';
    }
  }

  String lessonLearnersLabel(int people, int days) {
    switch (this) {
      case AppLanguage.en:
        return '$people learners in last $days days';
      case AppLanguage.vi:
        return '$people ng\u01b0\u1eddi h\u1ecdc trong $days ng\xe0y qua';
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
        return '$ratingText ($reviews \u0111\xe1nh gi\xe1)';
      case AppLanguage.ja:
        return '$ratingText（$reviews件）';
    }
  }

  String get lastStudiedSample {
    switch (this) {
      case AppLanguage.en:
        return '2 hours ago';
      case AppLanguage.vi:
        return '2 gi\u1edd tr\u01b0\u1edbc';
      case AppLanguage.ja:
        return '2時間前';
    }
  }

  String lastStudiedLabel(String timeAgo) {
    switch (this) {
      case AppLanguage.en:
        return 'Last studied: $timeAgo';
      case AppLanguage.vi:
        return 'L\u1ea7n h\u1ecdc cu\u1ed1i: $timeAgo';
      case AppLanguage.ja:
        return '最後の学習: $timeAgo';
    }
  }

  String get copySetLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Edit';
      case AppLanguage.vi:
        return 'Ch\u1ec9nh s\u1eeda';
      case AppLanguage.ja:
        return '編集';
    }
  }

  String get resetProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Reset progress';
      case AppLanguage.vi:
        return '\u0110\u1eb7t l\u1ea1i ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '進捗をリセット';
    }
  }

  String get combineSetLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Combine';
      case AppLanguage.vi:
        return 'G\u1ed9p';
      case AppLanguage.ja:
        return '結合';
    }
  }

  String get reportLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Report';
      case AppLanguage.vi:
        return 'B\xe1o c\xe1o';
      case AppLanguage.ja:
        return '報告';
    }
  }

  String get backToLessonLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Back to lesson';
      case AppLanguage.vi:
        return 'Tr\u1edf v\u1ec1 h\u1ecdc ph\u1ea7n';
      case AppLanguage.ja:
        return '学習セットに戻る';
    }
  }

  String get doneLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Done';
      case AppLanguage.vi:
        return 'Xong';
      case AppLanguage.ja:
        return '完了';
    }
  }

  String get publicLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Public';
      case AppLanguage.vi:
        return 'C\xf4ng khai';
      case AppLanguage.ja:
        return '公開';
    }
  }

  String get titleLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Title';
      case AppLanguage.vi:
        return 'Ti\xeau \u0111\u1ec1';
      case AppLanguage.ja:
        return 'タイトル';
    }
  }

  String get descriptionLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Add description...';
      case AppLanguage.vi:
        return 'Th\xeam m\xf4 t\u1ea3...';
      case AppLanguage.ja:
        return '説明を追加...';
    }
  }

  String get addTermLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Add';
      case AppLanguage.vi:
        return 'Th\xeam';
      case AppLanguage.ja:
        return '追加';
    }
  }




  String get hintsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Hints';
      case AppLanguage.vi:
        return 'G\u1ee3i \xfd';
      case AppLanguage.ja:
        return 'ヒント';
    }
  }

  String get termLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Term';
      case AppLanguage.vi:
        return 'Thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '用語';
    }
  }

  String get definitionLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Definition';
      case AppLanguage.vi:
        return '\u0110\u1ecbnh ngh\u0129a';
      case AppLanguage.ja:
        return '定義';
    }
  }


  String get confirmDeleteTermTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Delete term?';
      case AppLanguage.vi:
        return 'X\u00f3a thu\u1eadt ng\u1eef?';
      case AppLanguage.ja:
        return 'Delete term?';
    }
  }

  String get confirmDeleteTermBody {
    switch (this) {
      case AppLanguage.en:
        return 'This will remove the term from the lesson.';
      case AppLanguage.vi:
        return 'Thao t\u00e1c n\u00e0y s\u1ebd x\u00f3a thu\u1eadt ng\u1eef kh\u1ecfi h\u1ecdc ph\u1ea7n.';
      case AppLanguage.ja:
        return 'This will remove the term from the lesson.';
    }
  }

  String get swapLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Swap';
      case AppLanguage.vi:
        return 'Ho\xe1n \u0111\u1ed5i';
      case AppLanguage.ja:
        return '入れ替え';
    }
  }

  String get flashcardsAction {
    switch (this) {
      case AppLanguage.en:
        return 'Flashcards';
      case AppLanguage.vi:
        return 'Th\u1ebb ghi nh\u1edb';
      case AppLanguage.ja:
        return '単語カード';
    }
  }

  String get learnAction {
    switch (this) {
      case AppLanguage.en:
        return 'Learn';
      case AppLanguage.vi:
        return 'H\u1ecdc';
      case AppLanguage.ja:
        return '学習';
    }
  }

  String get testAction {
    switch (this) {
      case AppLanguage.en:
        return 'Test';
      case AppLanguage.vi:
        return 'Ki\u1ec3m tra';
      case AppLanguage.ja:
        return 'テスト';
    }
  }

  String get matchAction {
    switch (this) {
      case AppLanguage.en:
        return 'Match';
      case AppLanguage.vi:
        return 'Gh\xe9p th\u1ebb';
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
        return 'Gh\xe9p';
      case AppLanguage.ja:
        return 'カード結合';
    }
  }

  String get gamesLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Games';
      case AppLanguage.vi:
        return 'Tr\xf2 ch\u01a1i';
      case AppLanguage.ja:
        return '???';
    }
  }

  String get shuffleLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Shuffle';
      case AppLanguage.vi:
        return 'X\xe1o tr\u1ed9n';
      case AppLanguage.ja:
        return '?????';
    }
  }

  String get autoLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Auto';
      case AppLanguage.vi:
        return 'T\u1ef1 \u0111\u1ed9ng';
      case AppLanguage.ja:
        return '??';
    }
  }

  String get speedLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Speed';
      case AppLanguage.vi:
        return 'T\u1ed1c \u0111\u1ed9';
      case AppLanguage.ja:
        return '??';
    }
  }

  String get settingsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Settings';
      case AppLanguage.vi:
        return 'C\xe0i \u0111\u1eb7t';
      case AppLanguage.ja:
        return '??';
    }
  }

  String get fullscreenLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Fullscreen';
      case AppLanguage.vi:
        return 'To\xe0n m\xe0n h\xecnh';
      case AppLanguage.ja:
        return '???';
    }
  }

  String get showHintsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Show hints';
      case AppLanguage.vi:
        return 'Hi\u1ec3n th\u1ecb g\u1ee3i \xfd';
      case AppLanguage.ja:
        return 'ヒントを表示';
    }
  }

  String get trackProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Track progress';
      case AppLanguage.vi:
        return 'Theo d\xf5i ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '進捗を追跡';
    }
  }

  String get shortcutLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Shortcut';
      case AppLanguage.vi:
        return 'Ph\xedm t\u1eaft';
      case AppLanguage.ja:
        return 'ショートカット';
    }
  }

  String get shortcutInstruction {
    switch (this) {
      case AppLanguage.en:
        return 'Press space or tap the card to flip.';
      case AppLanguage.vi:
        return 'Nh\u1ea5n Space ho\u1eb7c ch\u1ea1m th\u1ebb \u0111\u1ec3 l\u1eadt.';
      case AppLanguage.ja:
        return 'スペースキーまたはカードをタップして裏返します。';
    }
  }

  String get audioComingSoon {
    switch (this) {
      case AppLanguage.en:
        return 'Audio will be added later.';
      case AppLanguage.vi:
        return '\xc2m thanh s\u1ebd \u0111\u01b0\u1ee3c th\xeam sau.';
      case AppLanguage.ja:
        return '音声は後で追加されます。';
    }
  }

  String lessonCountLabel(int count) {
    switch (this) {
      case AppLanguage.en:
        return '$count lessons';
      case AppLanguage.vi:
        return '$count b\xe0i h\u1ecdc';
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
        return '\xd4n t\u1eeb v\u1ef1ng theo l\u1ecbch.';
      case AppLanguage.ja:
        return 'スケジュールで語彙を復習。';
    }
  }

  String get grammarTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Grammar Quiz';
      case AppLanguage.vi:
        return 'Quiz ng\u1eef ph\xe1p';
      case AppLanguage.ja:
        return '文法クイズ';
    }
  }

  String grammarSubtitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level practice sets.';
      case AppLanguage.vi:
        return 'B\u1ed9 luy\u1ec7n t\u1eadp $level.';
      case AppLanguage.ja:
        return '$level 練習セット。';
    }
  }

  String get examTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Mock Exam';
      case AppLanguage.vi:
        return 'Thi th\u1eed';
      case AppLanguage.ja:
        return '模擬試験';
    }
  }

  String examSubtitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level timer, scoring, and review.';
      case AppLanguage.vi:
        return '\u0110\u1ec1 $level c\xf3 th\u1eddi gian, ch\u1ea5m \u0111i\u1ec3m v\xe0 xem l\u1ea1i.';
      case AppLanguage.ja:
        return '$level タイマー、採点、復習。';
    }
  }

  String get progressTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Progress';
      case AppLanguage.vi:
        return 'Ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '進捗';
    }
  }

  String get progressSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Streak, XP, and basic stats.';
      case AppLanguage.vi:
        return 'Streak, XP v\xe0 th\u1ed1ng k\xea c\u01a1 b\u1ea3n.';
      case AppLanguage.ja:
        return '連続学習、XP、基本統計。';
    }
  }

  String get vocabScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Vocab review flow will live here.';
      case AppLanguage.vi:
        return 'Lu\u1ed3ng \xf4n t\u1eeb v\u1ef1ng s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '語彙復習フローはここに表示されます。';
    }
  }

  String get selectLevelToViewVocab {
    switch (this) {
      case AppLanguage.en:
        return 'Select a level to see vocab.';
      case AppLanguage.vi:
        return 'H\xe3y ch\u1ecdn c\u1ea5p \u0111\u1ec3 xem t\u1eeb v\u1ef1ng.';
      case AppLanguage.ja:
        return '単語を見るにはレベルを選択してください。';
    }
  }

  String get vocabPreviewTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Sample vocab';
      case AppLanguage.vi:
        return 'T\u1eeb v\u1ef1ng m\u1eabu';
      case AppLanguage.ja:
        return 'サンプル単語';
    }
  }

  String get loadErrorLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Failed to load data.';
      case AppLanguage.vi:
        return 'T\u1ea3i d\u1eef li\u1ec7u th\u1ea5t b\u1ea1i.';
      case AppLanguage.ja:
        return 'データの読み込みに失敗しました。';
    }
  }

  String get grammarScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Grammar quiz flow will live here.';
      case AppLanguage.vi:
        return 'Lu\u1ed3ng quiz ng\u1eef ph\xe1p s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '文法クイズのフローはここに表示されます。';
    }
  }

  String get examScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Mock exam flow will live here.';
      case AppLanguage.vi:
        return 'Lu\u1ed3ng thi th\u1eed s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '模擬試験のフローはここに表示されます。';
    }
  }

  String get progressScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Progress and streak view will live here.';
      case AppLanguage.vi:
        return 'Ti\u1ebfn \u0111\u1ed9 v\xe0 streak s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '進捗と連続学習はここに表示されます。';
    }
  }

  String get n3OnlyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'N3 only';
      case AppLanguage.vi:
        return 'Ch\u1ec9 N3';
      case AppLanguage.ja:
        return 'N3のみ';
    }
  }
}
