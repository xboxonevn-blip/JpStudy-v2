import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/seeds/grammar_seeder.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);

  // Trigger seeding (Fire-and-forget safe because of internal check)
  Future.microtask(() async {
    final seeder = GrammarSeeder(database.grammarDao);
    await seeder.seedGrammarData(database);
  });

  return database;
});
