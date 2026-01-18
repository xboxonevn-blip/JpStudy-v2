
import 'package:flutter/material.dart';
import 'package:jpstudy/core/app_language.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.levelLabel,
    required this.language,
    required this.onVocabTap,
    required this.onDoTestTap,
    required this.onMatchGameTap,
  });

  final String levelLabel;
  final AppLanguage language;
  final VoidCallback onVocabTap;
  final VoidCallback onDoTestTap;
  final VoidCallback onMatchGameTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Study Modes ($levelLabel)",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ActionCard(
              title: "Vocab List",
              icon: Icons.list_alt,
              color: Colors.blue,
              onTap: onVocabTap,
            ),
            const SizedBox(width: 12),
            ActionCard(
              title: "Quiz Mode",
              icon: Icons.quiz,
              color: Colors.orange,
              onTap: onDoTestTap,
            ),
            const SizedBox(width: 12),
            ActionCard(
              title: "Match Game",
              icon: Icons.games,
              color: Colors.purple,
              onTap: onMatchGameTap,
            ),
          ],
        ),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final MaterialColor color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.shade100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
