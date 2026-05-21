import 'dart:convert';
import 'dart:io';

import 'package:jpstudy/core/srs/cross_modal_srs.dart';

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
      'usage: dart run tool/migration/migrate_srs_to_cross_modal.dart input.json output.json',
    );
    exitCode = 64;
    return;
  }

  final input = jsonDecode(File(args[0]).readAsStringSync());
  if (input is! Map<String, Object?>) {
    stderr.writeln('input_json_must_be_object');
    exitCode = 65;
    return;
  }

  final legacy = <LegacySrsSnapshot>[
    ..._readVocab(input['srs']),
    ..._readGrammar(input['grammarSrs']),
    ..._readKanji(input['kanjiSrs']),
  ];
  final migrated = const CrossModalSrsMigrator().migrateLegacy(legacy);
  final output = {
    'schemaVersion': 1,
    'generatedAt': DateTime.now().toIso8601String(),
    'items': migrated.map((item) => item.toJson()).toList(growable: false),
  };
  File(
    args[1],
  ).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(output));
}

Iterable<LegacySrsSnapshot> _readVocab(Object? raw) sync* {
  for (final row in _rows(raw)) {
    final id = row['vocabId'] ?? row['vocab_id'];
    if (id == null) continue;
    yield _snapshot('vocab', '$id', row);
  }
}

Iterable<LegacySrsSnapshot> _readGrammar(Object? raw) sync* {
  for (final row in _rows(raw)) {
    final id = row['grammarId'] ?? row['grammar_id'];
    if (id == null) continue;
    yield _snapshot('grammar', '$id', row);
  }
}

Iterable<LegacySrsSnapshot> _readKanji(Object? raw) sync* {
  for (final row in _rows(raw)) {
    final id = row['kanjiId'] ?? row['kanji_id'];
    if (id == null) continue;
    yield _snapshot('kanji', '$id', row);
  }
}

List<Map<String, Object?>> _rows(Object? raw) {
  return (raw as List? ?? const [])
      .whereType<Map>()
      .map((row) => row.cast<String, Object?>())
      .toList(growable: false);
}

LegacySrsSnapshot _snapshot(
  String itemType,
  String itemId,
  Map<String, Object?> row,
) {
  return LegacySrsSnapshot(
    itemType: itemType,
    itemId: itemId,
    repetitions: _int(row['repetitions'] ?? row['reps']),
    stability: _double(row['stability'], fallback: 1),
    difficulty: _double(row['difficulty'], fallback: 5),
    fsrsState: _int(row['fsrsState'] ?? row['fsrs_state'], fallback: 1),
    fsrsStep: _nullableInt(row['fsrsStep'] ?? row['fsrs_step']),
    lastConfidence: _int(row['lastConfidence'] ?? row['last_confidence']),
    lastReviewedAt: _date(row['lastReviewedAt'] ?? row['last_reviewed_at']),
    nextReviewAt: _date(row['nextReviewAt'] ?? row['next_review_at']),
  );
}

int _int(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}

int? _nullableInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse('$value');
}

double _double(Object? value, {required double fallback}) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value') ?? fallback;
}

DateTime? _date(Object? value) {
  if (value == null) return null;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return DateTime.tryParse('$value');
}
