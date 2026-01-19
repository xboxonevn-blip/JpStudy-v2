import 'dart:ui';
import 'lesson_node.dart';

class Unit {
  final String id;
  final String title;
  final String description;
  final List<LessonNode> nodes;
  final Color color;

  const Unit({
    required this.id,
    required this.title,
    required this.description,
    required this.nodes,
    required this.color,
  });
}
