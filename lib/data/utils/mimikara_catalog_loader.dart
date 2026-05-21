import 'dart:convert';

import 'package:flutter/services.dart';

class MimikaraUnitCatalog {
  const MimikaraUnitCatalog({
    required this.levelCode,
    required this.title,
    required this.sourceCredit,
    required this.sourceMode,
    required this.units,
  });

  final String levelCode;
  final String title;
  final String sourceCredit;
  final String sourceMode;
  final List<MimikaraUnitSummary> units;

  int get totalTerms => units.fold<int>(0, (sum, unit) => sum + unit.termCount);
}

class MimikaraUnitSummary {
  const MimikaraUnitSummary({
    required this.unitId,
    required this.lessonId,
    required this.title,
    required this.termCount,
    required this.previewTerms,
    required this.fileName,
    required this.sourceMode,
  });

  final int unitId;
  final int lessonId;
  final String title;
  final int termCount;
  final List<String> previewTerms;
  final String fileName;
  final String sourceMode;
}

class MimikaraUnitDetail {
  const MimikaraUnitDetail({
    required this.levelCode,
    required this.unitId,
    required this.title,
    required this.sourceMode,
    required this.entries,
  });

  final String levelCode;
  final int unitId;
  final String title;
  final String sourceMode;
  final List<MimikaraUnitEntry> entries;
}

class MimikaraUnitEntry {
  const MimikaraUnitEntry({
    required this.term,
    required this.reading,
    required this.meaningVi,
    required this.meaningEn,
    required this.hanViet,
    required this.exampleSentencesJson,
  });

  final String term;
  final String? reading;
  final String meaningVi;
  final String? meaningEn;
  final String? hanViet;
  final String exampleSentencesJson;
}

final _catalogCache = <String, MimikaraUnitCatalog>{};
final _detailCache = <String, MimikaraUnitDetail?>{};

Future<MimikaraUnitCatalog> loadMimikaraUnitCatalog(String levelCode) async {
  final normalizedLevel = levelCode.trim().toUpperCase();
  final cached = _catalogCache[normalizedLevel];
  if (cached != null) return cached;

  final levelLower = normalizedLevel.toLowerCase();
  final raw = await rootBundle.loadString(
    'assets/data/content/vocab/$levelLower/mimikara/index.json',
  );
  final payload = _asStringMap(json.decode(raw));
  final unitsRaw = payload['units'] is List
      ? payload['units'] as List
      : const [];
  final units = [
    for (final rawUnit in unitsRaw)
      if (rawUnit is Map) _mapSummary(_asStringMap(rawUnit)),
  ]..sort((left, right) => left.unitId.compareTo(right.unitId));

  final catalog = MimikaraUnitCatalog(
    levelCode: normalizedLevel,
    title: 'Mimikara $normalizedLevel',
    sourceCredit: _cleanText(payload['sourceCredit']),
    sourceMode: _cleanText(payload['sourceMode']),
    units: units,
  );
  _catalogCache[normalizedLevel] = catalog;
  return catalog;
}

Future<MimikaraUnitDetail?> loadMimikaraUnitDetail(
  String levelCode,
  int unitId,
) async {
  final normalizedLevel = levelCode.trim().toUpperCase();
  final key = '$normalizedLevel:$unitId';
  if (_detailCache.containsKey(key)) return _detailCache[key];

  final catalog = await loadMimikaraUnitCatalog(normalizedLevel);
  MimikaraUnitSummary? unit;
  for (final item in catalog.units) {
    if (item.unitId == unitId) {
      unit = item;
      break;
    }
  }
  if (unit == null) {
    _detailCache[key] = null;
    return null;
  }

  final levelLower = normalizedLevel.toLowerCase();
  final raw = await rootBundle.loadString(
    'assets/data/content/vocab/$levelLower/mimikara/${unit.fileName}',
  );
  final payload = _asStringMap(json.decode(raw));
  final entriesRaw = payload['entries'] is List
      ? payload['entries'] as List
      : const [];
  final detail = MimikaraUnitDetail(
    levelCode: normalizedLevel,
    unitId: unit.unitId,
    title: _cleanText(payload['unitTitle']).isNotEmpty
        ? _cleanText(payload['unitTitle'])
        : unit.title,
    sourceMode: _cleanText(payload['sourceMode']),
    entries: [
      for (final rawEntry in entriesRaw)
        if (rawEntry is Map) _mapEntry(_asStringMap(rawEntry)),
    ],
  );
  _detailCache[key] = detail;
  return detail;
}

MimikaraUnitSummary _mapSummary(Map<String, dynamic> unit) {
  return MimikaraUnitSummary(
    unitId: _intValue(unit['unitId']),
    lessonId: _intValue(unit['lessonId']),
    title: _cleanText(unit['title']),
    termCount: _intValue(unit['termCount']),
    previewTerms: [
      for (final item
          in (unit['previewTerms'] is List
              ? unit['previewTerms'] as List
              : const []))
        if (_cleanText(item).isNotEmpty) _cleanText(item),
    ],
    fileName: _cleanText(unit['file']),
    sourceMode: _cleanText(unit['sourceMode']),
  );
}

MimikaraUnitEntry _mapEntry(Map<String, dynamic> entry) {
  final lemma = _asStringMap(entry['lemma']);
  final sense = _asStringMap(entry['sense']);
  final labels = _asStringMap(lemma['labels']);
  return MimikaraUnitEntry(
    term: _cleanText(lemma['term']),
    reading: _nullIfEmpty(_cleanText(lemma['reading'])),
    meaningVi: _cleanText(sense['meaningVi']),
    meaningEn: _nullIfEmpty(_cleanText(sense['meaningEn'])),
    hanViet: _nullIfEmpty(_cleanText(labels['hanViet'])),
    exampleSentencesJson: entry['example_sentences'] is List
        ? json.encode(entry['example_sentences'])
        : '[]',
  );
}

Map<String, dynamic> _asStringMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return const {};
}

int _intValue(Object? raw) {
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  return int.tryParse('${raw ?? ''}') ?? 0;
}

String _cleanText(Object? raw) => '${raw ?? ''}'.trim();

String? _nullIfEmpty(String value) => value.isEmpty ? null : value;
