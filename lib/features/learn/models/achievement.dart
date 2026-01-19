import 'package:flutter/material.dart';

/// Achievement types
enum AchievementType {
  perfectRound,
  streak,
  levelUp,
  masteryComplete,
  speedDemon,
}

extension AchievementTypeExtension on AchievementType {
  String get title {
    switch (this) {
      case AchievementType.perfectRound:
        return 'Perfect Round!';
      case AchievementType.streak:
        return 'Study Streak!';
      case AchievementType.levelUp:
        return 'Level Up!';
      case AchievementType.masteryComplete:
        return 'Mastery Complete!';
      case AchievementType.speedDemon:
        return 'Speed Demon!';
    }
  }

  String get emoji {
    switch (this) {
      case AchievementType.perfectRound:
        return '🏆';
      case AchievementType.streak:
        return '🔥';
      case AchievementType.levelUp:
        return '⭐';
      case AchievementType.masteryComplete:
        return '🎓';
      case AchievementType.speedDemon:
        return '⚡';
    }
  }

  Color get color {
    switch (this) {
      case AchievementType.perfectRound:
        return Colors.amber;
      case AchievementType.streak:
        return Colors.deepOrange;
      case AchievementType.levelUp:
        return Colors.purple;
      case AchievementType.masteryComplete:
        return Colors.green;
      case AchievementType.speedDemon:
        return Colors.blue;
    }
  }
}

/// Achievement data model
class Achievement {
  final AchievementType type;
  final int value;
  final DateTime earnedAt;
  final int? lessonId;
  final String? sessionId;
  final bool isNotified;

  const Achievement({
    required this.type,
    required this.value,
    required this.earnedAt,
    this.lessonId,
    this.sessionId,
    this.isNotified = false,
  });

  String get description {
    switch (type) {
      case AchievementType.perfectRound:
        return 'Answered all questions correctly!';
      case AchievementType.streak:
        return '$value day study streak!';
      case AchievementType.levelUp:
        return 'Reached level $value!';
      case AchievementType.masteryComplete:
        return 'Mastered all terms in lesson!';
      case AchievementType.speedDemon:
        return 'Completed in record time!';
    }
  }

  int get bonusXP {
    switch (type) {
      case AchievementType.perfectRound:
        return 50;
      case AchievementType.streak:
        return value * 10;
      case AchievementType.levelUp:
        return 100;
      case AchievementType.masteryComplete:
        return 75;
      case AchievementType.speedDemon:
        return 25;
    }
  }
}
