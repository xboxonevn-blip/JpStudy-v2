// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VocabItemsTable extends VocabItems
    with TableInfo<$VocabItemsTable, VocabItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _termMeta = const VerificationMeta('term');
  @override
  late final GeneratedColumn<String> term = GeneratedColumn<String>(
    'term',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N5'),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    term,
    reading,
    meaning,
    level,
    tags,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('term')) {
      context.handle(
        _termMeta,
        term.isAcceptableOrUnknown(data['term']!, _termMeta),
      );
    } else if (isInserting) {
      context.missing(_termMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      term: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}term'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      ),
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabItemsTable createAlias(String alias) {
    return $VocabItemsTable(attachedDatabase, alias);
  }
}

class VocabItem extends DataClass implements Insertable<VocabItem> {
  final int id;
  final String term;
  final String? reading;
  final String meaning;
  final String level;
  final String? tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabItem({
    required this.id,
    required this.term,
    this.reading,
    required this.meaning,
    required this.level,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['term'] = Variable<String>(term);
    if (!nullToAbsent || reading != null) {
      map['reading'] = Variable<String>(reading);
    }
    map['meaning'] = Variable<String>(meaning);
    map['level'] = Variable<String>(level);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabItemsCompanion toCompanion(bool nullToAbsent) {
    return VocabItemsCompanion(
      id: Value(id),
      term: Value(term),
      reading: reading == null && nullToAbsent
          ? const Value.absent()
          : Value(reading),
      meaning: Value(meaning),
      level: Value(level),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabItem(
      id: serializer.fromJson<int>(json['id']),
      term: serializer.fromJson<String>(json['term']),
      reading: serializer.fromJson<String?>(json['reading']),
      meaning: serializer.fromJson<String>(json['meaning']),
      level: serializer.fromJson<String>(json['level']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'term': serializer.toJson<String>(term),
      'reading': serializer.toJson<String?>(reading),
      'meaning': serializer.toJson<String>(meaning),
      'level': serializer.toJson<String>(level),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabItem copyWith({
    int? id,
    String? term,
    Value<String?> reading = const Value.absent(),
    String? meaning,
    String? level,
    Value<String?> tags = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabItem(
    id: id ?? this.id,
    term: term ?? this.term,
    reading: reading.present ? reading.value : this.reading,
    meaning: meaning ?? this.meaning,
    level: level ?? this.level,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabItem copyWithCompanion(VocabItemsCompanion data) {
    return VocabItem(
      id: data.id.present ? data.id.value : this.id,
      term: data.term.present ? data.term.value : this.term,
      reading: data.reading.present ? data.reading.value : this.reading,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      level: data.level.present ? data.level.value : this.level,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabItem(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('reading: $reading, ')
          ..write('meaning: $meaning, ')
          ..write('level: $level, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    term,
    reading,
    meaning,
    level,
    tags,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabItem &&
          other.id == this.id &&
          other.term == this.term &&
          other.reading == this.reading &&
          other.meaning == this.meaning &&
          other.level == this.level &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabItemsCompanion extends UpdateCompanion<VocabItem> {
  final Value<int> id;
  final Value<String> term;
  final Value<String?> reading;
  final Value<String> meaning;
  final Value<String> level;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const VocabItemsCompanion({
    this.id = const Value.absent(),
    this.term = const Value.absent(),
    this.reading = const Value.absent(),
    this.meaning = const Value.absent(),
    this.level = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  VocabItemsCompanion.insert({
    this.id = const Value.absent(),
    required String term,
    this.reading = const Value.absent(),
    required String meaning,
    this.level = const Value.absent(),
    this.tags = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : term = Value(term),
       meaning = Value(meaning),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VocabItem> custom({
    Expression<int>? id,
    Expression<String>? term,
    Expression<String>? reading,
    Expression<String>? meaning,
    Expression<String>? level,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (term != null) 'term': term,
      if (reading != null) 'reading': reading,
      if (meaning != null) 'meaning': meaning,
      if (level != null) 'level': level,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  VocabItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? term,
    Value<String?>? reading,
    Value<String>? meaning,
    Value<String>? level,
    Value<String?>? tags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return VocabItemsCompanion(
      id: id ?? this.id,
      term: term ?? this.term,
      reading: reading ?? this.reading,
      meaning: meaning ?? this.meaning,
      level: level ?? this.level,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (term.present) {
      map['term'] = Variable<String>(term.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabItemsCompanion(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('reading: $reading, ')
          ..write('meaning: $meaning, ')
          ..write('level: $level, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SrsReviewsTable extends SrsReviews
    with TableInfo<$SrsReviewsTable, SrsReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vocabIdMeta = const VerificationMeta(
    'vocabId',
  );
  @override
  late final GeneratedColumn<int> vocabId = GeneratedColumn<int>(
    'vocab_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocab_items (id)',
    ),
  );
  static const VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int> box = GeneratedColumn<int>(
    'box',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<double> ease = GeneratedColumn<double>(
    'ease',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextReviewAtMeta = const VerificationMeta(
    'nextReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
    'next_review_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vocabId,
    box,
    repetitions,
    ease,
    lastReviewedAt,
    nextReviewAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_reviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrsReview> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocab_id')) {
      context.handle(
        _vocabIdMeta,
        vocabId.isAcceptableOrUnknown(data['vocab_id']!, _vocabIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vocabIdMeta);
    }
    if (data.containsKey('box')) {
      context.handle(
        _boxMeta,
        box.isAcceptableOrUnknown(data['box']!, _boxMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('ease')) {
      context.handle(
        _easeMeta,
        ease.isAcceptableOrUnknown(data['ease']!, _easeMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
        _nextReviewAtMeta,
        nextReviewAt.isAcceptableOrUnknown(
          data['next_review_at']!,
          _nextReviewAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsReview(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vocabId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vocab_id'],
      )!,
      box: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}box'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      ease: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      nextReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_at'],
      )!,
    );
  }

  @override
  $SrsReviewsTable createAlias(String alias) {
    return $SrsReviewsTable(attachedDatabase, alias);
  }
}

class SrsReview extends DataClass implements Insertable<SrsReview> {
  final int id;
  final int vocabId;
  final int box;
  final int repetitions;
  final double ease;
  final DateTime? lastReviewedAt;
  final DateTime nextReviewAt;
  const SrsReview({
    required this.id,
    required this.vocabId,
    required this.box,
    required this.repetitions,
    required this.ease,
    this.lastReviewedAt,
    required this.nextReviewAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocab_id'] = Variable<int>(vocabId);
    map['box'] = Variable<int>(box);
    map['repetitions'] = Variable<int>(repetitions);
    map['ease'] = Variable<double>(ease);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    return map;
  }

  SrsReviewsCompanion toCompanion(bool nullToAbsent) {
    return SrsReviewsCompanion(
      id: Value(id),
      vocabId: Value(vocabId),
      box: Value(box),
      repetitions: Value(repetitions),
      ease: Value(ease),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      nextReviewAt: Value(nextReviewAt),
    );
  }

  factory SrsReview.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsReview(
      id: serializer.fromJson<int>(json['id']),
      vocabId: serializer.fromJson<int>(json['vocabId']),
      box: serializer.fromJson<int>(json['box']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      ease: serializer.fromJson<double>(json['ease']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      nextReviewAt: serializer.fromJson<DateTime>(json['nextReviewAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabId': serializer.toJson<int>(vocabId),
      'box': serializer.toJson<int>(box),
      'repetitions': serializer.toJson<int>(repetitions),
      'ease': serializer.toJson<double>(ease),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'nextReviewAt': serializer.toJson<DateTime>(nextReviewAt),
    };
  }

  SrsReview copyWith({
    int? id,
    int? vocabId,
    int? box,
    int? repetitions,
    double? ease,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    DateTime? nextReviewAt,
  }) => SrsReview(
    id: id ?? this.id,
    vocabId: vocabId ?? this.vocabId,
    box: box ?? this.box,
    repetitions: repetitions ?? this.repetitions,
    ease: ease ?? this.ease,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    nextReviewAt: nextReviewAt ?? this.nextReviewAt,
  );
  SrsReview copyWithCompanion(SrsReviewsCompanion data) {
    return SrsReview(
      id: data.id.present ? data.id.value : this.id,
      vocabId: data.vocabId.present ? data.vocabId.value : this.vocabId,
      box: data.box.present ? data.box.value : this.box,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      ease: data.ease.present ? data.ease.value : this.ease,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsReview(')
          ..write('id: $id, ')
          ..write('vocabId: $vocabId, ')
          ..write('box: $box, ')
          ..write('repetitions: $repetitions, ')
          ..write('ease: $ease, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vocabId,
    box,
    repetitions,
    ease,
    lastReviewedAt,
    nextReviewAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsReview &&
          other.id == this.id &&
          other.vocabId == this.vocabId &&
          other.box == this.box &&
          other.repetitions == this.repetitions &&
          other.ease == this.ease &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.nextReviewAt == this.nextReviewAt);
}

class SrsReviewsCompanion extends UpdateCompanion<SrsReview> {
  final Value<int> id;
  final Value<int> vocabId;
  final Value<int> box;
  final Value<int> repetitions;
  final Value<double> ease;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime> nextReviewAt;
  const SrsReviewsCompanion({
    this.id = const Value.absent(),
    this.vocabId = const Value.absent(),
    this.box = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.ease = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
  });
  SrsReviewsCompanion.insert({
    this.id = const Value.absent(),
    required int vocabId,
    this.box = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.ease = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    required DateTime nextReviewAt,
  }) : vocabId = Value(vocabId),
       nextReviewAt = Value(nextReviewAt);
  static Insertable<SrsReview> custom({
    Expression<int>? id,
    Expression<int>? vocabId,
    Expression<int>? box,
    Expression<int>? repetitions,
    Expression<double>? ease,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? nextReviewAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabId != null) 'vocab_id': vocabId,
      if (box != null) 'box': box,
      if (repetitions != null) 'repetitions': repetitions,
      if (ease != null) 'ease': ease,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
    });
  }

  SrsReviewsCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabId,
    Value<int>? box,
    Value<int>? repetitions,
    Value<double>? ease,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime>? nextReviewAt,
  }) {
    return SrsReviewsCompanion(
      id: id ?? this.id,
      vocabId: vocabId ?? this.vocabId,
      box: box ?? this.box,
      repetitions: repetitions ?? this.repetitions,
      ease: ease ?? this.ease,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabId.present) {
      map['vocab_id'] = Variable<int>(vocabId.value);
    }
    if (box.present) {
      map['box'] = Variable<int>(box.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (ease.present) {
      map['ease'] = Variable<double>(ease.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsReviewsCompanion(')
          ..write('id: $id, ')
          ..write('vocabId: $vocabId, ')
          ..write('box: $box, ')
          ..write('repetitions: $repetitions, ')
          ..write('ease: $ease, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt')
          ..write(')'))
        .toString();
  }
}

class $GrammarQuestionsTable extends GrammarQuestions
    with TableInfo<$GrammarQuestionsTable, GrammarQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N5'),
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choicesJsonMeta = const VerificationMeta(
    'choicesJson',
  );
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
    'choices_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctIndexMeta = const VerificationMeta(
    'correctIndex',
  );
  @override
  late final GeneratedColumn<int> correctIndex = GeneratedColumn<int>(
    'correct_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    prompt,
    choicesJson,
    correctIndex,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
        _choicesJsonMeta,
        choicesJson.isAcceptableOrUnknown(
          data['choices_json']!,
          _choicesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_choicesJsonMeta);
    }
    if (data.containsKey('correct_index')) {
      context.handle(
        _correctIndexMeta,
        correctIndex.isAcceptableOrUnknown(
          data['correct_index']!,
          _correctIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctIndexMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      choicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choices_json'],
      )!,
      correctIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_index'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
    );
  }

  @override
  $GrammarQuestionsTable createAlias(String alias) {
    return $GrammarQuestionsTable(attachedDatabase, alias);
  }
}

class GrammarQuestion extends DataClass implements Insertable<GrammarQuestion> {
  final int id;
  final String level;
  final String prompt;
  final String choicesJson;
  final int correctIndex;
  final String? explanation;
  const GrammarQuestion({
    required this.id,
    required this.level,
    required this.prompt,
    required this.choicesJson,
    required this.correctIndex,
    this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['prompt'] = Variable<String>(prompt);
    map['choices_json'] = Variable<String>(choicesJson);
    map['correct_index'] = Variable<int>(correctIndex);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    return map;
  }

  GrammarQuestionsCompanion toCompanion(bool nullToAbsent) {
    return GrammarQuestionsCompanion(
      id: Value(id),
      level: Value(level),
      prompt: Value(prompt),
      choicesJson: Value(choicesJson),
      correctIndex: Value(correctIndex),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
    );
  }

  factory GrammarQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarQuestion(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      prompt: serializer.fromJson<String>(json['prompt']),
      choicesJson: serializer.fromJson<String>(json['choicesJson']),
      correctIndex: serializer.fromJson<int>(json['correctIndex']),
      explanation: serializer.fromJson<String?>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'prompt': serializer.toJson<String>(prompt),
      'choicesJson': serializer.toJson<String>(choicesJson),
      'correctIndex': serializer.toJson<int>(correctIndex),
      'explanation': serializer.toJson<String?>(explanation),
    };
  }

  GrammarQuestion copyWith({
    int? id,
    String? level,
    String? prompt,
    String? choicesJson,
    int? correctIndex,
    Value<String?> explanation = const Value.absent(),
  }) => GrammarQuestion(
    id: id ?? this.id,
    level: level ?? this.level,
    prompt: prompt ?? this.prompt,
    choicesJson: choicesJson ?? this.choicesJson,
    correctIndex: correctIndex ?? this.correctIndex,
    explanation: explanation.present ? explanation.value : this.explanation,
  );
  GrammarQuestion copyWithCompanion(GrammarQuestionsCompanion data) {
    return GrammarQuestion(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarQuestion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('prompt: $prompt, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, level, prompt, choicesJson, correctIndex, explanation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarQuestion &&
          other.id == this.id &&
          other.level == this.level &&
          other.prompt == this.prompt &&
          other.choicesJson == this.choicesJson &&
          other.correctIndex == this.correctIndex &&
          other.explanation == this.explanation);
}

class GrammarQuestionsCompanion extends UpdateCompanion<GrammarQuestion> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> prompt;
  final Value<String> choicesJson;
  final Value<int> correctIndex;
  final Value<String?> explanation;
  const GrammarQuestionsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.prompt = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.explanation = const Value.absent(),
  });
  GrammarQuestionsCompanion.insert({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    required String prompt,
    required String choicesJson,
    required int correctIndex,
    this.explanation = const Value.absent(),
  }) : prompt = Value(prompt),
       choicesJson = Value(choicesJson),
       correctIndex = Value(correctIndex);
  static Insertable<GrammarQuestion> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? prompt,
    Expression<String>? choicesJson,
    Expression<int>? correctIndex,
    Expression<String>? explanation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (prompt != null) 'prompt': prompt,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (explanation != null) 'explanation': explanation,
    });
  }

  GrammarQuestionsCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? prompt,
    Value<String>? choicesJson,
    Value<int>? correctIndex,
    Value<String?>? explanation,
  }) {
    return GrammarQuestionsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      prompt: prompt ?? this.prompt,
      choicesJson: choicesJson ?? this.choicesJson,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    if (correctIndex.present) {
      map['correct_index'] = Variable<int>(correctIndex.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('prompt: $prompt, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }
}

class $ExamSessionsTable extends ExamSessions
    with TableInfo<$ExamSessionsTable, ExamSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('N5'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    startedAt,
    durationSeconds,
    score,
    total,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $ExamSessionsTable createAlias(String alias) {
    return $ExamSessionsTable(attachedDatabase, alias);
  }
}

class ExamSession extends DataClass implements Insertable<ExamSession> {
  final int id;
  final String level;
  final DateTime startedAt;
  final int durationSeconds;
  final int? score;
  final int? total;
  final DateTime? finishedAt;
  const ExamSession({
    required this.id,
    required this.level,
    required this.startedAt,
    required this.durationSeconds,
    this.score,
    this.total,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || total != null) {
      map['total'] = Variable<int>(total);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  ExamSessionsCompanion toCompanion(bool nullToAbsent) {
    return ExamSessionsCompanion(
      id: Value(id),
      level: Value(level),
      startedAt: Value(startedAt),
      durationSeconds: Value(durationSeconds),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      total: total == null && nullToAbsent
          ? const Value.absent()
          : Value(total),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory ExamSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamSession(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      score: serializer.fromJson<int?>(json['score']),
      total: serializer.fromJson<int?>(json['total']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'score': serializer.toJson<int?>(score),
      'total': serializer.toJson<int?>(total),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  ExamSession copyWith({
    int? id,
    String? level,
    DateTime? startedAt,
    int? durationSeconds,
    Value<int?> score = const Value.absent(),
    Value<int?> total = const Value.absent(),
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => ExamSession(
    id: id ?? this.id,
    level: level ?? this.level,
    startedAt: startedAt ?? this.startedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    score: score.present ? score.value : this.score,
    total: total.present ? total.value : this.total,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  ExamSession copyWithCompanion(ExamSessionsCompanion data) {
    return ExamSession(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      score: data.score.present ? data.score.value : this.score,
      total: data.total.present ? data.total.value : this.total,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamSession(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('score: $score, ')
          ..write('total: $total, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    startedAt,
    durationSeconds,
    score,
    total,
    finishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamSession &&
          other.id == this.id &&
          other.level == this.level &&
          other.startedAt == this.startedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.score == this.score &&
          other.total == this.total &&
          other.finishedAt == this.finishedAt);
}

class ExamSessionsCompanion extends UpdateCompanion<ExamSession> {
  final Value<int> id;
  final Value<String> level;
  final Value<DateTime> startedAt;
  final Value<int> durationSeconds;
  final Value<int?> score;
  final Value<int?> total;
  final Value<DateTime?> finishedAt;
  const ExamSessionsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.score = const Value.absent(),
    this.total = const Value.absent(),
    this.finishedAt = const Value.absent(),
  });
  ExamSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    required DateTime startedAt,
    required int durationSeconds,
    this.score = const Value.absent(),
    this.total = const Value.absent(),
    this.finishedAt = const Value.absent(),
  }) : startedAt = Value(startedAt),
       durationSeconds = Value(durationSeconds);
  static Insertable<ExamSession> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<DateTime>? startedAt,
    Expression<int>? durationSeconds,
    Expression<int>? score,
    Expression<int>? total,
    Expression<DateTime>? finishedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (startedAt != null) 'started_at': startedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (score != null) 'score': score,
      if (total != null) 'total': total,
      if (finishedAt != null) 'finished_at': finishedAt,
    });
  }

  ExamSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<DateTime>? startedAt,
    Value<int>? durationSeconds,
    Value<int?>? score,
    Value<int?>? total,
    Value<DateTime?>? finishedAt,
  }) {
    return ExamSessionsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      score: score ?? this.score,
      total: total ?? this.total,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamSessionsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('score: $score, ')
          ..write('total: $total, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }
}

class $ExamAnswersTable extends ExamAnswers
    with TableInfo<$ExamAnswersTable, ExamAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exam_sessions (id)',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES grammar_questions (id)',
    ),
  );
  static const VerificationMeta _selectedIndexMeta = const VerificationMeta(
    'selectedIndex',
  );
  @override
  late final GeneratedColumn<int> selectedIndex = GeneratedColumn<int>(
    'selected_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    questionId,
    selectedIndex,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_index')) {
      context.handle(
        _selectedIndexMeta,
        selectedIndex.isAcceptableOrUnknown(
          data['selected_index']!,
          _selectedIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedIndexMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      )!,
      selectedIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_index'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
    );
  }

  @override
  $ExamAnswersTable createAlias(String alias) {
    return $ExamAnswersTable(attachedDatabase, alias);
  }
}

class ExamAnswer extends DataClass implements Insertable<ExamAnswer> {
  final int id;
  final int sessionId;
  final int questionId;
  final int selectedIndex;
  final bool isCorrect;
  const ExamAnswer({
    required this.id,
    required this.sessionId,
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['question_id'] = Variable<int>(questionId);
    map['selected_index'] = Variable<int>(selectedIndex);
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  ExamAnswersCompanion toCompanion(bool nullToAbsent) {
    return ExamAnswersCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      questionId: Value(questionId),
      selectedIndex: Value(selectedIndex),
      isCorrect: Value(isCorrect),
    );
  }

  factory ExamAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamAnswer(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      questionId: serializer.fromJson<int>(json['questionId']),
      selectedIndex: serializer.fromJson<int>(json['selectedIndex']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'questionId': serializer.toJson<int>(questionId),
      'selectedIndex': serializer.toJson<int>(selectedIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  ExamAnswer copyWith({
    int? id,
    int? sessionId,
    int? questionId,
    int? selectedIndex,
    bool? isCorrect,
  }) => ExamAnswer(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    questionId: questionId ?? this.questionId,
    selectedIndex: selectedIndex ?? this.selectedIndex,
    isCorrect: isCorrect ?? this.isCorrect,
  );
  ExamAnswer copyWithCompanion(ExamAnswersCompanion data) {
    return ExamAnswer(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedIndex: data.selectedIndex.present
          ? data.selectedIndex.value
          : this.selectedIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamAnswer(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, questionId, selectedIndex, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamAnswer &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.questionId == this.questionId &&
          other.selectedIndex == this.selectedIndex &&
          other.isCorrect == this.isCorrect);
}

class ExamAnswersCompanion extends UpdateCompanion<ExamAnswer> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> questionId;
  final Value<int> selectedIndex;
  final Value<bool> isCorrect;
  const ExamAnswersCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });
  ExamAnswersCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int questionId,
    required int selectedIndex,
    required bool isCorrect,
  }) : sessionId = Value(sessionId),
       questionId = Value(questionId),
       selectedIndex = Value(selectedIndex),
       isCorrect = Value(isCorrect);
  static Insertable<ExamAnswer> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? questionId,
    Expression<int>? selectedIndex,
    Expression<bool>? isCorrect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (questionId != null) 'question_id': questionId,
      if (selectedIndex != null) 'selected_index': selectedIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
    });
  }

  ExamAnswersCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? questionId,
    Value<int>? selectedIndex,
    Value<bool>? isCorrect,
  }) {
    return ExamAnswersCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      questionId: questionId ?? this.questionId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (selectedIndex.present) {
      map['selected_index'] = Variable<int>(selectedIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamAnswersCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }
}

class $DailyProgressTable extends DailyProgress
    with TableInfo<$DailyProgressTable, DailyProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cardsReviewedMeta = const VerificationMeta(
    'cardsReviewed',
  );
  @override
  late final GeneratedColumn<int> cardsReviewed = GeneratedColumn<int>(
    'cards_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quizzesCompletedMeta = const VerificationMeta(
    'quizzesCompleted',
  );
  @override
  late final GeneratedColumn<int> quizzesCompleted = GeneratedColumn<int>(
    'quizzes_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    xp,
    cardsReviewed,
    quizzesCompleted,
    streak,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('cards_reviewed')) {
      context.handle(
        _cardsReviewedMeta,
        cardsReviewed.isAcceptableOrUnknown(
          data['cards_reviewed']!,
          _cardsReviewedMeta,
        ),
      );
    }
    if (data.containsKey('quizzes_completed')) {
      context.handle(
        _quizzesCompletedMeta,
        quizzesCompleted.isAcceptableOrUnknown(
          data['quizzes_completed']!,
          _quizzesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      cardsReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cards_reviewed'],
      )!,
      quizzesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quizzes_completed'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
    );
  }

  @override
  $DailyProgressTable createAlias(String alias) {
    return $DailyProgressTable(attachedDatabase, alias);
  }
}

class DailyProgressData extends DataClass
    implements Insertable<DailyProgressData> {
  final int id;
  final DateTime day;
  final int xp;
  final int cardsReviewed;
  final int quizzesCompleted;
  final int streak;
  const DailyProgressData({
    required this.id,
    required this.day,
    required this.xp,
    required this.cardsReviewed,
    required this.quizzesCompleted,
    required this.streak,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<DateTime>(day);
    map['xp'] = Variable<int>(xp);
    map['cards_reviewed'] = Variable<int>(cardsReviewed);
    map['quizzes_completed'] = Variable<int>(quizzesCompleted);
    map['streak'] = Variable<int>(streak);
    return map;
  }

  DailyProgressCompanion toCompanion(bool nullToAbsent) {
    return DailyProgressCompanion(
      id: Value(id),
      day: Value(day),
      xp: Value(xp),
      cardsReviewed: Value(cardsReviewed),
      quizzesCompleted: Value(quizzesCompleted),
      streak: Value(streak),
    );
  }

  factory DailyProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyProgressData(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<DateTime>(json['day']),
      xp: serializer.fromJson<int>(json['xp']),
      cardsReviewed: serializer.fromJson<int>(json['cardsReviewed']),
      quizzesCompleted: serializer.fromJson<int>(json['quizzesCompleted']),
      streak: serializer.fromJson<int>(json['streak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<DateTime>(day),
      'xp': serializer.toJson<int>(xp),
      'cardsReviewed': serializer.toJson<int>(cardsReviewed),
      'quizzesCompleted': serializer.toJson<int>(quizzesCompleted),
      'streak': serializer.toJson<int>(streak),
    };
  }

  DailyProgressData copyWith({
    int? id,
    DateTime? day,
    int? xp,
    int? cardsReviewed,
    int? quizzesCompleted,
    int? streak,
  }) => DailyProgressData(
    id: id ?? this.id,
    day: day ?? this.day,
    xp: xp ?? this.xp,
    cardsReviewed: cardsReviewed ?? this.cardsReviewed,
    quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
    streak: streak ?? this.streak,
  );
  DailyProgressData copyWithCompanion(DailyProgressCompanion data) {
    return DailyProgressData(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      xp: data.xp.present ? data.xp.value : this.xp,
      cardsReviewed: data.cardsReviewed.present
          ? data.cardsReviewed.value
          : this.cardsReviewed,
      quizzesCompleted: data.quizzesCompleted.present
          ? data.quizzesCompleted.value
          : this.quizzesCompleted,
      streak: data.streak.present ? data.streak.value : this.streak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressData(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('xp: $xp, ')
          ..write('cardsReviewed: $cardsReviewed, ')
          ..write('quizzesCompleted: $quizzesCompleted, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, day, xp, cardsReviewed, quizzesCompleted, streak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyProgressData &&
          other.id == this.id &&
          other.day == this.day &&
          other.xp == this.xp &&
          other.cardsReviewed == this.cardsReviewed &&
          other.quizzesCompleted == this.quizzesCompleted &&
          other.streak == this.streak);
}

class DailyProgressCompanion extends UpdateCompanion<DailyProgressData> {
  final Value<int> id;
  final Value<DateTime> day;
  final Value<int> xp;
  final Value<int> cardsReviewed;
  final Value<int> quizzesCompleted;
  final Value<int> streak;
  const DailyProgressCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.xp = const Value.absent(),
    this.cardsReviewed = const Value.absent(),
    this.quizzesCompleted = const Value.absent(),
    this.streak = const Value.absent(),
  });
  DailyProgressCompanion.insert({
    this.id = const Value.absent(),
    required DateTime day,
    this.xp = const Value.absent(),
    this.cardsReviewed = const Value.absent(),
    this.quizzesCompleted = const Value.absent(),
    this.streak = const Value.absent(),
  }) : day = Value(day);
  static Insertable<DailyProgressData> custom({
    Expression<int>? id,
    Expression<DateTime>? day,
    Expression<int>? xp,
    Expression<int>? cardsReviewed,
    Expression<int>? quizzesCompleted,
    Expression<int>? streak,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (xp != null) 'xp': xp,
      if (cardsReviewed != null) 'cards_reviewed': cardsReviewed,
      if (quizzesCompleted != null) 'quizzes_completed': quizzesCompleted,
      if (streak != null) 'streak': streak,
    });
  }

  DailyProgressCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? day,
    Value<int>? xp,
    Value<int>? cardsReviewed,
    Value<int>? quizzesCompleted,
    Value<int>? streak,
  }) {
    return DailyProgressCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      xp: xp ?? this.xp,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      streak: streak ?? this.streak,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (cardsReviewed.present) {
      map['cards_reviewed'] = Variable<int>(cardsReviewed.value);
    }
    if (quizzesCompleted.present) {
      map['quizzes_completed'] = Variable<int>(quizzesCompleted.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyProgressCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('xp: $xp, ')
          ..write('cardsReviewed: $cardsReviewed, ')
          ..write('quizzesCompleted: $quizzesCompleted, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VocabItemsTable vocabItems = $VocabItemsTable(this);
  late final $SrsReviewsTable srsReviews = $SrsReviewsTable(this);
  late final $GrammarQuestionsTable grammarQuestions = $GrammarQuestionsTable(
    this,
  );
  late final $ExamSessionsTable examSessions = $ExamSessionsTable(this);
  late final $ExamAnswersTable examAnswers = $ExamAnswersTable(this);
  late final $DailyProgressTable dailyProgress = $DailyProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vocabItems,
    srsReviews,
    grammarQuestions,
    examSessions,
    examAnswers,
    dailyProgress,
  ];
}

typedef $$VocabItemsTableCreateCompanionBuilder =
    VocabItemsCompanion Function({
      Value<int> id,
      required String term,
      Value<String?> reading,
      required String meaning,
      Value<String> level,
      Value<String?> tags,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$VocabItemsTableUpdateCompanionBuilder =
    VocabItemsCompanion Function({
      Value<int> id,
      Value<String> term,
      Value<String?> reading,
      Value<String> meaning,
      Value<String> level,
      Value<String?> tags,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$VocabItemsTableReferences
    extends BaseReferences<_$AppDatabase, $VocabItemsTable, VocabItem> {
  $$VocabItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SrsReviewsTable, List<SrsReview>>
  _srsReviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.srsReviews,
    aliasName: $_aliasNameGenerator(db.vocabItems.id, db.srsReviews.vocabId),
  );

  $$SrsReviewsTableProcessedTableManager get srsReviewsRefs {
    final manager = $$SrsReviewsTableTableManager(
      $_db,
      $_db.srsReviews,
    ).filter((f) => f.vocabId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_srsReviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VocabItemsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabItemsTable> {
  $$VocabItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get term => $composableBuilder(
    column: $table.term,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> srsReviewsRefs(
    Expression<bool> Function($$SrsReviewsTableFilterComposer f) f,
  ) {
    final $$SrsReviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.srsReviews,
      getReferencedColumn: (t) => t.vocabId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SrsReviewsTableFilterComposer(
            $db: $db,
            $table: $db.srsReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VocabItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabItemsTable> {
  $$VocabItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get term => $composableBuilder(
    column: $table.term,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VocabItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabItemsTable> {
  $$VocabItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get term =>
      $composableBuilder(column: $table.term, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> srsReviewsRefs<T extends Object>(
    Expression<T> Function($$SrsReviewsTableAnnotationComposer a) f,
  ) {
    final $$SrsReviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.srsReviews,
      getReferencedColumn: (t) => t.vocabId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SrsReviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.srsReviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VocabItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabItemsTable,
          VocabItem,
          $$VocabItemsTableFilterComposer,
          $$VocabItemsTableOrderingComposer,
          $$VocabItemsTableAnnotationComposer,
          $$VocabItemsTableCreateCompanionBuilder,
          $$VocabItemsTableUpdateCompanionBuilder,
          (VocabItem, $$VocabItemsTableReferences),
          VocabItem,
          PrefetchHooks Function({bool srsReviewsRefs})
        > {
  $$VocabItemsTableTableManager(_$AppDatabase db, $VocabItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> term = const Value.absent(),
                Value<String?> reading = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => VocabItemsCompanion(
                id: id,
                term: term,
                reading: reading,
                meaning: meaning,
                level: level,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String term,
                Value<String?> reading = const Value.absent(),
                required String meaning,
                Value<String> level = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => VocabItemsCompanion.insert(
                id: id,
                term: term,
                reading: reading,
                meaning: meaning,
                level: level,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VocabItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({srsReviewsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (srsReviewsRefs) db.srsReviews],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (srsReviewsRefs)
                    await $_getPrefetchedData<
                      VocabItem,
                      $VocabItemsTable,
                      SrsReview
                    >(
                      currentTable: table,
                      referencedTable: $$VocabItemsTableReferences
                          ._srsReviewsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$VocabItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).srsReviewsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.vocabId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VocabItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabItemsTable,
      VocabItem,
      $$VocabItemsTableFilterComposer,
      $$VocabItemsTableOrderingComposer,
      $$VocabItemsTableAnnotationComposer,
      $$VocabItemsTableCreateCompanionBuilder,
      $$VocabItemsTableUpdateCompanionBuilder,
      (VocabItem, $$VocabItemsTableReferences),
      VocabItem,
      PrefetchHooks Function({bool srsReviewsRefs})
    >;
typedef $$SrsReviewsTableCreateCompanionBuilder =
    SrsReviewsCompanion Function({
      Value<int> id,
      required int vocabId,
      Value<int> box,
      Value<int> repetitions,
      Value<double> ease,
      Value<DateTime?> lastReviewedAt,
      required DateTime nextReviewAt,
    });
typedef $$SrsReviewsTableUpdateCompanionBuilder =
    SrsReviewsCompanion Function({
      Value<int> id,
      Value<int> vocabId,
      Value<int> box,
      Value<int> repetitions,
      Value<double> ease,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime> nextReviewAt,
    });

final class $$SrsReviewsTableReferences
    extends BaseReferences<_$AppDatabase, $SrsReviewsTable, SrsReview> {
  $$SrsReviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VocabItemsTable _vocabIdTable(_$AppDatabase db) =>
      db.vocabItems.createAlias(
        $_aliasNameGenerator(db.srsReviews.vocabId, db.vocabItems.id),
      );

  $$VocabItemsTableProcessedTableManager get vocabId {
    final $_column = $_itemColumn<int>('vocab_id')!;

    final manager = $$VocabItemsTableTableManager(
      $_db,
      $_db.vocabItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vocabIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SrsReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsReviewsTable> {
  $$SrsReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VocabItemsTableFilterComposer get vocabId {
    final $$VocabItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabId,
      referencedTable: $db.vocabItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabItemsTableFilterComposer(
            $db: $db,
            $table: $db.vocabItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SrsReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsReviewsTable> {
  $$SrsReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VocabItemsTableOrderingComposer get vocabId {
    final $$VocabItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabId,
      referencedTable: $db.vocabItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabItemsTableOrderingComposer(
            $db: $db,
            $table: $db.vocabItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SrsReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsReviewsTable> {
  $$SrsReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get box =>
      $composableBuilder(column: $table.box, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => column,
  );

  $$VocabItemsTableAnnotationComposer get vocabId {
    final $$VocabItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vocabId,
      referencedTable: $db.vocabItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.vocabItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SrsReviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrsReviewsTable,
          SrsReview,
          $$SrsReviewsTableFilterComposer,
          $$SrsReviewsTableOrderingComposer,
          $$SrsReviewsTableAnnotationComposer,
          $$SrsReviewsTableCreateCompanionBuilder,
          $$SrsReviewsTableUpdateCompanionBuilder,
          (SrsReview, $$SrsReviewsTableReferences),
          SrsReview,
          PrefetchHooks Function({bool vocabId})
        > {
  $$SrsReviewsTableTableManager(_$AppDatabase db, $SrsReviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vocabId = const Value.absent(),
                Value<int> box = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime> nextReviewAt = const Value.absent(),
              }) => SrsReviewsCompanion(
                id: id,
                vocabId: vocabId,
                box: box,
                repetitions: repetitions,
                ease: ease,
                lastReviewedAt: lastReviewedAt,
                nextReviewAt: nextReviewAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vocabId,
                Value<int> box = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                required DateTime nextReviewAt,
              }) => SrsReviewsCompanion.insert(
                id: id,
                vocabId: vocabId,
                box: box,
                repetitions: repetitions,
                ease: ease,
                lastReviewedAt: lastReviewedAt,
                nextReviewAt: nextReviewAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SrsReviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vocabId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vocabId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vocabId,
                                referencedTable: $$SrsReviewsTableReferences
                                    ._vocabIdTable(db),
                                referencedColumn: $$SrsReviewsTableReferences
                                    ._vocabIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SrsReviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrsReviewsTable,
      SrsReview,
      $$SrsReviewsTableFilterComposer,
      $$SrsReviewsTableOrderingComposer,
      $$SrsReviewsTableAnnotationComposer,
      $$SrsReviewsTableCreateCompanionBuilder,
      $$SrsReviewsTableUpdateCompanionBuilder,
      (SrsReview, $$SrsReviewsTableReferences),
      SrsReview,
      PrefetchHooks Function({bool vocabId})
    >;
typedef $$GrammarQuestionsTableCreateCompanionBuilder =
    GrammarQuestionsCompanion Function({
      Value<int> id,
      Value<String> level,
      required String prompt,
      required String choicesJson,
      required int correctIndex,
      Value<String?> explanation,
    });
typedef $$GrammarQuestionsTableUpdateCompanionBuilder =
    GrammarQuestionsCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> prompt,
      Value<String> choicesJson,
      Value<int> correctIndex,
      Value<String?> explanation,
    });

final class $$GrammarQuestionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $GrammarQuestionsTable, GrammarQuestion> {
  $$GrammarQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExamAnswersTable, List<ExamAnswer>>
  _examAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examAnswers,
    aliasName: $_aliasNameGenerator(
      db.grammarQuestions.id,
      db.examAnswers.questionId,
    ),
  );

  $$ExamAnswersTableProcessedTableManager get examAnswersRefs {
    final manager = $$ExamAnswersTableTableManager(
      $_db,
      $_db.examAnswers,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GrammarQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarQuestionsTable> {
  $$GrammarQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> examAnswersRefs(
    Expression<bool> Function($$ExamAnswersTableFilterComposer f) f,
  ) {
    final $$ExamAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamAnswersTableFilterComposer(
            $db: $db,
            $table: $db.examAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarQuestionsTable> {
  $$GrammarQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarQuestionsTable> {
  $$GrammarQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  Expression<T> examAnswersRefs<T extends Object>(
    Expression<T> Function($$ExamAnswersTableAnnotationComposer a) f,
  ) {
    final $$ExamAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examAnswers,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.examAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GrammarQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarQuestionsTable,
          GrammarQuestion,
          $$GrammarQuestionsTableFilterComposer,
          $$GrammarQuestionsTableOrderingComposer,
          $$GrammarQuestionsTableAnnotationComposer,
          $$GrammarQuestionsTableCreateCompanionBuilder,
          $$GrammarQuestionsTableUpdateCompanionBuilder,
          (GrammarQuestion, $$GrammarQuestionsTableReferences),
          GrammarQuestion,
          PrefetchHooks Function({bool examAnswersRefs})
        > {
  $$GrammarQuestionsTableTableManager(
    _$AppDatabase db,
    $GrammarQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> choicesJson = const Value.absent(),
                Value<int> correctIndex = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
              }) => GrammarQuestionsCompanion(
                id: id,
                level: level,
                prompt: prompt,
                choicesJson: choicesJson,
                correctIndex: correctIndex,
                explanation: explanation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                required String prompt,
                required String choicesJson,
                required int correctIndex,
                Value<String?> explanation = const Value.absent(),
              }) => GrammarQuestionsCompanion.insert(
                id: id,
                level: level,
                prompt: prompt,
                choicesJson: choicesJson,
                correctIndex: correctIndex,
                explanation: explanation,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GrammarQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examAnswersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (examAnswersRefs) db.examAnswers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (examAnswersRefs)
                    await $_getPrefetchedData<
                      GrammarQuestion,
                      $GrammarQuestionsTable,
                      ExamAnswer
                    >(
                      currentTable: table,
                      referencedTable: $$GrammarQuestionsTableReferences
                          ._examAnswersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GrammarQuestionsTableReferences(
                            db,
                            table,
                            p0,
                          ).examAnswersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.questionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GrammarQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarQuestionsTable,
      GrammarQuestion,
      $$GrammarQuestionsTableFilterComposer,
      $$GrammarQuestionsTableOrderingComposer,
      $$GrammarQuestionsTableAnnotationComposer,
      $$GrammarQuestionsTableCreateCompanionBuilder,
      $$GrammarQuestionsTableUpdateCompanionBuilder,
      (GrammarQuestion, $$GrammarQuestionsTableReferences),
      GrammarQuestion,
      PrefetchHooks Function({bool examAnswersRefs})
    >;
typedef $$ExamSessionsTableCreateCompanionBuilder =
    ExamSessionsCompanion Function({
      Value<int> id,
      Value<String> level,
      required DateTime startedAt,
      required int durationSeconds,
      Value<int?> score,
      Value<int?> total,
      Value<DateTime?> finishedAt,
    });
typedef $$ExamSessionsTableUpdateCompanionBuilder =
    ExamSessionsCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<DateTime> startedAt,
      Value<int> durationSeconds,
      Value<int?> score,
      Value<int?> total,
      Value<DateTime?> finishedAt,
    });

final class $$ExamSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $ExamSessionsTable, ExamSession> {
  $$ExamSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExamAnswersTable, List<ExamAnswer>>
  _examAnswersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examAnswers,
    aliasName: $_aliasNameGenerator(
      db.examSessions.id,
      db.examAnswers.sessionId,
    ),
  );

  $$ExamAnswersTableProcessedTableManager get examAnswersRefs {
    final manager = $$ExamAnswersTableTableManager(
      $_db,
      $_db.examAnswers,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examAnswersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExamSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> examAnswersRefs(
    Expression<bool> Function($$ExamAnswersTableFilterComposer f) f,
  ) {
    final $$ExamAnswersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examAnswers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamAnswersTableFilterComposer(
            $db: $db,
            $table: $db.examAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  Expression<T> examAnswersRefs<T extends Object>(
    Expression<T> Function($$ExamAnswersTableAnnotationComposer a) f,
  ) {
    final $$ExamAnswersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examAnswers,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamAnswersTableAnnotationComposer(
            $db: $db,
            $table: $db.examAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExamSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamSessionsTable,
          ExamSession,
          $$ExamSessionsTableFilterComposer,
          $$ExamSessionsTableOrderingComposer,
          $$ExamSessionsTableAnnotationComposer,
          $$ExamSessionsTableCreateCompanionBuilder,
          $$ExamSessionsTableUpdateCompanionBuilder,
          (ExamSession, $$ExamSessionsTableReferences),
          ExamSession,
          PrefetchHooks Function({bool examAnswersRefs})
        > {
  $$ExamSessionsTableTableManager(_$AppDatabase db, $ExamSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> total = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
              }) => ExamSessionsCompanion(
                id: id,
                level: level,
                startedAt: startedAt,
                durationSeconds: durationSeconds,
                score: score,
                total: total,
                finishedAt: finishedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                required DateTime startedAt,
                required int durationSeconds,
                Value<int?> score = const Value.absent(),
                Value<int?> total = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
              }) => ExamSessionsCompanion.insert(
                id: id,
                level: level,
                startedAt: startedAt,
                durationSeconds: durationSeconds,
                score: score,
                total: total,
                finishedAt: finishedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examAnswersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (examAnswersRefs) db.examAnswers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (examAnswersRefs)
                    await $_getPrefetchedData<
                      ExamSession,
                      $ExamSessionsTable,
                      ExamAnswer
                    >(
                      currentTable: table,
                      referencedTable: $$ExamSessionsTableReferences
                          ._examAnswersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExamSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).examAnswersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExamSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamSessionsTable,
      ExamSession,
      $$ExamSessionsTableFilterComposer,
      $$ExamSessionsTableOrderingComposer,
      $$ExamSessionsTableAnnotationComposer,
      $$ExamSessionsTableCreateCompanionBuilder,
      $$ExamSessionsTableUpdateCompanionBuilder,
      (ExamSession, $$ExamSessionsTableReferences),
      ExamSession,
      PrefetchHooks Function({bool examAnswersRefs})
    >;
typedef $$ExamAnswersTableCreateCompanionBuilder =
    ExamAnswersCompanion Function({
      Value<int> id,
      required int sessionId,
      required int questionId,
      required int selectedIndex,
      required bool isCorrect,
    });
typedef $$ExamAnswersTableUpdateCompanionBuilder =
    ExamAnswersCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> questionId,
      Value<int> selectedIndex,
      Value<bool> isCorrect,
    });

final class $$ExamAnswersTableReferences
    extends BaseReferences<_$AppDatabase, $ExamAnswersTable, ExamAnswer> {
  $$ExamAnswersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExamSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.examSessions.createAlias(
        $_aliasNameGenerator(db.examAnswers.sessionId, db.examSessions.id),
      );

  $$ExamSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$ExamSessionsTableTableManager(
      $_db,
      $_db.examSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GrammarQuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.grammarQuestions.createAlias(
        $_aliasNameGenerator(db.examAnswers.questionId, db.grammarQuestions.id),
      );

  $$GrammarQuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<int>('question_id')!;

    final manager = $$GrammarQuestionsTableTableManager(
      $_db,
      $_db.grammarQuestions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $ExamAnswersTable> {
  $$ExamAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$ExamSessionsTableFilterComposer get sessionId {
    final $$ExamSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.examSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSessionsTableFilterComposer(
            $db: $db,
            $table: $db.examSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GrammarQuestionsTableFilterComposer get questionId {
    final $$GrammarQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.grammarQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.grammarQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamAnswersTable> {
  $$ExamAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExamSessionsTableOrderingComposer get sessionId {
    final $$ExamSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.examSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.examSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GrammarQuestionsTableOrderingComposer get questionId {
    final $$GrammarQuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.grammarQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarQuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.grammarQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamAnswersTable> {
  $$ExamAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$ExamSessionsTableAnnotationComposer get sessionId {
    final $$ExamSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.examSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.examSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GrammarQuestionsTableAnnotationComposer get questionId {
    final $$GrammarQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.grammarQuestions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrammarQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.grammarQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamAnswersTable,
          ExamAnswer,
          $$ExamAnswersTableFilterComposer,
          $$ExamAnswersTableOrderingComposer,
          $$ExamAnswersTableAnnotationComposer,
          $$ExamAnswersTableCreateCompanionBuilder,
          $$ExamAnswersTableUpdateCompanionBuilder,
          (ExamAnswer, $$ExamAnswersTableReferences),
          ExamAnswer,
          PrefetchHooks Function({bool sessionId, bool questionId})
        > {
  $$ExamAnswersTableTableManager(_$AppDatabase db, $ExamAnswersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamAnswersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> questionId = const Value.absent(),
                Value<int> selectedIndex = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
              }) => ExamAnswersCompanion(
                id: id,
                sessionId: sessionId,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int questionId,
                required int selectedIndex,
                required bool isCorrect,
              }) => ExamAnswersCompanion.insert(
                id: id,
                sessionId: sessionId,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExamAnswersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$ExamAnswersTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$ExamAnswersTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$ExamAnswersTableReferences
                                    ._questionIdTable(db),
                                referencedColumn: $$ExamAnswersTableReferences
                                    ._questionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExamAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamAnswersTable,
      ExamAnswer,
      $$ExamAnswersTableFilterComposer,
      $$ExamAnswersTableOrderingComposer,
      $$ExamAnswersTableAnnotationComposer,
      $$ExamAnswersTableCreateCompanionBuilder,
      $$ExamAnswersTableUpdateCompanionBuilder,
      (ExamAnswer, $$ExamAnswersTableReferences),
      ExamAnswer,
      PrefetchHooks Function({bool sessionId, bool questionId})
    >;
typedef $$DailyProgressTableCreateCompanionBuilder =
    DailyProgressCompanion Function({
      Value<int> id,
      required DateTime day,
      Value<int> xp,
      Value<int> cardsReviewed,
      Value<int> quizzesCompleted,
      Value<int> streak,
    });
typedef $$DailyProgressTableUpdateCompanionBuilder =
    DailyProgressCompanion Function({
      Value<int> id,
      Value<DateTime> day,
      Value<int> xp,
      Value<int> cardsReviewed,
      Value<int> quizzesCompleted,
      Value<int> streak,
    });

class $$DailyProgressTableFilterComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quizzesCompleted => $composableBuilder(
    column: $table.quizzesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quizzesCompleted => $composableBuilder(
    column: $table.quizzesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyProgressTable> {
  $$DailyProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get cardsReviewed => $composableBuilder(
    column: $table.cardsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quizzesCompleted => $composableBuilder(
    column: $table.quizzesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);
}

class $$DailyProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyProgressTable,
          DailyProgressData,
          $$DailyProgressTableFilterComposer,
          $$DailyProgressTableOrderingComposer,
          $$DailyProgressTableAnnotationComposer,
          $$DailyProgressTableCreateCompanionBuilder,
          $$DailyProgressTableUpdateCompanionBuilder,
          (
            DailyProgressData,
            BaseReferences<
              _$AppDatabase,
              $DailyProgressTable,
              DailyProgressData
            >,
          ),
          DailyProgressData,
          PrefetchHooks Function()
        > {
  $$DailyProgressTableTableManager(_$AppDatabase db, $DailyProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> cardsReviewed = const Value.absent(),
                Value<int> quizzesCompleted = const Value.absent(),
                Value<int> streak = const Value.absent(),
              }) => DailyProgressCompanion(
                id: id,
                day: day,
                xp: xp,
                cardsReviewed: cardsReviewed,
                quizzesCompleted: quizzesCompleted,
                streak: streak,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime day,
                Value<int> xp = const Value.absent(),
                Value<int> cardsReviewed = const Value.absent(),
                Value<int> quizzesCompleted = const Value.absent(),
                Value<int> streak = const Value.absent(),
              }) => DailyProgressCompanion.insert(
                id: id,
                day: day,
                xp: xp,
                cardsReviewed: cardsReviewed,
                quizzesCompleted: quizzesCompleted,
                streak: streak,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyProgressTable,
      DailyProgressData,
      $$DailyProgressTableFilterComposer,
      $$DailyProgressTableOrderingComposer,
      $$DailyProgressTableAnnotationComposer,
      $$DailyProgressTableCreateCompanionBuilder,
      $$DailyProgressTableUpdateCompanionBuilder,
      (
        DailyProgressData,
        BaseReferences<_$AppDatabase, $DailyProgressTable, DailyProgressData>,
      ),
      DailyProgressData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VocabItemsTableTableManager get vocabItems =>
      $$VocabItemsTableTableManager(_db, _db.vocabItems);
  $$SrsReviewsTableTableManager get srsReviews =>
      $$SrsReviewsTableTableManager(_db, _db.srsReviews);
  $$GrammarQuestionsTableTableManager get grammarQuestions =>
      $$GrammarQuestionsTableTableManager(_db, _db.grammarQuestions);
  $$ExamSessionsTableTableManager get examSessions =>
      $$ExamSessionsTableTableManager(_db, _db.examSessions);
  $$ExamAnswersTableTableManager get examAnswers =>
      $$ExamAnswersTableTableManager(_db, _db.examAnswers);
  $$DailyProgressTableTableManager get dailyProgress =>
      $$DailyProgressTableTableManager(_db, _db.dailyProgress);
}
