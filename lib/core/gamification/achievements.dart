enum AchievementId {
  firstLesson, // Hoàn thành lesson đầu tiên
  perfectStreak7, // 7 ngày streak
  perfectStreak30, // 30 ngày streak
  nightOwl, // Học sau 10h tối (Cú đêm)
  kanjiMaster, // Thuộc 100 từ Kanji (Thánh Kanji)
  perfectScore, // Làm test không sai câu nào (Bàn tay vàng)
  speedRunner, // Hoàn thành match game < 20s
  comboKing, // Đạt combo x10 trong match game
}

class Achievement {
  const Achievement({
    required this.id,
    required this.titleEn,
    required this.titleVi,
    required this.titleJa,
    required this.descriptionEn,
    required this.descriptionVi,
    required this.descriptionJa,
    required this.icon,
    required this.xpReward,
  });

  final AchievementId id;
  final String titleEn;
  final String titleVi;
  final String titleJa;
  final String descriptionEn;
  final String descriptionVi;
  final String descriptionJa;
  final String icon; // Emoji or icon name
  final int xpReward;

  String getTitle(String languageCode) {
    switch (languageCode) {
      case 'vi':
        return titleVi;
      case 'ja':
        return titleJa;
      default:
        return titleEn;
    }
  }

  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'vi':
        return descriptionVi;
      case 'ja':
        return descriptionJa;
      default:
        return descriptionEn;
    }
  }
}

// Achievement definitions
const List<Achievement> allAchievements = [
  Achievement(
    id: AchievementId.firstLesson,
    titleEn: 'First Steps',
    titleVi: 'Bước đầu tiên',
    titleJa: '最初の一歩',
    descriptionEn: 'Complete your first lesson',
    descriptionVi: 'Hoàn thành bài học đầu tiên',
    descriptionJa: '最初のレッスンを完了',
    icon: '🎓',
    xpReward: 50,
  ),
  Achievement(
    id: AchievementId.perfectStreak7,
    titleEn: '7-Day Warrior',
    titleVi: 'Chiến binh 7 ngày',
    titleJa: '7日間の戦士',
    descriptionEn: 'Study for 7 days in a row',
    descriptionVi: 'Học liên tục 7 ngày',
    descriptionJa: '7日間連続で学習',
    icon: '🔥',
    xpReward: 100,
  ),
  Achievement(
    id: AchievementId.perfectStreak30,
    titleEn: 'Dedication Master',
    titleVi: 'Bậc thầy kiên trì',
    titleJa: '献身のマスター',
    descriptionEn: 'Study for 30 days in a row',
    descriptionVi: 'Học liên tục 30 ngày',
    descriptionJa: '30日間連続で学習',
    icon: '💎',
    xpReward: 500,
  ),
  Achievement(
    id: AchievementId.nightOwl,
    titleEn: 'Night Owl',
    titleVi: 'Cú đêm',
    titleJa: '夜更かし',
    descriptionEn: 'Study after 10 PM',
    descriptionVi: 'Học sau 10 giờ tối',
    descriptionJa: '午後10時以降に学習',
    icon: '🦉',
    xpReward: 50,
  ),
  Achievement(
    id: AchievementId.kanjiMaster,
    titleEn: 'Kanji Master',
    titleVi: 'Thánh Kanji',
    titleJa: '漢字マスター',
    descriptionEn: 'Learn 100 kanji terms',
    descriptionVi: 'Học thuộc 100 từ Kanji',
    descriptionJa: '100個の漢字を習得',
    icon: '📚',
    xpReward: 200,
  ),
  Achievement(
    id: AchievementId.perfectScore,
    titleEn: 'Golden Hand',
    titleVi: 'Bàn tay vàng',
    titleJa: '完璧な手',
    descriptionEn: 'Complete a test with 100% accuracy',
    descriptionVi: 'Hoàn thành bài test không sai câu nào',
    descriptionJa: '100%の正解率でテストを完了',
    icon: '✨',
    xpReward: 150,
  ),
  Achievement(
    id: AchievementId.speedRunner,
    titleEn: 'Speed Runner',
    titleVi: 'Tốc độ ánh sáng',
    titleJa: 'スピードランナー',
    descriptionEn: 'Complete match game in under 20 seconds',
    descriptionVi: 'Hoàn thành match game dưới 20 giây',
    descriptionJa: 'マッチゲームを20秒以内に完了',
    icon: '⚡',
    xpReward: 100,
  ),
  Achievement(
    id: AchievementId.comboKing,
    titleEn: 'Combo King',
    titleVi: 'Vua Combo',
    titleJa: 'コンボキング',
    descriptionEn: 'Achieve 10x combo in match game',
    descriptionVi: 'Đạt combo x10 trong match game',
    descriptionJa: 'マッチゲームで10連コンボ',
    icon: '👑',
    xpReward: 100,
  ),
];

class UserAchievement {
  const UserAchievement({
    required this.achievementId,
    required this.unlockedAt,
    required this.xpAwarded,
  });

  final AchievementId achievementId;
  final DateTime unlockedAt;
  final int xpAwarded;
}
