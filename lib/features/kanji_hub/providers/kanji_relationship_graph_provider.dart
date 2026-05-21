import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/content_database_provider.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_graph_practice.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';

final kanjiRelationshipGraphAssetLoaderProvider =
    Provider<KanjiRelationshipGraphAssetLoader>(
      (ref) => KanjiRelationshipGraphAssetLoader(),
    );

final kanjiRelationshipGraphProvider =
    FutureProvider.family<KanjiRelationshipGraphData, String>((
      ref,
      character,
    ) async {
      final loader = ref.watch(kanjiRelationshipGraphAssetLoaderProvider);
      final allKanji = await loader.loadAllKanji();
      return KanjiRelationshipGraphBuilder.build(
        focusCharacter: _decodeRouteCharacter(character),
        allKanji: allKanji,
      );
    });

final kanjiGraphDbIdResolverProvider = Provider<KanjiGraphDbIdResolver>((ref) {
  return KanjiGraphDbIdResolver(ref.watch(contentDatabaseProvider));
});

final kanjiRelationshipGraphSrsTiersProvider =
    FutureProvider.family<Map<String, KanjiGraphSrsTier>, String>((
      ref,
      character,
    ) async {
      final graph = await ref.watch(
        kanjiRelationshipGraphProvider(character).future,
      );
      final resolver = ref.watch(kanjiGraphDbIdResolverProvider);
      final idsByCharacter = await resolver.resolveCharacters(
        graph.nodes
            .where((node) => node.item != null)
            .map((node) => node.character),
      );
      if (idsByCharacter.isEmpty) return const {};
      final states = await ref
          .watch(databaseProvider)
          .kanjiSrsDao
          .getStatesForIds(idsByCharacter.values.toList(growable: false));
      final stateById = {for (final state in states) state.kanjiId: state};
      final now = DateTime.now();
      return {
        for (final entry in idsByCharacter.entries)
          entry.key: kanjiGraphSrsTierFromState(
            nextReviewAt: stateById[entry.value]?.nextReviewAt,
            stability: stateById[entry.value]?.stability ?? 0,
            now: now,
          ),
      };
    });

final dueKanjiMiniGraphProvider = FutureProvider<KanjiRelationshipGraphData?>((
  ref,
) async {
  final level = ref.watch(studyLevelProvider);
  final dueIds = await ref.watch(databaseProvider).kanjiSrsDao.getDueKanjiIds();
  if (dueIds.isEmpty) return null;
  final contentDb = ref.watch(contentDatabaseProvider);
  final query = contentDb.select(contentDb.kanji)
    ..where((tbl) {
      final dueFilter = tbl.id.isIn(dueIds);
      final levelCode = level?.shortLabel;
      if (levelCode == null) return dueFilter;
      return dueFilter & tbl.jlptLevel.equals(levelCode);
    })
    ..limit(1);
  final row = await query.getSingleOrNull();
  if (row == null) return null;
  final graph = await ref.watch(
    kanjiRelationshipGraphProvider(row.character).future,
  );
  return KanjiRelationshipGraphBuilder.build(
    focusCharacter: graph.focus.character,
    allKanji: graph.nodes
        .map((node) => node.item)
        .whereType<KanjiItem>()
        .toList(growable: false),
    depthLimit: 1,
    maxNodes: 6,
  );
});

final kanjiGraphPracticeRecorderProvider = Provider<KanjiGraphPracticeRecorder>(
  (ref) {
    return KanjiGraphPracticeRecorder(
      resolver: ref.watch(kanjiGraphDbIdResolverProvider),
      recordReview: ({required int kanjiId, required int grade}) => ref
          .watch(databaseProvider)
          .kanjiSrsDao
          .recordReview(kanjiId: kanjiId, grade: grade),
    );
  },
);

class KanjiRelationshipGraphAssetLoader {
  KanjiRelationshipGraphAssetLoader({
    AssetBundle? bundle,
    this.levels,
    this.lessonCount = 25,
  }) : bundle = bundle ?? rootBundle;

  final AssetBundle bundle;
  final List<String>? levels;
  final int lessonCount;

  Future<List<KanjiItem>> loadAllKanji() async {
    final levelCodes =
        levels ??
        StudyLevel.values
            .map((level) => level.shortLabel.toLowerCase())
            .toList(growable: false);
    final futures = <Future<List<KanjiItem>>>[];
    var syntheticId = 1;
    for (final level in levelCodes) {
      for (var lessonId = 1; lessonId <= lessonCount; lessonId++) {
        final startId = syntheticId;
        syntheticId += 1000;
        futures.add(_loadLesson(level, lessonId, startId));
      }
    }
    final buckets = await Future.wait(futures);
    return [for (final bucket in buckets) ...bucket];
  }

  Future<List<KanjiItem>> _loadLesson(
    String level,
    int lessonId,
    int startId,
  ) async {
    final paddedLessonId = lessonId.toString().padLeft(2, '0');
    final path = 'assets/data/content/kanji/$level/lesson_$paddedLessonId.json';
    try {
      final raw = await bundle.loadString(path);
      final decoded = jsonDecode(raw);
      final payload = decoded is Map<String, dynamic> ? decoded : null;
      final entries = payload?['entries'];
      if (entries is! List) return const [];
      final items = <KanjiItem>[];
      var offset = 0;
      for (final rawEntry in entries) {
        final entry = _asMap(rawEntry);
        if (entry == null) continue;
        final item = _itemFromEntry(entry, fallbackId: startId + offset);
        if (item != null) {
          items.add(item);
          offset++;
        }
      }
      return items;
    } catch (_) {
      return const [];
    }
  }

  KanjiItem? _itemFromEntry(
    Map<String, dynamic> entry, {
    required int fallbackId,
  }) {
    final character = _readText(entry, 'character');
    if (character.isEmpty) return null;
    final labels = _asMap(entry['labels']);
    final readings = _asMap(entry['readings']);
    final mnemonic = _asMap(entry['mnemonic']);
    final legacy = _asMap(entry['legacy']);
    final meaning =
        _readNullableText(labels ?? const {}, 'meaningViDisplay') ??
        _readNullableText(labels ?? const {}, 'meaningVi') ??
        _readNullableText(legacy ?? const {}, 'meaning') ??
        character;
    final hanViet = _readNullableText(labels ?? const {}, 'hanViet');
    final decomposition = _asMap(entry['decomposition']);
    final decompositionModel = KanjiDecomposition.fromJson({
      if (decomposition != null) ...decomposition,
      if (hanViet != null && hanViet.isNotEmpty) 'hanViet': hanViet,
    });
    final examples = entry['examples'];
    return KanjiItem(
      id: fallbackId,
      lessonId: _readInt(entry, 'lessonId') ?? 0,
      character: character,
      strokeCount: _readInt(entry, 'strokeCount') ?? 0,
      onyomi: _readReading(readings, legacy, 'onyomi'),
      kunyomi: _readReading(readings, legacy, 'kunyomi'),
      meaning: meaning,
      meaningEn: _readNullableText(labels ?? const {}, 'meaningEn'),
      meaningJa: _readNullableText(labels ?? const {}, 'meaningJa'),
      mnemonicVi: _readNullableText(mnemonic ?? const {}, 'vi'),
      mnemonicEn: _readNullableText(mnemonic ?? const {}, 'en'),
      decomposition: decompositionModel.hasContent ? decompositionModel : null,
      examples: examples is List
          ? [
              for (final item in examples)
                if (_asMap(item) case final map?) KanjiExample.fromJson(map),
            ]
          : const [],
      jlptLevel: _readText(entry, 'level'),
    );
  }

  String? _readReading(
    Map<String, dynamic>? readings,
    Map<String, dynamic>? legacy,
    String key,
  ) {
    final raw = readings?[key];
    if (raw is List) {
      final text = raw
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join(', ');
      return text.isEmpty ? null : text;
    }
    return _readNullableText(legacy ?? const {}, key);
  }
}

class KanjiGraphDbIdResolver {
  KanjiGraphDbIdResolver(this.db);

  final ContentDatabase? db;

  Future<Map<String, int>> resolveCharacters(
    Iterable<String> characters,
  ) async {
    final contentDb = db;
    if (contentDb == null) return const {};
    final uniqueCharacters = characters
        .map((character) => character.trim())
        .where((character) => character.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (uniqueCharacters.isEmpty) return const {};
    final rows = await (contentDb.select(
      contentDb.kanji,
    )..where((tbl) => tbl.character.isIn(uniqueCharacters))).get();
    final result = <String, int>{};
    for (final row in rows) {
      result.putIfAbsent(row.character, () => row.id);
    }
    return result;
  }
}

class KanjiGraphPracticeRecorder {
  KanjiGraphPracticeRecorder({
    required this.resolver,
    required this.recordReview,
  });

  factory KanjiGraphPracticeRecorder.forTesting({
    required Future<void> Function(
      KanjiRelationshipGraphData graphData,
      KanjiGraphPracticeOutcome outcome,
    )
    onRecord,
  }) {
    return KanjiGraphPracticeRecorder(
      resolver: _NoopKanjiGraphDbIdResolver(),
      recordReview: ({required int kanjiId, required int grade}) async {},
    ).._testRecord = onRecord;
  }

  final KanjiGraphDbIdResolver resolver;
  final Future<void> Function({required int kanjiId, required int grade})
  recordReview;
  Future<void> Function(
    KanjiRelationshipGraphData graphData,
    KanjiGraphPracticeOutcome outcome,
  )?
  _testRecord;

  Future<void> record({
    required KanjiRelationshipGraphData graphData,
    required KanjiGraphPracticeOutcome outcome,
  }) async {
    final testRecord = _testRecord;
    if (testRecord != null) {
      await testRecord(graphData, outcome);
      return;
    }
    final idsByCharacter = await resolver.resolveCharacters(
      graphData.nodes
          .where((node) => node.item != null)
          .map((node) => node.character),
    );
    if (idsByCharacter.isEmpty) return;
    final targetCharacters = outcome.passed
        ? idsByCharacter.keys.toSet()
        : outcome.missedCharacters;
    final grade = outcome.passed ? 3 : 1;
    await Future.wait([
      for (final character in targetCharacters)
        if (idsByCharacter[character] case final kanjiId?)
          recordReview(kanjiId: kanjiId, grade: grade),
    ]);
  }
}

class _NoopKanjiGraphDbIdResolver extends KanjiGraphDbIdResolver {
  _NoopKanjiGraphDbIdResolver() : super(null);

  @override
  Future<Map<String, int>> resolveCharacters(
    Iterable<String> characters,
  ) async {
    return const {};
  }
}

String _decodeRouteCharacter(String character) {
  final trimmed = character.trim();
  if (!trimmed.contains('%')) return trimmed;
  return Uri.decodeComponent(trimmed).trim();
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, value) => MapEntry(key.toString(), value));
  }
  return null;
}

String _readText(Map<String, dynamic> json, String key) {
  return json[key]?.toString().trim() ?? '';
}

String? _readNullableText(Map<String, dynamic> json, String key) {
  final text = _readText(json, key);
  return text.isEmpty ? null : text;
}

int? _readInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
