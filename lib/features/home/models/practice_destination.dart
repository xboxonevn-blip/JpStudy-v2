import 'package:flutter/material.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/grammar/screens/grammar_practice_screen.dart';

class PracticeDestination {
  const PracticeDestination({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
    this.extra,
    this.badgeCount,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
  final Object? extra;
  final int? badgeCount;
}

List<PracticeDestination> buildPracticeDestinations({
  required AppLanguage language,
  int ghostCount = 0,
  int mistakeCount = 0,
}) {
  return [
    PracticeDestination(
      title: language.practiceMatchLabel,
      subtitle: language.practiceMatchSubtitle,
      icon: Icons.extension_rounded,
      color: const Color(0xFF0EA5E9),
      route: '/match',
    ),
    PracticeDestination(
      title: language.practiceGhostLabel,
      subtitle: language.practiceGhostSubtitle,
      icon: Icons.auto_fix_high_rounded,
      color: const Color(0xFFF43F5E),
      route: '/grammar-practice',
      extra: GrammarPracticeMode.ghost,
      badgeCount: ghostCount > 0 ? ghostCount : null,
    ),
    PracticeDestination(
      title: language.practiceKanjiDashLabel,
      subtitle: language.practiceKanjiDashSubtitle,
      icon: Icons.flash_on_rounded,
      color: const Color(0xFFF59E0B),
      route: '/kanji-dash',
    ),
    PracticeDestination(
      title: language.writeModeHandwritingLabel,
      subtitle: language.writeModeHandwritingSubtitle,
      icon: Icons.draw_rounded,
      color: const Color(0xFF0F766E),
      route: '/practice/handwriting',
    ),
    PracticeDestination(
      title: language.practiceExamCardLabel,
      subtitle: language.practiceExamSubtitle,
      icon: Icons.quiz_rounded,
      color: const Color(0xFF14B8A6),
      route: '/practice/mock-exam',
    ),
    PracticeDestination(
      title: language.practiceImmersionLabel,
      subtitle: language.practiceImmersionSubtitle,
      icon: Icons.newspaper_rounded,
      color: const Color(0xFF2563EB),
      route: '/immersion',
    ),
    PracticeDestination(
      title: language.practiceMistakesLabel,
      subtitle: language.practiceMistakesSubtitle,
      icon: Icons.warning_amber_rounded,
      color: const Color(0xFFDC2626),
      route: '/mistakes',
      badgeCount: mistakeCount > 0 ? mistakeCount : null,
    ),
  ];
}
