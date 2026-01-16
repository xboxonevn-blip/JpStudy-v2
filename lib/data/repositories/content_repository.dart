import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/content_database_provider.dart';

final vocabPreviewProvider =
    FutureProvider.family<List<VocabData>, String>((ref, level) async {
  final db = ref.watch(contentDatabaseProvider);
  final query = db.select(db.vocab)
    ..where((tbl) => tbl.level.equals(level))
    ..limit(5);
  return query.get();
});
