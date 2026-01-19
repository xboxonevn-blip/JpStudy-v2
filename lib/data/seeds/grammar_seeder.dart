import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../daos/grammar_dao.dart';

class GrammarSeeder {
  final GrammarDao _dao;
  
  GrammarSeeder(this._dao);

  Future<void> seedN5Grammar() async {
    // Check if data already exists to avoid duplicates
    final existing = await _dao.getGrammarPointsByLevel('N5');
    if (existing.isNotEmpty) {
      return; 
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/grammar_n5.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      for (final item in jsonList) {
        final point = await _dao.into(_dao.db.grammarPoints).insertReturning(
          GrammarPointsCompanion.insert(
            grammarPoint: item['grammarPoint'],
            meaning: item['meaning'],
            meaningVi: Value(item['meaning_vi']),
            connection: item['connection'],
            explanation: item['explanation'],
            explanationVi: Value(item['explanation_vi']),
            jlptLevel: item['jlptLevel'],
            isLearned: const Value(false),
          ),
        );

        final examples = item['examples'] as List<dynamic>;
        for (final ex in examples) {
          await _dao.into(_dao.db.grammarExamples).insert(
            GrammarExamplesCompanion.insert(
              grammarId: point.id,
              japanese: ex['japanese'],
              translation: ex['translation'],
              translationVi: Value(ex['translation_vi']),
              audioUrl: Value(ex['audioUrl']),
            ),
          );
        }
        
        // Initialize SRS state immediately (or lazy load later)
        // Let's lazy load when they start learning to save space/logic
      }
    } catch (e) {
      debugPrint('Error seeding grammar: $e');
      // In production, might want to rethrow or log to analytics
    }
  }
}
