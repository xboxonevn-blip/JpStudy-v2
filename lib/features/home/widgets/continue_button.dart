import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';

import '../providers/continue_provider.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionAsync = ref.watch(continueActionProvider);
    final language = ref.watch(appLanguageProvider);

    return actionAsync.when(
      data: (action) => _buildCard(context, action, language),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ContinueAction action,
    AppLanguage language,
  ) {
    final accent = _getAccentColor(action.type);
    final icon = _getIcon(action.type);
    final isNextLesson = action.type == ContinueActionType.nextLesson;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNavigation(context, action),
          borderRadius: BorderRadius.circular(26),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: accent.withValues(alpha: 0.28)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10213A59),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: isNextLesson
                ? _buildNextLessonStyle(action, language)
                : _buildCompactStyle(icon, accent, action, language),
          ),
        ),
      ),
    );
  }

  Widget _buildNextLessonStyle(ContinueAction action, AppLanguage language) {
    final accent = _getAccentColor(action.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_lesson_rounded, color: accent, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              language.nextStepLabel.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          language.nextLessonSubtitle,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 27,
            fontWeight: FontWeight.w900,
            height: 1.02,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getLabel(action, language),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            language.startPracticeLabel.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStyle(
    IconData icon,
    Color accent,
    ContinueAction action,
    AppLanguage language,
  ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withValues(alpha: 0.14),
          ),
          child: Icon(icon, color: accent, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getTitle(action.type, language),
                style: TextStyle(
                  color: accent.withValues(alpha: 0.92),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getLabel(action, language),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: accent.withValues(alpha: 0.9),
          size: 32,
        ),
      ],
    );
  }

  Color _getAccentColor(ContinueActionType type) {
    switch (type) {
      case ContinueActionType.grammarReview:
        return const Color(0xFF7C3AED);
      case ContinueActionType.vocabReview:
        return const Color(0xFF2563EB);
      case ContinueActionType.kanjiReview:
        return const Color(0xFF0E7490);
      case ContinueActionType.nextLesson:
        return const Color(0xFF16A34A);
      case ContinueActionType.fixMistakes:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF2563EB);
    }
  }

  IconData _getIcon(ContinueActionType type) {
    switch (type) {
      case ContinueActionType.grammarReview:
        return Icons.auto_stories_rounded;
      case ContinueActionType.vocabReview:
        return Icons.style_rounded;
      case ContinueActionType.kanjiReview:
        return Icons.brush_rounded;
      case ContinueActionType.nextLesson:
        return Icons.play_lesson_rounded;
      case ContinueActionType.fixMistakes:
        return Icons.warning_amber_rounded;
      default:
        return Icons.arrow_forward_rounded;
    }
  }

  String _getTitle(ContinueActionType type, AppLanguage language) {
    switch (type) {
      case ContinueActionType.grammarReview:
        return language.reviewGrammarLabel.toUpperCase();
      case ContinueActionType.vocabReview:
        return language.reviewVocabLabel.toUpperCase();
      case ContinueActionType.kanjiReview:
        return language.reviewKanjiLabel.toUpperCase();
      case ContinueActionType.nextLesson:
        return language.continueJourneyLabel.toUpperCase();
      case ContinueActionType.fixMistakes:
        return language.fixMistakesLabel.toUpperCase();
      default:
        return language.nextStepLabel.toUpperCase();
    }
  }

  String _getLabel(ContinueAction action, AppLanguage language) {
    if (action.type == ContinueActionType.nextLesson) {
      final number = action.label.replaceAll(RegExp(r'[^0-9]'), '');
      if (number.isNotEmpty) {
        return '${language.lessonLabel} $number';
      }
      return action.label;
    }
    if (action.count != null && action.count! > 0) {
      return language.itemsCountLabel(action.count!);
    }
    return action.label;
  }

  void _handleNavigation(BuildContext context, ContinueAction action) {
    switch (action.type) {
      case ContinueActionType.grammarReview:
        context.push('/grammar');
        break;
      case ContinueActionType.vocabReview:
        context.push('/vocab/review');
        break;
      case ContinueActionType.kanjiReview:
        context.push('/kanji-dash');
        break;
      case ContinueActionType.fixMistakes:
        context.push('/mistakes');
        break;
      case ContinueActionType.nextLesson:
        if (action.data != null) {
          context.push('/lesson/${action.data}');
        } else {
          context.push('/');
        }
        break;
      default:
        break;
    }
  }
}
