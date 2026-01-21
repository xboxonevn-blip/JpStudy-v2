import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/continue_provider.dart';
import '../../common/widgets/clay_button.dart';

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
    ClayButtonStyle style = ClayButtonStyle.primary;
    IconData icon = Icons.play_arrow_rounded;

    switch (action.type) {
      case ContinueActionType.grammarReview:
        style = ClayButtonStyle.tertiary; // Orange for Grammar
        icon = Icons.auto_stories;
        break;
      case ContinueActionType.vocabReview:
        style = ClayButtonStyle.primary; // Indigo for Vocab
        icon = Icons.style;
        break;
      case ContinueActionType.fixMistakes:
        style = ClayButtonStyle.neutral; // White for Mistakes 
        // Note: Neutral usually has gray text, might want custom later.
        icon = Icons.build_circle;
        break;
      case ContinueActionType.nextLesson:
        style = ClayButtonStyle.secondary; // Green for "Go"
        icon = Icons.arrow_forward_rounded;
        break;
      default:
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ClayButton(
          label: _getLabel(action),
          icon: icon,
          style: style,
          isExpanded: true, // Make text centered
          onPressed: () => _handleNavigation(context, action),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select the next unlocked lesson from the path above!')),
        );
        break;
      default:
        break;
    }
  }
}
