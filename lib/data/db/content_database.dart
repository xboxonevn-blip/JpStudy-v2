import 'dart:convert';
import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'content_tables.dart';
import '../utils/grammar_example_matching.dart';
import '../utils/grammar_english_notation.dart';
import '../utils/han_viet_lookup.dart';

part 'content_database.g.dart';

const _kanjiSeedRevision = 90;
const _kanjiSeedRevisionKey = 'kanjiSeedRevision';
const _vocabSeedRevision = 18;
const _vocabSeedRevisionKeyPrefix = 'vocabSeedRevision';
const _vocabExampleTemplateFragments = [
  'を使う文を',
  '文を一つ作り',
  'を使った文',
  'Trong giờ học, tôi dùng',
  'với nghĩa',
  'trong một câu ngắn',
];
const _grammarSeedRevision = 29;
const _grammarSeedRevisionKey = 'grammarSeedRevision';
const _conjugationLemmaAssetPath =
    'assets/data/content/conjugation/lemmas.json';
const _kanjiSeedSentinels = <_KanjiSeedSentinel>[
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 1,
    character: '遭',
    meaning: 'Tao (gặp phải; gặp chuyện không may)',
    decompositionContains: '"hanViet":"Tao"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 2,
    character: '挙',
    meaning: 'Cử (giơ lên; nêu ra; tổ chức; hành động)',
    decompositionContains: '"hanViet":"Cử"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 3,
    character: '圧',
    meaning: 'Áp (áp lực; nén; ép)',
    decompositionContains: '"hanViet":"Áp"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 4,
    character: '甘',
    meaning: 'Cam (ngọt; dễ dãi; nuông chiều)',
    decompositionContains: '"hanViet":"Cam"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 5,
    character: '争',
    meaning: 'Tranh (tranh chấp; cạnh tranh; cãi nhau)',
    decompositionContains: '"hanViet":"Tranh"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 6,
    character: '案',
    meaning: 'Án (ý tưởng; phương án; vụ việc)',
    decompositionContains: '"hanViet":"Án"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 7,
    character: '育',
    meaning: 'Dục (nuôi dạy; phát triển; giáo dục)',
    decompositionContains: '"hanViet":"Dục"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 8,
    character: '勇',
    meaning: 'Dũng (dũng cảm; can đảm; khí phách)',
    decompositionContains: '"hanViet":"Dũng"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 9,
    character: '段',
    meaning: 'Đoạn (bậc; đoạn; cấp độ)',
    decompositionContains: '"hanViet":"Đoạn"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 10,
    character: '定',
    meaning: 'Định (quyết định; cố định; ổn định)',
    decompositionContains: '"hanViet":"Định"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 11,
    character: '妹',
    meaning: 'Muội (em gái; người em nữ)',
    decompositionContains: '"hanViet":"Muội"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 12,
    character: '力',
    meaning: 'Lực (sức mạnh; lực; năng lực)',
    decompositionContains: '"hanViet":"Lực"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 13,
    character: '持',
    meaning: 'Trì (cầm; giữ; mang; duy trì)',
    decompositionContains: '"hanViet":"Trì"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 14,
    character: '写',
    meaning: 'Tả (chụp lại; sao chép; phản chiếu)',
    decompositionContains: '"hanViet":"Tả"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 15,
    character: '恨',
    meaning: 'Hận (oán hận; thù hằn; nỗi hận)',
    decompositionContains: '"hanViet":"Hận"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 16,
    character: '英',
    meaning: 'Anh (Anh; nước Anh; tiếng Anh; ưu tú)',
    decompositionContains: '"hanViet":"Anh"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 17,
    character: '宴',
    meaning: 'Yến (yến; tiệc; yến tiệc; tiệc rượu)',
    decompositionContains: '"hanViet":"Yến"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 18,
    character: '遠',
    meaning: 'Viễn (viễn; xa; xa xôi; cách xa)',
    decompositionContains: '"hanViet":"Viễn"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 19,
    character: '援',
    meaning: 'Viện (viện; hỗ trợ; viện trợ; cứu giúp)',
    decompositionContains: '"hanViet":"Viện"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 20,
    character: '米',
    meaning: 'Mễ (mễ; gạo; lúa gạo; Hoa Kỳ)',
    decompositionContains: '"hanViet":"Mễ"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 21,
    character: '補',
    meaning: 'Bổ (bổ sung; bù đắp; hỗ trợ)',
    decompositionContains: '"hanViet":"Bổ"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 22,
    character: '惜',
    meaning: 'Tiếc (đáng tiếc; trân trọng; không nỡ)',
    decompositionContains: '"hanViet":"Tiếc"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 23,
    character: '教',
    meaning: 'Giáo (dạy; giáo dục; giáo lý)',
    decompositionContains: '"hanViet":"Giáo"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 24,
    character: '母',
    meaning: 'Mẫu (mẹ; mẫu thân; bậc nữ lớn tuổi)',
    decompositionContains: '"hanViet":"Mẫu"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 25,
    character: '恩',
    meaning: 'Ân (ơn nghĩa; lòng tốt; ân huệ)',
    decompositionContains: '"hanViet":"Ân"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 1,
    character: '嗚',
    meaning: 'Ô (than khóc; tiếng kêu than; chao ôi)',
    decompositionContains: '"hanViet":"Ô"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 2,
    character: '柄',
    meaning: 'Bính (hoa văn; tính chất; tay cầm)',
    decompositionContains: '"hanViet":"Bính"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 3,
    character: '亜',
    meaning: 'Á (châu Á; thứ hai; phụ/á)',
    decompositionContains: '"hanViet":"Á"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 4,
    character: '上',
    meaning: 'Thượng (trên; lên; tăng)',
    decompositionContains: '"hanViet":"Thượng"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 5,
    character: '日',
    meaning: 'Nhật (ngày; mặt trời; Nhật Bản)',
    decompositionContains: '"hanViet":"Nhật"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 6,
    character: '浅',
    meaning: 'Thiển (nông; cạn; hời hợt)',
    decompositionContains: '"hanViet":"Thiển"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 7,
    character: '処',
    meaning: 'Xử (xử lý; giải quyết; nơi chốn)',
    decompositionContains: '"hanViet":"Xử"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 8,
    character: '化',
    meaning: 'Hóa (biến đổi; biến hóa; -hóa)',
    decompositionContains: '"hanViet":"Hóa"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 9,
    character: '力',
    meaning: 'Lực (sức mạnh; lực; năng lực)',
    decompositionContains: '"hanViet":"Lực"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 10,
    character: '油',
    meaning: 'Du (dầu; chất béo; sơn dầu)',
    decompositionContains: '"hanViet":"Du"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 11,
    character: '予',
    meaning: 'Dự (trước; dự tính; chuẩn bị)',
    decompositionContains: '"hanViet":"Dự"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 12,
    character: '粗',
    meaning: 'Thô (thô; sơ sài; thô ráp)',
    decompositionContains: '"hanViet":"Thô"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 13,
    character: '示',
    meaning: 'Thị (chỉ ra; biểu thị; cho thấy)',
    decompositionContains: '"hanViet":"Thị"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 14,
    character: '伊',
    meaning: 'Y (Ý; người ấy; dùng trong tên riêng)',
    decompositionContains: '"hanViet":"Y"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 15,
    character: '否',
    meaning: 'Phủ (không; phủ định; từ chối)',
    decompositionContains: '"hanViet":"Phủ"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 16,
    character: '歪',
    meaning: 'Oai (méo; lệch; vặn vẹo)',
    decompositionContains: '"hanViet":"Oai"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 17,
    character: '緯',
    meaning: 'Vĩ (vĩ tuyến; sợi ngang; chiều ngang)',
    decompositionContains: '"hanViet":"Vĩ"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 18,
    character: '議',
    meaning: 'Nghị (bàn luận; nghị sự; ý kiến)',
    decompositionContains: '"hanViet":"Nghị"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 19,
    character: '移',
    meaning: 'Di (di chuyển; chuyển đổi; dời đi)',
    decompositionContains: '"hanViet":"Di"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 20,
    character: '託',
    meaning: 'Thác (ủy thác; nhờ cậy; giao phó)',
    decompositionContains: '"hanViet":"Thác"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 21,
    character: '位',
    meaning: 'Vị (vị trí; cấp bậc; địa vị)',
    decompositionContains: '"hanViet":"Vị"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 22,
    character: '別',
    meaning: 'Biệt (riêng; khác; chia lìa)',
    decompositionContains: '"hanViet":"Biệt"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 17,
    character: '技',
    meaning: 'Kỹ (kỹ năng; kỹ thuật; tài nghệ)',
    decompositionContains: '"hanViet":"Kỹ"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 18,
    character: '裁',
    meaning: 'Tài (xét xử; phán quyết; cắt may)',
    decompositionContains: '"hanViet":"Tài"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 19,
    character: '材',
    meaning: 'Tài (nguyên liệu; vật liệu; gỗ)',
    decompositionContains: '"hanViet":"Tài"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 20,
    character: '感',
    meaning: 'Cảm (cảm xúc; cảm giác; cảm nhận)',
    decompositionContains: '"hanViet":"Cảm"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 21,
    character: '財',
    meaning: 'Tài (tài sản; của cải; tiền bạc)',
    decompositionContains: '"hanViet":"Tài"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 22,
    character: '説',
    meaning: 'Thuyết (giải thích; học thuyết; ý kiến)',
    decompositionContains: '"hanViet":"Thuyết"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 23,
    character: '歴',
    meaning: 'Lịch (lịch sử; trải qua; quá trình)',
    decompositionContains: '"hanViet":"Lịch"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 24,
    character: '流',
    meaning: 'Lưu (dòng chảy; lưu hành; trôi)',
    decompositionContains: '"hanViet":"Lưu"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 25,
    character: '際',
    meaning: 'Tế (dịp; ranh giới; khi)',
    decompositionContains: '"hanViet":"Tế"',
  ),
];

const _qaA026KanjiSeedSentinels = <_KanjiSeedSentinel>[
  _KanjiSeedSentinel(
    level: 'N5',
    lessonId: 21,
    character: '海',
    meaning: 'Hải (biển)',
    decompositionContains: '"hanViet":"Hải"',
  ),
  _KanjiSeedSentinel(
    level: 'N5',
    lessonId: 22,
    character: '帰',
    meaning: 'Quy (trở về)',
    decompositionContains: '"hanViet":"Quy"',
  ),
  _KanjiSeedSentinel(
    level: 'N4',
    lessonId: 25,
    character: '親',
    meaning: 'Thân (cha mẹ; người thân; thân thiết)',
    decompositionContains: '"hanViet":"Thân"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 23,
    character: '銀',
    meaning: 'Ngân (bạc)',
    decompositionContains: '"hanViet":"Ngân"',
  ),
  _KanjiSeedSentinel(
    level: 'N3',
    lessonId: 12,
    character: '重',
    meaning: 'Trọng (nặng; quan trọng)',
    decompositionContains: '"hanViet":"Trọng"',
  ),
  _KanjiSeedSentinel(
    level: 'N2',
    lessonId: 25,
    character: '議',
    meaning: 'Nghị (bàn bạc; nghị luận)',
    decompositionContains: '"hanViet":"Nghị"',
  ),
  _KanjiSeedSentinel(
    level: 'N1',
    lessonId: 1,
    character: '仁',
    meaning: 'Nhân (Nhân nghĩa)',
    decompositionContains: '"hanViet":"Nhân"',
  ),
];

@DriftDatabase(
  tables: [
    Vocab,
    GrammarPoint,
    GrammarExample,
    Question,
    MockTest,
    MockTestSection,
    MockTestQuestionMap,
    UserProgress,
    ConjugationLemma,
    Kanji,
  ],
)
class ContentDatabase extends _$ContentDatabase {
  ContentDatabase({QueryExecutor? executor})
    : super(executor ?? _openContentConnection());

  Future<bool>? _kanjiContentCurrentFuture;

  @override
  int get schemaVersion => 37;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedMinnaVocabularyForActiveLevel();
        await _seedHajimeteVocabularyForActiveLevel();
        await _seedMimikaraVocabularyForActiveLevel();
        await _seedConjugationLemmasForActiveLevel();
        await _seedMinnaGrammarForActiveLevel();
        await _markContentRevision(
          _grammarSeedRevisionKey,
          _grammarSeedRevision,
        );
        await _seedMinnaKanji();
        await _createContentIndexes();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(userProgress);
        }
        if (from < 3) {
          await _addColumn(m, vocab, vocab.kanjiMeaning);
        }
        if (from < 6) {
          await _addColumn(m, vocab, vocab.meaningEn);
        }
        if (from < 7) {
          await m.createTable(grammarPoint);
          await m.createTable(grammarExample);
          await _seedMinnaGrammar();
        }
        if (from < 9) {
          await m.createTable(kanji);
          await _seedMinnaKanji();
        }
        if (from < 10) {
          await _reseedMinnaKanji();
        }
        if (from < 11) {
          await _seedMinnaGrammar();
          await _reseedMinnaVocabulary();
        }
        if (from < 14) {
          await _seedMinnaGrammar();
        }
        if (from >= 11 && from < 15) {
          await _reseedMinnaVocabulary();
        }
        if (from < 15) {
          await _seedMinnaGrammar();
        }
        // Force re-seed for grammar examples expansion (v16)
        if (from < 16) {
          await _seedMinnaGrammar();
        }
        if (from < 17) {
          await _addColumn(m, kanji, kanji.mnemonicVi);
          await _addColumn(m, kanji, kanji.mnemonicEn);
          await _reseedMinnaKanji();
        }
        if (from < 18) {
          // Backfill users who seeded during path-transition versions.
          await _reseedMinnaVocabulary();
        }
        if (from < 19) {
          await _addColumn(m, vocab, vocab.sourceVocabId);
          await _addColumn(m, vocab, vocab.sourceSenseId);
          // Populate new source IDs for existing installs.
          await _reseedMinnaVocabulary();
        }
        if (from < 20) {
          await _addColumn(m, kanji, kanji.decompositionJson);
          await _backfillKanjiDecompositionFromCanonical();
        }
        if (from < 21) {
          await _seedMinnaGrammar();
        }
        if (from < 22) {
          await _seedMinnaGrammar();
        }
        if (from < 23) {
          await _seedMinnaGrammar();
        }
        if (from < 24) {
          await _seedMinnaGrammar();
        }
        if (from < 25) {
          await _seedMinnaGrammar();
        }
        if (from < 26) {
          await _addColumn(m, vocab, vocab.series);
          await customStatement(
            "UPDATE vocab SET series = 'minna' WHERE series IS NULL OR series = ''",
          );
          await _reseedHajimeteVocab();
        }
        if (from < 27) {
          await _reseedMinnaVocabulary();
        }
        if (from < 28) {
          await _createContentIndexes();
        }
        if (from < 29) {
          await _reseedMinnaVocabulary();
        }
        if (from < 30) {
          await _seedMinnaGrammar();
        }
        if (from < 31) {
          // kanji reseed consolidated into v32
        }
        if (from < 35) {
          await _selfHealKanjiMeaningJaColumn();
        }
        if (from < 32) {
          await _reseedMinnaKanji();
        }
        if (from < 33) {
          await _reseedMinnaKanji();
        }
        if (from < 34) {
          await _reseedMinnaKanji();
        }
        if (from < 35) {
          await _reseedMinnaKanji();
        }
        if (from < 36) {
          await m.createTable(conjugationLemma);
          await _createContentIndexes();
          await _seedConjugationLemmasForActiveLevel();
        }
        if (from < 37) {
          await _addColumn(m, vocab, vocab.exampleSentencesJson);
          await _reseedVocabularyForLevel(await _activeStudyLevelLabel());
        }
      },
      beforeOpen: (details) async {
        await _ensureKanjiContentCurrent();
        await _ensureGrammarSeedRevision();
        await _ensureVocabSeedRevisionForActiveLevel();
        // All four checks are independent — run them concurrently so the
        // content DB is ready in the time of the single slowest check.
        await Future.wait([
          _ensureMinnaVocabularySeededForActiveLevel(),
          _ensureHajimeteVocabularySeededForActiveLevel(),
          _ensureMimikaraVocabularySeededForActiveLevel(),
          _ensureMinnaGrammarSeededForActiveLevel(),
        ]);
        await _ensureConjugationLemmasSeededForActiveLevel();
      },
    );
  }

  Future<bool> ensureKanjiContentCurrent() {
    final pending = _kanjiContentCurrentFuture;
    if (pending != null) return pending;
    final future = _ensureKanjiContentCurrent();
    _kanjiContentCurrentFuture = future;
    return future.whenComplete(() => _kanjiContentCurrentFuture = null);
  }

  Future<bool> ensureVocabContentCurrentForActiveLevel() {
    return _ensureVocabSeedRevisionForActiveLevel();
  }

  Future<bool> ensureVocabContentCurrentForLevel(String level) {
    return _ensureVocabSeedRevisionForLevel(level);
  }

  Future<bool> _ensureKanjiContentCurrent() async {
    var repaired = false;
    repaired = await _selfHealKanjiMeaningJaColumn() || repaired;
    repaired = await _ensureKanjiSeedRevision() || repaired;
    repaired = await _ensureMinnaKanjiSeeded() || repaired;
    return repaired;
  }

  Future<bool> _selfHealKanjiMeaningJaColumn() async {
    final columns = await customSelect("PRAGMA table_info('kanji')").get();
    if (columns.isEmpty) {
      return false;
    }
    final columnNames = columns
        .map((row) => row.data['name'])
        .whereType<String>()
        .toSet();
    if (columnNames.contains('meaning_ja')) {
      return false;
    }
    await customStatement('ALTER TABLE kanji ADD COLUMN meaning_ja TEXT NULL');
    return true;
  }

  Future<bool> _ensureKanjiSeedRevision() async {
    await _ensureContentMetaTable();
    final revisionRows = await customSelect(
      "SELECT value FROM content_meta WHERE key = '$_kanjiSeedRevisionKey' "
      'LIMIT 1',
    ).get();
    final storedRevision = revisionRows.isEmpty
        ? null
        : int.tryParse('${revisionRows.single.data['value']}');
    final sentinelsHealthy = await _kanjiSeedSentinelsHealthy();
    if (storedRevision != null &&
        storedRevision >= _kanjiSeedRevision &&
        sentinelsHealthy) {
      return false;
    }

    var repaired = false;
    if (storedRevision != null || !sentinelsHealthy) {
      await _reseedMinnaKanji();
      repaired = true;
    }
    await customStatement(
      "INSERT OR REPLACE INTO content_meta (key, value) VALUES "
      "('$_kanjiSeedRevisionKey', '$_kanjiSeedRevision')",
    );
    return repaired;
  }

  Future<void> _ensureContentMetaTable() {
    return customStatement(
      'CREATE TABLE IF NOT EXISTS content_meta ('
      'key TEXT NOT NULL PRIMARY KEY, '
      'value TEXT NOT NULL'
      ')',
    );
  }

  Future<void> _markContentRevision(String key, int revision) async {
    await _ensureContentMetaTable();
    await customStatement(
      "INSERT OR REPLACE INTO content_meta (key, value) VALUES "
      "('$key', '$revision')",
    );
  }

  Future<bool> _ensureGrammarSeedRevision() async {
    await _ensureContentMetaTable();
    final revisionRows = await customSelect(
      "SELECT value FROM content_meta WHERE key = '$_grammarSeedRevisionKey' "
      'LIMIT 1',
    ).get();
    final storedRevision = revisionRows.isEmpty
        ? null
        : int.tryParse('${revisionRows.single.data['value']}');
    if (storedRevision != null && storedRevision >= _grammarSeedRevision) {
      return false;
    }

    await _seedMinnaGrammar();
    await _markContentRevision(_grammarSeedRevisionKey, _grammarSeedRevision);
    return true;
  }

  Future<bool> _ensureVocabSeedRevisionForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    return _ensureVocabSeedRevisionForLevel(activeLevel);
  }

  Future<bool> _ensureVocabSeedRevisionForLevel(String level) async {
    final normalizedLevel = level.trim().toUpperCase();
    if (_contentSeedSpecForLevel(normalizedLevel) == null) return false;
    await _ensureContentMetaTable();
    final key = '$_vocabSeedRevisionKeyPrefix:$normalizedLevel';
    final revisionRows = await customSelect(
      "SELECT value FROM content_meta WHERE key = '$key' LIMIT 1",
    ).get();
    final storedRevision = revisionRows.isEmpty
        ? null
        : int.tryParse('${revisionRows.single.data['value']}');
    final examplesHealthy = await _vocabExampleSeedHealthy(normalizedLevel);
    if (storedRevision != null &&
        storedRevision >= _vocabSeedRevision &&
        examplesHealthy) {
      return false;
    }

    await _reseedVocabularyForLevel(normalizedLevel);
    await _markContentRevision(key, _vocabSeedRevision);
    return true;
  }

  Future<bool> _vocabExampleSeedHealthy(String normalizedLevel) async {
    final clauses = _vocabExampleTemplateFragments
        .map((_) => 'example_sentences_json LIKE ?')
        .join(' OR ');
    final rows = await customSelect(
      'SELECT COUNT(*) AS count FROM vocab '
      'WHERE level = ? AND ($clauses)',
      variables: [
        Variable<String>(normalizedLevel),
        for (final fragment in _vocabExampleTemplateFragments)
          Variable<String>('%$fragment%'),
      ],
    ).getSingle();
    final bannedCount = (rows.data['count'] as int?) ?? 0;
    if (bannedCount > 0) return false;

    if (normalizedLevel == 'N5') {
      final sentinelRows = await customSelect(
        'SELECT example_sentences_json FROM vocab '
        "WHERE level = 'N5' AND series = 'minna' AND term = '私' "
        'LIMIT 1',
      ).get();
      if (sentinelRows.isEmpty) return false;
      final examples = '${sentinelRows.single.data['example_sentences_json']}';
      return examples.contains('私の番？') &&
          examples.contains('tatoeba-cc-by-2.0');
    }
    return true;
  }

  // ... (reseed methods)

  Future<void> _reseedMinnaVocabulary() async {
    await (delete(vocab)..where(
          (tbl) => tbl.series.equals('minna') | tbl.series.equals('ShinKanzen'),
        ))
        .go();

    await _seedMinnaVocabulary();
  }

  Future<void> _ensureMinnaVocabularySeeded([
    Iterable<_ContentSeedSpec> specs = _contentSeedSpecs,
  ]) async {
    // One GROUP BY query replaces N sequential COUNT queries (one per level).
    final levelCol = vocab.level;
    final seriesCol = vocab.series;
    final countExpr = vocab.id.count();
    final rows =
        await (selectOnly(vocab)
              ..addColumns([levelCol, seriesCol, countExpr])
              ..where(
                specs
                    .map((s) {
                      return vocab.level.equals(s.levelLabel) &
                          vocab.series.equals(s.series);
                    })
                    .reduce((a, b) => a | b),
              )
              ..groupBy([levelCol, seriesCol]))
            .get();
    final counts = {
      for (final row in rows)
        '${row.read(levelCol)}:${row.read(seriesCol)}':
            row.read(countExpr) ?? 0,
    };
    final missingSpecs = specs
        .where((s) => (counts['${s.levelLabel}:${s.series}'] ?? 0) == 0)
        .toList();
    if (missingSpecs.isNotEmpty) {
      await Future.wait(missingSpecs.map(_seedVocabularyLevel));
    }

    // Self-heal old seeded DBs that still contain placeholder/garbled rows.
    final corruptedCountExpr = vocab.id.count();
    final corruptedQuery = selectOnly(vocab)
      ..addColumns([corruptedCountExpr])
      ..where(vocab.tags.like('%minna_%') | vocab.tags.like('%shinkanzen_%'))
      ..where(
        vocab.term.like('%?%') |
            vocab.reading.like('%?%') |
            vocab.term.like('%ã%') |
            vocab.reading.like('%ã%') |
            vocab.term.like('%Ã%') |
            vocab.reading.like('%Ã%'),
      );
    final corruptedRow = await corruptedQuery.getSingle();
    final corruptedCount = corruptedRow.read(corruptedCountExpr) ?? 0;
    if (corruptedCount > 0) {
      await _reseedMinnaVocabulary();
      return;
    }

    // Self-heal DBs seeded before N2/N1 Vietnamese drafts were approved.
    final untranslatedCountExpr = vocab.id.count();
    final untranslatedQuery = selectOnly(vocab)
      ..addColumns([untranslatedCountExpr])
      ..where(
        vocab.series.equals('ShinKanzen') &
            vocab.level.isIn(const ['N2', 'N1']) &
            vocab.meaningEn.isNotNull() &
            vocab.meaning.equalsExp(vocab.meaningEn),
      );
    final untranslatedRow = await untranslatedQuery.getSingle();
    final untranslatedCount = untranslatedRow.read(untranslatedCountExpr) ?? 0;
    if (untranslatedCount > 0) {
      await _reseedMinnaVocabulary();
    }
  }

  Future<void> _ensureMinnaVocabularySeededForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await _ensureMinnaVocabularySeeded(
      _contentSeedSpecs.where((s) => s.levelLabel == activeLevel),
    );
  }

  Future<void> _seedMinnaVocabulary() {
    // All level specs are independent — seed them concurrently so file I/O
    // for N5, N4, and N3 overlaps. DB writes still serialize through the isolate.
    return Future.wait(_contentSeedSpecs.map(_seedVocabularyLevel));
  }

  Future<void> _seedMinnaVocabularyForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await Future.wait(
      _contentSeedSpecs
          .where((s) => s.levelLabel == activeLevel)
          .map(_seedVocabularyLevel),
    );
  }

  Future<void> _ensureHajimeteVocabularySeeded([
    Iterable<_HajimeteSeedSpec> specs = _hajimeteSeedSpecs,
  ]) async {
    // One GROUP BY query replaces N sequential COUNT queries (one per level).
    final levelCol = vocab.level;
    final countExpr = vocab.id.count();
    final rows =
        await (selectOnly(vocab)
              ..addColumns([levelCol, countExpr])
              ..where(
                vocab.series.equals('hajimete') &
                    vocab.level.isIn(specs.map((s) => s.levelLabel).toList()),
              )
              ..groupBy([levelCol]))
            .get();
    final counts = {
      for (final row in rows) row.read(levelCol)!: row.read(countExpr) ?? 0,
    };
    final missingSpecs = specs
        .where((s) => (counts[s.levelLabel] ?? 0) == 0)
        .toList();
    if (missingSpecs.isNotEmpty) {
      await Future.wait(missingSpecs.map(_seedHajimeteLevel));
    }
  }

  Future<void> _ensureHajimeteVocabularySeededForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await _ensureHajimeteVocabularySeeded(
      _hajimeteSeedSpecs.where((s) => s.levelLabel == activeLevel),
    );
  }

  Future<void> _seedHajimeteVocabulary() {
    // All Hajimete level specs are independent — seed them concurrently.
    return Future.wait(_hajimeteSeedSpecs.map(_seedHajimeteLevel));
  }

  Future<void> _seedHajimeteVocabularyForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await Future.wait(
      _hajimeteSeedSpecs
          .where((s) => s.levelLabel == activeLevel)
          .map(_seedHajimeteLevel),
    );
  }

  Future<void> _ensureMimikaraVocabularySeededForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    final specs = _mimikaraSeedSpecs.where((s) => s.levelLabel == activeLevel);
    final levelCol = vocab.level;
    final countExpr = vocab.id.count();
    final rows =
        await (selectOnly(vocab)
              ..addColumns([levelCol, countExpr])
              ..where(
                vocab.series.equals('mimikara') &
                    vocab.level.isIn(specs.map((s) => s.levelLabel).toList()),
              )
              ..groupBy([levelCol]))
            .get();
    final counts = {
      for (final row in rows) row.read(levelCol)!: row.read(countExpr) ?? 0,
    };
    final missingSpecs = specs
        .where((s) => (counts[s.levelLabel] ?? 0) == 0)
        .toList();
    if (missingSpecs.isNotEmpty) {
      await Future.wait(missingSpecs.map(_seedMimikaraLevel));
    }
  }

  Future<void> _seedMimikaraVocabularyForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await Future.wait(
      _mimikaraSeedSpecs
          .where((s) => s.levelLabel == activeLevel)
          .map(_seedMimikaraLevel),
    );
  }

  Future<void> _reseedHajimeteVocab() async {
    await (delete(vocab)..where((tbl) => tbl.series.equals('hajimete'))).go();
    await _seedHajimeteVocabulary();
  }

  Future<void> _reseedVocabularyForLevel(String level) async {
    final normalizedLevel = level.trim().toUpperCase();
    await (delete(
      vocab,
    )..where((tbl) => tbl.level.equals(normalizedLevel))).go();
    final contentSpec = _contentSeedSpecForLevel(normalizedLevel);
    final hajimeteSpecs = _hajimeteSeedSpecs.where(
      (spec) => spec.levelLabel == normalizedLevel,
    );
    await Future.wait([
      if (contentSpec != null) _seedVocabularyLevel(contentSpec),
      ...hajimeteSpecs.map(_seedHajimeteLevel),
      ..._mimikaraSeedSpecs
          .where((spec) => spec.levelLabel == normalizedLevel)
          .map(_seedMimikaraLevel),
    ]);
  }

  Future<void> _ensureConjugationLemmasSeededForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    final countExpr = conjugationLemma.id.count();
    final row =
        await (selectOnly(conjugationLemma)
              ..addColumns([countExpr])
              ..where(conjugationLemma.level.equals(activeLevel)))
            .getSingle();
    final count = row.read(countExpr) ?? 0;
    if (count == 0) {
      await _seedConjugationLemmasForActiveLevel();
    }
  }

  Future<void> _seedConjugationLemmasForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await _seedConjugationLemmasForLevel(activeLevel);
  }

  Future<void> _seedConjugationLemmasForLevel(String level) async {
    final normalizedLevel = level.trim().toUpperCase();
    if (_contentSeedSpecForLevel(normalizedLevel) == null) return;

    final entries = await _loadConjugationLemmaRowsForLevel(normalizedLevel);
    if (entries.isEmpty) return;

    final vocabRows = await (select(
      vocab,
    )..where((tbl) => tbl.level.equals(normalizedLevel))).get();
    if (vocabRows.isEmpty) return;

    final bySourcePair = <String, VocabData>{};
    final bySourceVocabId = <String, VocabData>{};
    final byTermReading = <String, VocabData>{};
    for (final row in vocabRows) {
      final sourceVocabId = row.sourceVocabId?.trim();
      final sourceSenseId = row.sourceSenseId?.trim();
      if (sourceVocabId != null && sourceVocabId.isNotEmpty) {
        if (sourceSenseId != null && sourceSenseId.isNotEmpty) {
          bySourcePair['$sourceVocabId|$sourceSenseId'] = row;
        }
        bySourceVocabId.putIfAbsent(sourceVocabId, () => row);
      }
      byTermReading.putIfAbsent(
        '${row.term}|${row.reading?.trim() ?? ''}|${row.series}',
        () => row,
      );
    }

    final companions = <ConjugationLemmaCompanion>[];
    for (final entry in entries) {
      final vocabRow = _resolveConjugationLemmaVocab(
        entry: entry,
        bySourcePair: bySourcePair,
        bySourceVocabId: bySourceVocabId,
        byTermReading: byTermReading,
      );
      if (vocabRow == null) continue;

      final id = _readInt(entry, 'id');
      final contentEntryId = _readText(entry, 'contentEntryId');
      final term = _readText(entry, 'term');
      final dictionaryForm = _readText(entry, 'dictionaryForm');
      final kind = _readText(entry, 'kind');
      final conjugationClass = _readText(entry, 'conjugationClass');
      final jmdictEntrySeq = _readText(entry, 'jmdictEntrySeq');
      final lessonId = _readInt(entry, 'lessonId');
      final matchMethod = _readText(entry, 'matchMethod');
      if (id == null ||
          contentEntryId.isEmpty ||
          term.isEmpty ||
          dictionaryForm.isEmpty ||
          kind.isEmpty ||
          conjugationClass.isEmpty ||
          jmdictEntrySeq.isEmpty ||
          lessonId == null ||
          matchMethod.isEmpty) {
        continue;
      }

      companions.add(
        ConjugationLemmaCompanion.insert(
          id: Value(id),
          contentVocabId: vocabRow.id,
          contentEntryId: contentEntryId,
          term: term,
          reading: Value(_readNullableText(entry, 'reading')),
          dictionaryForm: dictionaryForm,
          dictionaryReading: Value(
            _readNullableText(entry, 'dictionaryReading'),
          ),
          kind: kind,
          conjugationClass: conjugationClass,
          posTagsJson: json.encode(entry['posTags'] ?? const []),
          jmdictEntrySeq: jmdictEntrySeq,
          sourceVocabId: Value(_readNullableText(entry, 'sourceVocabId')),
          sourceSenseId: Value(_readNullableText(entry, 'sourceSenseId')),
          level: normalizedLevel,
          series: _readText(entry, 'series'),
          lessonId: lessonId,
          matchMethod: matchMethod,
        ),
      );
    }

    await (delete(
      conjugationLemma,
    )..where((tbl) => tbl.level.equals(normalizedLevel))).go();
    if (companions.isEmpty) return;
    await batch((b) {
      for (final companion in companions) {
        b.insert(conjugationLemma, companion, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> _loadConjugationLemmaRowsForLevel(
    String level,
  ) async {
    try {
      final raw = await rootBundle.loadString(_conjugationLemmaAssetPath);
      final payload = _asMap(json.decode(raw));
      final entries = payload?['entries'];
      if (entries is! List) return const [];
      return [
        for (final rawEntry in entries)
          if (_asMap(rawEntry) case final entry?)
            if (_readText(entry, 'level').toUpperCase() == level) entry,
      ];
    } catch (_) {
      return const [];
    }
  }

  VocabData? _resolveConjugationLemmaVocab({
    required Map<String, dynamic> entry,
    required Map<String, VocabData> bySourcePair,
    required Map<String, VocabData> bySourceVocabId,
    required Map<String, VocabData> byTermReading,
  }) {
    final sourceVocabId = _readNullableText(entry, 'sourceVocabId');
    final sourceSenseId = _readNullableText(entry, 'sourceSenseId');
    if (sourceVocabId != null && sourceSenseId != null) {
      final byPair = bySourcePair['$sourceVocabId|$sourceSenseId'];
      if (byPair != null) return byPair;
    }
    if (sourceVocabId != null) {
      final bySource = bySourceVocabId[sourceVocabId];
      if (bySource != null) return bySource;
    }

    final term = _readText(entry, 'term');
    final reading = _readText(entry, 'reading');
    final series = _readText(entry, 'series');
    return byTermReading['$term|$reading|$series'];
  }

  Future<void> _seedHajimeteLevel(_HajimeteSeedSpec spec) async {
    final level = spec.levelLabel;

    // Step 1: Load all chapter JSON files concurrently.
    final chapterFutures = [
      for (int chapterId = 1; chapterId <= spec.chapterCount; chapterId++)
        _tryLoadHajimeteChapterEntries(spec.levelLower, chapterId),
    ];
    final chapterEntryLists = await Future.wait(chapterFutures);

    // Step 2: Resolve all HanViet lookups concurrently across all chapters.
    // HanVietLookup caches after first load; concurrent calls are safe.
    final resolutionFutures = <Future<VocabCompanion?>>[];
    for (final entries in chapterEntryLists) {
      if (entries == null) continue;
      for (final rawEntry in entries) {
        resolutionFutures.add(_resolveHajimeteEntry(rawEntry, level));
      }
    }
    final companions = await Future.wait(resolutionFutures);

    // Step 3: Batch insert all resolved entries in one round-trip.
    await batch((b) {
      for (final companion in companions) {
        if (companion != null) {
          b.insert(vocab, companion, mode: InsertMode.insertOrIgnore);
        }
      }
    });
  }

  Future<void> _seedMimikaraLevel(_MimikaraSeedSpec spec) async {
    final level = spec.levelLabel;
    final indexPath =
        'assets/data/content/vocab/${spec.levelLower}/mimikara/index.json';
    List<Map<String, dynamic>> units;
    try {
      final raw = await rootBundle.loadString(indexPath);
      final payload = _asMap(json.decode(raw));
      final rawUnits = payload?['units'];
      units = [
        if (rawUnits is List)
          for (final rawUnit in rawUnits) ?_asMap(rawUnit),
      ];
    } catch (_) {
      return;
    }
    if (units.isEmpty) return;

    final perUnitRows = await Future.wait([
      for (final unit in units) _loadMimikaraUnitRows(spec, unit),
    ]);
    final rows = <Map<String, dynamic>>[];
    for (final unitRows in perUnitRows) {
      rows.addAll(unitRows);
    }
    final collapsedRows = _collapseExactDuplicateRows(rows);
    if (collapsedRows.isEmpty) return;

    await batch((b) {
      for (final item in collapsedRows) {
        b.insert(
          vocab,
          VocabCompanion.insert(
            term: item['term'] as String,
            reading: Value(item['reading'] as String?),
            kanjiMeaning: Value(item['kanjiMeaning'] as String?),
            sourceVocabId: Value(item['sourceVocabId'] as String?),
            sourceSenseId: Value(item['sourceSenseId'] as String?),
            meaning: item['meaning_vi'] as String,
            meaningEn: Value(item['meaning_en'] as String?),
            series: const Value('mimikara'),
            level: level,
            tags: Value(item['tags'] as String?),
            exampleSentencesJson: Value(
              item['exampleSentencesJson'] as String? ?? '[]',
            ),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> _loadMimikaraUnitRows(
    _MimikaraSeedSpec spec,
    Map<String, dynamic> unit,
  ) async {
    final fileName = _readText(unit, 'file');
    final unitId = _readInt(unit, 'unitId') ?? 0;
    if (fileName.isEmpty || unitId <= 0) return const [];
    final path =
        'assets/data/content/vocab/${spec.levelLower}/mimikara/$fileName';
    try {
      final raw = await rootBundle.loadString(path);
      final payload = _asMap(json.decode(raw));
      final entries = payload?['entries'];
      if (entries is! List) return const [];
      return [
        for (final rawEntry in entries)
          ?_mimikaraEntryRow(rawEntry, spec.levelLabel, unitId),
      ];
    } catch (_) {
      return const [];
    }
  }

  Map<String, dynamic>? _mimikaraEntryRow(
    dynamic rawEntry,
    String level,
    int unitId,
  ) {
    final entry = _asMap(rawEntry);
    final lemma = _asMap(entry?['lemma']);
    final sense = _asMap(entry?['sense']);
    final links = _asMap(entry?['links']);
    if (entry == null || lemma == null || sense == null) return null;
    final term = _readText(lemma, 'term');
    final meaningVi = _readText(sense, 'meaningVi');
    if (term.isEmpty || meaningVi.isEmpty) return null;
    final labels = _asMap(lemma['labels']);
    return {
      'term': term,
      'reading': _readNullableText(lemma, 'reading'),
      'kanjiMeaning': labels == null
          ? _readNullableText(entry, 'kanjiMeaning')
          : _readNullableText(labels, 'hanViet'),
      'sourceVocabId': links == null
          ? _readNullableText(entry, 'sourceVocabId')
          : _readNullableText(links, 'sourceVocabId'),
      'sourceSenseId': links == null
          ? _readNullableText(entry, 'sourceSenseId')
          : _readNullableText(links, 'sourceSenseId'),
      'meaning_vi': meaningVi,
      'meaning_en': _readNullableText(sense, 'meaningEn'),
      'level': level,
      'series': 'mimikara',
      'tags': _joinTags([_readTags(entry['tags']), 'mimikara_$unitId']),
      'exampleSentencesJson': _exampleSentencesJsonFromEntry(entry),
    };
  }

  Future<List<dynamic>?> _tryLoadHajimeteChapterEntries(
    String levelLower,
    int chapterId,
  ) async {
    final padded = chapterId.toString().padLeft(2, '0');
    final path = _hajimeteVocabAssetPath(levelLower, padded);
    try {
      final raw = await rootBundle.loadString(path);
      final payload = _asMap(json.decode(raw));
      final entries = payload?['entries'];
      return entries is List ? entries : null;
    } catch (_) {
      return null; // Missing chapter file: skip until that level is implemented.
    }
  }

  Future<VocabCompanion?> _resolveHajimeteEntry(
    dynamic rawEntry,
    String level,
  ) async {
    final entry = _asMap(rawEntry);
    final lemma = _asMap(entry?['lemma']);
    final sense = _asMap(entry?['sense']);
    if (entry == null || lemma == null || sense == null) return null;

    final term = _readText(lemma, 'term');
    final meaningVi = _readText(sense, 'meaningVi');
    if (term.isEmpty || meaningVi.isEmpty) return null;

    final labels = _asMap(lemma['labels']);
    final links = _asMap(entry['links']);
    final tags = _readTags(entry['tags']);

    final hvResolution = await HanVietLookup.resolve(
      term: term,
      explicitHanViet: _readText(
        labels ?? const <String, dynamic>{},
        'hanViet',
      ).nullIfEmpty(),
      explicitMeaningVi: meaningVi,
    );

    return VocabCompanion.insert(
      term: term,
      reading: Value(_readText(lemma, 'reading').nullIfEmpty()),
      meaning: hvResolution.meaningVi ?? meaningVi,
      meaningEn: Value(_readText(sense, 'meaningEn').nullIfEmpty()),
      kanjiMeaning: Value(hvResolution.hanViet),
      sourceVocabId: Value(
        _readText(
          links ?? const <String, dynamic>{},
          'sourceVocabId',
        ).nullIfEmpty(),
      ),
      sourceSenseId: Value(
        _readText(
          links ?? const <String, dynamic>{},
          'sourceSenseId',
        ).nullIfEmpty(),
      ),
      series: const Value('hajimete'),
      level: level,
      tags: Value(tags?.nullIfEmpty()),
      exampleSentencesJson: Value(_exampleSentencesJsonFromEntry(entry)),
    );
  }

  Future<bool> _ensureMinnaKanjiSeeded() async {
    // One GROUP BY query replaces N sequential COUNT queries (one per level).
    final levelCol = kanji.jlptLevel;
    final countExpr = kanji.id.count();
    final rows =
        await (selectOnly(kanji)
              ..addColumns([levelCol, countExpr])
              ..where(
                kanji.jlptLevel.isIn(
                  _contentSeedSpecs.map((s) => s.levelLabel).toList(),
                ),
              )
              ..groupBy([levelCol]))
            .get();
    final counts = {
      for (final row in rows) row.read(levelCol)!: row.read(countExpr) ?? 0,
    };
    final expectedCounts = await _loadExpectedKanjiCountsByLevel();
    final incompleteKanjiSpecs = _contentSeedSpecs.where((s) {
      final current = counts[s.levelLabel] ?? 0;
      final expected = expectedCounts[s.levelLabel];
      return current == 0 || (expected != null && current < expected);
    }).toList();
    if (incompleteKanjiSpecs.isNotEmpty) {
      await _reseedKanjiLevels(incompleteKanjiSpecs);
      return true;
    }
    return false;
  }

  Future<bool> _kanjiSeedSentinelsHealthy() async {
    assert(_kanjiSeedSentinels.isNotEmpty);
    for (final sentinel in _qaA026KanjiSeedSentinels) {
      final rows =
          await (select(kanji)
                ..where(
                  (tbl) =>
                      tbl.jlptLevel.equals(sentinel.level) &
                      tbl.lessonId.equals(sentinel.lessonId) &
                      tbl.character.equals(sentinel.character),
                )
                ..limit(1))
              .get();
      if (rows.isEmpty) return false;
      final row = rows.single;
      if (row.meaning != sentinel.meaning) return false;
      final decomposition = row.decompositionJson ?? '';
      if (!decomposition.contains(sentinel.decompositionContains)) {
        return false;
      }
    }
    return true;
  }

  Future<Map<String, int>> _loadExpectedKanjiCountsByLevel() async {
    try {
      final raw = await rootBundle.loadString('assets/data/content/index.json');
      final payload = _asMap(json.decode(raw));
      final datasets = _asMap(payload?['datasets']);
      final kanjiDataset = _asMap(datasets?['kanji']);
      final levels = _asMap(kanjiDataset?['levels']);
      if (levels == null) return const {};
      return {
        for (final entry in levels.entries)
          if (_asMap(entry.value)?['entries'] is num)
            entry.key.toString().toUpperCase():
                (_asMap(entry.value)!['entries'] as num).toInt(),
      };
    } catch (_) {
      return const {};
    }
  }

  Future<void> _ensureMinnaGrammarSeeded([
    Iterable<_ContentSeedSpec> specs = _contentSeedSpecs,
  ]) async {
    final specList = specs.toList(growable: false);
    if (specList.isEmpty) return;
    // One GROUP BY query replaces N sequential COUNT queries (one per level).
    final levelCol = grammarPoint.level;
    final countExpr = grammarPoint.id.count();
    final maxLessonExpr = grammarPoint.lessonId.max();
    final rows =
        await (selectOnly(grammarPoint)
              ..addColumns([levelCol, countExpr, maxLessonExpr])
              ..where(
                grammarPoint.level.isIn(
                  specList.map((s) => s.levelLabel).toList(),
                ),
              )
              ..groupBy([levelCol]))
            .get();
    final counts = {
      for (final row in rows) row.read(levelCol)!: row.read(countExpr) ?? 0,
    };
    final maxLessons = {
      for (final row in rows) row.read(levelCol)!: row.read(maxLessonExpr) ?? 0,
    };
    final missingSpecs = specList
        .where(
          (spec) =>
              (counts[spec.levelLabel] ?? 0) == 0 ||
              (maxLessons[spec.levelLabel] ?? 0) < spec.endLesson,
        )
        .toList(growable: false);
    if (missingSpecs.isNotEmpty) {
      await _seedMinnaGrammar(missingSpecs);
    }
  }

  Future<void> _ensureMinnaGrammarSeededForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    await ensureGrammarSeededForLevel(activeLevel);
  }

  Future<void> ensureGrammarSeededForLevel(String level) async {
    final spec = _contentSeedSpecForLevel(level);
    if (spec == null) return;
    await _ensureMinnaGrammarSeeded([spec]);
  }

  Future<void> _seedMinnaGrammar([
    Iterable<_ContentSeedSpec> specs = _contentSeedSpecs,
  ]) async {
    final specList = specs.toList(growable: false);
    if (specList.isEmpty) return;

    // Clear existing data for target levels only to prevent duplicates while
    // preserving levels that should stay lazy.
    final targetLevels = specList.map((s) => s.levelLabel).toList();
    final pointIdRows =
        await (selectOnly(grammarPoint)
              ..addColumns([grammarPoint.id])
              ..where(grammarPoint.level.isIn(targetLevels)))
            .get();
    final pointIds = pointIdRows
        .map((row) => row.read(grammarPoint.id))
        .whereType<int>()
        .toList();
    if (pointIds.isNotEmpty) {
      await (delete(
        grammarExample,
      )..where((tbl) => tbl.grammarPointId.isIn(pointIds))).go();
    }
    await (delete(
      grammarPoint,
    )..where((tbl) => tbl.level.isIn(targetLevels))).go();

    // Phase 1: Load every (def, examples) file pair concurrently — pure I/O.
    final filePairs = <({String defPath, String exPath})>[];
    for (final spec in specList) {
      for (
        var lessonId = spec.startLesson;
        lessonId <= spec.endLesson;
        lessonId++
      ) {
        filePairs.add((
          defPath:
              'assets/data/content/grammar/${spec.levelLower}/grammar_${spec.levelLower}_$lessonId.json',
          exPath:
              'assets/data/content/grammar_examples/${spec.levelLower}/lesson_$lessonId.json',
        ));
      }
    }

    final loadFutures = filePairs.map((pair) async {
      try {
        final defStr = await rootBundle.loadString(pair.defPath);
        final points = json.decode(defStr) as List<dynamic>;
        List<dynamic> extras = const [];
        try {
          final exStr = await rootBundle.loadString(pair.exPath);
          final decoded = json.decode(exStr);
          if (decoded is List<dynamic>) {
            extras = decoded;
          } else if (decoded is Map<String, dynamic> &&
              decoded['examples'] is List<dynamic>) {
            extras = decoded['examples'] as List<dynamic>;
          }
        } catch (_) {}
        return (points: points, extras: extras);
      } catch (_) {
        return null;
      }
    }).toList();
    final allFileData = await Future.wait(loadFutures);

    // Phase 2: Insert grammar points sequentially (need generated IDs for examples).
    // Accumulate all example companions for a single batch insert at the end.
    final exampleCompanions = <GrammarExampleCompanion>[];
    for (final fileData in allFileData) {
      if (fileData == null || fileData.points.isEmpty) continue;
      for (final pointData in fileData.points) {
        late final int pointId;
        try {
          pointId = await into(grammarPoint).insert(
            GrammarPointCompanion.insert(
              lessonId: pointData['lessonId'] as int,
              title: pointData['title'] as String,
              titleEn: Value(
                normalizeGrammarTitleEn(pointData['titleEn'] as String?),
              ),
              structure: pointData['structure'] as String,
              structureEn: Value(
                normalizeGrammarStructureEn(
                  pointData['structureEn'] as String?,
                ),
              ),
              explanation: pointData['explanation'] as String,
              explanationEn: Value(pointData['explanationEn'] as String?),
              level: pointData['level'] as String,
              tags: Value(_readTags(pointData['tags'])),
            ),
            mode: InsertMode.insertOrReplace,
          );
        } catch (_) {
          continue;
        }

        final List<dynamic> examples = [...(pointData['examples'] ?? const [])];
        final extraExamples = findGrammarExamplesForDefinition(
          exampleBlocks: fileData.extras,
          title: pointData['title'] as String?,
          grammarPoint: pointData['grammarPoint'] as String?,
        );
        if (extraExamples != null) {
          examples.addAll(extraExamples);
        }

        for (final ex in examples) {
          exampleCompanions.add(
            GrammarExampleCompanion.insert(
              grammarPointId: pointId,
              sentence: ex['sentence'] as String,
              translation: ex['translation'] as String,
              translationEn: Value(ex['translationEn'] as String?),
            ),
          );
        }
      }
    }

    // Phase 3: Single batch for all example rows.
    if (exampleCompanions.isNotEmpty) {
      await batch((b) {
        for (final companion in exampleCompanions) {
          b.insert(grammarExample, companion, mode: InsertMode.insertOrReplace);
        }
      });
    }
  }

  Future<void> _seedMinnaGrammarForActiveLevel() async {
    final activeLevel = await _activeStudyLevelLabel();
    final spec = _contentSeedSpecForLevel(activeLevel);
    await _seedMinnaGrammar(spec == null ? const [] : [spec]);
  }

  Future<void> _seedVocabularyLevel(_ContentSeedSpec spec) async {
    final level = spec.levelLabel;
    final startLesson = spec.startLesson;
    final endLesson = spec.endLesson;

    // Load all lesson JSON files concurrently — each file is independent.
    final perLessonFutures = [
      for (int lessonId = startLesson; lessonId <= endLesson; lessonId++)
        _loadCanonicalVocabRows(level: level, lessonId: lessonId),
    ];
    final perLessonRows = await Future.wait(perLessonFutures);

    final allRows = <Map<String, dynamic>>[];
    for (int idx = 0; idx < perLessonRows.length; idx++) {
      final rows = perLessonRows[idx];
      if (rows.isEmpty) continue;
      allRows.addAll(
        _mergeLessonRows(
          preferred: rows,
          fallback: const [],
          level: level,
          lessonId: startLesson + idx,
        ),
      );
    }

    final collapsedRows = _collapseExactDuplicateRows(allRows);
    // Batch all inserts in a single round-trip to the DB isolate.
    await batch((b) {
      for (final item in collapsedRows) {
        b.insert(
          vocab,
          VocabCompanion.insert(
            term: item['term'] as String,
            reading: Value(item['reading'] as String?),
            kanjiMeaning: Value(item['kanjiMeaning'] as String?),
            sourceVocabId: Value(item['sourceVocabId'] as String?),
            sourceSenseId: Value(item['sourceSenseId'] as String?),
            meaning: item['meaning_vi'] as String,
            meaningEn: Value(item['meaning_en'] as String?),
            series: Value((item['series'] as String?) ?? 'minna'),
            level: item['level'] as String,
            tags: Value(item['tags'] as String?),
            exampleSentencesJson: Value(
              item['exampleSentencesJson'] as String? ?? '[]',
            ),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  String _minnaVocabAssetPath(String levelLower, String paddedLessonId) {
    final nestedPath =
        'assets/data/content/vocab/$levelLower/minna/lesson_$paddedLessonId.json';
    if (levelLower == 'n4' || levelLower == 'n5') {
      return nestedPath;
    }
    return 'assets/data/content/vocab/$levelLower/lesson_$paddedLessonId.json';
  }

  Future<String> _resolveCanonicalVocabAssetPath({
    required String levelLower,
    required int lessonId,
  }) async {
    final paddedLessonId = lessonId.toString().padLeft(2, '0');
    if (levelLower == 'n4' || levelLower == 'n5') {
      return _minnaVocabAssetPath(levelLower, paddedLessonId);
    }
    final shinkanzenIndexPath =
        'assets/data/content/vocab/$levelLower/ShinKanzen/index.json';

    try {
      final indexRaw = await rootBundle.loadString(shinkanzenIndexPath);
      final indexPayload = _asMap(json.decode(indexRaw));
      final lessons = indexPayload?['lessons'];
      if (lessons is List) {
        for (final rawLesson in lessons) {
          final lesson = _asMap(rawLesson);
          if (lesson == null) continue;
          final indexedLessonId = _readInt(lesson, 'lessonId') ?? -1;
          final fileName = _readText(lesson, 'file');
          if (indexedLessonId == lessonId && fileName.isNotEmpty) {
            return 'assets/data/content/vocab/$levelLower/ShinKanzen/$fileName';
          }
        }
      }
    } catch (_) {}

    return _minnaVocabAssetPath(levelLower, paddedLessonId);
  }

  String _hajimeteVocabAssetPath(String levelLower, String paddedChapterId) {
    return 'assets/data/content/vocab/$levelLower/hajimete/hajimete_ch$paddedChapterId.json';
  }

  Future<List<Map<String, dynamic>>> _loadCanonicalVocabRows({
    required String level,
    required int lessonId,
  }) async {
    final levelLower = level.toLowerCase();
    final path = await _resolveCanonicalVocabAssetPath(
      levelLower: levelLower,
      lessonId: lessonId,
    );

    try {
      final raw = await rootBundle.loadString(path);
      final payload = _asMap(json.decode(raw));
      final entries = payload?['entries'];
      if (entries is! List) {
        return const [];
      }

      final rows = <Map<String, dynamic>>[];
      for (final rawEntry in entries) {
        final entry = _asMap(rawEntry);
        if (entry == null) continue;
        final lemma = _asMap(entry['lemma']);
        final sense = _asMap(entry['sense']);
        final links = _asMap(entry['links']);
        if (lemma == null || sense == null) continue;

        final term = _readText(lemma, 'term');
        final meaningVi = _readText(sense, 'meaningVi');
        if (term.isEmpty || meaningVi.isEmpty) continue;

        final labels = _asMap(lemma['labels']);
        final payloadSeries =
            _readText(payload ?? const {}, 'series').nullIfEmpty() ??
            _seriesForCanonicalLevel(level);
        final tags = _joinTags([
          _readTags(payload?['tags']),
          _readTags(entry['tags']),
        ]);
        final tagPrefix = _lessonSeriesTag(payloadSeries, lessonId);
        final mergedTags = tags.isEmpty ? tagPrefix : '$tagPrefix,$tags';

        rows.add({
          'term': term,
          'reading': _readNullableText(lemma, 'reading'),
          'kanjiMeaning': labels == null
              ? _readNullableText(entry, 'kanjiMeaning')
              : _readNullableText(labels, 'hanViet'),
          'sourceVocabId': links == null
              ? _readNullableText(entry, 'sourceVocabId')
              : _readNullableText(links, 'sourceVocabId'),
          'sourceSenseId': links == null
              ? _readNullableText(entry, 'sourceSenseId')
              : _readNullableText(links, 'sourceSenseId'),
          'meaning_vi': meaningVi,
          'meaning_en': _readNullableText(sense, 'meaningEn'),
          'level': level,
          'series': payloadSeries,
          'tags': mergedTags,
          'exampleSentencesJson': _exampleSentencesJsonFromEntry(entry),
        });
      }

      return rows;
    } catch (_) {
      return const [];
    }
  }

  List<Map<String, dynamic>> _mergeLessonRows({
    required List<Map<String, dynamic>> preferred,
    required List<Map<String, dynamic>> fallback,
    required String level,
    required int lessonId,
  }) {
    final merged = <Map<String, dynamic>>[];
    final seen = <String>{};

    void addRow(Map<String, dynamic> raw) {
      final term = _readText(raw, 'term');
      final meaningVi = _firstNonEmpty([
        _readText(raw, 'meaning_vi'),
        _readText(raw, 'meaning'),
      ]);
      if (term.isEmpty || meaningVi.isEmpty) return;

      final reading = _readNullableText(raw, 'reading');
      if (_containsPlaceholder(term) || _containsPlaceholder(reading)) {
        return;
      }
      final kanjiMeaning = _readNullableText(raw, 'kanjiMeaning');
      final sourceVocabId = _readNullableText(raw, 'sourceVocabId');
      final sourceSenseId = _readNullableText(raw, 'sourceSenseId');
      final meaningEn = _readNullableText(raw, 'meaning_en');
      final exampleSentencesJson = _readText(raw, 'exampleSentencesJson');
      final rowLevel = _firstNonEmpty([_readText(raw, 'level'), level]);
      final series = _firstNonEmpty([
        _readText(raw, 'series'),
        _seriesForCanonicalLevel(level),
      ]);
      final tags = _firstNonEmpty([
        _readText(raw, 'tags'),
        _lessonSeriesTag(series, lessonId),
      ]);

      final normalized = <String, dynamic>{
        'term': term,
        'reading': reading,
        'kanjiMeaning': kanjiMeaning,
        'sourceVocabId': sourceVocabId,
        'sourceSenseId': sourceSenseId,
        'meaning_vi': meaningVi,
        'meaning_en': meaningEn,
        'level': rowLevel,
        'series': series,
        'tags': tags,
        'exampleSentencesJson': exampleSentencesJson.isEmpty
            ? '[]'
            : exampleSentencesJson,
      };

      final key = _exactSignature(normalized);
      if (seen.add(key)) {
        merged.add(normalized);
      }
    }

    for (final item in preferred) {
      addRow(item);
    }
    for (final item in fallback) {
      addRow(item);
    }

    return merged;
  }

  List<Map<String, dynamic>> _collapseExactDuplicateRows(
    List<Map<String, dynamic>> rows,
  ) {
    final aggregateBySignature = <String, _SeedVocabAggregate>{};
    for (final row in rows) {
      final signature = _exactSignature(row);
      final existing = aggregateBySignature[signature];
      if (existing == null) {
        aggregateBySignature[signature] = _SeedVocabAggregate.fromRow(row);
      } else {
        existing.mergeTags(_readNullableText(row, 'tags'));
      }
    }
    return aggregateBySignature.values.map((item) => item.toRow()).toList();
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  String _readText(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value == null) return '';
    return value.toString().trim();
  }

  String? _readNullableText(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return text;
  }

  String _exampleSentencesJsonFromEntry(Map<String, dynamic> entry) {
    final examples = entry['example_sentences'];
    return examples is List ? json.encode(examples) : '[]';
  }

  String? _readTags(Object? raw) {
    if (raw == null) return null;
    if (raw is Iterable && raw is! String) {
      return _joinTags(raw.map((entry) => entry.toString()));
    }
    final text = raw.toString().trim();
    return text.isEmpty ? null : text;
  }

  String _joinTags(Iterable<String?> rawTags) {
    final tags = <String>{};
    for (final raw in rawTags) {
      if (raw == null) continue;
      for (final tag in raw.split(',')) {
        final normalized = tag.trim();
        if (normalized.isNotEmpty) tags.add(normalized);
      }
    }
    return tags.join(',');
  }

  int? _readInt(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  String _firstNonEmpty(List<String?> candidates) {
    for (final candidate in candidates) {
      final normalized = candidate?.trim() ?? '';
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
    return '';
  }

  String _exactSignature(Map<String, dynamic> row) {
    final term = _readText(row, 'term');
    final reading = _readText(row, 'reading');
    final kanjiMeaning = _readText(row, 'kanjiMeaning');
    final sourceVocabId = _readText(row, 'sourceVocabId');
    final sourceSenseId = _readText(row, 'sourceSenseId');
    final meaningVi = _firstNonEmpty([
      _readText(row, 'meaning_vi'),
      _readText(row, 'meaning'),
    ]);
    final meaningEn = _readText(row, 'meaning_en');
    final level = _readText(row, 'level');
    final series = _readText(row, 'series');
    return '$term|$reading|$kanjiMeaning|$sourceVocabId|$sourceSenseId|$meaningVi|$meaningEn|$level|$series';
  }

  String _seriesForCanonicalLevel(String level) {
    final normalized = level.trim().toUpperCase();
    return normalized == 'N3' || normalized == 'N2' || normalized == 'N1'
        ? 'ShinKanzen'
        : 'minna';
  }

  static final _seriesNormalizeRe = RegExp(r'[^a-z0-9]+');

  String _lessonSeriesTag(String series, int lessonId) {
    final normalized = series.toLowerCase().replaceAll(_seriesNormalizeRe, '');
    final prefix = normalized.isEmpty ? 'lesson' : normalized;
    return '${prefix}_$lessonId';
  }

  bool _containsPlaceholder(String? value) {
    return (value ?? '').contains('?');
  }

  Future<void> _addColumn<T extends Object>(
    Migrator migrator,
    TableInfo table,
    Column<T> column,
  ) async {
    await migrator.addColumn(table, column as GeneratedColumn);
  }

  Future<void> _createContentIndexes() async {
    // Vocab — most frequently queried columns for every vocab screen load.
    // Composite (level, series) covers the common getVocabByLevelAndSeries
    // pattern; (level) alone covers getVocabByLevel fallback queries.
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_level_series ON vocab(level, series)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_level ON vocab(level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vocab_series ON vocab(series)',
    );
    // Kanji — queried by JLPT level on every kanji hub / practice screen open.
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_kanji_jlpt ON kanji(jlpt_level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_kanji_lesson ON kanji(lesson_id)',
    );
    // Grammar (content DB copy) — queried by level in JLPT mock exam builder.
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_grammar_point_level ON grammar_point(level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_conjugation_lemma_vocab '
      'ON conjugation_lemma(content_vocab_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_conjugation_lemma_level '
      'ON conjugation_lemma(level)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_conjugation_lemma_source '
      'ON conjugation_lemma(source_vocab_id, source_sense_id)',
    );
  }

  Future<void> _reseedMinnaKanji() async {
    // Delete all existing Kanji data to prevent duplicates or stale data
    await _reseedKanjiLevels(_contentSeedSpecs);
  }

  Future<void> _reseedKanjiLevels(Iterable<_ContentSeedSpec> specs) async {
    final specList = specs.toList(growable: false);
    if (specList.isEmpty) return;
    await (delete(kanji)..where(
          (tbl) => tbl.jlptLevel.isIn(
            specList.map((spec) => spec.levelLabel).toList(growable: false),
          ),
        ))
        .go();
    await Future.wait(specList.map(_seedKanjiLevel));
  }

  Future<void> _seedMinnaKanji() {
    // All level specs are independent — seed them concurrently.
    return Future.wait(_contentSeedSpecs.map(_seedKanjiLevel));
  }

  Future<void> _backfillKanjiDecompositionFromCanonical() async {
    // Create all file-load futures before any await — pure IO, no deps between
    // lessons, so all reads start concurrently in the event loop.
    final rowFutures = <Future<List<Map<String, dynamic>>>>[];
    final lessonIds = <int>[];
    for (final spec in _contentSeedSpecs) {
      for (var lessonId = 1; lessonId <= 25; lessonId++) {
        lessonIds.add(lessonId);
        rowFutures.add(
          _loadCanonicalKanjiRows(
            levelLower: spec.levelLower,
            lessonId: lessonId,
          ),
        );
      }
    }

    final allRowLists = await Future.wait(rowFutures);

    // Single batch for all decomposition updates across every level/lesson.
    await batch((b) {
      for (var i = 0; i < lessonIds.length; i++) {
        final lessonId = lessonIds[i];
        for (final row in allRowLists[i]) {
          final character = _readText(row, 'character');
          final decompositionJson = _readNullableText(
            row,
            'decomposition_json',
          );
          if (character.isEmpty || decompositionJson == null) continue;
          b.update(
            kanji,
            KanjiCompanion(decompositionJson: Value(decompositionJson)),
            where: (tbl) =>
                tbl.lessonId.equals(lessonId) & tbl.character.equals(character),
          );
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> _loadCanonicalKanjiRows({
    required String levelLower,
    required int lessonId,
  }) async {
    final paddedLessonId = lessonId.toString().padLeft(2, '0');
    final path =
        'assets/data/content/kanji/$levelLower/lesson_$paddedLessonId.json';

    try {
      final raw = await rootBundle.loadString(path);
      final payload = _asMap(json.decode(raw));
      final entries = payload?['entries'];
      if (entries is! List) {
        return const [];
      }

      final rows = <Map<String, dynamic>>[];
      for (final rawEntry in entries) {
        final entry = _asMap(rawEntry);
        if (entry == null) continue;
        final labels = _asMap(entry['labels']);
        final readings = _asMap(entry['readings']);
        final mnemonic = _asMap(entry['mnemonic']);
        final legacy = _asMap(entry['legacy']);
        final examples = entry['examples'];
        final character = _readText(entry, 'character');
        final meaning = labels == null
            ? _readNullableText(legacy ?? const {}, 'meaning')
            : _readNullableText(labels, 'meaningViDisplay');
        if (character.isEmpty || meaning == null || meaning.isEmpty) continue;
        final hanViet = labels == null
            ? null
            : _readNullableText(labels, 'hanViet');
        final decomposition = _asMap(entry['decomposition']);
        final decompositionJson = _kanjiDecompositionJson(
          decomposition: decomposition,
          hanViet: hanViet,
        );

        rows.add({
          'lessonId': _readInt(entry, 'lessonId') ?? lessonId,
          'character': character,
          'strokeCount': _readInt(entry, 'strokeCount') ?? 0,
          'onyomi': readings == null
              ? _readNullableText(legacy ?? const {}, 'onyomi')
              : (readings['onyomi'] is List
                    ? (readings['onyomi'] as List)
                          .map((item) => item.toString().trim())
                          .where((item) => item.isNotEmpty)
                          .join(', ')
                    : null),
          'kunyomi': readings == null
              ? _readNullableText(legacy ?? const {}, 'kunyomi')
              : (readings['kunyomi'] is List
                    ? (readings['kunyomi'] as List)
                          .map((item) => item.toString().trim())
                          .where((item) => item.isNotEmpty)
                          .join(', ')
                    : null),
          'meaning': meaning,
          'meaningEn': labels == null
              ? null
              : _readNullableText(labels, 'meaningEn'),
          'meaningJa': labels == null
              ? null
              : _readNullableText(labels, 'meaningJa'),
          'mnemonic_vi': mnemonic == null
              ? null
              : _readNullableText(mnemonic, 'vi'),
          'mnemonic_en': mnemonic == null
              ? null
              : _readNullableText(mnemonic, 'en'),
          'decomposition_json': decompositionJson,
          'examples': examples is List ? examples : const [],
          'jlptLevel': _readText(entry, 'level'),
        });
      }

      return rows;
    } catch (_) {
      return const [];
    }
  }

  String? _kanjiDecompositionJson({
    required Map<String, dynamic>? decomposition,
    required String? hanViet,
  }) {
    final merged = <String, dynamic>{
      if (decomposition != null) ...decomposition,
      if (hanViet != null && hanViet.isNotEmpty) 'hanViet': hanViet,
    };
    return merged.isEmpty ? null : json.encode(merged);
  }

  Future<void> _insertKanjiRows(List<dynamic> rows) async {
    await batch((batch) {
      for (final raw in rows) {
        final item = _asMap(raw);
        if (item == null) continue;
        batch.insert(
          kanji,
          KanjiCompanion.insert(
            lessonId: _readInt(item, 'lessonId') ?? 0,
            character: _readText(item, 'character'),
            strokeCount: _readInt(item, 'strokeCount') ?? 0,
            onyomi: Value(_readNullableText(item, 'onyomi')),
            kunyomi: Value(_readNullableText(item, 'kunyomi')),
            meaning: _readText(item, 'meaning'),
            meaningEn: Value(_readNullableText(item, 'meaningEn')),
            meaningJa: Value(_readNullableText(item, 'meaningJa')),
            mnemonicVi: Value(_readNullableText(item, 'mnemonic_vi')),
            mnemonicEn: Value(_readNullableText(item, 'mnemonic_en')),
            decompositionJson: Value(
              _readNullableText(item, 'decomposition_json') ??
                  (item['decomposition'] is Map
                      ? json.encode(item['decomposition'])
                      : null),
            ),
            examplesJson: json.encode(item['examples'] ?? const []),
            jlptLevel: _readText(item, 'jlptLevel'),
          ),
        );
      }
    });
  }

  Future<void> _seedKanjiLevel(_ContentSeedSpec spec) async {
    // Load all lesson files for this level concurrently — pure I/O, no deps.
    final perLessonFutures = [
      for (int lessonId = 1; lessonId <= 25; lessonId++)
        _loadCanonicalKanjiRows(
          levelLower: spec.levelLower,
          lessonId: lessonId,
        ),
    ];
    final perLessonRows = await Future.wait(perLessonFutures);

    final allRows = <Map<String, dynamic>>[];
    for (final rows in perLessonRows) {
      allRows.addAll(rows);
    }
    if (allRows.isNotEmpty) {
      await _insertKanjiRows(allRows);
    }
  }
}

class _SeedVocabAggregate {
  _SeedVocabAggregate({
    required this.term,
    required this.reading,
    required this.kanjiMeaning,
    required this.sourceVocabId,
    required this.sourceSenseId,
    required this.meaningVi,
    required this.meaningEn,
    required this.level,
    required this.series,
    required this.exampleSentencesJson,
    required Iterable<String> tags,
  }) : _tags = LinkedHashSet<String>() {
    _mergeTags(tags);
  }

  final String term;
  final String? reading;
  final String? kanjiMeaning;
  final String? sourceVocabId;
  final String? sourceSenseId;
  final String meaningVi;
  final String? meaningEn;
  final String level;
  final String series;
  final String exampleSentencesJson;
  final LinkedHashSet<String> _tags;

  factory _SeedVocabAggregate.fromRow(Map<String, dynamic> row) {
    return _SeedVocabAggregate(
      term: row['term'] as String,
      reading: row['reading'] as String?,
      kanjiMeaning: row['kanjiMeaning'] as String?,
      sourceVocabId: row['sourceVocabId'] as String?,
      sourceSenseId: row['sourceSenseId'] as String?,
      meaningVi: row['meaning_vi'] as String,
      meaningEn: row['meaning_en'] as String?,
      level: row['level'] as String,
      series: (row['series'] as String?) ?? 'minna',
      exampleSentencesJson:
          (row['exampleSentencesJson'] as String?)?.trim().isNotEmpty == true
          ? row['exampleSentencesJson'] as String
          : '[]',
      tags: _splitTags(row['tags'] as String?),
    );
  }

  void mergeTags(String? tags) {
    _mergeTags(_splitTags(tags));
  }

  Map<String, dynamic> toRow() {
    return {
      'term': term,
      'reading': reading,
      'kanjiMeaning': kanjiMeaning,
      'sourceVocabId': sourceVocabId,
      'sourceSenseId': sourceSenseId,
      'meaning_vi': meaningVi,
      'meaning_en': meaningEn,
      'level': level,
      'series': series,
      'tags': _tags.join(','),
      'exampleSentencesJson': exampleSentencesJson,
    };
  }

  void _mergeTags(Iterable<String> tags) {
    for (final tag in tags) {
      final normalized = tag.trim();
      if (normalized.isNotEmpty) {
        _tags.add(normalized);
      }
    }
  }

  static Iterable<String> _splitTags(String? rawTags) sync* {
    if (rawTags == null || rawTags.trim().isEmpty) {
      return;
    }

    for (final tag in rawTags.split(',')) {
      final normalized = tag.trim();
      if (normalized.isNotEmpty) {
        yield normalized;
      }
    }
  }
}

class _ContentSeedSpec {
  const _ContentSeedSpec(
    this.levelLabel,
    this.levelLower,
    this.startLesson,
    this.endLesson,
    this.series,
  );

  final String levelLabel;
  final String levelLower;
  final int startLesson;
  final int endLesson;
  final String series;
}

class _KanjiSeedSentinel {
  const _KanjiSeedSentinel({
    required this.level,
    required this.lessonId,
    required this.character,
    required this.meaning,
    required this.decompositionContains,
  });

  final String level;
  final int lessonId;
  final String character;
  final String meaning;
  final String decompositionContains;
}

const _contentSeedSpecs = <_ContentSeedSpec>[
  _ContentSeedSpec('N5', 'n5', 1, 25, 'minna'),
  _ContentSeedSpec('N4', 'n4', 26, 50, 'minna'),
  _ContentSeedSpec('N3', 'n3', 1, 83, 'ShinKanzen'),
  _ContentSeedSpec('N2', 'n2', 1, 163, 'ShinKanzen'),
  _ContentSeedSpec('N1', 'n1', 1, 88, 'ShinKanzen'),
];

_ContentSeedSpec? _contentSeedSpecForLevel(String level) {
  final normalized = level.trim().toUpperCase();
  for (final spec in _contentSeedSpecs) {
    if (spec.levelLabel == normalized) {
      return spec;
    }
  }
  return null;
}

class _HajimeteSeedSpec {
  const _HajimeteSeedSpec(this.levelLabel, this.levelLower, this.chapterCount);

  final String levelLabel;
  final String levelLower;
  final int chapterCount;
}

const _hajimeteSeedSpecs = <_HajimeteSeedSpec>[
  _HajimeteSeedSpec('N5', 'n5', 14),
  _HajimeteSeedSpec('N4', 'n4', 20),
  _HajimeteSeedSpec('N3', 'n3', 28),
  _HajimeteSeedSpec('N2', 'n2', 38),
  _HajimeteSeedSpec('N1', 'n1', 50),
];

class _MimikaraSeedSpec {
  const _MimikaraSeedSpec(this.levelLabel, this.levelLower);

  final String levelLabel;
  final String levelLower;
}

const _mimikaraSeedSpecs = <_MimikaraSeedSpec>[
  _MimikaraSeedSpec('N3', 'n3'),
  _MimikaraSeedSpec('N2', 'n2'),
  _MimikaraSeedSpec('N1', 'n1'),
];

extension _StringNullIfEmpty on String {
  String? nullIfEmpty() => trim().isEmpty ? null : this;
}

Future<String> _activeStudyLevelLabel() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('onboarding.level')?.toUpperCase();
    return switch (stored) {
      'N1' || 'N2' || 'N3' || 'N4' || 'N5' => stored!,
      _ => 'N5',
    };
  } catch (_) {
    return 'N5';
  }
}

QueryExecutor _openContentConnection() {
  return driftDatabase(
    name: 'content',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
