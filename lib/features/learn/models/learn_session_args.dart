import '../../../data/models/vocab_item.dart';
import 'question_type.dart';

class LearnSessionArgs {
  final List<VocabItem> items;
  final int lessonId;
  final String lessonTitle;
  final List<QuestionType>? enabledTypes;

  const LearnSessionArgs({
    required this.items,
    required this.lessonId,
    required this.lessonTitle,
    this.enabledTypes,
  });
}
