import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/app_database.dart';
import '../daos/grammar_dao.dart';

class GrammarSeeder {
  final GrammarDao _dao;
  
  // Tăng version này lên khi thay đổi file JSON data
  static const int kGrammarDataVersion = 1; 
  static const String kKeyGrammarVersion = 'grammar_data_version';

  GrammarSeeder(this._dao);

  Future<void> seedGrammarData(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();
    final currentVersion = prefs.getInt(kKeyGrammarVersion) ?? 0;

    // Smart Seeding: Chỉ chạy nếu version thay đổi hoặc chưa có data
    if (currentVersion >= kGrammarDataVersion) {
      debugPrint('⚡ Skipping Grammar Seed: Data is up to date (v$currentVersion)');
      return;
    }

    debugPrint('🔄 Starting Grammar Seed (v$kGrammarDataVersion)...');
    
    final stopwatch = Stopwatch()..start();

    // Chạy trong transaction để đảm bảo toàn vẹn dữ liệu
    await db.transaction(() async {
      await _seedLevel('N5', 1, 25);
      await _seedLevel('N4', 26, 50);
    });

    await prefs.setInt(kKeyGrammarVersion, kGrammarDataVersion);
    stopwatch.stop();
    debugPrint('✅ Grammar Seed Completed in ${stopwatch.elapsedMilliseconds}ms. Version updated to $kGrammarDataVersion');
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
                        grammarPoint: item['grammarPoint'] ?? item['title'], 
                        meaning: item['titleEn'] ?? item['meaning'] ?? '',
                        meaningVi: Value(item['title'] ?? item['meaning_vi']), 
                        connection: item['structure'] ?? item['connection'] ?? '',
                        explanation: item['explanation'] ?? '',
                        explanationVi: Value(item['explanation'] ?? item['explanation_vi']),
                        jlptLevel: level,
                        isLearned: const Value(false),
                    ),
                    mode: InsertMode.insertOrReplace,
                );

                // Insert Examples
                if (exJson != null) {
                    final exBlock = exJson.firstWhere(
                        (e) => e['grammarPoint'] == item['title'], 
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
            debugPrint('   -> Seeded Lesson $i ($level)');
        } catch (e) {
            debugPrint('   -> Error seeding Lesson $i: $e');
        }
    }
  }
}
