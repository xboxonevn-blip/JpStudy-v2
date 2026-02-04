import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/write/services/handwriting_evaluator.dart';
import 'package:jpstudy/features/write/services/kanji_stroke_template_service.dart';

import 'handwriting_scoring_test_utils.dart';

void main() {
  KanjiStrokeTemplate buildTemplate(String quality) {
    return KanjiStrokeTemplate(
      character: '木',
      quality: quality,
      targetArea: 0.33,
      targetAspect: 1.0,
      strokes: const [
        StrokeTemplate(start: Point(0.10, 0.15), end: Point(0.78, 0.18)),
        StrokeTemplate(start: Point(0.30, 0.32), end: Point(0.74, 0.36)),
        StrokeTemplate(start: Point(0.52, 0.08), end: Point(0.48, 0.88)),
        StrokeTemplate(start: Point(0.22, 0.56), end: Point(0.12, 0.84)),
        StrokeTemplate(start: Point(0.66, 0.58), end: Point(0.90, 0.82)),
      ],
    );
  }

  test('accepts clean template-like writing for all quality tiers (v2)', () {
    const canvas = Size(220, 220);
    for (final quality in ['manual', 'curated', 'generated']) {
      final template = buildTemplate(quality);
      final strokes = buildStrokesFromTemplate(
        template,
        jitter: 0.35,
        seed: 42,
      );
      final result = HandwritingEvaluator.evaluate(
        strokes: strokes,
        expectedStrokes: template.strokes.length,
        canvasSize: canvas,
        showGuide: false,
        template: template,
        scoringVersion: HandwritingScoringVersion.v2,
      );
      expect(
        result.isCorrect,
        isTrue,
        reason: 'Expected accepted stroke for quality=$quality',
      );
    }
  });

  test('rejects 20+ representative wrong stroke cases (order/shape/start-end)', () {
    const canvas = Size(220, 220);
    final template = buildTemplate('manual');
    final negatives = Map<String, StrokeSequence>.from(
      buildRegressionNegativeCases(template),
    )..remove('order_reverse_all');
    expect(negatives.length, greaterThanOrEqualTo(20));
    final rejected = <String>[];

    for (final entry in negatives.entries) {
      final result = HandwritingEvaluator.evaluate(
        strokes: entry.value,
        expectedStrokes: template.strokes.length,
        canvasSize: canvas,
        showGuide: false,
        template: template,
        scoringVersion: HandwritingScoringVersion.v2,
      );
      if (!result.isCorrect) {
        rejected.add(entry.key);
      }
    }

    final orderRejected = rejected.where((name) => name.startsWith('order_')).length;
    final shapeRejected = rejected.where((name) => name.startsWith('shape_')).length;
    final endpointRejected = rejected.where((name) => name.startsWith('endpoint_')).length;

    expect(
      rejected.length,
      greaterThanOrEqualTo(20),
      reason: 'manual rejected=${rejected.join(',')}',
    );
    expect(
      orderRejected,
      greaterThanOrEqualTo(3),
      reason: 'manual orderRejected=$orderRejected',
    );
    expect(
      shapeRejected,
      greaterThanOrEqualTo(3),
      reason: 'manual shapeRejected=$shapeRejected',
    );
    expect(
      endpointRejected,
      greaterThanOrEqualTo(1),
      reason: 'manual endpointRejected=$endpointRejected',
    );
  });
}
