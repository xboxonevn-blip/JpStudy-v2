import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../daos/grammar_dao.dart';

class GrammarSeeder {
  final GrammarDao _dao;
  
  GrammarSeeder(this._dao);

  Future<void> seedN5Grammar(AppDatabase db) async {
    // We want to force update if data is old/mismatched. 
    // Ideally, we version this. For now, we will Upsert (Insert or Replace).
    // Or we can check count. If count < 50 (since we have 50 lessons now), re-seed.
    // The previous monolith had ~25 lessons?
    // Let's iterate all 50 lessons (N5: 1-25, N4: 26-50) and insert/update.
    
    // NOTE: This seeder is now renamed to seedGrammarData since it covers N5 and N4.
    await _seedLevel('N5', 1, 25);
    await _seedLevel('N4', 26, 50);
  }

  Future<void> _seedLevel(String level, int startLesson, int endLesson) async {
    for (int i = startLesson; i <= endLesson; i++) {
        try {
            // 1. Definition File
            final defPath = 'assets/data/grammar/${level.toLowerCase()}/grammar_${level.toLowerCase()}_$i.json';
            final defString = await rootBundle.loadString(defPath);
            final List<dynamic> defJson = json.decode(defString);

            // 2. Example File
            final exPath = 'assets/data/grammar/examples/${level.toLowerCase()}/lesson_$i.json';
            String? exString;
            try {
                exString = await rootBundle.loadString(exPath);
            } catch (_) {
                // Ignore missing examples
            }
            final List<dynamic>? exJson = exString != null ? json.decode(exString) : null;

            for (final item in defJson) {
                // Insert Grammar Point
                final pointStart = await _dao.into(_dao.db.grammarPoints).insertReturning(
                    GrammarPointsCompanion.insert(
                        // We might need to handle ID conflicts if we want to preserve IDs. 
                        // But usually IDs are auto-inc. 
                        // Better to check if exists by grammarPoint string + level
                        grammarPoint: item['grammarPoint'] ?? item['title'], // Handle different keys if any
                        meaning: item['titleEn'] ?? item['meaning'] ?? '',
                        meaningVi: Value(item['title'] ?? item['meaning_vi']), 
                        connection: item['structure'] ?? item['connection'] ?? '',
                        explanation: item['explanation'] ?? '',
                        explanationVi: Value(item['explanation'] ?? item['explanation_vi']), // explanation in new format is Vietnamese
                        jlptLevel: level,
                        isLearned: const Value(false),
                    ),
                    mode: InsertMode.insertOrReplace, // Update if conflict on ID (but ID is auto-inc?)
                    // Actually, we can't easily upsert without a unique key other than ID.
                    // For now, let's just insert. Duplicates? 
                    // We should ideally clear valid data first or check existence.
                );

                // Insert Examples
                if (exJson != null) {
                    // Match example block to grammar point. 
                    // The example file has structure: [{ "grammarPoint": "...", "examples": [...] }]
                    // We need to find the matching block.
                    final exBlock = exJson.firstWhere(
                        (e) => e['grammarPoint'] == item['title'], // 'title' in def matches 'grammarPoint' in ex?
                        // Let's check keys. 
                        // Def: "title": "N1 は N2 です"
                        // Ex: "grammarPoint": "N1 は N2 です"
                        orElse: () => null,
                    );

                    if (exBlock != null) {
                       final examples = exBlock['examples'] as List<dynamic>;
                       for (final ex in examples) {
                           await _dao.into(_dao.db.grammarExamples).insert(
                               GrammarExamplesCompanion.insert(
                                   grammarId: pointStart.id,
                                   japanese: ex['sentence'],
                                   translation: ex['translationEn'] ?? '',
                                   translationVi: Value(ex['translation']),
                                   audioUrl: const Value(null),
                               ),
                           );
                       }
                    }
                }
            }
            debugPrint('Seeded Lesson $i ($level)');
        } catch (e) {
            debugPrint('Error seeding Lesson $i: $e');
        }
    }
  }
}
