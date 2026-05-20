import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/data/repositories/conjugation_repository.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/kanji_hub/kanji_hub_screen.dart';
import 'package:jpstudy/features/kanji_hub/providers/kanji_home_provider.dart';

class _FakeKanjiHubLessonRepository extends LessonRepository {
  _FakeKanjiHubLessonRepository({
    required this.n5Kanji,
    required this.n4Kanji,
    required this.n3Kanji,
    required this.n2Kanji,
    required this.n1Kanji,
    this.dueKanji = const {},
    this.unseenKanji = const {},
  }) : super(
         AppDatabase(executor: NativeDatabase.memory()),
         ContentDatabase(executor: NativeDatabase.memory()),
       );

  final List<KanjiItem> n5Kanji;
  final List<KanjiItem> n4Kanji;
  final List<KanjiItem> n3Kanji;
  final List<KanjiItem> n2Kanji;
  final List<KanjiItem> n1Kanji;

  /// Per-level due kanji (SRS-scheduled reviews). Defaults to empty (nothing due).
  final Map<String, List<KanjiItem>> dueKanji;

  /// Per-level unseen kanji (never practiced). Defaults to empty.
  final Map<String, List<KanjiItem>> unseenKanji;

  @override
  Future<List<KanjiItem>> fetchKanjiByLevel(String level) async {
    return switch (level) {
      'N5' => n5Kanji,
      'N4' => n4Kanji,
      'N3' => n3Kanji,
      'N2' => n2Kanji,
      'N1' => n1Kanji,
      _ => const [],
    };
  }

  @override
  Future<List<KanjiItem>> fetchDueKanjiByLevel(String level) async {
    return dueKanji[level] ?? const [];
  }

  @override
  Future<List<KanjiItem>> fetchUnseenKanjiByLevel(
    String level, {
    int limit = 15,
  }) async {
    final items = unseenKanji[level] ?? const [];
    return items.take(limit).toList();
  }

  @override
  Future<Set<int>> fetchSeenKanjiIds() async => const {};

  @override
  Future<Set<int>> fetchDueKanjiIds() async => const {};

  @override
  Future<int> countDueKanjiByLevel(String level) async =>
      dueKanji[level]?.length ?? 0;

  @override
  Future<int> countUnseenKanjiByLevel(String level) async =>
      unseenKanji[level]?.length ??
      fetchKanjiByLevel(level).then((items) => items.length);

  @override
  Future<int> countKanjiByLevel(String level) async =>
      fetchKanjiByLevel(level).then((items) => items.length);
}

class _FakeKanjiConjugationRepository extends ConjugationRepository {
  _FakeKanjiConjugationRepository()
    : super(ContentDatabase(executor: NativeDatabase.memory()));

  @override
  Future<ConjugationLemmaData?> findBySourceIds({
    String? sourceVocabId,
    String? sourceSenseId,
  }) async {
    if (sourceVocabId != 'haj_n5_ch10_v033') return null;
    return const ConjugationLemmaData(
      id: 1,
      contentVocabId: 21438,
      contentEntryId: 'haj_n5_ch10_v033',
      term: '帰る',
      reading: 'かえる',
      dictionaryForm: '帰る',
      dictionaryReading: 'かえる',
      kind: 'verb',
      conjugationClass: 'godanRu',
      posTagsJson: '[]',
      jmdictEntrySeq: '123',
      sourceVocabId: 'haj_n5_ch10_v033',
      sourceSenseId: null,
      level: 'N5',
      series: 'hajimete',
      lessonId: 10,
      matchMethod: 'test',
    );
  }
}

class _SlowKanjiHubLessonRepository extends _FakeKanjiHubLessonRepository {
  _SlowKanjiHubLessonRepository({
    required this.pendingN5Kanji,
    required super.n5Kanji,
    required super.n4Kanji,
    required super.n3Kanji,
    required super.n2Kanji,
    required super.n1Kanji,
  });

  final Future<List<KanjiItem>> pendingN5Kanji;

  @override
  Future<List<KanjiItem>> fetchKanjiByLevel(String level) {
    if (level == 'N5') return pendingN5Kanji;
    return super.fetchKanjiByLevel(level);
  }
}

Widget _buildSubject({
  required LessonRepository repo,
  AppLanguage language = AppLanguage.en,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
      lessonRepositoryProvider.overrideWithValue(repo),
      ...overrides,
    ],
    child: const MaterialApp(home: KanjiHubScreen()),
  );
}

Widget _buildRoutedSubject({
  required LessonRepository repo,
  AppLanguage language = AppLanguage.vi,
  List<Override> overrides = const [],
}) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const KanjiHubScreen()),
      GoRoute(
        path: AppRoutePath.grammarConjugationWord,
        name: AppRouteName.grammarConjugationWord,
        builder: (context, state) => Scaffold(
          body: Text('conjugation:${state.pathParameters['contentVocabId']}'),
        ),
      ),
    ],
  );
  return ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
      lessonRepositoryProvider.overrideWithValue(repo),
      ...overrides,
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _pumpKanjiHub(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _mockRadicalsAsset() async {
  final messenger =
      TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;
  const primaryRadicalsAsset = 'assets/data/support/kanji/radicals_214.json';
  const fallbackRadicalsAsset =
      'assets/data/support/kanji/radicals_214.source.json';
  rootBundle.evict(primaryRadicalsAsset);
  rootBundle.evict(fallbackRadicalsAsset);
  addTearDown(() {
    messenger.setMockMessageHandler('flutter/assets', null);
  });
  const radicalsJson = [
    {
      'id': 72,
      'kanji': '\u65e5',
      'strokes': 4,
      'vi_meaning': 'nhat (mat troi)',
      'vi_meaning_raw': 'nhat (mat troi)',
    },
  ];
  final payload = ByteData.view(
    Uint8List.fromList(utf8.encode(jsonEncode(radicalsJson))).buffer,
  );
  messenger.setMockMessageHandler('flutter/assets', (message) async {
    final key = utf8.decode(message!.buffer.asUint8List());
    if (key == primaryRadicalsAsset) {
      return payload;
    }
    return null;
  });
}

_FakeKanjiHubLessonRepository _buildRepo({
  Map<String, List<KanjiItem>> dueKanji = const {},
  Map<String, List<KanjiItem>> unseenKanji = const {},
}) {
  return _FakeKanjiHubLessonRepository(
    dueKanji: dueKanji,
    unseenKanji: unseenKanji,
    n5Kanji: const [
      KanjiItem(
        id: 1,
        lessonId: 1,
        character: '\u660e',
        strokeCount: 8,
        meaning: 'bright',
        meaningEn: 'bright',
        examples: [],
        jlptLevel: 'N5',
        decomposition: KanjiDecomposition(components: ['\u65e5', '\u6708']),
      ),
      KanjiItem(
        id: 5,
        lessonId: 1,
        character: '\u5b66',
        strokeCount: 8,
        onyomi: 'GAKU',
        kunyomi: 'manabu',
        meaning: 'hoc',
        meaningEn: 'study',
        mnemonicVi: 'Liên tưởng mái trường khi học chữ này.',
        mnemonicEn: 'Picture a student under a school roof.',
        examples: [
          KanjiExample(
            word: '\u5b66\u6821',
            reading: 'gakkou',
            meaning: 'truong hoc',
            meaningEn: 'school',
          ),
        ],
        jlptLevel: 'N5',
        decomposition: KanjiDecomposition(hanViet: 'hoc'),
      ),
      KanjiItem(
        id: 2,
        lessonId: 1,
        character: '\u4f11',
        strokeCount: 6,
        meaning: 'rest',
        meaningEn: 'rest',
        examples: [],
        jlptLevel: 'N5',
        decomposition: KanjiDecomposition(components: ['\u4ebb', '\u6728']),
      ),
    ],
    n4Kanji: const [
      KanjiItem(
        id: 3,
        lessonId: 2,
        character: '\u6642',
        strokeCount: 10,
        onyomi: '\u30b8',
        kunyomi: '\u3068\u304d',
        meaning: 'time',
        meaningEn: 'time',
        examples: [
          KanjiExample(
            word: '\u6642\u9593',
            reading: '\u3058\u304b\u3093',
            meaning: 'time',
            meaningEn: 'time',
          ),
        ],
        jlptLevel: 'N4',
        decomposition: KanjiDecomposition(components: ['\u65e5', '\u5bfa']),
      ),
    ],
    n3Kanji: const [
      KanjiItem(
        id: 4,
        lessonId: 3,
        character: '\u65e7',
        strokeCount: 5,
        meaning: 'old',
        meaningEn: 'old',
        examples: [],
        jlptLevel: 'N3',
        decomposition: KanjiDecomposition(relatedKanji: ['\u65e5']),
      ),
    ],
    n2Kanji: const [
      KanjiItem(
        id: 6,
        lessonId: 4,
        character: '\u66dc',
        strokeCount: 18,
        meaning: 'weekday',
        meaningEn: 'weekday',
        examples: [],
        jlptLevel: 'N2',
      ),
    ],
    n1Kanji: const [
      KanjiItem(
        id: 7,
        lessonId: 5,
        character: '\u9b31',
        strokeCount: 29,
        meaning: 'gloom',
        meaningEn: 'gloom',
        examples: [],
        jlptLevel: 'N1',
      ),
    ],
  );
}

void main() {
  testWidgets('kanji hub surfaces due/new/explore CTAs first', (tester) async {
    await _mockRadicalsAsset();
    await tester.pumpWidget(_buildSubject(repo: _buildRepo()));
    await _pumpKanjiHub(tester);

    expect(find.byKey(const ValueKey('kanji_today_panel')), findsOneWidget);
    expect(find.byKey(const ValueKey('kanji_cta_due')), findsOneWidget);
    expect(find.byKey(const ValueKey('kanji_cta_new')), findsOneWidget);
    expect(find.byKey(const ValueKey('kanji_cta_explore')), findsOneWidget);
  });

  testWidgets('kanji hub shows loading card while today summary resolves', (
    tester,
  ) async {
    await _mockRadicalsAsset();
    final completer = Completer<KanjiHomeSummary>();

    await tester.pumpWidget(
      _buildSubject(
        repo: _buildRepo(),
        overrides: [
          kanjiHomeSummaryProvider.overrideWith((ref) => completer.future),
        ],
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('kanji_today_loading')), findsOneWidget);
    expect(find.text("Preparing today's kanji"), findsOneWidget);
  });

  testWidgets('kanji grid shows bounded copy while level data resolves', (
    tester,
  ) async {
    await _mockRadicalsAsset();
    final completer = Completer<List<KanjiItem>>();
    final baseRepo = _buildRepo();
    final repo = _SlowKanjiHubLessonRepository(
      pendingN5Kanji: completer.future,
      n5Kanji: baseRepo.n5Kanji,
      n4Kanji: baseRepo.n4Kanji,
      n3Kanji: baseRepo.n3Kanji,
      n2Kanji: baseRepo.n2Kanji,
      n1Kanji: baseRepo.n1Kanji,
    );

    await tester.pumpWidget(
      _buildSubject(
        repo: repo,
        language: AppLanguage.vi,
        overrides: [
          kanjiHomeSummaryProvider.overrideWith(
            (ref) async => const KanjiHomeSummary(
              levelCode: 'N5',
              dueCount: 0,
              newCount: 12,
              exploreCount: 185,
            ),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const ValueKey('kanji_grid_loading')), findsOneWidget);
    expect(find.text('Đang chuẩn bị lưới kanji N5'), findsOneWidget);
    expect(find.textContaining('đang nạp dữ liệu lần đầu'), findsOneWidget);
  });

  testWidgets('kanji hub shows retry card when today summary fails', (
    tester,
  ) async {
    await _mockRadicalsAsset();

    await tester.pumpWidget(
      _buildSubject(
        repo: _buildRepo(),
        overrides: [
          kanjiHomeSummaryProvider.overrideWith(
            (ref) async => throw Exception('boom'),
          ),
        ],
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byKey(const ValueKey('kanji_today_error')), findsOneWidget);
    expect(find.text('Could not load kanji summary'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('kanji search matches kanji, readings, and Vietnamese hanviet', (
    tester,
  ) async {
    await _mockRadicalsAsset();
    await tester.pumpWidget(_buildSubject(repo: _buildRepo()));
    await _pumpKanjiHub(tester);

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    final hocWithTone = String.fromCharCodes([0x68, 0x1ecd, 0x63]);
    for (final query in [
      '\u5b66',
      'hoc',
      hocWithTone,
      'gaku',
      'manabu',
      'gakkou',
    ]) {
      await tester.enterText(searchField, query);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('\u5b66'), findsWidgets, reason: 'query=$query');
      expect(find.text('bright'), findsNothing, reason: 'query=$query');
    }

    await tester.enterText(searchField, 'xyz');
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('empty_state')), findsOneWidget);
    expect(find.text('\\u5b66'), findsNothing);
  });

  testWidgets('radical group headers render Vietnamese tone marks', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2000, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    await tester.pumpWidget(
      _buildSubject(repo: _buildRepo(), language: AppLanguage.vi),
    );
    await _pumpKanjiHub(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('kanji_collection_radicals')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('kanji_collection_radicals')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('4 nét'), findsWidgets);
    expect(find.text('1 bộ thủ'), findsOneWidget);
    expect(find.text('4 n?t'), findsNothing);
    expect(find.text('1 b? th?'), findsNothing);
  });

  testWidgets('kanji hub renders N2 and N1 collection tabs and loads entries', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    await tester.pumpWidget(
      _buildSubject(repo: _buildRepo(), language: AppLanguage.vi),
    );
    await _pumpKanjiHub(tester);

    expect(find.byKey(const ValueKey('kanji_collection_n2')), findsOneWidget);
    expect(find.byKey(const ValueKey('kanji_collection_n1')), findsOneWidget);
    expect(find.text('Trung cao cấp'), findsOneWidget);
    expect(find.text('Cao cấp'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('kanji_collection_n2')),
    );
    await tester.tap(find.byKey(const ValueKey('kanji_collection_n2')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('\u66dc'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey('kanji_collection_n1')),
    );
    await tester.tap(find.byKey(const ValueKey('kanji_collection_n1')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('\u9b31'), findsOneWidget);
  });

  testWidgets('Han-Viet rules action is visible only in Vietnamese', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    await tester.pumpWidget(
      _buildSubject(repo: _buildRepo(), language: AppLanguage.vi),
    );
    await _pumpKanjiHub(tester);

    expect(
      find.byKey(const ValueKey('kanji_han_viet_rules_button')),
      findsOneWidget,
    );

    await tester.pumpWidget(Container());
    await tester.pump();
    await _mockRadicalsAsset();
    await tester.pumpWidget(
      _buildSubject(repo: _buildRepo(), language: AppLanguage.en),
    );
    await _pumpKanjiHub(tester);

    expect(
      find.byKey(const ValueKey('kanji_han_viet_rules_button')),
      findsNothing,
    );
  });

  testWidgets('study flow kanji card returns from radicals to kanji grid', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    await tester.pumpWidget(_buildSubject(repo: _buildRepo()));
    await _pumpKanjiHub(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('kanji_collection_radicals')),
    );
    await tester.tap(find.byKey(const ValueKey('kanji_collection_radicals')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('\u660e'), findsNothing);
    expect(find.text('\u65e5'), findsWidgets);

    await tester.ensureVisible(find.byKey(const ValueKey('kanji_flow_target')));
    final kanjiFlowTopLeft = tester.getTopLeft(
      find.byKey(const ValueKey('kanji_flow_target')),
    );
    await tester.tapAt(kanjiFlowTopLeft + const Offset(12, 12));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('\u660e'), findsWidgets);
  });

  testWidgets(
    'JA related kanji previews do not show Vietnamese fallback text',
    (tester) async {
      tester.view.physicalSize = const Size(1600, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _mockRadicalsAsset();
      final repo = _FakeKanjiHubLessonRepository(
        n5Kanji: const [
          KanjiItem(
            id: 20,
            lessonId: 1,
            character: '\u660e',
            strokeCount: 8,
            meaning: 'sáng',
            meaningEn: 'bright',
            examples: [],
            jlptLevel: 'N5',
            decomposition: KanjiDecomposition(relatedKanji: ['\u65e5']),
          ),
          KanjiItem(
            id: 21,
            lessonId: 1,
            character: '\u65e5',
            strokeCount: 4,
            meaning: 'mặt trời',
            examples: [
              KanjiExample(
                word: '\u65e5\u672c',
                reading: '\u306b\u307b\u3093',
                meaning: 'Nhật Bản',
              ),
            ],
            jlptLevel: 'N5',
          ),
        ],
        n4Kanji: const [],
        n3Kanji: const [],
        n2Kanji: const [],
        n1Kanji: const [],
      );
      await tester.pumpWidget(
        _buildSubject(repo: repo, language: AppLanguage.ja),
      );
      await _pumpKanjiHub(tester);

      await tester.tap(find.text('\u660e').first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('mặt trời'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('preview_N5_\u65e5')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('mặt trời'), findsNothing);
      expect(find.textContaining('Nhật Bản'), findsNothing);
    },
  );

  testWidgets('kanji hub follows async persisted level after first frame', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    final repo = _buildRepo();
    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        appLanguageProvider.overrideWith(
          (ref) => AppLanguageController.test(AppLanguage.en),
        ),
        lessonRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    container.read(studyLevelProvider.notifier).state = StudyLevel.n5;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: KanjiHubScreen()),
      ),
    );
    await _pumpKanjiHub(tester);

    container.read(studyLevelProvider.notifier).state = StudyLevel.n2;
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('\u66dc'), findsOneWidget);
    expect(find.text('\u660e'), findsNothing);
  });

  testWidgets('kanji detail dialog includes related kanji study groups', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    await tester.pumpWidget(
      _buildSubject(repo: _buildRepo(), language: AppLanguage.vi),
    );
    await _pumpKanjiHub(tester);

    await tester.tap(find.text('\u660e').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.byKey(const ValueKey('kanji_detail_study_flow')),
      findsOneWidget,
    );
    expect(find.text('Mở tất cả (2)'), findsOneWidget);
    expect(find.text('Nhóm N4 \u2014 1 kanji'), findsOneWidget);
    expect(find.text('Nhóm N3 \u2014 1 kanji'), findsOneWidget);
  });

  testWidgets('Vietnamese kanji detail shows Han-Viet learning aids', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    await tester.pumpWidget(
      _buildSubject(repo: _buildRepo(), language: AppLanguage.vi),
    );
    await _pumpKanjiHub(tester);

    await tester.tap(find.text('\u5b66').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.byKey(const ValueKey('kanji_detail_han_viet_row')),
      findsOneWidget,
    );
    expect(find.text('Liên tưởng mái trường khi học chữ này.'), findsOneWidget);
  });

  testWidgets('kanji example word opens sourced conjugation practice', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _mockRadicalsAsset();
    final repo = _FakeKanjiHubLessonRepository(
      n5Kanji: const [
        KanjiItem(
          id: 8,
          lessonId: 10,
          character: '帰',
          strokeCount: 10,
          meaning: 'trở về',
          meaningEn: 'return',
          examples: [
            KanjiExample(
              word: '帰る',
              reading: 'かえる',
              meaning: 'trở về',
              meaningEn: 'return',
              sourceVocabId: 'haj_n5_ch10_v033',
            ),
          ],
          jlptLevel: 'N5',
        ),
      ],
      n4Kanji: const [],
      n3Kanji: const [],
      n2Kanji: const [],
      n1Kanji: const [],
    );
    await tester.pumpWidget(
      _buildRoutedSubject(
        repo: repo,
        overrides: [
          conjugationRepositoryProvider.overrideWithValue(
            _FakeKanjiConjugationRepository(),
          ),
        ],
      ),
    );
    await _pumpKanjiHub(tester);

    await tester.ensureVisible(find.text('帰').first);
    await tester.tap(find.text('帰').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('帰る'), findsOneWidget);
    expect(find.text('Luyện chia thể'), findsOneWidget);
    await tester.tap(find.text('Luyện chia thể'));
    await tester.pumpAndSettle();

    expect(find.text('conjugation:21438'), findsOneWidget);
  });

  testWidgets('English and Japanese kanji detail hide Han-Viet aids', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final language in [AppLanguage.en, AppLanguage.ja]) {
      await _mockRadicalsAsset();
      await tester.pumpWidget(
        _buildSubject(repo: _buildRepo(), language: language),
      );
      await _pumpKanjiHub(tester);

      await tester.tap(find.text('\u5b66').first);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.byKey(const ValueKey('kanji_detail_han_viet_row')),
        findsNothing,
        reason: 'language=$language',
      );
      expect(
        find.byKey(const ValueKey('han_viet_inline_panel')),
        findsNothing,
        reason: 'language=$language',
      );
      if (language == AppLanguage.en) {
        expect(
          find.text('Picture a student under a school roof.'),
          findsOneWidget,
        );
      }

      await tester.pumpWidget(Container());
      await tester.pump();
    }
  });
}
