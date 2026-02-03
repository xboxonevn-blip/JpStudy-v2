import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class KanjiStrokeTemplateService {
  KanjiStrokeTemplateService._();

  static final KanjiStrokeTemplateService instance =
      KanjiStrokeTemplateService._();

  static const _assetPath = 'assets/data/kanji/stroke_templates.json';

  Map<String, KanjiStrokeTemplate>? _templates;

  Future<KanjiStrokeTemplate?> getTemplate(String character) async {
    await _ensureLoaded();
    return _templates?[character];
  }

  Future<void> _ensureLoaded() async {
    if (_templates != null) return;
    final raw = (await rootBundle.loadString(_assetPath)).replaceFirst(
      '\uFEFF',
      '',
    );
    final decoded = jsonDecode(raw) as List<dynamic>;
    final templates = decoded
        .map((entry) => KanjiStrokeTemplate.fromJson(entry as Map<String, dynamic>))
        .toList();
    _templates = {for (final template in templates) template.character: template};
  }
}

class KanjiStrokeTemplate {
  const KanjiStrokeTemplate({
    required this.character,
    required this.strokes,
    this.targetArea = 0.32,
    this.targetAspect = 1.0,
    this.quality = 'manual',
  });

  final String character;
  final List<StrokeTemplate> strokes;
  final double targetArea;
  final double targetAspect;
  final String quality;

  String get normalizedQuality => quality.toLowerCase().trim();

  bool get isHighConfidence => normalizedQuality == 'manual';

  bool get isMediumConfidence => normalizedQuality == 'curated';

  factory KanjiStrokeTemplate.fromJson(Map<String, dynamic> json) {
    return KanjiStrokeTemplate(
      character: json['character'] as String,
      strokes: (json['strokes'] as List<dynamic>)
          .map((e) => StrokeTemplate.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetArea: (json['targetArea'] as num?)?.toDouble() ?? 0.32,
      targetAspect: (json['targetAspect'] as num?)?.toDouble() ?? 1.0,
      quality: (json['quality'] as String?)?.trim().isNotEmpty == true
          ? (json['quality'] as String).trim()
          : 'manual',
    );
  }
}

class StrokeTemplate {
  const StrokeTemplate({
    required this.start,
    required this.end,
  });

  final Point<double> start;
  final Point<double> end;

  factory StrokeTemplate.fromJson(Map<String, dynamic> json) {
    final start = (json['start'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
    final end = (json['end'] as List<dynamic>)
        .map((e) => (e as num).toDouble())
        .toList();
    return StrokeTemplate(
      start: Point(start[0], start[1]),
      end: Point(end[0], end[1]),
    );
  }
}
