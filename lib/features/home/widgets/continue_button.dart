import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/continue_provider.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionAsync = ref.watch(continueActionProvider);

    return actionAsync.when(
      data: (action) => _buildButton(context, action),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildButton(BuildContext context, ContinueAction action) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Determine color based on action type
    Color btnColor = colorScheme.primaryContainer;
    Color iconColor = colorScheme.onPrimaryContainer;
    IconData icon = Icons.play_arrow_rounded;

    switch (action.type) {
      case ContinueActionType.grammarReview:
        btnColor = colorScheme.tertiaryContainer;
        iconColor = colorScheme.onTertiaryContainer;
        icon = Icons.auto_stories;
        break;
      case ContinueActionType.vocabReview:
        btnColor = colorScheme.secondaryContainer;
        iconColor = colorScheme.onSecondaryContainer;
        icon = Icons.style; // Cards
        break;
      case ContinueActionType.fixMistakes:
        btnColor = colorScheme.errorContainer;
        iconColor = colorScheme.onErrorContainer;
        icon = Icons.build;
        break;
      case ContinueActionType.nextLesson:
        btnColor = colorScheme.primary;
        iconColor = colorScheme.onPrimary;
        icon = Icons.arrow_forward;
        break;
      default:
        break;
    }

    // Fix color types if needed (Colors.purpleContainer doesn't exist in MaterialColor directly usually, needs context or ColorScheme)
    // Using simple colors for now or mapping from scheme.
    if (action.type == ContinueActionType.grammarReview) {
       btnColor = colorScheme.tertiaryContainer;
       iconColor = colorScheme.onTertiaryContainer;
    } else if (action.type == ContinueActionType.fixMistakes) {
       btnColor = colorScheme.errorContainer;
       iconColor = colorScheme.onErrorContainer;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: FilledButton.icon(
        onPressed: () {
          // Handle navigation
          _handleNavigation(context, action);
        },
        style: FilledButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: iconColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          _getLabel(action),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getLabel(ContinueAction action) {
    if (action.count != null && action.count! > 0) {
      return '${action.label} (${action.count})';
    }
    return action.label;
  }

  void _handleNavigation(BuildContext context, ContinueAction action) {
    switch (action.type) {
      case ContinueActionType.grammarReview:
        context.push('/grammar');
        break;
      case ContinueActionType.vocabReview:
        context.push('/vocab');
        break;
      case ContinueActionType.fixMistakes:
        context.push('/mistakes');
        break;
      case ContinueActionType.nextLesson:
        // Logic to find next lesson and go there
        // For now, go to /? to trigger path? Or stay in Path.
        // Actually since this button is ON the path, "Next Lesson" might mean "Launch the next unlocked lesson".
        // But doing that analysis here is hard without data.
        // Just scroll? Or do nothing?
        // Let's make it go to the first unit if generic.
        // Or if we can find the next lesson ID, push /lesson/:id.
        // For now:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select the next unlocked lesson from the path above!')),
        );
        break;
      default:
        break;
    }
  }
}
