import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import '../providers/continue_provider.dart';

class ContinueButton extends ConsumerStatefulWidget {
  const ContinueButton({super.key});

  @override
  ConsumerState<ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends ConsumerState<ContinueButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionAsync = ref.watch(continueActionProvider);
    final language = ref.watch(appLanguageProvider);

    return actionAsync.when(
      data: (action) => _buildAnimatedButton(context, action, language),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildAnimatedButton(
    BuildContext context,
    ContinueAction action,
    AppLanguage language,
  ) {
    final gradient = _getGradient(action.type);
    final icon = _getIcon(action.type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          width: double.infinity,
          height: 64, // Floating Card Height
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _handleNavigation(context, action),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTitle(action.type, language),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            _getLabel(action, language),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradient(ContinueActionType type) {
    switch (type) {
      case ContinueActionType.grammarReview:
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)], // Violet
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ContinueActionType.vocabReview:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)], // Blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ContinueActionType.nextLesson:
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)], // Emerald
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getIcon(ContinueActionType type) {
    switch (type) {
      case ContinueActionType.grammarReview:
        return Icons.auto_stories_rounded;
      case ContinueActionType.vocabReview:
        return Icons.style_rounded;
      case ContinueActionType.nextLesson:
        return Icons.play_lesson_rounded;
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
      // Extract number from "Lesson 3" -> "3"
      final number = action.label.replaceAll(RegExp(r'[^0-9]'), '');
      if (number.isNotEmpty) {
        // Return localized "Bài 3"
        return '${language.lessonLabel} $number';
      }
      // Fallback if no number found
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
        // Maps to /grammar (list) or /grammar-practice
        context.push('/grammar');
        break;
      case ContinueActionType.vocabReview:
        context.push('/vocab/review');
        break;
      case ContinueActionType.fixMistakes:
        context.push('/mistakes');
        break;
      case ContinueActionType.nextLesson:
        if (action.data != null) {
          context.push('/lesson/${action.data}');
        } else {
          // Should not happen if data is correctly set
          context.push('/');
        }
        break;
      default:
        break;
    }
  }
}
