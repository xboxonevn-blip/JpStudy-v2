import 'package:drift/drift.dart';


/// Table to store Grammar Points (Concepts)
/// Based on Bunpro/JLPT data structure
class GrammarPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get grammarPoint => text().withLength(min: 1, max: 255)(); // e.g. "〜てはいけない"
  TextColumn get meaning => text()(); // e.g. "Must not, cannot"
  TextColumn get connection => text()(); // e.g. "Verb-て + は + いけない"
  TextColumn get explanation => text()(); // Detailed HTML or Markdown explanation
  TextColumn get jlptLevel => text().withLength(min: 2, max: 2)(); // e.g. "N5", "N4"
  BoolColumn get isLearned => boolean().withDefault(const Constant(false))();
}

/// Table to store Example Sentences for Grammar Points
class GrammarExamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get grammarId => integer().references(GrammarPoints, #id, onDelete: KeyAction.cascade)();
  TextColumn get japanese => text()(); // Full japanese sentence
  TextColumn get translation => text()(); // English/Vietnamese translation
  TextColumn get audioUrl => text().nullable()(); // Path to audio file if available
}

/// Table to store SRS Progress for Grammar
/// Includes "Ghost Review" logic (tracking specific failures)
class GrammarSrsState extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get grammarId => integer().references(GrammarPoints, #id, onDelete: KeyAction.cascade)();
  IntColumn get streak => integer().withDefault(const Constant(0))(); // Current correct streak
  RealColumn get ease => real().withDefault(const Constant(2.5))(); // SM-2 Ease factor
  DateTimeColumn get nextReviewAt => dateTime()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  
  // Ghost Review Logic
  // If > 0, this item is a "Ghost" generated from a mistake.
  // Reviews of ghosts don't advance the main SRS interval as much, or are auxiliary.
  IntColumn get ghostReviewsDue => integer().withDefault(const Constant(0))();
}
