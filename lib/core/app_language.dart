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
        return '\u65e5\u672c\u8a9e';
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
        return 'JLPT\u30ec\u30d9\u30eb\u3092\u9078\u629e';
    }
  }

  String get levelMenuSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Pick a level to tailor quizzes and exams.';
      case AppLanguage.vi:
        return 'Ch\u1ecdn c\u1ea5p \u0111\u1ec3 c\xe1 nh\xe2n h\xf3a quiz v\xe0 thi th\u1eed.';
      case AppLanguage.ja:
        return '\u30ec\u30d9\u30eb\u3092\u9078\u3093\u3067\u30af\u30a4\u30ba\u3068\u6a21\u8a66\u3092\u6700\u9069\u5316\u3057\u307e\u3059\u3002';
    }
  }

  String get changeLevelLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Change level';
      case AppLanguage.vi:
        return '\u0110\u1ed5i c\u1ea5p';
      case AppLanguage.ja:
        return '\u30ec\u30d9\u30eb\u5909\u66f4';
    }
  }

  String get backToLevelsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Back to levels';
      case AppLanguage.vi:
        return 'V\u1ec1 ch\u1ecdn c\u1ea5p';
      case AppLanguage.ja:
        return '\u30ec\u30d9\u30eb\u9078\u629e\u3078';
    }
  }

  String get languageMenuLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Language';
      case AppLanguage.vi:
        return 'Ng\xf4n ng\u1eef';
      case AppLanguage.ja:
        return '\u8a00\u8a9e';
    }
  }

  String get levelLabelPrefix {
    switch (this) {
      case AppLanguage.en:
        return 'Level: ';
      case AppLanguage.vi:
        return 'C\u1ea5p: ';
      case AppLanguage.ja:
        return '\u30ec\u30d9\u30eb: ';
    }
  }

  String get mvpModulesTitle {
    switch (this) {
      case AppLanguage.en:
        return 'MVP modules';
      case AppLanguage.vi:
        return 'Module MVP';
      case AppLanguage.ja:
        return 'MVP\u30e2\u30b8\u30e5\u30fc\u30eb';
    }
  }

  String get lessonPickerTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Choose lessons';
      case AppLanguage.vi:
        return 'Ch\u1ecdn b\xe0i h\u1ecdc';
      case AppLanguage.ja:
        return '\u30ec\u30c3\u30b9\u30f3\u3092\u9078\u629e';
    }
  }

  String lessonListTitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level · Sets';
      case AppLanguage.vi:
        return '$level B\u1ed9 h\u1ecdc ph\u1ea7n';
      case AppLanguage.ja:
        return '$level \u30fb\u5b66\u7fd2\u30bb\u30c3\u30c8';
    }
  }

  String get filterAllLabel {
    switch (this) {
      case AppLanguage.en:
        return 'All';
      case AppLanguage.vi:
        return 'T\u1ea5t c\u1ea3';
      case AppLanguage.ja:
        return '\u3059\u3079\u3066';
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

  String get filterCustomLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Custom';
      case AppLanguage.vi:
        return 'T\u00f9y ch\u1ec9nh';
      case AppLanguage.ja:
        return '\u30ab\u30b9\u30bf\u30e0';
    }
  }

  String get recentItemsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Recent items';
      case AppLanguage.vi:
        return 'M\u1ee5c g\u1ea7n \u0111\xe2y';
      case AppLanguage.ja:
        return '\u6700\u8fd1\u306e\u9805\u76ee';
    }
  }

  String get searchFolderHint {
    switch (this) {
      case AppLanguage.en:
        return 'Search in this folder';
      case AppLanguage.vi:
        return 'T\xecm trong th\u01b0 m\u1ee5c n\xe0y';
      case AppLanguage.ja:
        return '\u3053\u306e\u30d5\u30a9\u30eb\u30c0\u5185\u3092\u691c\u7d22';
    }
  }

  String get searchLessonsHint {
    switch (this) {
      case AppLanguage.en:
        return 'Search lessons';
      case AppLanguage.vi:
        return 'T\xecm b\xe0i h\u1ecdc';
      case AppLanguage.ja:
        return '\u5b66\u7fd2\u30bb\u30c3\u30c8\u3092\u691c\u7d22';
    }
  }

  String get createLessonLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Create set';
      case AppLanguage.vi:
        return 'T\u1ea1o h\u1ecdc ph\u1ea7n';
      case AppLanguage.ja:
        return '\u30bb\u30c3\u30c8\u4f5c\u6210';
    }
  }

  String get sortRecentLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Recent';
      case AppLanguage.vi:
        return 'G\u1ea7n \u0111\xe2y';
      case AppLanguage.ja:
        return '\u6700\u8fd1';
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
        return '\u9032\u6357';
    }
  }

  String get sortTermCountLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Term count';
      case AppLanguage.vi:
        return 'S\u1ed1 thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '\u8a9e\u6570';
    }
  }

  String termsCountLabel(int count) {
    switch (this) {
      case AppLanguage.en:
        return '$count terms';
      case AppLanguage.vi:
        return '$count thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '$count \u8a9e';
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
          return '$minutes\u5206\u524d';
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
          return '$hours\u6642\u9593\u524d';
      }
    }
    final days = (minutes / 1440).round();
    switch (this) {
      case AppLanguage.en:
        return '$days days ago';
      case AppLanguage.vi:
        return '$days ng\xe0y tr\u01b0\u1edbc';
      case AppLanguage.ja:
        return '$days\u65e5\u524d';
    }
  }

  String lessonTitle(int index) {
    switch (this) {
      case AppLanguage.en:
        return 'Minna No Nihongo $index';
      case AppLanguage.vi:
        return 'Minna No Nihongo $index';
      case AppLanguage.ja:
        return '\u307f\u3093\u306a\u306e\u65e5\u672c\u8a9e $index';
    }
  }

  String lessonSubtitle(int termCount) {
    switch (this) {
      case AppLanguage.en:
        return 'Set • $termCount terms';
      case AppLanguage.vi:
        return 'H\u1ecdc ph\u1ea7n c\xf3 $termCount thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '\u5b66\u7fd2\u30bb\u30c3\u30c8\u30fb$termCount \u8a9e';
    }
  }

  String get savedLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Saved';
      case AppLanguage.vi:
        return '\u0110\xe3 l\u01b0u';
      case AppLanguage.ja:
        return '\u4fdd\u5b58\u6e08\u307f';
    }
  }

  String get groupLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Group';
      case AppLanguage.vi:
        return 'Nh\xf3m';
      case AppLanguage.ja:
        return '\u30b0\u30eb\u30fc\u30d7';
    }
  }

  String lessonLearnersLabel(int people, int days) {
    switch (this) {
      case AppLanguage.en:
        return '$people learners in last $days days';
      case AppLanguage.vi:
        return '$people ng\u01b0\u1eddi h\u1ecdc trong $days ng\xe0y qua';
      case AppLanguage.ja:
        return '\u904e\u53bb$days\u65e5\u3067$people\u4eba\u304c\u5b66\u7fd2';
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
        return '$ratingText\uff08$reviews\u4ef6\uff09';
    }
  }

  String get lastStudiedSample {
    switch (this) {
      case AppLanguage.en:
        return '2 hours ago';
      case AppLanguage.vi:
        return '2 gi\u1edd tr\u01b0\u1edbc';
      case AppLanguage.ja:
        return '2\u6642\u9593\u524d';
    }
  }

  String lastStudiedLabel(String timeAgo) {
    switch (this) {
      case AppLanguage.en:
        return 'Last studied: $timeAgo';
      case AppLanguage.vi:
        return 'L\u1ea7n h\u1ecdc cu\u1ed1i: $timeAgo';
      case AppLanguage.ja:
        return '\u6700\u5f8c\u306e\u5b66\u7fd2: $timeAgo';
    }
  }

  String get copySetLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Edit';
      case AppLanguage.vi:
        return 'Ch\u1ec9nh s\u1eeda';
      case AppLanguage.ja:
        return '\u7de8\u96c6';
    }
  }

  String get resetProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Reset progress';
      case AppLanguage.vi:
        return '\u0110\u1eb7t l\u1ea1i ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '\u9032\u6357\u3092\u30ea\u30bb\u30c3\u30c8';
    }
  }

  String get combineSetLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Combine';
      case AppLanguage.vi:
        return 'G\u1ed9p';
      case AppLanguage.ja:
        return '\u7d50\u5408';
    }
  }

  String get reportLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Report';
      case AppLanguage.vi:
        return 'B\xe1o c\xe1o';
      case AppLanguage.ja:
        return '\u5831\u544a';
    }
  }

  String get backToLessonLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Back to lesson';
      case AppLanguage.vi:
        return 'Tr\u1edf v\u1ec1 h\u1ecdc ph\u1ea7n';
      case AppLanguage.ja:
        return '\u5b66\u7fd2\u30bb\u30c3\u30c8\u306b\u623b\u308b';
    }
  }

  String get doneLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Done';
      case AppLanguage.vi:
        return 'Xong';
      case AppLanguage.ja:
        return '\u5b8c\u4e86';
    }
  }

  String get publicLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Public';
      case AppLanguage.vi:
        return 'C\xf4ng khai';
      case AppLanguage.ja:
        return '\u516c\u958b';
    }
  }

  String get titleLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Title';
      case AppLanguage.vi:
        return 'Ti\xeau \u0111\u1ec1';
      case AppLanguage.ja:
        return '\u30bf\u30a4\u30c8\u30eb';
    }
  }

  String get descriptionLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Add description...';
      case AppLanguage.vi:
        return 'Th\xeam m\xf4 t\u1ea3...';
      case AppLanguage.ja:
        return '\u8aac\u660e\u3092\u8ffd\u52a0...';
    }
  }

  String get addTermLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Add';
      case AppLanguage.vi:
        return 'Th\xeam';
      case AppLanguage.ja:
        return '\u8ffd\u52a0';
    }
  }

  String get importCsvLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Import CSV';
      case AppLanguage.vi:
        return 'Nh\u1eadp CSV';
      case AppLanguage.ja:
        return 'CSV\u3092\u30a4\u30f3\u30dd\u30fc\u30c8';
    }
  }

  String get exportCsvLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Export CSV';
      case AppLanguage.vi:
        return 'Xu\u1ea5t CSV';
      case AppLanguage.ja:
        return 'CSV\u3092\u30a8\u30af\u30b9\u30dd\u30fc\u30c8';
    }
  }

  String get importConfirmTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Replace existing terms?';
      case AppLanguage.vi:
        return 'Thay th\u1ebf danh s\u00e1ch hi\u1ec7n t\u1ea1i?';
      case AppLanguage.ja:
        return '\u65e2\u5b58\u306e\u7528\u8a9e\u3092\u7f6e\u304d\u63db\u3048\u307e\u3059\u304b\uff1f';
    }
  }

  String get importConfirmBody {
    switch (this) {
      case AppLanguage.en:
        return 'Choose to replace or append terms.';
      case AppLanguage.vi:
        return 'Ch\u1ecdn thay th\u1ebf ho\u1eb7c th\u00eam v\u00e0o danh s\u00e1ch.';
      case AppLanguage.ja:
        return '\u7f6e\u304d\u63db\u3048\u307e\u305f\u306f\u8ffd\u52a0\u3092\u9078\u3093\u3067\u304f\u3060\u3055\u3044\u3002';
    }
  }

  String get importConfirmReplaceLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Replace';
      case AppLanguage.vi:
        return 'Thay th\u1ebf';
      case AppLanguage.ja:
        return '\u7f6e\u304d\u63db\u3048';
    }
  }

  String get importConfirmAppendLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Append';
      case AppLanguage.vi:
        return 'Th\u00eam';
      case AppLanguage.ja:
        return '\u8ffd\u52a0';
    }
  }

  String get importSuccessLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Imported successfully.';
      case AppLanguage.vi:
        return '\u0110\u00e3 nh\u1eadp th\u00e0nh c\u00f4ng.';
      case AppLanguage.ja:
        return '\u30a4\u30f3\u30dd\u30fc\u30c8\u3057\u307e\u3057\u305f\u3002';
    }
  }

  String get importErrorLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Import failed. Please check the CSV file.';
      case AppLanguage.vi:
        return 'Nh\u1eadp th\u1ea5t b\u1ea1i. Vui l\u00f2ng ki\u1ec3m tra file CSV.';
      case AppLanguage.ja:
        return '\u30a4\u30f3\u30dd\u30fc\u30c8\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002CSV\u3092\u78ba\u8a8d\u3057\u3066\u304f\u3060\u3055\u3044\u3002';
    }
  }

  String get exportSuccessLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Exported successfully.';
      case AppLanguage.vi:
        return '\u0110\u00e3 xu\u1ea5t th\u00e0nh c\u00f4ng.';
      case AppLanguage.ja:
        return '\u30a8\u30af\u30b9\u30dd\u30fc\u30c8\u3057\u307e\u3057\u305f\u3002';
    }
  }

  String get exportErrorLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Export failed.';
      case AppLanguage.vi:
        return 'Xu\u1ea5t th\u1ea5t b\u1ea1i.';
      case AppLanguage.ja:
        return '\u30a8\u30af\u30b9\u30dd\u30fc\u30c8\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002';
    }
  }




  String get hintsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Hints';
      case AppLanguage.vi:
        return 'G\u1ee3i \xfd';
      case AppLanguage.ja:
        return '\u30d2\u30f3\u30c8';
    }
  }

  String get termLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Term';
      case AppLanguage.vi:
        return 'Thu\u1eadt ng\u1eef';
      case AppLanguage.ja:
        return '\u7528\u8a9e';
    }
  }

  String get definitionLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Definition';
      case AppLanguage.vi:
        return '\u0110\u1ecbnh ngh\u0129a';
      case AppLanguage.ja:
        return '\u5b9a\u7fa9';
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
        return '\u5165\u308c\u66ff\u3048';
    }
  }

  String get flashcardsAction {
    switch (this) {
      case AppLanguage.en:
        return 'Flashcards';
      case AppLanguage.vi:
        return 'Th\u1ebb ghi nh\u1edb';
      case AppLanguage.ja:
        return '\u5358\u8a9e\u30ab\u30fc\u30c9';
    }
  }

  String get reviewAction {
    switch (this) {
      case AppLanguage.en:
        return 'Review';
      case AppLanguage.vi:
        return '\u00d4n t\u1eadp';
      case AppLanguage.ja:
        return '\u5fa9\u7fd2';
    }
  }

  String get learnAction {
    switch (this) {
      case AppLanguage.en:
        return 'Learn';
      case AppLanguage.vi:
        return 'H\u1ecdc';
      case AppLanguage.ja:
        return '\u5b66\u7fd2';
    }
  }

  String get testAction {
    switch (this) {
      case AppLanguage.en:
        return 'Test';
      case AppLanguage.vi:
        return 'Ki\u1ec3m tra';
      case AppLanguage.ja:
        return '\u30c6\u30b9\u30c8';
    }
  }

  String get matchAction {
    switch (this) {
      case AppLanguage.en:
        return 'Match';
      case AppLanguage.vi:
        return 'Gh\xe9p th\u1ebb';
      case AppLanguage.ja:
        return '\u30de\u30c3\u30c1';
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
        return '\u30ab\u30fc\u30c9\u7d50\u5408';
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
        return '\u30d2\u30f3\u30c8\u3092\u8868\u793a';
    }
  }

  String get trackProgressLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Track progress';
      case AppLanguage.vi:
        return 'Theo d\xf5i ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '\u9032\u6357\u3092\u8ffd\u8de1';
    }
  }

  String get shortcutLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Shortcut';
      case AppLanguage.vi:
        return 'Ph\xedm t\u1eaft';
      case AppLanguage.ja:
        return '\u30b7\u30e7\u30fc\u30c8\u30ab\u30c3\u30c8';
    }
  }

  String get shortcutInstruction {
    switch (this) {
      case AppLanguage.en:
        return 'Press space or tap the card to flip.';
      case AppLanguage.vi:
        return 'Nh\u1ea5n Space ho\u1eb7c ch\u1ea1m th\u1ebb \u0111\u1ec3 l\u1eadt.';
      case AppLanguage.ja:
        return '\u30b9\u30da\u30fc\u30b9\u30ad\u30fc\u307e\u305f\u306f\u30ab\u30fc\u30c9\u3092\u30bf\u30c3\u30d7\u3057\u3066\u88cf\u8fd4\u3057\u307e\u3059\u3002';
    }
  }

  String reviewCountLabel(int count) {
    switch (this) {
      case AppLanguage.en:
        return '$count reviews due';
      case AppLanguage.vi:
        return '$count t\u1eeb \u0111\u1ebfn h\u1ea1n \u00f4n t\u1eadp';
      case AppLanguage.ja:
        return '\u672c\u65e5\u306e\u5fa9\u7fd2: $count';
    }
  }

  String get reviewEmptyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'No reviews due right now.';
      case AppLanguage.vi:
        return 'Hi\u1ec7n kh\u00f4ng c\u00f3 t\u1eeb \u0111\u1ebfn h\u1ea1n.';
      case AppLanguage.ja:
        return '\u73fe\u5728\u306f\u5fa9\u7fd2\u304c\u3042\u308a\u307e\u305b\u3093\u3002';
    }
  }

  String get reviewAgainLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Again';
      case AppLanguage.vi:
        return 'L\u1ea1i';
      case AppLanguage.ja:
        return '\u3082\u3046\u4e00\u5ea6';
    }
  }

  String get reviewHardLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Hard';
      case AppLanguage.vi:
        return 'Kh\u00f3';
      case AppLanguage.ja:
        return '\u96e3\u3057\u3044';
    }
  }

  String get reviewGoodLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Good';
      case AppLanguage.vi:
        return 'T\u1ed1t';
      case AppLanguage.ja:
        return '\u826f\u3044';
    }
  }

  String get reviewEasyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Easy';
      case AppLanguage.vi:
        return 'D\u1ec5';
      case AppLanguage.ja:
        return '\u7c21\u5358';
    }
  }

  String get audioNotConfigured {
    switch (this) {
      case AppLanguage.en:
        return 'Audio is not configured.';
      case AppLanguage.vi:
        return '\u00c2m thanh ch\u01b0a \u0111\u01b0\u1ee3c c\u1ea5u h\u00ecnh.';
      case AppLanguage.ja:
        return '\u97f3\u58f0\u304c\u8a2d\u5b9a\u3055\u308c\u3066\u3044\u307e\u305b\u3093\u3002';
    }
  }

  String get audioSettingsLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Audio';
      case AppLanguage.vi:
        return '\u00c2m thanh';
      case AppLanguage.ja:
        return '\u97f3\u58f0';
    }
  }

  String get audioModeLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Read';
      case AppLanguage.vi:
        return '\u0110\u1ecdc';
      case AppLanguage.ja:
        return '\u8aad\u307f\u4e0a\u3052';
    }
  }

  String get audioModeTerm {
    switch (this) {
      case AppLanguage.en:
        return 'Term';
      case AppLanguage.vi:
        return 'T\u1eeb';
      case AppLanguage.ja:
        return '\u7528\u8a9e';
    }
  }

  String get audioModeReading {
    switch (this) {
      case AppLanguage.en:
        return 'Reading';
      case AppLanguage.vi:
        return 'C\u00e1ch \u0111\u1ecdc';
      case AppLanguage.ja:
        return '\u8aad\u307f';
    }
  }

  String get audioModeDefinition {
    switch (this) {
      case AppLanguage.en:
        return 'Definition';
      case AppLanguage.vi:
        return '\u0110\u1ecbnh ngh\u0129a';
      case AppLanguage.ja:
        return '\u5b9a\u7fa9';
    }
  }

  String get audioVoiceLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Voice';
      case AppLanguage.vi:
        return 'Gi\u1ecdng';
      case AppLanguage.ja:
        return '\u58f0';
    }
  }

  String get audioVoiceFemale {
    switch (this) {
      case AppLanguage.en:
        return 'Female';
      case AppLanguage.vi:
        return 'N\u1eef';
      case AppLanguage.ja:
        return '\u5973';
    }
  }

  String get audioVoiceMale {
    switch (this) {
      case AppLanguage.en:
        return 'Male';
      case AppLanguage.vi:
        return 'Nam';
      case AppLanguage.ja:
        return '\u7537';
    }
  }

  String get audioCacheLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Audio cache';
      case AppLanguage.vi:
        return 'B\u1ed9 nh\u1edb \u0111\u1ec7m \u00e2m thanh';
      case AppLanguage.ja:
        return '\u97f3\u58f0\u30ad\u30e3\u30c3\u30b7\u30e5';
    }
  }

  String get audioClearCacheLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Clear cache';
      case AppLanguage.vi:
        return 'X\u00f3a cache';
      case AppLanguage.ja:
        return '\u30ad\u30e3\u30c3\u30b7\u30e5\u3092\u6d88\u53bb';
    }
  }

  String get audioCacheClearedLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Audio cache cleared.';
      case AppLanguage.vi:
        return '\u0110\u00e3 x\u00f3a cache \u00e2m thanh.';
      case AppLanguage.ja:
        return '\u97f3\u58f0\u30ad\u30e3\u30c3\u30b7\u30e5\u3092\u6d88\u53bb\u3057\u307e\u3057\u305f\u3002';
    }
  }

  String get audioCacheClearFailedLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Failed to clear audio cache.';
      case AppLanguage.vi:
        return 'X\u00f3a cache \u00e2m thanh th\u1ea5t b\u1ea1i.';
      case AppLanguage.ja:
        return '\u97f3\u58f0\u30ad\u30e3\u30c3\u30b7\u30e5\u306e\u6d88\u53bb\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002';
    }
  }

  String get audioErrorLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Audio failed to play.';
      case AppLanguage.vi:
        return 'Kh\xf4ng ph\xe1t \u0111\u01b0\u1ee3c \xe2m thanh.';
      case AppLanguage.ja:
        return '\u97f3\u58f0\u306e\u518d\u751f\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002';
    }
  }

  String get audioEmptyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'No text to read.';
      case AppLanguage.vi:
        return 'Kh\xf4ng c\xf3 n\u1ed9i dung \u0111\u1ec3 \u0111\u1ecdc.';
      case AppLanguage.ja:
        return '\u8aad\u307f\u4e0a\u3052\u308b\u30c6\u30ad\u30b9\u30c8\u304c\u3042\u308a\u307e\u305b\u3093\u3002';
    }
  }

  String lessonCountLabel(int count) {
    switch (this) {
      case AppLanguage.en:
        return '$count lessons';
      case AppLanguage.vi:
        return '$count b\xe0i h\u1ecdc';
      case AppLanguage.ja:
        return '$count \u30ec\u30c3\u30b9\u30f3';
    }
  }

  String get vocabTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Flashcards + SRS';
      case AppLanguage.vi:
        return 'Flashcard + SRS';
      case AppLanguage.ja:
        return '\u30d5\u30e9\u30c3\u30b7\u30e5\u30ab\u30fc\u30c9 + SRS';
    }
  }

  String get vocabSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Review vocabulary with scheduling.';
      case AppLanguage.vi:
        return '\xd4n t\u1eeb v\u1ef1ng theo l\u1ecbch.';
      case AppLanguage.ja:
        return '\u30b9\u30b1\u30b8\u30e5\u30fc\u30eb\u3067\u8a9e\u5f59\u3092\u5fa9\u7fd2\u3002';
    }
  }

  String get grammarTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Grammar Quiz';
      case AppLanguage.vi:
        return 'Quiz ng\u1eef ph\xe1p';
      case AppLanguage.ja:
        return '\u6587\u6cd5\u30af\u30a4\u30ba';
    }
  }

  String grammarSubtitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level practice sets.';
      case AppLanguage.vi:
        return 'B\u1ed9 luy\u1ec7n t\u1eadp $level.';
      case AppLanguage.ja:
        return '$level \u7df4\u7fd2\u30bb\u30c3\u30c8\u3002';
    }
  }

  String get examTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Mock Exam';
      case AppLanguage.vi:
        return 'Thi th\u1eed';
      case AppLanguage.ja:
        return '\u6a21\u64ec\u8a66\u9a13';
    }
  }

  String examSubtitle(String level) {
    switch (this) {
      case AppLanguage.en:
        return '$level timer, scoring, and review.';
      case AppLanguage.vi:
        return '\u0110\u1ec1 $level c\xf3 th\u1eddi gian, ch\u1ea5m \u0111i\u1ec3m v\xe0 xem l\u1ea1i.';
      case AppLanguage.ja:
        return '$level \u30bf\u30a4\u30de\u30fc\u3001\u63a1\u70b9\u3001\u5fa9\u7fd2\u3002';
    }
  }

  String get progressTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Progress';
      case AppLanguage.vi:
        return 'Ti\u1ebfn \u0111\u1ed9';
      case AppLanguage.ja:
        return '\u9032\u6357';
    }
  }

  String get progressSubtitle {
    switch (this) {
      case AppLanguage.en:
        return 'Streak, XP, and basic stats.';
      case AppLanguage.vi:
        return 'Streak, XP v\xe0 th\u1ed1ng k\xea c\u01a1 b\u1ea3n.';
      case AppLanguage.ja:
        return '\u9023\u7d9a\u5b66\u7fd2\u3001XP\u3001\u57fa\u672c\u7d71\u8a08\u3002';
    }
  }

  String get vocabScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Vocab review flow will live here.';
      case AppLanguage.vi:
        return 'Lu\u1ed3ng \xf4n t\u1eeb v\u1ef1ng s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '\u8a9e\u5f59\u5fa9\u7fd2\u30d5\u30ed\u30fc\u306f\u3053\u3053\u306b\u8868\u793a\u3055\u308c\u307e\u3059\u3002';
    }
  }

  String get selectLevelToViewVocab {
    switch (this) {
      case AppLanguage.en:
        return 'Select a level to see vocab.';
      case AppLanguage.vi:
        return 'H\xe3y ch\u1ecdn c\u1ea5p \u0111\u1ec3 xem t\u1eeb v\u1ef1ng.';
      case AppLanguage.ja:
        return '\u5358\u8a9e\u3092\u898b\u308b\u306b\u306f\u30ec\u30d9\u30eb\u3092\u9078\u629e\u3057\u3066\u304f\u3060\u3055\u3044\u3002';
    }
  }

  String get vocabPreviewTitle {
    switch (this) {
      case AppLanguage.en:
        return 'Sample vocab';
      case AppLanguage.vi:
        return 'T\u1eeb v\u1ef1ng m\u1eabu';
      case AppLanguage.ja:
        return '\u30b5\u30f3\u30d7\u30eb\u5358\u8a9e';
    }
  }

  String get loadErrorLabel {
    switch (this) {
      case AppLanguage.en:
        return 'Failed to load data.';
      case AppLanguage.vi:
        return 'T\u1ea3i d\u1eef li\u1ec7u th\u1ea5t b\u1ea1i.';
      case AppLanguage.ja:
        return '\u30c7\u30fc\u30bf\u306e\u8aad\u307f\u8fbc\u307f\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002';
    }
  }

  String get grammarScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Grammar quiz flow will live here.';
      case AppLanguage.vi:
        return 'Lu\u1ed3ng quiz ng\u1eef ph\xe1p s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '\u6587\u6cd5\u30af\u30a4\u30ba\u306e\u30d5\u30ed\u30fc\u306f\u3053\u3053\u306b\u8868\u793a\u3055\u308c\u307e\u3059\u3002';
    }
  }

  String get examScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Mock exam flow will live here.';
      case AppLanguage.vi:
        return 'Lu\u1ed3ng thi th\u1eed s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '\u6a21\u64ec\u8a66\u9a13\u306e\u30d5\u30ed\u30fc\u306f\u3053\u3053\u306b\u8868\u793a\u3055\u308c\u307e\u3059\u3002';
    }
  }

  String get progressScreenBody {
    switch (this) {
      case AppLanguage.en:
        return 'Progress and streak view will live here.';
      case AppLanguage.vi:
        return 'Ti\u1ebfn \u0111\u1ed9 v\xe0 streak s\u1ebd hi\u1ec3n th\u1ecb \u1edf \u0111\xe2y.';
      case AppLanguage.ja:
        return '\u9032\u6357\u3068\u9023\u7d9a\u5b66\u7fd2\u306f\u3053\u3053\u306b\u8868\u793a\u3055\u308c\u307e\u3059\u3002';
    }
  }

  String get n3OnlyLabel {
    switch (this) {
      case AppLanguage.en:
        return 'N3 only';
      case AppLanguage.vi:
        return 'Ch\u1ec9 N3';
      case AppLanguage.ja:
        return 'N3\u306e\u307f';
    }
  }
}
