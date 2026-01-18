// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SrsStateTable extends SrsState
    with TableInfo<$SrsStateTable, SrsStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsStateTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'srs_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrsStateData> instance, {
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
  SrsStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsStateData(
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
  $SrsStateTable createAlias(String alias) {
    return $SrsStateTable(attachedDatabase, alias);
  }
}

class SrsStateData extends DataClass implements Insertable<SrsStateData> {
  final int id;
  final int vocabId;
  final int box;
  final int repetitions;
  final double ease;
  final DateTime? lastReviewedAt;
  final DateTime nextReviewAt;
  const SrsStateData({
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

  SrsStateCompanion toCompanion(bool nullToAbsent) {
    return SrsStateCompanion(
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

  factory SrsStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsStateData(
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

  SrsStateData copyWith({
    int? id,
    int? vocabId,
    int? box,
    int? repetitions,
    double? ease,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    DateTime? nextReviewAt,
  }) => SrsStateData(
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
  SrsStateData copyWithCompanion(SrsStateCompanion data) {
    return SrsStateData(
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
    return (StringBuffer('SrsStateData(')
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
      (other is SrsStateData &&
          other.id == this.id &&
          other.vocabId == this.vocabId &&
          other.box == this.box &&
          other.repetitions == this.repetitions &&
          other.ease == this.ease &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.nextReviewAt == this.nextReviewAt);
}

class SrsStateCompanion extends UpdateCompanion<SrsStateData> {
  final Value<int> id;
  final Value<int> vocabId;
  final Value<int> box;
  final Value<int> repetitions;
  final Value<double> ease;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime> nextReviewAt;
  const SrsStateCompanion({
    this.id = const Value.absent(),
    this.vocabId = const Value.absent(),
    this.box = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.ease = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
  });
  SrsStateCompanion.insert({
    this.id = const Value.absent(),
    required int vocabId,
    this.box = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.ease = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    required DateTime nextReviewAt,
  }) : vocabId = Value(vocabId),
       nextReviewAt = Value(nextReviewAt);
  static Insertable<SrsStateData> custom({
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

  SrsStateCompanion copyWith({
    Value<int>? id,
    Value<int>? vocabId,
    Value<int>? box,
    Value<int>? repetitions,
    Value<double>? ease,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime>? nextReviewAt,
  }) {
    return SrsStateCompanion(
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
    return (StringBuffer('SrsStateCompanion(')
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

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _reviewedCountMeta = const VerificationMeta(
    'reviewedCount',
  );
  @override
  late final GeneratedColumn<int> reviewedCount = GeneratedColumn<int>(
    'reviewed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewAgainCountMeta = const VerificationMeta(
    'reviewAgainCount',
  );
  @override
  late final GeneratedColumn<int> reviewAgainCount = GeneratedColumn<int>(
    'review_again_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewHardCountMeta = const VerificationMeta(
    'reviewHardCount',
  );
  @override
  late final GeneratedColumn<int> reviewHardCount = GeneratedColumn<int>(
    'review_hard_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewGoodCountMeta = const VerificationMeta(
    'reviewGoodCount',
  );
  @override
  late final GeneratedColumn<int> reviewGoodCount = GeneratedColumn<int>(
    'review_good_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewEasyCountMeta = const VerificationMeta(
    'reviewEasyCount',
  );
  @override
  late final GeneratedColumn<int> reviewEasyCount = GeneratedColumn<int>(
    'review_easy_count',
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
    streak,
    reviewedCount,
    reviewAgainCount,
    reviewHardCount,
    reviewGoodCount,
    reviewEasyCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressData> instance, {
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
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('reviewed_count')) {
      context.handle(
        _reviewedCountMeta,
        reviewedCount.isAcceptableOrUnknown(
          data['reviewed_count']!,
          _reviewedCountMeta,
        ),
      );
    }
    if (data.containsKey('review_again_count')) {
      context.handle(
        _reviewAgainCountMeta,
        reviewAgainCount.isAcceptableOrUnknown(
          data['review_again_count']!,
          _reviewAgainCountMeta,
        ),
      );
    }
    if (data.containsKey('review_hard_count')) {
      context.handle(
        _reviewHardCountMeta,
        reviewHardCount.isAcceptableOrUnknown(
          data['review_hard_count']!,
          _reviewHardCountMeta,
        ),
      );
    }
    if (data.containsKey('review_good_count')) {
      context.handle(
        _reviewGoodCountMeta,
        reviewGoodCount.isAcceptableOrUnknown(
          data['review_good_count']!,
          _reviewGoodCountMeta,
        ),
      );
    }
    if (data.containsKey('review_easy_count')) {
      context.handle(
        _reviewEasyCountMeta,
        reviewEasyCount.isAcceptableOrUnknown(
          data['review_easy_count']!,
          _reviewEasyCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressData(
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
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      reviewedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reviewed_count'],
      )!,
      reviewAgainCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_again_count'],
      )!,
      reviewHardCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_hard_count'],
      )!,
      reviewGoodCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_good_count'],
      )!,
      reviewEasyCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_easy_count'],
      )!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressData extends DataClass
    implements Insertable<UserProgressData> {
  final int id;
  final DateTime day;
  final int xp;
  final int streak;
  final int reviewedCount;
  final int reviewAgainCount;
  final int reviewHardCount;
  final int reviewGoodCount;
  final int reviewEasyCount;
  const UserProgressData({
    required this.id,
    required this.day,
    required this.xp,
    required this.streak,
    required this.reviewedCount,
    required this.reviewAgainCount,
    required this.reviewHardCount,
    required this.reviewGoodCount,
    required this.reviewEasyCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<DateTime>(day);
    map['xp'] = Variable<int>(xp);
    map['streak'] = Variable<int>(streak);
    map['reviewed_count'] = Variable<int>(reviewedCount);
    map['review_again_count'] = Variable<int>(reviewAgainCount);
    map['review_hard_count'] = Variable<int>(reviewHardCount);
    map['review_good_count'] = Variable<int>(reviewGoodCount);
    map['review_easy_count'] = Variable<int>(reviewEasyCount);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      day: Value(day),
      xp: Value(xp),
      streak: Value(streak),
      reviewedCount: Value(reviewedCount),
      reviewAgainCount: Value(reviewAgainCount),
      reviewHardCount: Value(reviewHardCount),
      reviewGoodCount: Value(reviewGoodCount),
      reviewEasyCount: Value(reviewEasyCount),
    );
  }

  factory UserProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressData(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<DateTime>(json['day']),
      xp: serializer.fromJson<int>(json['xp']),
      streak: serializer.fromJson<int>(json['streak']),
      reviewedCount: serializer.fromJson<int>(json['reviewedCount']),
      reviewAgainCount: serializer.fromJson<int>(json['reviewAgainCount']),
      reviewHardCount: serializer.fromJson<int>(json['reviewHardCount']),
      reviewGoodCount: serializer.fromJson<int>(json['reviewGoodCount']),
      reviewEasyCount: serializer.fromJson<int>(json['reviewEasyCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<DateTime>(day),
      'xp': serializer.toJson<int>(xp),
      'streak': serializer.toJson<int>(streak),
      'reviewedCount': serializer.toJson<int>(reviewedCount),
      'reviewAgainCount': serializer.toJson<int>(reviewAgainCount),
      'reviewHardCount': serializer.toJson<int>(reviewHardCount),
      'reviewGoodCount': serializer.toJson<int>(reviewGoodCount),
      'reviewEasyCount': serializer.toJson<int>(reviewEasyCount),
    };
  }

  UserProgressData copyWith({
    int? id,
    DateTime? day,
    int? xp,
    int? streak,
    int? reviewedCount,
    int? reviewAgainCount,
    int? reviewHardCount,
    int? reviewGoodCount,
    int? reviewEasyCount,
  }) => UserProgressData(
    id: id ?? this.id,
    day: day ?? this.day,
    xp: xp ?? this.xp,
    streak: streak ?? this.streak,
    reviewedCount: reviewedCount ?? this.reviewedCount,
    reviewAgainCount: reviewAgainCount ?? this.reviewAgainCount,
    reviewHardCount: reviewHardCount ?? this.reviewHardCount,
    reviewGoodCount: reviewGoodCount ?? this.reviewGoodCount,
    reviewEasyCount: reviewEasyCount ?? this.reviewEasyCount,
  );
  UserProgressData copyWithCompanion(UserProgressCompanion data) {
    return UserProgressData(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      xp: data.xp.present ? data.xp.value : this.xp,
      streak: data.streak.present ? data.streak.value : this.streak,
      reviewedCount: data.reviewedCount.present
          ? data.reviewedCount.value
          : this.reviewedCount,
      reviewAgainCount: data.reviewAgainCount.present
          ? data.reviewAgainCount.value
          : this.reviewAgainCount,
      reviewHardCount: data.reviewHardCount.present
          ? data.reviewHardCount.value
          : this.reviewHardCount,
      reviewGoodCount: data.reviewGoodCount.present
          ? data.reviewGoodCount.value
          : this.reviewGoodCount,
      reviewEasyCount: data.reviewEasyCount.present
          ? data.reviewEasyCount.value
          : this.reviewEasyCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressData(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('xp: $xp, ')
          ..write('streak: $streak, ')
          ..write('reviewedCount: $reviewedCount, ')
          ..write('reviewAgainCount: $reviewAgainCount, ')
          ..write('reviewHardCount: $reviewHardCount, ')
          ..write('reviewGoodCount: $reviewGoodCount, ')
          ..write('reviewEasyCount: $reviewEasyCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    xp,
    streak,
    reviewedCount,
    reviewAgainCount,
    reviewHardCount,
    reviewGoodCount,
    reviewEasyCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressData &&
          other.id == this.id &&
          other.day == this.day &&
          other.xp == this.xp &&
          other.streak == this.streak &&
          other.reviewedCount == this.reviewedCount &&
          other.reviewAgainCount == this.reviewAgainCount &&
          other.reviewHardCount == this.reviewHardCount &&
          other.reviewGoodCount == this.reviewGoodCount &&
          other.reviewEasyCount == this.reviewEasyCount);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressData> {
  final Value<int> id;
  final Value<DateTime> day;
  final Value<int> xp;
  final Value<int> streak;
  final Value<int> reviewedCount;
  final Value<int> reviewAgainCount;
  final Value<int> reviewHardCount;
  final Value<int> reviewGoodCount;
  final Value<int> reviewEasyCount;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.xp = const Value.absent(),
    this.streak = const Value.absent(),
    this.reviewedCount = const Value.absent(),
    this.reviewAgainCount = const Value.absent(),
    this.reviewHardCount = const Value.absent(),
    this.reviewGoodCount = const Value.absent(),
    this.reviewEasyCount = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    required DateTime day,
    this.xp = const Value.absent(),
    this.streak = const Value.absent(),
    this.reviewedCount = const Value.absent(),
    this.reviewAgainCount = const Value.absent(),
    this.reviewHardCount = const Value.absent(),
    this.reviewGoodCount = const Value.absent(),
    this.reviewEasyCount = const Value.absent(),
  }) : day = Value(day);
  static Insertable<UserProgressData> custom({
    Expression<int>? id,
    Expression<DateTime>? day,
    Expression<int>? xp,
    Expression<int>? streak,
    Expression<int>? reviewedCount,
    Expression<int>? reviewAgainCount,
    Expression<int>? reviewHardCount,
    Expression<int>? reviewGoodCount,
    Expression<int>? reviewEasyCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (xp != null) 'xp': xp,
      if (streak != null) 'streak': streak,
      if (reviewedCount != null) 'reviewed_count': reviewedCount,
      if (reviewAgainCount != null) 'review_again_count': reviewAgainCount,
      if (reviewHardCount != null) 'review_hard_count': reviewHardCount,
      if (reviewGoodCount != null) 'review_good_count': reviewGoodCount,
      if (reviewEasyCount != null) 'review_easy_count': reviewEasyCount,
    });
  }

  UserProgressCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? day,
    Value<int>? xp,
    Value<int>? streak,
    Value<int>? reviewedCount,
    Value<int>? reviewAgainCount,
    Value<int>? reviewHardCount,
    Value<int>? reviewGoodCount,
    Value<int>? reviewEasyCount,
  }) {
    return UserProgressCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      reviewAgainCount: reviewAgainCount ?? this.reviewAgainCount,
      reviewHardCount: reviewHardCount ?? this.reviewHardCount,
      reviewGoodCount: reviewGoodCount ?? this.reviewGoodCount,
      reviewEasyCount: reviewEasyCount ?? this.reviewEasyCount,
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
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (reviewedCount.present) {
      map['reviewed_count'] = Variable<int>(reviewedCount.value);
    }
    if (reviewAgainCount.present) {
      map['review_again_count'] = Variable<int>(reviewAgainCount.value);
    }
    if (reviewHardCount.present) {
      map['review_hard_count'] = Variable<int>(reviewHardCount.value);
    }
    if (reviewGoodCount.present) {
      map['review_good_count'] = Variable<int>(reviewGoodCount.value);
    }
    if (reviewEasyCount.present) {
      map['review_easy_count'] = Variable<int>(reviewEasyCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('xp: $xp, ')
          ..write('streak: $streak, ')
          ..write('reviewedCount: $reviewedCount, ')
          ..write('reviewAgainCount: $reviewAgainCount, ')
          ..write('reviewHardCount: $reviewHardCount, ')
          ..write('reviewGoodCount: $reviewGoodCount, ')
          ..write('reviewEasyCount: $reviewEasyCount')
          ..write(')'))
        .toString();
  }
}

class $AttemptTable extends Attempt with TableInfo<$AttemptTable, AttemptData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
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
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    level,
    startedAt,
    finishedAt,
    score,
    total,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempt';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttemptData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttemptData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      ),
    );
  }

  @override
  $AttemptTable createAlias(String alias) {
    return $AttemptTable(attachedDatabase, alias);
  }
}

class AttemptData extends DataClass implements Insertable<AttemptData> {
  final int id;
  final String mode;
  final String level;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int? score;
  final int? total;
  const AttemptData({
    required this.id,
    required this.mode,
    required this.level,
    required this.startedAt,
    this.finishedAt,
    this.score,
    this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mode'] = Variable<String>(mode);
    map['level'] = Variable<String>(level);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || total != null) {
      map['total'] = Variable<int>(total);
    }
    return map;
  }

  AttemptCompanion toCompanion(bool nullToAbsent) {
    return AttemptCompanion(
      id: Value(id),
      mode: Value(mode),
      level: Value(level),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      total: total == null && nullToAbsent
          ? const Value.absent()
          : Value(total),
    );
  }

  factory AttemptData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptData(
      id: serializer.fromJson<int>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      level: serializer.fromJson<String>(json['level']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      score: serializer.fromJson<int?>(json['score']),
      total: serializer.fromJson<int?>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String>(mode),
      'level': serializer.toJson<String>(level),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'score': serializer.toJson<int?>(score),
      'total': serializer.toJson<int?>(total),
    };
  }

  AttemptData copyWith({
    int? id,
    String? mode,
    String? level,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    Value<int?> score = const Value.absent(),
    Value<int?> total = const Value.absent(),
  }) => AttemptData(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    level: level ?? this.level,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    score: score.present ? score.value : this.score,
    total: total.present ? total.value : this.total,
  );
  AttemptData copyWithCompanion(AttemptCompanion data) {
    return AttemptData(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      level: data.level.present ? data.level.value : this.level,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      score: data.score.present ? data.score.value : this.score,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttemptData(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('level: $level, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('score: $score, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mode, level, startedAt, finishedAt, score, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptData &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.level == this.level &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.score == this.score &&
          other.total == this.total);
}

class AttemptCompanion extends UpdateCompanion<AttemptData> {
  final Value<int> id;
  final Value<String> mode;
  final Value<String> level;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int?> score;
  final Value<int?> total;
  const AttemptCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.level = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.score = const Value.absent(),
    this.total = const Value.absent(),
  });
  AttemptCompanion.insert({
    this.id = const Value.absent(),
    required String mode,
    required String level,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.score = const Value.absent(),
    this.total = const Value.absent(),
  }) : mode = Value(mode),
       level = Value(level),
       startedAt = Value(startedAt);
  static Insertable<AttemptData> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<String>? level,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? score,
    Expression<int>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (level != null) 'level': level,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (score != null) 'score': score,
      if (total != null) 'total': total,
    });
  }

  AttemptCompanion copyWith({
    Value<int>? id,
    Value<String>? mode,
    Value<String>? level,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int?>? score,
    Value<int?>? total,
  }) {
    return AttemptCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      level: level ?? this.level,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      score: score ?? this.score,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttemptCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('level: $level, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('score: $score, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class $AttemptAnswerTable extends AttemptAnswer
    with TableInfo<$AttemptAnswerTable, AttemptAnswerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttemptAnswerTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<int> attemptId = GeneratedColumn<int>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES attempt (id)',
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
    attemptId,
    questionId,
    selectedIndex,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attempt_answer';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttemptAnswerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
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
  AttemptAnswerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttemptAnswerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_id'],
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
  $AttemptAnswerTable createAlias(String alias) {
    return $AttemptAnswerTable(attachedDatabase, alias);
  }
}

class AttemptAnswerData extends DataClass
    implements Insertable<AttemptAnswerData> {
  final int id;
  final int attemptId;
  final int questionId;
  final int selectedIndex;
  final bool isCorrect;
  const AttemptAnswerData({
    required this.id,
    required this.attemptId,
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['attempt_id'] = Variable<int>(attemptId);
    map['question_id'] = Variable<int>(questionId);
    map['selected_index'] = Variable<int>(selectedIndex);
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  AttemptAnswerCompanion toCompanion(bool nullToAbsent) {
    return AttemptAnswerCompanion(
      id: Value(id),
      attemptId: Value(attemptId),
      questionId: Value(questionId),
      selectedIndex: Value(selectedIndex),
      isCorrect: Value(isCorrect),
    );
  }

  factory AttemptAnswerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttemptAnswerData(
      id: serializer.fromJson<int>(json['id']),
      attemptId: serializer.fromJson<int>(json['attemptId']),
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
      'attemptId': serializer.toJson<int>(attemptId),
      'questionId': serializer.toJson<int>(questionId),
      'selectedIndex': serializer.toJson<int>(selectedIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  AttemptAnswerData copyWith({
    int? id,
    int? attemptId,
    int? questionId,
    int? selectedIndex,
    bool? isCorrect,
  }) => AttemptAnswerData(
    id: id ?? this.id,
    attemptId: attemptId ?? this.attemptId,
    questionId: questionId ?? this.questionId,
    selectedIndex: selectedIndex ?? this.selectedIndex,
    isCorrect: isCorrect ?? this.isCorrect,
  );
  AttemptAnswerData copyWithCompanion(AttemptAnswerCompanion data) {
    return AttemptAnswerData(
      id: data.id.present ? data.id.value : this.id,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
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
    return (StringBuffer('AttemptAnswerData(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, attemptId, questionId, selectedIndex, isCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttemptAnswerData &&
          other.id == this.id &&
          other.attemptId == this.attemptId &&
          other.questionId == this.questionId &&
          other.selectedIndex == this.selectedIndex &&
          other.isCorrect == this.isCorrect);
}

class AttemptAnswerCompanion extends UpdateCompanion<AttemptAnswerData> {
  final Value<int> id;
  final Value<int> attemptId;
  final Value<int> questionId;
  final Value<int> selectedIndex;
  final Value<bool> isCorrect;
  const AttemptAnswerCompanion({
    this.id = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
  });
  AttemptAnswerCompanion.insert({
    this.id = const Value.absent(),
    required int attemptId,
    required int questionId,
    required int selectedIndex,
    required bool isCorrect,
  }) : attemptId = Value(attemptId),
       questionId = Value(questionId),
       selectedIndex = Value(selectedIndex),
       isCorrect = Value(isCorrect);
  static Insertable<AttemptAnswerData> custom({
    Expression<int>? id,
    Expression<int>? attemptId,
    Expression<int>? questionId,
    Expression<int>? selectedIndex,
    Expression<bool>? isCorrect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attemptId != null) 'attempt_id': attemptId,
      if (questionId != null) 'question_id': questionId,
      if (selectedIndex != null) 'selected_index': selectedIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
    });
  }

  AttemptAnswerCompanion copyWith({
    Value<int>? id,
    Value<int>? attemptId,
    Value<int>? questionId,
    Value<int>? selectedIndex,
    Value<bool>? isCorrect,
  }) {
    return AttemptAnswerCompanion(
      id: id ?? this.id,
      attemptId: attemptId ?? this.attemptId,
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
    if (attemptId.present) {
      map['attempt_id'] = Variable<int>(attemptId.value);
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
    return (StringBuffer('AttemptAnswerCompanion(')
          ..write('id: $id, ')
          ..write('attemptId: $attemptId, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }
}

class $UserLessonTable extends UserLesson
    with TableInfo<$UserLessonTable, UserLessonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserLessonTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isPublicMeta = const VerificationMeta(
    'isPublic',
  );
  @override
  late final GeneratedColumn<bool> isPublic = GeneratedColumn<bool>(
    'is_public',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_public" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCustomTitleMeta = const VerificationMeta(
    'isCustomTitle',
  );
  @override
  late final GeneratedColumn<bool> isCustomTitle = GeneratedColumn<bool>(
    'is_custom_title',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_title" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _learnTermLimitMeta = const VerificationMeta(
    'learnTermLimit',
  );
  @override
  late final GeneratedColumn<int> learnTermLimit = GeneratedColumn<int>(
    'learn_term_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _testQuestionLimitMeta = const VerificationMeta(
    'testQuestionLimit',
  );
  @override
  late final GeneratedColumn<int> testQuestionLimit = GeneratedColumn<int>(
    'test_question_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _matchPairLimitMeta = const VerificationMeta(
    'matchPairLimit',
  );
  @override
  late final GeneratedColumn<int> matchPairLimit = GeneratedColumn<int>(
    'match_pair_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    title,
    description,
    tags,
    isPublic,
    isCustomTitle,
    learnTermLimit,
    testQuestionLimit,
    matchPairLimit,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_lesson';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserLessonData> instance, {
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
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('is_public')) {
      context.handle(
        _isPublicMeta,
        isPublic.isAcceptableOrUnknown(data['is_public']!, _isPublicMeta),
      );
    }
    if (data.containsKey('is_custom_title')) {
      context.handle(
        _isCustomTitleMeta,
        isCustomTitle.isAcceptableOrUnknown(
          data['is_custom_title']!,
          _isCustomTitleMeta,
        ),
      );
    }
    if (data.containsKey('learn_term_limit')) {
      context.handle(
        _learnTermLimitMeta,
        learnTermLimit.isAcceptableOrUnknown(
          data['learn_term_limit']!,
          _learnTermLimitMeta,
        ),
      );
    }
    if (data.containsKey('test_question_limit')) {
      context.handle(
        _testQuestionLimitMeta,
        testQuestionLimit.isAcceptableOrUnknown(
          data['test_question_limit']!,
          _testQuestionLimitMeta,
        ),
      );
    }
    if (data.containsKey('match_pair_limit')) {
      context.handle(
        _matchPairLimitMeta,
        matchPairLimit.isAcceptableOrUnknown(
          data['match_pair_limit']!,
          _matchPairLimitMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserLessonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLessonData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      isPublic: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_public'],
      )!,
      isCustomTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_title'],
      )!,
      learnTermLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learn_term_limit'],
      )!,
      testQuestionLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}test_question_limit'],
      )!,
      matchPairLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}match_pair_limit'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $UserLessonTable createAlias(String alias) {
    return $UserLessonTable(attachedDatabase, alias);
  }
}

class UserLessonData extends DataClass implements Insertable<UserLessonData> {
  final int id;
  final String level;
  final String title;
  final String description;
  final String tags;
  final bool isPublic;
  final bool isCustomTitle;
  final int learnTermLimit;
  final int testQuestionLimit;
  final int matchPairLimit;
  final DateTime? updatedAt;
  const UserLessonData({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.tags,
    required this.isPublic,
    required this.isCustomTitle,
    required this.learnTermLimit,
    required this.testQuestionLimit,
    required this.matchPairLimit,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['tags'] = Variable<String>(tags);
    map['is_public'] = Variable<bool>(isPublic);
    map['is_custom_title'] = Variable<bool>(isCustomTitle);
    map['learn_term_limit'] = Variable<int>(learnTermLimit);
    map['test_question_limit'] = Variable<int>(testQuestionLimit);
    map['match_pair_limit'] = Variable<int>(matchPairLimit);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserLessonCompanion toCompanion(bool nullToAbsent) {
    return UserLessonCompanion(
      id: Value(id),
      level: Value(level),
      title: Value(title),
      description: Value(description),
      tags: Value(tags),
      isPublic: Value(isPublic),
      isCustomTitle: Value(isCustomTitle),
      learnTermLimit: Value(learnTermLimit),
      testQuestionLimit: Value(testQuestionLimit),
      matchPairLimit: Value(matchPairLimit),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserLessonData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLessonData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      tags: serializer.fromJson<String>(json['tags']),
      isPublic: serializer.fromJson<bool>(json['isPublic']),
      isCustomTitle: serializer.fromJson<bool>(json['isCustomTitle']),
      learnTermLimit: serializer.fromJson<int>(json['learnTermLimit']),
      testQuestionLimit: serializer.fromJson<int>(json['testQuestionLimit']),
      matchPairLimit: serializer.fromJson<int>(json['matchPairLimit']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'tags': serializer.toJson<String>(tags),
      'isPublic': serializer.toJson<bool>(isPublic),
      'isCustomTitle': serializer.toJson<bool>(isCustomTitle),
      'learnTermLimit': serializer.toJson<int>(learnTermLimit),
      'testQuestionLimit': serializer.toJson<int>(testQuestionLimit),
      'matchPairLimit': serializer.toJson<int>(matchPairLimit),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserLessonData copyWith({
    int? id,
    String? level,
    String? title,
    String? description,
    String? tags,
    bool? isPublic,
    bool? isCustomTitle,
    int? learnTermLimit,
    int? testQuestionLimit,
    int? matchPairLimit,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => UserLessonData(
    id: id ?? this.id,
    level: level ?? this.level,
    title: title ?? this.title,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    isPublic: isPublic ?? this.isPublic,
    isCustomTitle: isCustomTitle ?? this.isCustomTitle,
    learnTermLimit: learnTermLimit ?? this.learnTermLimit,
    testQuestionLimit: testQuestionLimit ?? this.testQuestionLimit,
    matchPairLimit: matchPairLimit ?? this.matchPairLimit,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  UserLessonData copyWithCompanion(UserLessonCompanion data) {
    return UserLessonData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      isPublic: data.isPublic.present ? data.isPublic.value : this.isPublic,
      isCustomTitle: data.isCustomTitle.present
          ? data.isCustomTitle.value
          : this.isCustomTitle,
      learnTermLimit: data.learnTermLimit.present
          ? data.learnTermLimit.value
          : this.learnTermLimit,
      testQuestionLimit: data.testQuestionLimit.present
          ? data.testQuestionLimit.value
          : this.testQuestionLimit,
      matchPairLimit: data.matchPairLimit.present
          ? data.matchPairLimit.value
          : this.matchPairLimit,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserLessonData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('isPublic: $isPublic, ')
          ..write('isCustomTitle: $isCustomTitle, ')
          ..write('learnTermLimit: $learnTermLimit, ')
          ..write('testQuestionLimit: $testQuestionLimit, ')
          ..write('matchPairLimit: $matchPairLimit, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    title,
    description,
    tags,
    isPublic,
    isCustomTitle,
    learnTermLimit,
    testQuestionLimit,
    matchPairLimit,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLessonData &&
          other.id == this.id &&
          other.level == this.level &&
          other.title == this.title &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.isPublic == this.isPublic &&
          other.isCustomTitle == this.isCustomTitle &&
          other.learnTermLimit == this.learnTermLimit &&
          other.testQuestionLimit == this.testQuestionLimit &&
          other.matchPairLimit == this.matchPairLimit &&
          other.updatedAt == this.updatedAt);
}

class UserLessonCompanion extends UpdateCompanion<UserLessonData> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> title;
  final Value<String> description;
  final Value<String> tags;
  final Value<bool> isPublic;
  final Value<bool> isCustomTitle;
  final Value<int> learnTermLimit;
  final Value<int> testQuestionLimit;
  final Value<int> matchPairLimit;
  final Value<DateTime?> updatedAt;
  const UserLessonCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isCustomTitle = const Value.absent(),
    this.learnTermLimit = const Value.absent(),
    this.testQuestionLimit = const Value.absent(),
    this.matchPairLimit = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserLessonCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String title,
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.isPublic = const Value.absent(),
    this.isCustomTitle = const Value.absent(),
    this.learnTermLimit = const Value.absent(),
    this.testQuestionLimit = const Value.absent(),
    this.matchPairLimit = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : level = Value(level),
       title = Value(title);
  static Insertable<UserLessonData> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<bool>? isPublic,
    Expression<bool>? isCustomTitle,
    Expression<int>? learnTermLimit,
    Expression<int>? testQuestionLimit,
    Expression<int>? matchPairLimit,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (isPublic != null) 'is_public': isPublic,
      if (isCustomTitle != null) 'is_custom_title': isCustomTitle,
      if (learnTermLimit != null) 'learn_term_limit': learnTermLimit,
      if (testQuestionLimit != null) 'test_question_limit': testQuestionLimit,
      if (matchPairLimit != null) 'match_pair_limit': matchPairLimit,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserLessonCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? title,
    Value<String>? description,
    Value<String>? tags,
    Value<bool>? isPublic,
    Value<bool>? isCustomTitle,
    Value<int>? learnTermLimit,
    Value<int>? testQuestionLimit,
    Value<int>? matchPairLimit,
    Value<DateTime?>? updatedAt,
  }) {
    return UserLessonCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      isCustomTitle: isCustomTitle ?? this.isCustomTitle,
      learnTermLimit: learnTermLimit ?? this.learnTermLimit,
      testQuestionLimit: testQuestionLimit ?? this.testQuestionLimit,
      matchPairLimit: matchPairLimit ?? this.matchPairLimit,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isPublic.present) {
      map['is_public'] = Variable<bool>(isPublic.value);
    }
    if (isCustomTitle.present) {
      map['is_custom_title'] = Variable<bool>(isCustomTitle.value);
    }
    if (learnTermLimit.present) {
      map['learn_term_limit'] = Variable<int>(learnTermLimit.value);
    }
    if (testQuestionLimit.present) {
      map['test_question_limit'] = Variable<int>(testQuestionLimit.value);
    }
    if (matchPairLimit.present) {
      map['match_pair_limit'] = Variable<int>(matchPairLimit.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserLessonCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('isPublic: $isPublic, ')
          ..write('isCustomTitle: $isCustomTitle, ')
          ..write('learnTermLimit: $learnTermLimit, ')
          ..write('testQuestionLimit: $testQuestionLimit, ')
          ..write('matchPairLimit: $matchPairLimit, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserLessonTermTable extends UserLessonTerm
    with TableInfo<$UserLessonTermTable, UserLessonTermData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserLessonTermTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_lesson (id)',
    ),
  );
  static const VerificationMeta _termMeta = const VerificationMeta('term');
  @override
  late final GeneratedColumn<String> term = GeneratedColumn<String>(
    'term',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _definitionMeta = const VerificationMeta(
    'definition',
  );
  @override
  late final GeneratedColumn<String> definition = GeneratedColumn<String>(
    'definition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _kanjiMeaningMeta = const VerificationMeta(
    'kanjiMeaning',
  );
  @override
  late final GeneratedColumn<String> kanjiMeaning = GeneratedColumn<String>(
    'kanji_meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isStarredMeta = const VerificationMeta(
    'isStarred',
  );
  @override
  late final GeneratedColumn<bool> isStarred = GeneratedColumn<bool>(
    'is_starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLearnedMeta = const VerificationMeta(
    'isLearned',
  );
  @override
  late final GeneratedColumn<bool> isLearned = GeneratedColumn<bool>(
    'is_learned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_learned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lessonId,
    term,
    reading,
    definition,
    kanjiMeaning,
    isStarred,
    isLearned,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_lesson_term';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserLessonTermData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('term')) {
      context.handle(
        _termMeta,
        term.isAcceptableOrUnknown(data['term']!, _termMeta),
      );
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    }
    if (data.containsKey('definition')) {
      context.handle(
        _definitionMeta,
        definition.isAcceptableOrUnknown(data['definition']!, _definitionMeta),
      );
    }
    if (data.containsKey('kanji_meaning')) {
      context.handle(
        _kanjiMeaningMeta,
        kanjiMeaning.isAcceptableOrUnknown(
          data['kanji_meaning']!,
          _kanjiMeaningMeta,
        ),
      );
    }
    if (data.containsKey('is_starred')) {
      context.handle(
        _isStarredMeta,
        isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta),
      );
    }
    if (data.containsKey('is_learned')) {
      context.handle(
        _isLearnedMeta,
        isLearned.isAcceptableOrUnknown(data['is_learned']!, _isLearnedMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserLessonTermData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLessonTermData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      term: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}term'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
      definition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition'],
      )!,
      kanjiMeaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kanji_meaning'],
      )!,
      isStarred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starred'],
      )!,
      isLearned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_learned'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $UserLessonTermTable createAlias(String alias) {
    return $UserLessonTermTable(attachedDatabase, alias);
  }
}

class UserLessonTermData extends DataClass
    implements Insertable<UserLessonTermData> {
  final int id;
  final int lessonId;
  final String term;
  final String reading;
  final String definition;
  final String kanjiMeaning;
  final bool isStarred;
  final bool isLearned;
  final int orderIndex;
  const UserLessonTermData({
    required this.id,
    required this.lessonId,
    required this.term,
    required this.reading,
    required this.definition,
    required this.kanjiMeaning,
    required this.isStarred,
    required this.isLearned,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['term'] = Variable<String>(term);
    map['reading'] = Variable<String>(reading);
    map['definition'] = Variable<String>(definition);
    map['kanji_meaning'] = Variable<String>(kanjiMeaning);
    map['is_starred'] = Variable<bool>(isStarred);
    map['is_learned'] = Variable<bool>(isLearned);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  UserLessonTermCompanion toCompanion(bool nullToAbsent) {
    return UserLessonTermCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      term: Value(term),
      reading: Value(reading),
      definition: Value(definition),
      kanjiMeaning: Value(kanjiMeaning),
      isStarred: Value(isStarred),
      isLearned: Value(isLearned),
      orderIndex: Value(orderIndex),
    );
  }

  factory UserLessonTermData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLessonTermData(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      term: serializer.fromJson<String>(json['term']),
      reading: serializer.fromJson<String>(json['reading']),
      definition: serializer.fromJson<String>(json['definition']),
      kanjiMeaning: serializer.fromJson<String>(json['kanjiMeaning']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      isLearned: serializer.fromJson<bool>(json['isLearned']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'term': serializer.toJson<String>(term),
      'reading': serializer.toJson<String>(reading),
      'definition': serializer.toJson<String>(definition),
      'kanjiMeaning': serializer.toJson<String>(kanjiMeaning),
      'isStarred': serializer.toJson<bool>(isStarred),
      'isLearned': serializer.toJson<bool>(isLearned),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  UserLessonTermData copyWith({
    int? id,
    int? lessonId,
    String? term,
    String? reading,
    String? definition,
    String? kanjiMeaning,
    bool? isStarred,
    bool? isLearned,
    int? orderIndex,
  }) => UserLessonTermData(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    term: term ?? this.term,
    reading: reading ?? this.reading,
    definition: definition ?? this.definition,
    kanjiMeaning: kanjiMeaning ?? this.kanjiMeaning,
    isStarred: isStarred ?? this.isStarred,
    isLearned: isLearned ?? this.isLearned,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  UserLessonTermData copyWithCompanion(UserLessonTermCompanion data) {
    return UserLessonTermData(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      term: data.term.present ? data.term.value : this.term,
      reading: data.reading.present ? data.reading.value : this.reading,
      definition: data.definition.present
          ? data.definition.value
          : this.definition,
      kanjiMeaning: data.kanjiMeaning.present
          ? data.kanjiMeaning.value
          : this.kanjiMeaning,
      isStarred: data.isStarred.present ? data.isStarred.value : this.isStarred,
      isLearned: data.isLearned.present ? data.isLearned.value : this.isLearned,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserLessonTermData(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('term: $term, ')
          ..write('reading: $reading, ')
          ..write('definition: $definition, ')
          ..write('kanjiMeaning: $kanjiMeaning, ')
          ..write('isStarred: $isStarred, ')
          ..write('isLearned: $isLearned, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lessonId,
    term,
    reading,
    definition,
    kanjiMeaning,
    isStarred,
    isLearned,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLessonTermData &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.term == this.term &&
          other.reading == this.reading &&
          other.definition == this.definition &&
          other.kanjiMeaning == this.kanjiMeaning &&
          other.isStarred == this.isStarred &&
          other.isLearned == this.isLearned &&
          other.orderIndex == this.orderIndex);
}

class UserLessonTermCompanion extends UpdateCompanion<UserLessonTermData> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<String> term;
  final Value<String> reading;
  final Value<String> definition;
  final Value<String> kanjiMeaning;
  final Value<bool> isStarred;
  final Value<bool> isLearned;
  final Value<int> orderIndex;
  const UserLessonTermCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.term = const Value.absent(),
    this.reading = const Value.absent(),
    this.definition = const Value.absent(),
    this.kanjiMeaning = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.isLearned = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  UserLessonTermCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    this.term = const Value.absent(),
    this.reading = const Value.absent(),
    this.definition = const Value.absent(),
    this.kanjiMeaning = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.isLearned = const Value.absent(),
    this.orderIndex = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<UserLessonTermData> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<String>? term,
    Expression<String>? reading,
    Expression<String>? definition,
    Expression<String>? kanjiMeaning,
    Expression<bool>? isStarred,
    Expression<bool>? isLearned,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (term != null) 'term': term,
      if (reading != null) 'reading': reading,
      if (definition != null) 'definition': definition,
      if (kanjiMeaning != null) 'kanji_meaning': kanjiMeaning,
      if (isStarred != null) 'is_starred': isStarred,
      if (isLearned != null) 'is_learned': isLearned,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  UserLessonTermCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<String>? term,
    Value<String>? reading,
    Value<String>? definition,
    Value<String>? kanjiMeaning,
    Value<bool>? isStarred,
    Value<bool>? isLearned,
    Value<int>? orderIndex,
  }) {
    return UserLessonTermCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      term: term ?? this.term,
      reading: reading ?? this.reading,
      definition: definition ?? this.definition,
      kanjiMeaning: kanjiMeaning ?? this.kanjiMeaning,
      isStarred: isStarred ?? this.isStarred,
      isLearned: isLearned ?? this.isLearned,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (term.present) {
      map['term'] = Variable<String>(term.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (definition.present) {
      map['definition'] = Variable<String>(definition.value);
    }
    if (kanjiMeaning.present) {
      map['kanji_meaning'] = Variable<String>(kanjiMeaning.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (isLearned.present) {
      map['is_learned'] = Variable<bool>(isLearned.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserLessonTermCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('term: $term, ')
          ..write('reading: $reading, ')
          ..write('definition: $definition, ')
          ..write('kanjiMeaning: $kanjiMeaning, ')
          ..write('isStarred: $isStarred, ')
          ..write('isLearned: $isLearned, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SrsStateTable srsState = $SrsStateTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $AttemptTable attempt = $AttemptTable(this);
  late final $AttemptAnswerTable attemptAnswer = $AttemptAnswerTable(this);
  late final $UserLessonTable userLesson = $UserLessonTable(this);
  late final $UserLessonTermTable userLessonTerm = $UserLessonTermTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    srsState,
    userProgress,
    attempt,
    attemptAnswer,
    userLesson,
    userLessonTerm,
  ];
}

typedef $$SrsStateTableCreateCompanionBuilder =
    SrsStateCompanion Function({
      Value<int> id,
      required int vocabId,
      Value<int> box,
      Value<int> repetitions,
      Value<double> ease,
      Value<DateTime?> lastReviewedAt,
      required DateTime nextReviewAt,
    });
typedef $$SrsStateTableUpdateCompanionBuilder =
    SrsStateCompanion Function({
      Value<int> id,
      Value<int> vocabId,
      Value<int> box,
      Value<int> repetitions,
      Value<double> ease,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime> nextReviewAt,
    });

class $$SrsStateTableFilterComposer
    extends Composer<_$AppDatabase, $SrsStateTable> {
  $$SrsStateTableFilterComposer({
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

  ColumnFilters<int> get vocabId => $composableBuilder(
    column: $table.vocabId,
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
}

class $$SrsStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsStateTable> {
  $$SrsStateTableOrderingComposer({
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

  ColumnOrderings<int> get vocabId => $composableBuilder(
    column: $table.vocabId,
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
}

class $$SrsStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsStateTable> {
  $$SrsStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get vocabId =>
      $composableBuilder(column: $table.vocabId, builder: (column) => column);

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
}

class $$SrsStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrsStateTable,
          SrsStateData,
          $$SrsStateTableFilterComposer,
          $$SrsStateTableOrderingComposer,
          $$SrsStateTableAnnotationComposer,
          $$SrsStateTableCreateCompanionBuilder,
          $$SrsStateTableUpdateCompanionBuilder,
          (
            SrsStateData,
            BaseReferences<_$AppDatabase, $SrsStateTable, SrsStateData>,
          ),
          SrsStateData,
          PrefetchHooks Function()
        > {
  $$SrsStateTableTableManager(_$AppDatabase db, $SrsStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vocabId = const Value.absent(),
                Value<int> box = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime> nextReviewAt = const Value.absent(),
              }) => SrsStateCompanion(
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
              }) => SrsStateCompanion.insert(
                id: id,
                vocabId: vocabId,
                box: box,
                repetitions: repetitions,
                ease: ease,
                lastReviewedAt: lastReviewedAt,
                nextReviewAt: nextReviewAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrsStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrsStateTable,
      SrsStateData,
      $$SrsStateTableFilterComposer,
      $$SrsStateTableOrderingComposer,
      $$SrsStateTableAnnotationComposer,
      $$SrsStateTableCreateCompanionBuilder,
      $$SrsStateTableUpdateCompanionBuilder,
      (
        SrsStateData,
        BaseReferences<_$AppDatabase, $SrsStateTable, SrsStateData>,
      ),
      SrsStateData,
      PrefetchHooks Function()
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      required DateTime day,
      Value<int> xp,
      Value<int> streak,
      Value<int> reviewedCount,
      Value<int> reviewAgainCount,
      Value<int> reviewHardCount,
      Value<int> reviewGoodCount,
      Value<int> reviewEasyCount,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      Value<DateTime> day,
      Value<int> xp,
      Value<int> streak,
      Value<int> reviewedCount,
      Value<int> reviewAgainCount,
      Value<int> reviewHardCount,
      Value<int> reviewGoodCount,
      Value<int> reviewEasyCount,
    });

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
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

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewedCount => $composableBuilder(
    column: $table.reviewedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewAgainCount => $composableBuilder(
    column: $table.reviewAgainCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewHardCount => $composableBuilder(
    column: $table.reviewHardCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewGoodCount => $composableBuilder(
    column: $table.reviewGoodCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewEasyCount => $composableBuilder(
    column: $table.reviewEasyCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
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

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewedCount => $composableBuilder(
    column: $table.reviewedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewAgainCount => $composableBuilder(
    column: $table.reviewAgainCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewHardCount => $composableBuilder(
    column: $table.reviewHardCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewGoodCount => $composableBuilder(
    column: $table.reviewGoodCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewEasyCount => $composableBuilder(
    column: $table.reviewEasyCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
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

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get reviewedCount => $composableBuilder(
    column: $table.reviewedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewAgainCount => $composableBuilder(
    column: $table.reviewAgainCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewHardCount => $composableBuilder(
    column: $table.reviewHardCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewGoodCount => $composableBuilder(
    column: $table.reviewGoodCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewEasyCount => $composableBuilder(
    column: $table.reviewEasyCount,
    builder: (column) => column,
  );
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressData,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (
            UserProgressData,
            BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>,
          ),
          UserProgressData,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> reviewedCount = const Value.absent(),
                Value<int> reviewAgainCount = const Value.absent(),
                Value<int> reviewHardCount = const Value.absent(),
                Value<int> reviewGoodCount = const Value.absent(),
                Value<int> reviewEasyCount = const Value.absent(),
              }) => UserProgressCompanion(
                id: id,
                day: day,
                xp: xp,
                streak: streak,
                reviewedCount: reviewedCount,
                reviewAgainCount: reviewAgainCount,
                reviewHardCount: reviewHardCount,
                reviewGoodCount: reviewGoodCount,
                reviewEasyCount: reviewEasyCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime day,
                Value<int> xp = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> reviewedCount = const Value.absent(),
                Value<int> reviewAgainCount = const Value.absent(),
                Value<int> reviewHardCount = const Value.absent(),
                Value<int> reviewGoodCount = const Value.absent(),
                Value<int> reviewEasyCount = const Value.absent(),
              }) => UserProgressCompanion.insert(
                id: id,
                day: day,
                xp: xp,
                streak: streak,
                reviewedCount: reviewedCount,
                reviewAgainCount: reviewAgainCount,
                reviewHardCount: reviewHardCount,
                reviewGoodCount: reviewGoodCount,
                reviewEasyCount: reviewEasyCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressData,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (
        UserProgressData,
        BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>,
      ),
      UserProgressData,
      PrefetchHooks Function()
    >;
typedef $$AttemptTableCreateCompanionBuilder =
    AttemptCompanion Function({
      Value<int> id,
      required String mode,
      required String level,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int?> score,
      Value<int?> total,
    });
typedef $$AttemptTableUpdateCompanionBuilder =
    AttemptCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<String> level,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int?> score,
      Value<int?> total,
    });

final class $$AttemptTableReferences
    extends BaseReferences<_$AppDatabase, $AttemptTable, AttemptData> {
  $$AttemptTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttemptAnswerTable, List<AttemptAnswerData>>
  _attemptAnswerRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attemptAnswer,
    aliasName: $_aliasNameGenerator(db.attempt.id, db.attemptAnswer.attemptId),
  );

  $$AttemptAnswerTableProcessedTableManager get attemptAnswerRefs {
    final manager = $$AttemptAnswerTableTableManager(
      $_db,
      $_db.attemptAnswer,
    ).filter((f) => f.attemptId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attemptAnswerRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AttemptTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptTable> {
  $$AttemptTableFilterComposer({
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

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
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

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
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

  Expression<bool> attemptAnswerRefs(
    Expression<bool> Function($$AttemptAnswerTableFilterComposer f) f,
  ) {
    final $$AttemptAnswerTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attemptAnswer,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptAnswerTableFilterComposer(
            $db: $db,
            $table: $db.attemptAnswer,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AttemptTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptTable> {
  $$AttemptTableOrderingComposer({
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

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
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

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
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
}

class $$AttemptTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptTable> {
  $$AttemptTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  Expression<T> attemptAnswerRefs<T extends Object>(
    Expression<T> Function($$AttemptAnswerTableAnnotationComposer a) f,
  ) {
    final $$AttemptAnswerTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attemptAnswer,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptAnswerTableAnnotationComposer(
            $db: $db,
            $table: $db.attemptAnswer,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AttemptTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptTable,
          AttemptData,
          $$AttemptTableFilterComposer,
          $$AttemptTableOrderingComposer,
          $$AttemptTableAnnotationComposer,
          $$AttemptTableCreateCompanionBuilder,
          $$AttemptTableUpdateCompanionBuilder,
          (AttemptData, $$AttemptTableReferences),
          AttemptData,
          PrefetchHooks Function({bool attemptAnswerRefs})
        > {
  $$AttemptTableTableManager(_$AppDatabase db, $AttemptTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> total = const Value.absent(),
              }) => AttemptCompanion(
                id: id,
                mode: mode,
                level: level,
                startedAt: startedAt,
                finishedAt: finishedAt,
                score: score,
                total: total,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mode,
                required String level,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> total = const Value.absent(),
              }) => AttemptCompanion.insert(
                id: id,
                mode: mode,
                level: level,
                startedAt: startedAt,
                finishedAt: finishedAt,
                score: score,
                total: total,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttemptTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptAnswerRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attemptAnswerRefs) db.attemptAnswer,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attemptAnswerRefs)
                    await $_getPrefetchedData<
                      AttemptData,
                      $AttemptTable,
                      AttemptAnswerData
                    >(
                      currentTable: table,
                      referencedTable: $$AttemptTableReferences
                          ._attemptAnswerRefsTable(db),
                      managerFromTypedResult: (p0) => $$AttemptTableReferences(
                        db,
                        table,
                        p0,
                      ).attemptAnswerRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.attemptId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AttemptTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptTable,
      AttemptData,
      $$AttemptTableFilterComposer,
      $$AttemptTableOrderingComposer,
      $$AttemptTableAnnotationComposer,
      $$AttemptTableCreateCompanionBuilder,
      $$AttemptTableUpdateCompanionBuilder,
      (AttemptData, $$AttemptTableReferences),
      AttemptData,
      PrefetchHooks Function({bool attemptAnswerRefs})
    >;
typedef $$AttemptAnswerTableCreateCompanionBuilder =
    AttemptAnswerCompanion Function({
      Value<int> id,
      required int attemptId,
      required int questionId,
      required int selectedIndex,
      required bool isCorrect,
    });
typedef $$AttemptAnswerTableUpdateCompanionBuilder =
    AttemptAnswerCompanion Function({
      Value<int> id,
      Value<int> attemptId,
      Value<int> questionId,
      Value<int> selectedIndex,
      Value<bool> isCorrect,
    });

final class $$AttemptAnswerTableReferences
    extends
        BaseReferences<_$AppDatabase, $AttemptAnswerTable, AttemptAnswerData> {
  $$AttemptAnswerTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AttemptTable _attemptIdTable(_$AppDatabase db) =>
      db.attempt.createAlias(
        $_aliasNameGenerator(db.attemptAnswer.attemptId, db.attempt.id),
      );

  $$AttemptTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<int>('attempt_id')!;

    final manager = $$AttemptTableTableManager(
      $_db,
      $_db.attempt,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttemptAnswerTableFilterComposer
    extends Composer<_$AppDatabase, $AttemptAnswerTable> {
  $$AttemptAnswerTableFilterComposer({
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

  ColumnFilters<int> get questionId => $composableBuilder(
    column: $table.questionId,
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

  $$AttemptTableFilterComposer get attemptId {
    final $$AttemptTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.attempt,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptTableFilterComposer(
            $db: $db,
            $table: $db.attempt,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptAnswerTableOrderingComposer
    extends Composer<_$AppDatabase, $AttemptAnswerTable> {
  $$AttemptAnswerTableOrderingComposer({
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

  ColumnOrderings<int> get questionId => $composableBuilder(
    column: $table.questionId,
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

  $$AttemptTableOrderingComposer get attemptId {
    final $$AttemptTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.attempt,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptTableOrderingComposer(
            $db: $db,
            $table: $db.attempt,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptAnswerTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttemptAnswerTable> {
  $$AttemptAnswerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$AttemptTableAnnotationComposer get attemptId {
    final $$AttemptTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.attempt,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttemptTableAnnotationComposer(
            $db: $db,
            $table: $db.attempt,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttemptAnswerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttemptAnswerTable,
          AttemptAnswerData,
          $$AttemptAnswerTableFilterComposer,
          $$AttemptAnswerTableOrderingComposer,
          $$AttemptAnswerTableAnnotationComposer,
          $$AttemptAnswerTableCreateCompanionBuilder,
          $$AttemptAnswerTableUpdateCompanionBuilder,
          (AttemptAnswerData, $$AttemptAnswerTableReferences),
          AttemptAnswerData,
          PrefetchHooks Function({bool attemptId})
        > {
  $$AttemptAnswerTableTableManager(_$AppDatabase db, $AttemptAnswerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttemptAnswerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttemptAnswerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttemptAnswerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> attemptId = const Value.absent(),
                Value<int> questionId = const Value.absent(),
                Value<int> selectedIndex = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
              }) => AttemptAnswerCompanion(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int attemptId,
                required int questionId,
                required int selectedIndex,
                required bool isCorrect,
              }) => AttemptAnswerCompanion.insert(
                id: id,
                attemptId: attemptId,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttemptAnswerTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptId = false}) {
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
                    if (attemptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.attemptId,
                                referencedTable: $$AttemptAnswerTableReferences
                                    ._attemptIdTable(db),
                                referencedColumn: $$AttemptAnswerTableReferences
                                    ._attemptIdTable(db)
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

typedef $$AttemptAnswerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttemptAnswerTable,
      AttemptAnswerData,
      $$AttemptAnswerTableFilterComposer,
      $$AttemptAnswerTableOrderingComposer,
      $$AttemptAnswerTableAnnotationComposer,
      $$AttemptAnswerTableCreateCompanionBuilder,
      $$AttemptAnswerTableUpdateCompanionBuilder,
      (AttemptAnswerData, $$AttemptAnswerTableReferences),
      AttemptAnswerData,
      PrefetchHooks Function({bool attemptId})
    >;
typedef $$UserLessonTableCreateCompanionBuilder =
    UserLessonCompanion Function({
      Value<int> id,
      required String level,
      required String title,
      Value<String> description,
      Value<String> tags,
      Value<bool> isPublic,
      Value<bool> isCustomTitle,
      Value<int> learnTermLimit,
      Value<int> testQuestionLimit,
      Value<int> matchPairLimit,
      Value<DateTime?> updatedAt,
    });
typedef $$UserLessonTableUpdateCompanionBuilder =
    UserLessonCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> title,
      Value<String> description,
      Value<String> tags,
      Value<bool> isPublic,
      Value<bool> isCustomTitle,
      Value<int> learnTermLimit,
      Value<int> testQuestionLimit,
      Value<int> matchPairLimit,
      Value<DateTime?> updatedAt,
    });

final class $$UserLessonTableReferences
    extends BaseReferences<_$AppDatabase, $UserLessonTable, UserLessonData> {
  $$UserLessonTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserLessonTermTable, List<UserLessonTermData>>
  _userLessonTermRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userLessonTerm,
    aliasName: $_aliasNameGenerator(
      db.userLesson.id,
      db.userLessonTerm.lessonId,
    ),
  );

  $$UserLessonTermTableProcessedTableManager get userLessonTermRefs {
    final manager = $$UserLessonTermTableTableManager(
      $_db,
      $_db.userLessonTerm,
    ).filter((f) => f.lessonId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userLessonTermRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserLessonTableFilterComposer
    extends Composer<_$AppDatabase, $UserLessonTable> {
  $$UserLessonTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomTitle => $composableBuilder(
    column: $table.isCustomTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get learnTermLimit => $composableBuilder(
    column: $table.learnTermLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get testQuestionLimit => $composableBuilder(
    column: $table.testQuestionLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get matchPairLimit => $composableBuilder(
    column: $table.matchPairLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userLessonTermRefs(
    Expression<bool> Function($$UserLessonTermTableFilterComposer f) f,
  ) {
    final $$UserLessonTermTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userLessonTerm,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserLessonTermTableFilterComposer(
            $db: $db,
            $table: $db.userLessonTerm,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserLessonTableOrderingComposer
    extends Composer<_$AppDatabase, $UserLessonTable> {
  $$UserLessonTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublic => $composableBuilder(
    column: $table.isPublic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomTitle => $composableBuilder(
    column: $table.isCustomTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get learnTermLimit => $composableBuilder(
    column: $table.learnTermLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get testQuestionLimit => $composableBuilder(
    column: $table.testQuestionLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get matchPairLimit => $composableBuilder(
    column: $table.matchPairLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserLessonTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserLessonTable> {
  $$UserLessonTableAnnotationComposer({
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isPublic =>
      $composableBuilder(column: $table.isPublic, builder: (column) => column);

  GeneratedColumn<bool> get isCustomTitle => $composableBuilder(
    column: $table.isCustomTitle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get learnTermLimit => $composableBuilder(
    column: $table.learnTermLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get testQuestionLimit => $composableBuilder(
    column: $table.testQuestionLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get matchPairLimit => $composableBuilder(
    column: $table.matchPairLimit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> userLessonTermRefs<T extends Object>(
    Expression<T> Function($$UserLessonTermTableAnnotationComposer a) f,
  ) {
    final $$UserLessonTermTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userLessonTerm,
      getReferencedColumn: (t) => t.lessonId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserLessonTermTableAnnotationComposer(
            $db: $db,
            $table: $db.userLessonTerm,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserLessonTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserLessonTable,
          UserLessonData,
          $$UserLessonTableFilterComposer,
          $$UserLessonTableOrderingComposer,
          $$UserLessonTableAnnotationComposer,
          $$UserLessonTableCreateCompanionBuilder,
          $$UserLessonTableUpdateCompanionBuilder,
          (UserLessonData, $$UserLessonTableReferences),
          UserLessonData,
          PrefetchHooks Function({bool userLessonTermRefs})
        > {
  $$UserLessonTableTableManager(_$AppDatabase db, $UserLessonTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserLessonTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserLessonTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserLessonTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<bool> isCustomTitle = const Value.absent(),
                Value<int> learnTermLimit = const Value.absent(),
                Value<int> testQuestionLimit = const Value.absent(),
                Value<int> matchPairLimit = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => UserLessonCompanion(
                id: id,
                level: level,
                title: title,
                description: description,
                tags: tags,
                isPublic: isPublic,
                isCustomTitle: isCustomTitle,
                learnTermLimit: learnTermLimit,
                testQuestionLimit: testQuestionLimit,
                matchPairLimit: matchPairLimit,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                required String title,
                Value<String> description = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> isPublic = const Value.absent(),
                Value<bool> isCustomTitle = const Value.absent(),
                Value<int> learnTermLimit = const Value.absent(),
                Value<int> testQuestionLimit = const Value.absent(),
                Value<int> matchPairLimit = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => UserLessonCompanion.insert(
                id: id,
                level: level,
                title: title,
                description: description,
                tags: tags,
                isPublic: isPublic,
                isCustomTitle: isCustomTitle,
                learnTermLimit: learnTermLimit,
                testQuestionLimit: testQuestionLimit,
                matchPairLimit: matchPairLimit,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserLessonTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userLessonTermRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userLessonTermRefs) db.userLessonTerm,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userLessonTermRefs)
                    await $_getPrefetchedData<
                      UserLessonData,
                      $UserLessonTable,
                      UserLessonTermData
                    >(
                      currentTable: table,
                      referencedTable: $$UserLessonTableReferences
                          ._userLessonTermRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserLessonTableReferences(
                            db,
                            table,
                            p0,
                          ).userLessonTermRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.lessonId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserLessonTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserLessonTable,
      UserLessonData,
      $$UserLessonTableFilterComposer,
      $$UserLessonTableOrderingComposer,
      $$UserLessonTableAnnotationComposer,
      $$UserLessonTableCreateCompanionBuilder,
      $$UserLessonTableUpdateCompanionBuilder,
      (UserLessonData, $$UserLessonTableReferences),
      UserLessonData,
      PrefetchHooks Function({bool userLessonTermRefs})
    >;
typedef $$UserLessonTermTableCreateCompanionBuilder =
    UserLessonTermCompanion Function({
      Value<int> id,
      required int lessonId,
      Value<String> term,
      Value<String> reading,
      Value<String> definition,
      Value<String> kanjiMeaning,
      Value<bool> isStarred,
      Value<bool> isLearned,
      Value<int> orderIndex,
    });
typedef $$UserLessonTermTableUpdateCompanionBuilder =
    UserLessonTermCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<String> term,
      Value<String> reading,
      Value<String> definition,
      Value<String> kanjiMeaning,
      Value<bool> isStarred,
      Value<bool> isLearned,
      Value<int> orderIndex,
    });

final class $$UserLessonTermTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $UserLessonTermTable,
          UserLessonTermData
        > {
  $$UserLessonTermTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserLessonTable _lessonIdTable(_$AppDatabase db) =>
      db.userLesson.createAlias(
        $_aliasNameGenerator(db.userLessonTerm.lessonId, db.userLesson.id),
      );

  $$UserLessonTableProcessedTableManager get lessonId {
    final $_column = $_itemColumn<int>('lesson_id')!;

    final manager = $$UserLessonTableTableManager(
      $_db,
      $_db.userLesson,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lessonIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserLessonTermTableFilterComposer
    extends Composer<_$AppDatabase, $UserLessonTermTable> {
  $$UserLessonTermTableFilterComposer({
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

  ColumnFilters<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kanjiMeaning => $composableBuilder(
    column: $table.kanjiMeaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLearned => $composableBuilder(
    column: $table.isLearned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$UserLessonTableFilterComposer get lessonId {
    final $$UserLessonTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.userLesson,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserLessonTableFilterComposer(
            $db: $db,
            $table: $db.userLesson,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserLessonTermTableOrderingComposer
    extends Composer<_$AppDatabase, $UserLessonTermTable> {
  $$UserLessonTermTableOrderingComposer({
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

  ColumnOrderings<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kanjiMeaning => $composableBuilder(
    column: $table.kanjiMeaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLearned => $composableBuilder(
    column: $table.isLearned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserLessonTableOrderingComposer get lessonId {
    final $$UserLessonTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.userLesson,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserLessonTableOrderingComposer(
            $db: $db,
            $table: $db.userLesson,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserLessonTermTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserLessonTermTable> {
  $$UserLessonTermTableAnnotationComposer({
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

  GeneratedColumn<String> get definition => $composableBuilder(
    column: $table.definition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kanjiMeaning => $composableBuilder(
    column: $table.kanjiMeaning,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStarred =>
      $composableBuilder(column: $table.isStarred, builder: (column) => column);

  GeneratedColumn<bool> get isLearned =>
      $composableBuilder(column: $table.isLearned, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$UserLessonTableAnnotationComposer get lessonId {
    final $$UserLessonTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lessonId,
      referencedTable: $db.userLesson,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserLessonTableAnnotationComposer(
            $db: $db,
            $table: $db.userLesson,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserLessonTermTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserLessonTermTable,
          UserLessonTermData,
          $$UserLessonTermTableFilterComposer,
          $$UserLessonTermTableOrderingComposer,
          $$UserLessonTermTableAnnotationComposer,
          $$UserLessonTermTableCreateCompanionBuilder,
          $$UserLessonTermTableUpdateCompanionBuilder,
          (UserLessonTermData, $$UserLessonTermTableReferences),
          UserLessonTermData,
          PrefetchHooks Function({bool lessonId})
        > {
  $$UserLessonTermTableTableManager(
    _$AppDatabase db,
    $UserLessonTermTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserLessonTermTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserLessonTermTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserLessonTermTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> term = const Value.absent(),
                Value<String> reading = const Value.absent(),
                Value<String> definition = const Value.absent(),
                Value<String> kanjiMeaning = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<bool> isLearned = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => UserLessonTermCompanion(
                id: id,
                lessonId: lessonId,
                term: term,
                reading: reading,
                definition: definition,
                kanjiMeaning: kanjiMeaning,
                isStarred: isStarred,
                isLearned: isLearned,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                Value<String> term = const Value.absent(),
                Value<String> reading = const Value.absent(),
                Value<String> definition = const Value.absent(),
                Value<String> kanjiMeaning = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<bool> isLearned = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => UserLessonTermCompanion.insert(
                id: id,
                lessonId: lessonId,
                term: term,
                reading: reading,
                definition: definition,
                kanjiMeaning: kanjiMeaning,
                isStarred: isStarred,
                isLearned: isLearned,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserLessonTermTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonId = false}) {
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
                    if (lessonId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lessonId,
                                referencedTable: $$UserLessonTermTableReferences
                                    ._lessonIdTable(db),
                                referencedColumn:
                                    $$UserLessonTermTableReferences
                                        ._lessonIdTable(db)
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

typedef $$UserLessonTermTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserLessonTermTable,
      UserLessonTermData,
      $$UserLessonTermTableFilterComposer,
      $$UserLessonTermTableOrderingComposer,
      $$UserLessonTermTableAnnotationComposer,
      $$UserLessonTermTableCreateCompanionBuilder,
      $$UserLessonTermTableUpdateCompanionBuilder,
      (UserLessonTermData, $$UserLessonTermTableReferences),
      UserLessonTermData,
      PrefetchHooks Function({bool lessonId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SrsStateTableTableManager get srsState =>
      $$SrsStateTableTableManager(_db, _db.srsState);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$AttemptTableTableManager get attempt =>
      $$AttemptTableTableManager(_db, _db.attempt);
  $$AttemptAnswerTableTableManager get attemptAnswer =>
      $$AttemptAnswerTableTableManager(_db, _db.attemptAnswer);
  $$UserLessonTableTableManager get userLesson =>
      $$UserLessonTableTableManager(_db, _db.userLesson);
  $$UserLessonTermTableTableManager get userLessonTerm =>
      $$UserLessonTermTableTableManager(_db, _db.userLessonTerm);
}
