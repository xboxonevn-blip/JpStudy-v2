import 'dart:convert';
import 'dart:io';

import 'conjugation_class.dart';
import 'conjugation_form.dart';
import 'japanese_conjugator.dart';

class ConjugationLemmaBuilder {
  const ConjugationLemmaBuilder._();

  static Future<ConjugationLemmaBuildReport> build({
    required Directory contentRoot,
    required File jmdictCache,
    DateTime? generatedAt,
  }) async {
    final jmdict = await _JmDictIndex.load(jmdictCache);
    final vocab = await _loadCurriculumVocab(contentRoot);
    final entries = <ConjugationLemmaEntry>[];
    final unmatched = <ConjugationSkippedEntry>[];
    final suffixOnlySkipped = <ConjugationSkippedEntry>[];
    final ambiguous = <ConjugationSkippedEntry>[];

    for (final item in vocab) {
      final match = jmdict.match(item);
      if (match == null) {
        if (item.looksConjugatable) {
          unmatched.add(ConjugationSkippedEntry._fromVocab(item));
        }
        continue;
      }
      if (match.isAmbiguous) {
        ambiguous.add(ConjugationSkippedEntry._fromVocab(item));
        continue;
      }

      final jmdictEntry = match.entry!;
      if (jmdictEntry.isSuffixOnly) {
        suffixOnlySkipped.add(ConjugationSkippedEntry._fromVocab(item));
        continue;
      }

      final spec = ConjugationSpec.fromJmDictPos(
        jmdictEntry.posTags,
        lemma: jmdictEntry.primaryTerm,
      );
      if (spec == null) {
        if (item.looksConjugatable) {
          unmatched.add(ConjugationSkippedEntry._fromVocab(item));
        }
        continue;
      }

      entries.add(
        ConjugationLemmaEntry(
          id: entries.length + 1,
          contentEntryId: item.entryId,
          contentVocabId: item.vocabId,
          term: item.term,
          reading: item.reading,
          dictionaryForm: jmdictEntry.primaryTerm,
          dictionaryReading: jmdictEntry.primaryReading,
          kind: _kindLabel(spec),
          conjugationClass: _classLabel(spec),
          posTags: jmdictEntry.posTags,
          jmdictEntrySeq: jmdictEntry.entrySeq,
          sourceVocabId: item.sourceVocabId,
          sourceSenseId: item.sourceSenseId,
          level: item.level,
          series: item.series,
          lessonId: item.lessonId,
          sourcePath: item.sourcePath,
          matchMethod: match.method,
        ),
      );
    }

    entries.sort((a, b) {
      final level = _levelSortKey(a.level).compareTo(_levelSortKey(b.level));
      if (level != 0) return level;
      final series = a.series.compareTo(b.series);
      if (series != 0) return series;
      final lesson = a.lessonId.compareTo(b.lessonId);
      if (lesson != 0) return lesson;
      return a.contentVocabId.compareTo(b.contentVocabId);
    });

    return ConjugationLemmaBuildReport(
      generatedAt: (generatedAt ?? DateTime.now().toUtc()).toUtc(),
      entries: [
        for (var index = 0; index < entries.length; index++)
          entries[index].copyWith(id: index + 1),
      ],
      unmatchedConjugatableLooking: unmatched,
      suffixOnlySkipped: suffixOnlySkipped,
      ambiguousMatches: ambiguous,
    );
  }
}

class ConjugationLemmaBuildReport {
  const ConjugationLemmaBuildReport({
    required this.generatedAt,
    required this.entries,
    required this.unmatchedConjugatableLooking,
    required this.suffixOnlySkipped,
    required this.ambiguousMatches,
  });

  final DateTime generatedAt;
  final List<ConjugationLemmaEntry> entries;
  final List<ConjugationSkippedEntry> unmatchedConjugatableLooking;
  final List<ConjugationSkippedEntry> suffixOnlySkipped;
  final List<ConjugationSkippedEntry> ambiguousMatches;

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': 1,
      'source': 'JMdict_e',
      'sourceUrl': 'https://ftp.edrdg.org/pub/Nihongo/JMdict_e.gz',
      'generatedAt': generatedAt.toIso8601String(),
      'entryCount': entries.length,
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'diagnostics': {
        'unmatchedConjugatableLooking': unmatchedConjugatableLooking
            .map((entry) => entry.toJson())
            .toList(),
        'suffixOnlySkipped': suffixOnlySkipped
            .map((entry) => entry.toJson())
            .toList(),
        'ambiguousMatches': ambiguousMatches
            .map((entry) => entry.toJson())
            .toList(),
      },
    };
  }

  String toPrettyJson() =>
      '${const JsonEncoder.withIndent('  ').convert(toJson())}\n';

  String toSummaryJson() {
    return jsonEncode({
      'entryCount': entries.length,
      'unmatchedConjugatableLooking': unmatchedConjugatableLooking.length,
      'suffixOnlySkipped': suffixOnlySkipped.length,
      'ambiguousMatches': ambiguousMatches.length,
    });
  }
}

class ConjugationLemmaEntry {
  const ConjugationLemmaEntry({
    required this.id,
    required this.contentEntryId,
    required this.contentVocabId,
    required this.term,
    required this.reading,
    required this.dictionaryForm,
    required this.dictionaryReading,
    required this.kind,
    required this.conjugationClass,
    required this.posTags,
    required this.jmdictEntrySeq,
    required this.sourceVocabId,
    required this.sourceSenseId,
    required this.level,
    required this.series,
    required this.lessonId,
    required this.sourcePath,
    required this.matchMethod,
  });

  final int id;
  final String contentEntryId;
  final String contentVocabId;
  final String term;
  final String reading;
  final String dictionaryForm;
  final String dictionaryReading;
  final String kind;
  final String conjugationClass;
  final List<String> posTags;
  final String jmdictEntrySeq;
  final String? sourceVocabId;
  final String? sourceSenseId;
  final String level;
  final String series;
  final int lessonId;
  final String sourcePath;
  final String matchMethod;

  ConjugationLemmaEntry copyWith({int? id}) {
    return ConjugationLemmaEntry(
      id: id ?? this.id,
      contentEntryId: contentEntryId,
      contentVocabId: contentVocabId,
      term: term,
      reading: reading,
      dictionaryForm: dictionaryForm,
      dictionaryReading: dictionaryReading,
      kind: kind,
      conjugationClass: conjugationClass,
      posTags: posTags,
      jmdictEntrySeq: jmdictEntrySeq,
      sourceVocabId: sourceVocabId,
      sourceSenseId: sourceSenseId,
      level: level,
      series: series,
      lessonId: lessonId,
      sourcePath: sourcePath,
      matchMethod: matchMethod,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'contentEntryId': contentEntryId,
      'contentVocabId': contentVocabId,
      'term': term,
      'reading': reading,
      'dictionaryForm': dictionaryForm,
      'dictionaryReading': dictionaryReading,
      'kind': kind,
      'conjugationClass': conjugationClass,
      'posTags': posTags,
      'jmdictEntrySeq': jmdictEntrySeq,
      if (sourceVocabId != null) 'sourceVocabId': sourceVocabId,
      if (sourceSenseId != null) 'sourceSenseId': sourceSenseId,
      'level': level,
      'series': series,
      'lessonId': lessonId,
      'sourcePath': sourcePath,
      'matchMethod': matchMethod,
    };
  }
}

class ConjugationSkippedEntry {
  const ConjugationSkippedEntry({
    required this.contentEntryId,
    required this.contentVocabId,
    required this.term,
    required this.reading,
    required this.level,
    required this.series,
    required this.lessonId,
    required this.sourcePath,
  });

  factory ConjugationSkippedEntry._fromVocab(_CurriculumVocab item) {
    return ConjugationSkippedEntry(
      contentEntryId: item.entryId,
      contentVocabId: item.vocabId,
      term: item.term,
      reading: item.reading,
      level: item.level,
      series: item.series,
      lessonId: item.lessonId,
      sourcePath: item.sourcePath,
    );
  }

  final String contentEntryId;
  final String contentVocabId;
  final String term;
  final String reading;
  final String level;
  final String series;
  final int lessonId;
  final String sourcePath;

  Map<String, Object?> toJson() {
    return {
      'contentEntryId': contentEntryId,
      'contentVocabId': contentVocabId,
      'term': term,
      'reading': reading,
      'level': level,
      'series': series,
      'lessonId': lessonId,
      'sourcePath': sourcePath,
    };
  }
}

class _JmDictIndex {
  _JmDictIndex(this.byEntrySeq, this.byTermReading, this.byGeneratedMasu);

  final Map<String, _JmDictEntry> byEntrySeq;
  final Map<String, List<_JmDictEntry>> byTermReading;
  final Map<String, List<_JmDictEntry>> byGeneratedMasu;

  static Future<_JmDictIndex> load(File cache) async {
    final decoded = jsonDecode(await cache.readAsString());
    final entries = decoded is Map && decoded['entries'] is List
        ? decoded['entries'] as List
        : const <Object?>[];
    final byEntrySeq = <String, _JmDictEntry>{};
    final byTermReading = <String, List<_JmDictEntry>>{};
    final byGeneratedMasu = <String, List<_JmDictEntry>>{};

    for (final raw in entries) {
      if (raw is! Map) continue;
      final map = Map<String, Object?>.from(raw);
      final entry = _JmDictEntry.fromJson(map);
      if (entry.entrySeq.isEmpty || entry.primaryTerm.isEmpty) continue;
      byEntrySeq[entry.entrySeq] = entry;
      for (final term in entry.matchTerms) {
        for (final reading in entry.readings) {
          byTermReading
              .putIfAbsent(_matchKey(term, reading), () => [])
              .add(entry);
        }
      }
      _indexGeneratedMasu(entry, byGeneratedMasu);
    }
    return _JmDictIndex(byEntrySeq, byTermReading, byGeneratedMasu);
  }

  _JmDictMatch? match(_CurriculumVocab item) {
    final sourceId = item.sourceVocabId;
    if (sourceId != null && byEntrySeq.containsKey(sourceId)) {
      return _JmDictMatch.single(byEntrySeq[sourceId]!, 'sourceVocabId');
    }
    final senseId = item.sourceSenseId;
    if (senseId != null && byEntrySeq.containsKey(senseId)) {
      return _JmDictMatch.single(byEntrySeq[senseId]!, 'sourceSenseId');
    }

    final matches =
        byTermReading[_matchKey(item.term, item.reading)] ?? const [];
    if (matches.length == 1) {
      return _JmDictMatch.single(matches.single, 'termReading');
    }
    if (matches.length > 1) {
      return const _JmDictMatch.ambiguous();
    }
    final generatedMasuMatches =
        byGeneratedMasu[_matchKey(item.term, item.reading)] ?? const [];
    if (generatedMasuMatches.length == 1) {
      return _JmDictMatch.single(generatedMasuMatches.single, 'generatedMasu');
    }
    if (generatedMasuMatches.length > 1) {
      return const _JmDictMatch.ambiguous();
    }
    return null;
  }
}

void _indexGeneratedMasu(
  _JmDictEntry entry,
  Map<String, List<_JmDictEntry>> index,
) {
  if (entry.isSuffixOnly) return;
  const conjugator = JapaneseConjugator();
  final seenKeys = <String>{};
  for (final term in entry.matchTerms) {
    final spec = ConjugationSpec.fromJmDictPos(entry.posTags, lemma: term);
    if (spec == null || spec.kind != ConjugationKind.verb) continue;
    String masuTerm;
    try {
      masuTerm = conjugator.form(term, spec, ConjugationForm.masu);
    } on UnsupportedError {
      continue;
    } on ArgumentError {
      continue;
    }
    for (final reading in entry.readings) {
      String masuReading;
      try {
        masuReading = conjugator.form(reading, spec, ConjugationForm.masu);
      } on UnsupportedError {
        continue;
      } on ArgumentError {
        continue;
      }
      final key = _matchKey(masuTerm, masuReading);
      if (seenKeys.add(key)) {
        index.putIfAbsent(key, () => []).add(entry);
      }
    }
  }
}

class _JmDictMatch {
  const _JmDictMatch.single(this.entry, this.method) : isAmbiguous = false;
  const _JmDictMatch.ambiguous()
    : entry = null,
      method = 'termReading',
      isAmbiguous = true;

  final _JmDictEntry? entry;
  final String method;
  final bool isAmbiguous;
}

class _JmDictEntry {
  const _JmDictEntry({
    required this.entrySeq,
    required this.primaryTerm,
    required this.primaryReading,
    required this.terms,
    required this.readings,
    required this.posTags,
  });

  factory _JmDictEntry.fromJson(Map<String, Object?> map) {
    final terms = _stringList(map['terms']);
    final readings = _stringList(map['readings']);
    final primaryTerm =
        _stringValue(map['primaryTerm']) ??
        (terms.isNotEmpty ? terms.first : '');
    final primaryReading =
        _stringValue(map['primaryReading']) ??
        (readings.isNotEmpty ? readings.first : '');
    return _JmDictEntry(
      entrySeq: _stringValue(map['entrySeq']) ?? '',
      primaryTerm: primaryTerm,
      primaryReading: primaryReading,
      terms: terms.isNotEmpty ? terms : [primaryTerm],
      readings: readings.isNotEmpty ? readings : [primaryReading],
      posTags: _stringList(map['partOfSpeech']),
    );
  }

  final String entrySeq;
  final String primaryTerm;
  final String primaryReading;
  final List<String> terms;
  final List<String> readings;
  final List<String> posTags;

  Iterable<String> get matchTerms sync* {
    final seen = <String>{};
    if (primaryTerm.isNotEmpty && seen.add(primaryTerm)) yield primaryTerm;
    for (final term in terms) {
      if (term.isNotEmpty && seen.add(term)) yield term;
    }
  }

  bool get isSuffixOnly {
    final normalized = posTags.map((tag) => tag.trim().toLowerCase()).toSet();
    return normalized.contains('suf') ||
        normalized.contains('&suf;') ||
        normalized.contains('suffix');
  }
}

class _CurriculumVocab {
  const _CurriculumVocab({
    required this.entryId,
    required this.vocabId,
    required this.term,
    required this.reading,
    required this.tags,
    required this.sourceVocabId,
    required this.sourceSenseId,
    required this.level,
    required this.series,
    required this.lessonId,
    required this.sourcePath,
  });

  final String entryId;
  final String vocabId;
  final String term;
  final String reading;
  final List<String> tags;
  final String? sourceVocabId;
  final String? sourceSenseId;
  final String level;
  final String series;
  final int lessonId;
  final String sourcePath;

  bool get looksConjugatable {
    final normalized = tags.map((tag) => tag.trim().toLowerCase()).toSet();
    return normalized.contains('verb') ||
        normalized.contains('adj_i') ||
        normalized.contains('adj-i') ||
        normalized.contains('adj_na') ||
        normalized.contains('adj-na');
  }
}

Future<List<_CurriculumVocab>> _loadCurriculumVocab(
  Directory contentRoot,
) async {
  final results = <_CurriculumVocab>[];
  final vocabRoot = Directory('${contentRoot.path}/vocab');
  if (!await vocabRoot.exists()) return results;
  await for (final entity in vocabRoot.list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.json')) continue;
    final decoded = jsonDecode(await entity.readAsString());
    if (decoded is! Map || decoded['entries'] is! List) continue;
    final fileMap = Map<String, Object?>.from(decoded);
    final fileLevel =
        _stringValue(fileMap['level']) ?? _levelFromPath(entity.path);
    final fileSeries =
        _stringValue(fileMap['series']) ?? _seriesFromPath(entity.path);
    final fileLessonId =
        _intValue(fileMap['lessonId']) ?? _lessonIdFromPath(entity.path);

    for (final rawEntry in fileMap['entries'] as List) {
      if (rawEntry is! Map) continue;
      final entry = Map<String, Object?>.from(rawEntry);
      final lemma = entry['lemma'] is Map
          ? Map<String, Object?>.from(entry['lemma'] as Map)
          : const <String, Object?>{};
      final links = entry['links'] is Map
          ? Map<String, Object?>.from(entry['links'] as Map)
          : const <String, Object?>{};
      final term = _stringValue(lemma['term']);
      if (term == null || term.isEmpty) continue;
      final vocabId = _stringValue(lemma['vocabId']);
      if (vocabId == null || vocabId.isEmpty) continue;
      final reading = _stringValue(lemma['reading']) ?? '';
      results.add(
        _CurriculumVocab(
          entryId: _stringValue(entry['entryId']) ?? vocabId,
          vocabId: vocabId,
          term: term,
          reading: reading,
          tags: _stringList(entry['tags']),
          sourceVocabId: _stringValue(links['sourceVocabId']),
          sourceSenseId: _stringValue(links['sourceSenseId']),
          level: _stringValue(entry['level']) ?? fileLevel,
          series: fileSeries,
          lessonId: _intValue(entry['lessonId']) ?? fileLessonId,
          sourcePath: _normalizePath(entity.path),
        ),
      );
    }
  }
  return results;
}

String _kindLabel(ConjugationSpec spec) {
  switch (spec.kind) {
    case ConjugationKind.verb:
      return 'verb';
    case ConjugationKind.adjective:
      switch (spec.adjectiveClass) {
        case AdjectiveClass.iAdjective:
        case AdjectiveClass.iiException:
          return 'i_adjective';
        case AdjectiveClass.naAdjective:
          return 'na_adjective';
        case null:
          return 'adjective';
      }
  }
}

String _classLabel(ConjugationSpec spec) {
  final verb = spec.verbClass;
  if (verb != null) return verb.name;
  final adjective = spec.adjectiveClass;
  if (adjective != null) return adjective.name;
  return 'unknown';
}

String _matchKey(String term, String reading) =>
    '${term.trim()}\u0000${reading.trim()}';

String _levelSortKey(String value) {
  final match = RegExp(r'^N([1-5])$').firstMatch(value);
  return match == null ? value : match.group(1)!;
}

String _levelFromPath(String path) {
  final normalized = _normalizePath(path);
  final match = RegExp(
    r'/n([1-5])/',
    caseSensitive: false,
  ).firstMatch(normalized);
  return match == null ? 'unknown' : 'N${match.group(1)}';
}

String _seriesFromPath(String path) {
  final segments = _normalizePath(path).split('/');
  final vocabIndex = segments.lastIndexOf('vocab');
  if (vocabIndex >= 0 && vocabIndex + 2 < segments.length) {
    return segments[vocabIndex + 2];
  }
  return 'unknown';
}

int _lessonIdFromPath(String path) {
  final normalized = _normalizePath(path);
  final match = RegExp(
    r'(?:lesson_|_ch|_)(\d{1,2})(?:\D|$)',
  ).firstMatch(normalized);
  return match == null ? 0 : int.parse(match.group(1)!);
}

String _normalizePath(String value) => value.replaceAll('\\', '/');

String? _stringValue(Object? value) => value is String ? value : null;

int? _intValue(Object? value) => value is int ? value : null;

List<String> _stringList(Object? value) {
  if (value is! Iterable) return const [];
  return value.whereType<String>().where((item) => item.isNotEmpty).toList();
}
