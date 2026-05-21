import 'dart:convert';

import 'package:flutter/services.dart';

import '../db/app_database.dart';
import '../models/grammar_directive_e_content.dart';

class GrammarDirectiveEAssetLookup {
  GrammarDirectiveEAssetLookup({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<GrammarDirectiveEContent?> findForPoint(GrammarPoint point) async {
    final lessonId = point.lessonId;
    if (lessonId == null) return null;

    final level = point.jlptLevel.trim().toLowerCase();
    if (level.isEmpty) return null;

    final path =
        'assets/data/content/grammar/$level/grammar_${level}_$lessonId.json';
    final items = await _loadJsonList(path);
    if (items == null) return null;

    final pointKeys = _keysFor([
      point.grammarPoint,
      point.connection,
      point.connectionEn,
      point.meaning,
      point.meaningVi,
      point.meaningEn,
    ]);

    for (final item in items) {
      if (item is! Map) continue;
      final map = item.cast<String, dynamic>();
      final directiveE = map['directiveE'];
      if (directiveE is! Map) continue;

      final itemKeys = _keysFor([
        map['title'],
        map['grammarPoint'],
        map['structure'],
        map['structureEn'],
        map['meaning'],
        map['meaning_vi'],
      ]);
      if (itemKeys.any(pointKeys.contains)) {
        return GrammarDirectiveEContent.fromJson(
          directiveE.cast<String, dynamic>(),
        );
      }
    }

    return null;
  }

  Future<List<dynamic>?> _loadJsonList(String path) async {
    try {
      final raw = await _bundle.loadString(path);
      final decoded = json.decode(raw);
      if (decoded is List) return decoded;
    } catch (_) {
      return null;
    }
    return null;
  }

  Set<String> _keysFor(Iterable<Object?> values) {
    return {
      for (final value in values)
        if (_normalize(value).isNotEmpty) _normalize(value),
    };
  }

  String _normalize(Object? value) {
    return (value ?? '')
        .toString()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s\u3000()\[\]{}:;,.!?/\\\-+・、。〜～`]+'), '')
        .trim();
  }
}
