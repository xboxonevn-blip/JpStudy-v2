import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/data/db/content_database.dart';

final contentDatabaseProvider = Provider<ContentDatabase>((ref) {
  final database = ContentDatabase();
  ref.onDispose(database.close);
  return database;
});
