import 'dart:convert';

class MistakeContext {
  final String? prompt;
  final String? correctAnswer;
  final String? userAnswer;
  final String? source;
  final Map<String, dynamic>? extra;

  const MistakeContext({
    this.prompt,
    this.correctAnswer,
    this.userAnswer,
    this.source,
    this.extra,
  });

  String? get extraJson {
    if (extra == null || extra!.isEmpty) return null;
    return jsonEncode(extra);
  }
}
