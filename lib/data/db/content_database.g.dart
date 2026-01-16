// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_database.dart';

// ignore_for_file: type=lint
class $VocabTable extends Vocab with TableInfo<$VocabTable, VocabData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    term,
    reading,
    meaning,
    level,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabData> instance, {
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
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabData(
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
    );
  }

  @override
  $VocabTable createAlias(String alias) {
    return $VocabTable(attachedDatabase, alias);
  }
}

class VocabData extends DataClass implements Insertable<VocabData> {
  final int id;
  final String term;
  final String? reading;
  final String meaning;
  final String level;
  final String? tags;
  const VocabData({
    required this.id,
    required this.term,
    this.reading,
    required this.meaning,
    required this.level,
    this.tags,
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
    return map;
  }

  VocabCompanion toCompanion(bool nullToAbsent) {
    return VocabCompanion(
      id: Value(id),
      term: Value(term),
      reading: reading == null && nullToAbsent
          ? const Value.absent()
          : Value(reading),
      meaning: Value(meaning),
      level: Value(level),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory VocabData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabData(
      id: serializer.fromJson<int>(json['id']),
      term: serializer.fromJson<String>(json['term']),
      reading: serializer.fromJson<String?>(json['reading']),
      meaning: serializer.fromJson<String>(json['meaning']),
      level: serializer.fromJson<String>(json['level']),
      tags: serializer.fromJson<String?>(json['tags']),
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
    };
  }

  VocabData copyWith({
    int? id,
    String? term,
    Value<String?> reading = const Value.absent(),
    String? meaning,
    String? level,
    Value<String?> tags = const Value.absent(),
  }) => VocabData(
    id: id ?? this.id,
    term: term ?? this.term,
    reading: reading.present ? reading.value : this.reading,
    meaning: meaning ?? this.meaning,
    level: level ?? this.level,
    tags: tags.present ? tags.value : this.tags,
  );
  VocabData copyWithCompanion(VocabCompanion data) {
    return VocabData(
      id: data.id.present ? data.id.value : this.id,
      term: data.term.present ? data.term.value : this.term,
      reading: data.reading.present ? data.reading.value : this.reading,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
      level: data.level.present ? data.level.value : this.level,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabData(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('reading: $reading, ')
          ..write('meaning: $meaning, ')
          ..write('level: $level, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, term, reading, meaning, level, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabData &&
          other.id == this.id &&
          other.term == this.term &&
          other.reading == this.reading &&
          other.meaning == this.meaning &&
          other.level == this.level &&
          other.tags == this.tags);
}

class VocabCompanion extends UpdateCompanion<VocabData> {
  final Value<int> id;
  final Value<String> term;
  final Value<String?> reading;
  final Value<String> meaning;
  final Value<String> level;
  final Value<String?> tags;
  const VocabCompanion({
    this.id = const Value.absent(),
    this.term = const Value.absent(),
    this.reading = const Value.absent(),
    this.meaning = const Value.absent(),
    this.level = const Value.absent(),
    this.tags = const Value.absent(),
  });
  VocabCompanion.insert({
    this.id = const Value.absent(),
    required String term,
    this.reading = const Value.absent(),
    required String meaning,
    required String level,
    this.tags = const Value.absent(),
  }) : term = Value(term),
       meaning = Value(meaning),
       level = Value(level);
  static Insertable<VocabData> custom({
    Expression<int>? id,
    Expression<String>? term,
    Expression<String>? reading,
    Expression<String>? meaning,
    Expression<String>? level,
    Expression<String>? tags,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (term != null) 'term': term,
      if (reading != null) 'reading': reading,
      if (meaning != null) 'meaning': meaning,
      if (level != null) 'level': level,
      if (tags != null) 'tags': tags,
    });
  }

  VocabCompanion copyWith({
    Value<int>? id,
    Value<String>? term,
    Value<String?>? reading,
    Value<String>? meaning,
    Value<String>? level,
    Value<String?>? tags,
  }) {
    return VocabCompanion(
      id: id ?? this.id,
      term: term ?? this.term,
      reading: reading ?? this.reading,
      meaning: meaning ?? this.meaning,
      level: level ?? this.level,
      tags: tags ?? this.tags,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabCompanion(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('reading: $reading, ')
          ..write('meaning: $meaning, ')
          ..write('level: $level, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }
}

class $GrammarTable extends Grammar with TableInfo<$GrammarTable, GrammarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, level, title, summary];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarData> instance, {
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
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarData(
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
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
    );
  }

  @override
  $GrammarTable createAlias(String alias) {
    return $GrammarTable(attachedDatabase, alias);
  }
}

class GrammarData extends DataClass implements Insertable<GrammarData> {
  final int id;
  final String level;
  final String title;
  final String summary;
  const GrammarData({
    required this.id,
    required this.level,
    required this.title,
    required this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    return map;
  }

  GrammarCompanion toCompanion(bool nullToAbsent) {
    return GrammarCompanion(
      id: Value(id),
      level: Value(level),
      title: Value(title),
      summary: Value(summary),
    );
  }

  factory GrammarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
    };
  }

  GrammarData copyWith({
    int? id,
    String? level,
    String? title,
    String? summary,
  }) => GrammarData(
    id: id ?? this.id,
    level: level ?? this.level,
    title: title ?? this.title,
    summary: summary ?? this.summary,
  );
  GrammarData copyWithCompanion(GrammarCompanion data) {
    return GrammarData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, title, summary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarData &&
          other.id == this.id &&
          other.level == this.level &&
          other.title == this.title &&
          other.summary == this.summary);
}

class GrammarCompanion extends UpdateCompanion<GrammarData> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> title;
  final Value<String> summary;
  const GrammarCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
  });
  GrammarCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String title,
    required String summary,
  }) : level = Value(level),
       title = Value(title),
       summary = Value(summary);
  static Insertable<GrammarData> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? title,
    Expression<String>? summary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
    });
  }

  GrammarCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? title,
    Value<String>? summary,
  }) {
    return GrammarCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      title: title ?? this.title,
      summary: summary ?? this.summary,
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
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }
}

class $QuestionTable extends Question
    with TableInfo<$QuestionTable, QuestionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _grammarIdMeta = const VerificationMeta(
    'grammarId',
  );
  @override
  late final GeneratedColumn<int> grammarId = GeneratedColumn<int>(
    'grammar_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    grammarId,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionData> instance, {
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
    if (data.containsKey('grammar_id')) {
      context.handle(
        _grammarIdMeta,
        grammarId.isAcceptableOrUnknown(data['grammar_id']!, _grammarIdMeta),
      );
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
  QuestionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionData(
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
      grammarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grammar_id'],
      ),
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
    );
  }

  @override
  $QuestionTable createAlias(String alias) {
    return $QuestionTable(attachedDatabase, alias);
  }
}

class QuestionData extends DataClass implements Insertable<QuestionData> {
  final int id;
  final String level;
  final String prompt;
  final String choicesJson;
  final int correctIndex;
  final int? grammarId;
  final String? explanation;
  const QuestionData({
    required this.id,
    required this.level,
    required this.prompt,
    required this.choicesJson,
    required this.correctIndex,
    this.grammarId,
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
    if (!nullToAbsent || grammarId != null) {
      map['grammar_id'] = Variable<int>(grammarId);
    }
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    return map;
  }

  QuestionCompanion toCompanion(bool nullToAbsent) {
    return QuestionCompanion(
      id: Value(id),
      level: Value(level),
      prompt: Value(prompt),
      choicesJson: Value(choicesJson),
      correctIndex: Value(correctIndex),
      grammarId: grammarId == null && nullToAbsent
          ? const Value.absent()
          : Value(grammarId),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
    );
  }

  factory QuestionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      prompt: serializer.fromJson<String>(json['prompt']),
      choicesJson: serializer.fromJson<String>(json['choicesJson']),
      correctIndex: serializer.fromJson<int>(json['correctIndex']),
      grammarId: serializer.fromJson<int?>(json['grammarId']),
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
      'grammarId': serializer.toJson<int?>(grammarId),
      'explanation': serializer.toJson<String?>(explanation),
    };
  }

  QuestionData copyWith({
    int? id,
    String? level,
    String? prompt,
    String? choicesJson,
    int? correctIndex,
    Value<int?> grammarId = const Value.absent(),
    Value<String?> explanation = const Value.absent(),
  }) => QuestionData(
    id: id ?? this.id,
    level: level ?? this.level,
    prompt: prompt ?? this.prompt,
    choicesJson: choicesJson ?? this.choicesJson,
    correctIndex: correctIndex ?? this.correctIndex,
    grammarId: grammarId.present ? grammarId.value : this.grammarId,
    explanation: explanation.present ? explanation.value : this.explanation,
  );
  QuestionData copyWithCompanion(QuestionCompanion data) {
    return QuestionData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      grammarId: data.grammarId.present ? data.grammarId.value : this.grammarId,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('prompt: $prompt, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('grammarId: $grammarId, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    prompt,
    choicesJson,
    correctIndex,
    grammarId,
    explanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionData &&
          other.id == this.id &&
          other.level == this.level &&
          other.prompt == this.prompt &&
          other.choicesJson == this.choicesJson &&
          other.correctIndex == this.correctIndex &&
          other.grammarId == this.grammarId &&
          other.explanation == this.explanation);
}

class QuestionCompanion extends UpdateCompanion<QuestionData> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> prompt;
  final Value<String> choicesJson;
  final Value<int> correctIndex;
  final Value<int?> grammarId;
  final Value<String?> explanation;
  const QuestionCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.prompt = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.grammarId = const Value.absent(),
    this.explanation = const Value.absent(),
  });
  QuestionCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String prompt,
    required String choicesJson,
    required int correctIndex,
    this.grammarId = const Value.absent(),
    this.explanation = const Value.absent(),
  }) : level = Value(level),
       prompt = Value(prompt),
       choicesJson = Value(choicesJson),
       correctIndex = Value(correctIndex);
  static Insertable<QuestionData> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? prompt,
    Expression<String>? choicesJson,
    Expression<int>? correctIndex,
    Expression<int>? grammarId,
    Expression<String>? explanation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (prompt != null) 'prompt': prompt,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (grammarId != null) 'grammar_id': grammarId,
      if (explanation != null) 'explanation': explanation,
    });
  }

  QuestionCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? prompt,
    Value<String>? choicesJson,
    Value<int>? correctIndex,
    Value<int?>? grammarId,
    Value<String?>? explanation,
  }) {
    return QuestionCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      prompt: prompt ?? this.prompt,
      choicesJson: choicesJson ?? this.choicesJson,
      correctIndex: correctIndex ?? this.correctIndex,
      grammarId: grammarId ?? this.grammarId,
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
    if (grammarId.present) {
      map['grammar_id'] = Variable<int>(grammarId.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('prompt: $prompt, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('grammarId: $grammarId, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }
}

class $MockTestTable extends MockTest
    with TableInfo<$MockTestTable, MockTestData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MockTestTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, level, title, durationSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mock_test';
  @override
  VerificationContext validateIntegrity(
    Insertable<MockTestData> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MockTestData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MockTestData(
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
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
    );
  }

  @override
  $MockTestTable createAlias(String alias) {
    return $MockTestTable(attachedDatabase, alias);
  }
}

class MockTestData extends DataClass implements Insertable<MockTestData> {
  final int id;
  final String level;
  final String title;
  final int durationSeconds;
  const MockTestData({
    required this.id,
    required this.level,
    required this.title,
    required this.durationSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<String>(level);
    map['title'] = Variable<String>(title);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    return map;
  }

  MockTestCompanion toCompanion(bool nullToAbsent) {
    return MockTestCompanion(
      id: Value(id),
      level: Value(level),
      title: Value(title),
      durationSeconds: Value(durationSeconds),
    );
  }

  factory MockTestData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MockTestData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      title: serializer.fromJson<String>(json['title']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<String>(level),
      'title': serializer.toJson<String>(title),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
    };
  }

  MockTestData copyWith({
    int? id,
    String? level,
    String? title,
    int? durationSeconds,
  }) => MockTestData(
    id: id ?? this.id,
    level: level ?? this.level,
    title: title ?? this.title,
    durationSeconds: durationSeconds ?? this.durationSeconds,
  );
  MockTestData copyWithCompanion(MockTestCompanion data) {
    return MockTestData(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      title: data.title.present ? data.title.value : this.title,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MockTestData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, title, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MockTestData &&
          other.id == this.id &&
          other.level == this.level &&
          other.title == this.title &&
          other.durationSeconds == this.durationSeconds);
}

class MockTestCompanion extends UpdateCompanion<MockTestData> {
  final Value<int> id;
  final Value<String> level;
  final Value<String> title;
  final Value<int> durationSeconds;
  const MockTestCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.title = const Value.absent(),
    this.durationSeconds = const Value.absent(),
  });
  MockTestCompanion.insert({
    this.id = const Value.absent(),
    required String level,
    required String title,
    required int durationSeconds,
  }) : level = Value(level),
       title = Value(title),
       durationSeconds = Value(durationSeconds);
  static Insertable<MockTestData> custom({
    Expression<int>? id,
    Expression<String>? level,
    Expression<String>? title,
    Expression<int>? durationSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (title != null) 'title': title,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
    });
  }

  MockTestCompanion copyWith({
    Value<int>? id,
    Value<String>? level,
    Value<String>? title,
    Value<int>? durationSeconds,
  }) {
    return MockTestCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      title: title ?? this.title,
      durationSeconds: durationSeconds ?? this.durationSeconds,
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
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MockTestCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('title: $title, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }
}

class $MockTestSectionTable extends MockTestSection
    with TableInfo<$MockTestSectionTable, MockTestSectionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MockTestSectionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<int> testId = GeneratedColumn<int>(
    'test_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, testId, title, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mock_test_section';
  @override
  VerificationContext validateIntegrity(
    Insertable<MockTestSectionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('test_id')) {
      context.handle(
        _testIdMeta,
        testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta),
      );
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MockTestSectionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MockTestSectionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      testId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}test_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $MockTestSectionTable createAlias(String alias) {
    return $MockTestSectionTable(attachedDatabase, alias);
  }
}

class MockTestSectionData extends DataClass
    implements Insertable<MockTestSectionData> {
  final int id;
  final int testId;
  final String title;
  final int orderIndex;
  const MockTestSectionData({
    required this.id,
    required this.testId,
    required this.title,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['test_id'] = Variable<int>(testId);
    map['title'] = Variable<String>(title);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  MockTestSectionCompanion toCompanion(bool nullToAbsent) {
    return MockTestSectionCompanion(
      id: Value(id),
      testId: Value(testId),
      title: Value(title),
      orderIndex: Value(orderIndex),
    );
  }

  factory MockTestSectionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MockTestSectionData(
      id: serializer.fromJson<int>(json['id']),
      testId: serializer.fromJson<int>(json['testId']),
      title: serializer.fromJson<String>(json['title']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'testId': serializer.toJson<int>(testId),
      'title': serializer.toJson<String>(title),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  MockTestSectionData copyWith({
    int? id,
    int? testId,
    String? title,
    int? orderIndex,
  }) => MockTestSectionData(
    id: id ?? this.id,
    testId: testId ?? this.testId,
    title: title ?? this.title,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  MockTestSectionData copyWithCompanion(MockTestSectionCompanion data) {
    return MockTestSectionData(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      title: data.title.present ? data.title.value : this.title,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MockTestSectionData(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, testId, title, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MockTestSectionData &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.title == this.title &&
          other.orderIndex == this.orderIndex);
}

class MockTestSectionCompanion extends UpdateCompanion<MockTestSectionData> {
  final Value<int> id;
  final Value<int> testId;
  final Value<String> title;
  final Value<int> orderIndex;
  const MockTestSectionCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.title = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  MockTestSectionCompanion.insert({
    this.id = const Value.absent(),
    required int testId,
    required String title,
    required int orderIndex,
  }) : testId = Value(testId),
       title = Value(title),
       orderIndex = Value(orderIndex);
  static Insertable<MockTestSectionData> custom({
    Expression<int>? id,
    Expression<int>? testId,
    Expression<String>? title,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (title != null) 'title': title,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  MockTestSectionCompanion copyWith({
    Value<int>? id,
    Value<int>? testId,
    Value<String>? title,
    Value<int>? orderIndex,
  }) {
    return MockTestSectionCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      title: title ?? this.title,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<int>(testId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MockTestSectionCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('title: $title, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $MockTestQuestionMapTable extends MockTestQuestionMap
    with TableInfo<$MockTestQuestionMapTable, MockTestQuestionMapData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MockTestQuestionMapTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _testIdMeta = const VerificationMeta('testId');
  @override
  late final GeneratedColumn<int> testId = GeneratedColumn<int>(
    'test_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<int> sectionId = GeneratedColumn<int>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    testId,
    sectionId,
    questionId,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mock_test_question_map';
  @override
  VerificationContext validateIntegrity(
    Insertable<MockTestQuestionMapData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('test_id')) {
      context.handle(
        _testIdMeta,
        testId.isAcceptableOrUnknown(data['test_id']!, _testIdMeta),
      );
    } else if (isInserting) {
      context.missing(_testIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MockTestQuestionMapData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MockTestQuestionMapData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      testId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}test_id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}section_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $MockTestQuestionMapTable createAlias(String alias) {
    return $MockTestQuestionMapTable(attachedDatabase, alias);
  }
}

class MockTestQuestionMapData extends DataClass
    implements Insertable<MockTestQuestionMapData> {
  final int id;
  final int testId;
  final int sectionId;
  final int questionId;
  final int orderIndex;
  const MockTestQuestionMapData({
    required this.id,
    required this.testId,
    required this.sectionId,
    required this.questionId,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['test_id'] = Variable<int>(testId);
    map['section_id'] = Variable<int>(sectionId);
    map['question_id'] = Variable<int>(questionId);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  MockTestQuestionMapCompanion toCompanion(bool nullToAbsent) {
    return MockTestQuestionMapCompanion(
      id: Value(id),
      testId: Value(testId),
      sectionId: Value(sectionId),
      questionId: Value(questionId),
      orderIndex: Value(orderIndex),
    );
  }

  factory MockTestQuestionMapData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MockTestQuestionMapData(
      id: serializer.fromJson<int>(json['id']),
      testId: serializer.fromJson<int>(json['testId']),
      sectionId: serializer.fromJson<int>(json['sectionId']),
      questionId: serializer.fromJson<int>(json['questionId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'testId': serializer.toJson<int>(testId),
      'sectionId': serializer.toJson<int>(sectionId),
      'questionId': serializer.toJson<int>(questionId),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  MockTestQuestionMapData copyWith({
    int? id,
    int? testId,
    int? sectionId,
    int? questionId,
    int? orderIndex,
  }) => MockTestQuestionMapData(
    id: id ?? this.id,
    testId: testId ?? this.testId,
    sectionId: sectionId ?? this.sectionId,
    questionId: questionId ?? this.questionId,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  MockTestQuestionMapData copyWithCompanion(MockTestQuestionMapCompanion data) {
    return MockTestQuestionMapData(
      id: data.id.present ? data.id.value : this.id,
      testId: data.testId.present ? data.testId.value : this.testId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MockTestQuestionMapData(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('sectionId: $sectionId, ')
          ..write('questionId: $questionId, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, testId, sectionId, questionId, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MockTestQuestionMapData &&
          other.id == this.id &&
          other.testId == this.testId &&
          other.sectionId == this.sectionId &&
          other.questionId == this.questionId &&
          other.orderIndex == this.orderIndex);
}

class MockTestQuestionMapCompanion
    extends UpdateCompanion<MockTestQuestionMapData> {
  final Value<int> id;
  final Value<int> testId;
  final Value<int> sectionId;
  final Value<int> questionId;
  final Value<int> orderIndex;
  const MockTestQuestionMapCompanion({
    this.id = const Value.absent(),
    this.testId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  MockTestQuestionMapCompanion.insert({
    this.id = const Value.absent(),
    required int testId,
    required int sectionId,
    required int questionId,
    required int orderIndex,
  }) : testId = Value(testId),
       sectionId = Value(sectionId),
       questionId = Value(questionId),
       orderIndex = Value(orderIndex);
  static Insertable<MockTestQuestionMapData> custom({
    Expression<int>? id,
    Expression<int>? testId,
    Expression<int>? sectionId,
    Expression<int>? questionId,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (testId != null) 'test_id': testId,
      if (sectionId != null) 'section_id': sectionId,
      if (questionId != null) 'question_id': questionId,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  MockTestQuestionMapCompanion copyWith({
    Value<int>? id,
    Value<int>? testId,
    Value<int>? sectionId,
    Value<int>? questionId,
    Value<int>? orderIndex,
  }) {
    return MockTestQuestionMapCompanion(
      id: id ?? this.id,
      testId: testId ?? this.testId,
      sectionId: sectionId ?? this.sectionId,
      questionId: questionId ?? this.questionId,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (testId.present) {
      map['test_id'] = Variable<int>(testId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<int>(sectionId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MockTestQuestionMapCompanion(')
          ..write('id: $id, ')
          ..write('testId: $testId, ')
          ..write('sectionId: $sectionId, ')
          ..write('questionId: $questionId, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

abstract class _$ContentDatabase extends GeneratedDatabase {
  _$ContentDatabase(QueryExecutor e) : super(e);
  $ContentDatabaseManager get managers => $ContentDatabaseManager(this);
  late final $VocabTable vocab = $VocabTable(this);
  late final $GrammarTable grammar = $GrammarTable(this);
  late final $QuestionTable question = $QuestionTable(this);
  late final $MockTestTable mockTest = $MockTestTable(this);
  late final $MockTestSectionTable mockTestSection = $MockTestSectionTable(
    this,
  );
  late final $MockTestQuestionMapTable mockTestQuestionMap =
      $MockTestQuestionMapTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vocab,
    grammar,
    question,
    mockTest,
    mockTestSection,
    mockTestQuestionMap,
  ];
}

typedef $$VocabTableCreateCompanionBuilder =
    VocabCompanion Function({
      Value<int> id,
      required String term,
      Value<String?> reading,
      required String meaning,
      required String level,
      Value<String?> tags,
    });
typedef $$VocabTableUpdateCompanionBuilder =
    VocabCompanion Function({
      Value<int> id,
      Value<String> term,
      Value<String?> reading,
      Value<String> meaning,
      Value<String> level,
      Value<String?> tags,
    });

class $$VocabTableFilterComposer
    extends Composer<_$ContentDatabase, $VocabTable> {
  $$VocabTableFilterComposer({
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
}

class $$VocabTableOrderingComposer
    extends Composer<_$ContentDatabase, $VocabTable> {
  $$VocabTableOrderingComposer({
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
}

class $$VocabTableAnnotationComposer
    extends Composer<_$ContentDatabase, $VocabTable> {
  $$VocabTableAnnotationComposer({
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
}

class $$VocabTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $VocabTable,
          VocabData,
          $$VocabTableFilterComposer,
          $$VocabTableOrderingComposer,
          $$VocabTableAnnotationComposer,
          $$VocabTableCreateCompanionBuilder,
          $$VocabTableUpdateCompanionBuilder,
          (
            VocabData,
            BaseReferences<_$ContentDatabase, $VocabTable, VocabData>,
          ),
          VocabData,
          PrefetchHooks Function()
        > {
  $$VocabTableTableManager(_$ContentDatabase db, $VocabTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> term = const Value.absent(),
                Value<String?> reading = const Value.absent(),
                Value<String> meaning = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String?> tags = const Value.absent(),
              }) => VocabCompanion(
                id: id,
                term: term,
                reading: reading,
                meaning: meaning,
                level: level,
                tags: tags,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String term,
                Value<String?> reading = const Value.absent(),
                required String meaning,
                required String level,
                Value<String?> tags = const Value.absent(),
              }) => VocabCompanion.insert(
                id: id,
                term: term,
                reading: reading,
                meaning: meaning,
                level: level,
                tags: tags,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VocabTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $VocabTable,
      VocabData,
      $$VocabTableFilterComposer,
      $$VocabTableOrderingComposer,
      $$VocabTableAnnotationComposer,
      $$VocabTableCreateCompanionBuilder,
      $$VocabTableUpdateCompanionBuilder,
      (VocabData, BaseReferences<_$ContentDatabase, $VocabTable, VocabData>),
      VocabData,
      PrefetchHooks Function()
    >;
typedef $$GrammarTableCreateCompanionBuilder =
    GrammarCompanion Function({
      Value<int> id,
      required String level,
      required String title,
      required String summary,
    });
typedef $$GrammarTableUpdateCompanionBuilder =
    GrammarCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> title,
      Value<String> summary,
    });

class $$GrammarTableFilterComposer
    extends Composer<_$ContentDatabase, $GrammarTable> {
  $$GrammarTableFilterComposer({
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

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GrammarTableOrderingComposer
    extends Composer<_$ContentDatabase, $GrammarTable> {
  $$GrammarTableOrderingComposer({
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

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarTableAnnotationComposer
    extends Composer<_$ContentDatabase, $GrammarTable> {
  $$GrammarTableAnnotationComposer({
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

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);
}

class $$GrammarTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $GrammarTable,
          GrammarData,
          $$GrammarTableFilterComposer,
          $$GrammarTableOrderingComposer,
          $$GrammarTableAnnotationComposer,
          $$GrammarTableCreateCompanionBuilder,
          $$GrammarTableUpdateCompanionBuilder,
          (
            GrammarData,
            BaseReferences<_$ContentDatabase, $GrammarTable, GrammarData>,
          ),
          GrammarData,
          PrefetchHooks Function()
        > {
  $$GrammarTableTableManager(_$ContentDatabase db, $GrammarTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> summary = const Value.absent(),
              }) => GrammarCompanion(
                id: id,
                level: level,
                title: title,
                summary: summary,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                required String title,
                required String summary,
              }) => GrammarCompanion.insert(
                id: id,
                level: level,
                title: title,
                summary: summary,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GrammarTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $GrammarTable,
      GrammarData,
      $$GrammarTableFilterComposer,
      $$GrammarTableOrderingComposer,
      $$GrammarTableAnnotationComposer,
      $$GrammarTableCreateCompanionBuilder,
      $$GrammarTableUpdateCompanionBuilder,
      (
        GrammarData,
        BaseReferences<_$ContentDatabase, $GrammarTable, GrammarData>,
      ),
      GrammarData,
      PrefetchHooks Function()
    >;
typedef $$QuestionTableCreateCompanionBuilder =
    QuestionCompanion Function({
      Value<int> id,
      required String level,
      required String prompt,
      required String choicesJson,
      required int correctIndex,
      Value<int?> grammarId,
      Value<String?> explanation,
    });
typedef $$QuestionTableUpdateCompanionBuilder =
    QuestionCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> prompt,
      Value<String> choicesJson,
      Value<int> correctIndex,
      Value<int?> grammarId,
      Value<String?> explanation,
    });

class $$QuestionTableFilterComposer
    extends Composer<_$ContentDatabase, $QuestionTable> {
  $$QuestionTableFilterComposer({
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

  ColumnFilters<int> get grammarId => $composableBuilder(
    column: $table.grammarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionTableOrderingComposer
    extends Composer<_$ContentDatabase, $QuestionTable> {
  $$QuestionTableOrderingComposer({
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

  ColumnOrderings<int> get grammarId => $composableBuilder(
    column: $table.grammarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionTableAnnotationComposer
    extends Composer<_$ContentDatabase, $QuestionTable> {
  $$QuestionTableAnnotationComposer({
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

  GeneratedColumn<int> get grammarId =>
      $composableBuilder(column: $table.grammarId, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );
}

class $$QuestionTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $QuestionTable,
          QuestionData,
          $$QuestionTableFilterComposer,
          $$QuestionTableOrderingComposer,
          $$QuestionTableAnnotationComposer,
          $$QuestionTableCreateCompanionBuilder,
          $$QuestionTableUpdateCompanionBuilder,
          (
            QuestionData,
            BaseReferences<_$ContentDatabase, $QuestionTable, QuestionData>,
          ),
          QuestionData,
          PrefetchHooks Function()
        > {
  $$QuestionTableTableManager(_$ContentDatabase db, $QuestionTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> choicesJson = const Value.absent(),
                Value<int> correctIndex = const Value.absent(),
                Value<int?> grammarId = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
              }) => QuestionCompanion(
                id: id,
                level: level,
                prompt: prompt,
                choicesJson: choicesJson,
                correctIndex: correctIndex,
                grammarId: grammarId,
                explanation: explanation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                required String prompt,
                required String choicesJson,
                required int correctIndex,
                Value<int?> grammarId = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
              }) => QuestionCompanion.insert(
                id: id,
                level: level,
                prompt: prompt,
                choicesJson: choicesJson,
                correctIndex: correctIndex,
                grammarId: grammarId,
                explanation: explanation,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $QuestionTable,
      QuestionData,
      $$QuestionTableFilterComposer,
      $$QuestionTableOrderingComposer,
      $$QuestionTableAnnotationComposer,
      $$QuestionTableCreateCompanionBuilder,
      $$QuestionTableUpdateCompanionBuilder,
      (
        QuestionData,
        BaseReferences<_$ContentDatabase, $QuestionTable, QuestionData>,
      ),
      QuestionData,
      PrefetchHooks Function()
    >;
typedef $$MockTestTableCreateCompanionBuilder =
    MockTestCompanion Function({
      Value<int> id,
      required String level,
      required String title,
      required int durationSeconds,
    });
typedef $$MockTestTableUpdateCompanionBuilder =
    MockTestCompanion Function({
      Value<int> id,
      Value<String> level,
      Value<String> title,
      Value<int> durationSeconds,
    });

class $$MockTestTableFilterComposer
    extends Composer<_$ContentDatabase, $MockTestTable> {
  $$MockTestTableFilterComposer({
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

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MockTestTableOrderingComposer
    extends Composer<_$ContentDatabase, $MockTestTable> {
  $$MockTestTableOrderingComposer({
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

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MockTestTableAnnotationComposer
    extends Composer<_$ContentDatabase, $MockTestTable> {
  $$MockTestTableAnnotationComposer({
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

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );
}

class $$MockTestTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $MockTestTable,
          MockTestData,
          $$MockTestTableFilterComposer,
          $$MockTestTableOrderingComposer,
          $$MockTestTableAnnotationComposer,
          $$MockTestTableCreateCompanionBuilder,
          $$MockTestTableUpdateCompanionBuilder,
          (
            MockTestData,
            BaseReferences<_$ContentDatabase, $MockTestTable, MockTestData>,
          ),
          MockTestData,
          PrefetchHooks Function()
        > {
  $$MockTestTableTableManager(_$ContentDatabase db, $MockTestTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MockTestTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MockTestTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MockTestTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
              }) => MockTestCompanion(
                id: id,
                level: level,
                title: title,
                durationSeconds: durationSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String level,
                required String title,
                required int durationSeconds,
              }) => MockTestCompanion.insert(
                id: id,
                level: level,
                title: title,
                durationSeconds: durationSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MockTestTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $MockTestTable,
      MockTestData,
      $$MockTestTableFilterComposer,
      $$MockTestTableOrderingComposer,
      $$MockTestTableAnnotationComposer,
      $$MockTestTableCreateCompanionBuilder,
      $$MockTestTableUpdateCompanionBuilder,
      (
        MockTestData,
        BaseReferences<_$ContentDatabase, $MockTestTable, MockTestData>,
      ),
      MockTestData,
      PrefetchHooks Function()
    >;
typedef $$MockTestSectionTableCreateCompanionBuilder =
    MockTestSectionCompanion Function({
      Value<int> id,
      required int testId,
      required String title,
      required int orderIndex,
    });
typedef $$MockTestSectionTableUpdateCompanionBuilder =
    MockTestSectionCompanion Function({
      Value<int> id,
      Value<int> testId,
      Value<String> title,
      Value<int> orderIndex,
    });

class $$MockTestSectionTableFilterComposer
    extends Composer<_$ContentDatabase, $MockTestSectionTable> {
  $$MockTestSectionTableFilterComposer({
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

  ColumnFilters<int> get testId => $composableBuilder(
    column: $table.testId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MockTestSectionTableOrderingComposer
    extends Composer<_$ContentDatabase, $MockTestSectionTable> {
  $$MockTestSectionTableOrderingComposer({
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

  ColumnOrderings<int> get testId => $composableBuilder(
    column: $table.testId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MockTestSectionTableAnnotationComposer
    extends Composer<_$ContentDatabase, $MockTestSectionTable> {
  $$MockTestSectionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get testId =>
      $composableBuilder(column: $table.testId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$MockTestSectionTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $MockTestSectionTable,
          MockTestSectionData,
          $$MockTestSectionTableFilterComposer,
          $$MockTestSectionTableOrderingComposer,
          $$MockTestSectionTableAnnotationComposer,
          $$MockTestSectionTableCreateCompanionBuilder,
          $$MockTestSectionTableUpdateCompanionBuilder,
          (
            MockTestSectionData,
            BaseReferences<
              _$ContentDatabase,
              $MockTestSectionTable,
              MockTestSectionData
            >,
          ),
          MockTestSectionData,
          PrefetchHooks Function()
        > {
  $$MockTestSectionTableTableManager(
    _$ContentDatabase db,
    $MockTestSectionTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MockTestSectionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MockTestSectionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MockTestSectionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> testId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => MockTestSectionCompanion(
                id: id,
                testId: testId,
                title: title,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int testId,
                required String title,
                required int orderIndex,
              }) => MockTestSectionCompanion.insert(
                id: id,
                testId: testId,
                title: title,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MockTestSectionTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $MockTestSectionTable,
      MockTestSectionData,
      $$MockTestSectionTableFilterComposer,
      $$MockTestSectionTableOrderingComposer,
      $$MockTestSectionTableAnnotationComposer,
      $$MockTestSectionTableCreateCompanionBuilder,
      $$MockTestSectionTableUpdateCompanionBuilder,
      (
        MockTestSectionData,
        BaseReferences<
          _$ContentDatabase,
          $MockTestSectionTable,
          MockTestSectionData
        >,
      ),
      MockTestSectionData,
      PrefetchHooks Function()
    >;
typedef $$MockTestQuestionMapTableCreateCompanionBuilder =
    MockTestQuestionMapCompanion Function({
      Value<int> id,
      required int testId,
      required int sectionId,
      required int questionId,
      required int orderIndex,
    });
typedef $$MockTestQuestionMapTableUpdateCompanionBuilder =
    MockTestQuestionMapCompanion Function({
      Value<int> id,
      Value<int> testId,
      Value<int> sectionId,
      Value<int> questionId,
      Value<int> orderIndex,
    });

class $$MockTestQuestionMapTableFilterComposer
    extends Composer<_$ContentDatabase, $MockTestQuestionMapTable> {
  $$MockTestQuestionMapTableFilterComposer({
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

  ColumnFilters<int> get testId => $composableBuilder(
    column: $table.testId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MockTestQuestionMapTableOrderingComposer
    extends Composer<_$ContentDatabase, $MockTestQuestionMapTable> {
  $$MockTestQuestionMapTableOrderingComposer({
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

  ColumnOrderings<int> get testId => $composableBuilder(
    column: $table.testId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MockTestQuestionMapTableAnnotationComposer
    extends Composer<_$ContentDatabase, $MockTestQuestionMapTable> {
  $$MockTestQuestionMapTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get testId =>
      $composableBuilder(column: $table.testId, builder: (column) => column);

  GeneratedColumn<int> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<int> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$MockTestQuestionMapTableTableManager
    extends
        RootTableManager<
          _$ContentDatabase,
          $MockTestQuestionMapTable,
          MockTestQuestionMapData,
          $$MockTestQuestionMapTableFilterComposer,
          $$MockTestQuestionMapTableOrderingComposer,
          $$MockTestQuestionMapTableAnnotationComposer,
          $$MockTestQuestionMapTableCreateCompanionBuilder,
          $$MockTestQuestionMapTableUpdateCompanionBuilder,
          (
            MockTestQuestionMapData,
            BaseReferences<
              _$ContentDatabase,
              $MockTestQuestionMapTable,
              MockTestQuestionMapData
            >,
          ),
          MockTestQuestionMapData,
          PrefetchHooks Function()
        > {
  $$MockTestQuestionMapTableTableManager(
    _$ContentDatabase db,
    $MockTestQuestionMapTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MockTestQuestionMapTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MockTestQuestionMapTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MockTestQuestionMapTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> testId = const Value.absent(),
                Value<int> sectionId = const Value.absent(),
                Value<int> questionId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => MockTestQuestionMapCompanion(
                id: id,
                testId: testId,
                sectionId: sectionId,
                questionId: questionId,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int testId,
                required int sectionId,
                required int questionId,
                required int orderIndex,
              }) => MockTestQuestionMapCompanion.insert(
                id: id,
                testId: testId,
                sectionId: sectionId,
                questionId: questionId,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MockTestQuestionMapTableProcessedTableManager =
    ProcessedTableManager<
      _$ContentDatabase,
      $MockTestQuestionMapTable,
      MockTestQuestionMapData,
      $$MockTestQuestionMapTableFilterComposer,
      $$MockTestQuestionMapTableOrderingComposer,
      $$MockTestQuestionMapTableAnnotationComposer,
      $$MockTestQuestionMapTableCreateCompanionBuilder,
      $$MockTestQuestionMapTableUpdateCompanionBuilder,
      (
        MockTestQuestionMapData,
        BaseReferences<
          _$ContentDatabase,
          $MockTestQuestionMapTable,
          MockTestQuestionMapData
        >,
      ),
      MockTestQuestionMapData,
      PrefetchHooks Function()
    >;

class $ContentDatabaseManager {
  final _$ContentDatabase _db;
  $ContentDatabaseManager(this._db);
  $$VocabTableTableManager get vocab =>
      $$VocabTableTableManager(_db, _db.vocab);
  $$GrammarTableTableManager get grammar =>
      $$GrammarTableTableManager(_db, _db.grammar);
  $$QuestionTableTableManager get question =>
      $$QuestionTableTableManager(_db, _db.question);
  $$MockTestTableTableManager get mockTest =>
      $$MockTestTableTableManager(_db, _db.mockTest);
  $$MockTestSectionTableTableManager get mockTestSection =>
      $$MockTestSectionTableTableManager(_db, _db.mockTestSection);
  $$MockTestQuestionMapTableTableManager get mockTestQuestionMap =>
      $$MockTestQuestionMapTableTableManager(_db, _db.mockTestQuestionMap);
}
