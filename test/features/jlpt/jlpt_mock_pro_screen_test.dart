import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/jlpt/data/jlpt_mock_bank.dart';
import 'package:jpstudy/features/jlpt/models/jlpt_coach_models.dart';
import 'package:jpstudy/features/jlpt/models/jlpt_mock_models.dart';
import 'package:jpstudy/features/jlpt/screens/jlpt_mock_pro_screen.dart';

void main() {
  const mockSections = <JlptMockSection>[
    JlptMockSection(
      id: 'vocab',
      title: 'Vocabulary',
      minutes: 8,
      questions: [
        JlptMockQuestion(
          id: 'v-1',
          area: JlptSkillArea.vocabulary,
          prompt: '"予約" có nghĩa là gì?',
          options: ['Đặt trước', 'Hủy lịch', 'Rời đi ngay', 'Mượn tiền'],
          correctIndex: 0,
          explanation: '予約 = đặt trước.',
        ),
        JlptMockQuestion(
          id: 'v-2',
          area: JlptSkillArea.vocabulary,
          prompt: '"毎週" có nghĩa là gì?',
          options: ['Mỗi tuần', 'Mỗi tháng', 'Mỗi ngày', 'Mỗi năm'],
          correctIndex: 0,
          explanation: '毎週 = mỗi tuần.',
        ),
      ],
    ),
  ];

  testWidgets('JlptMockProScreen hiển thị nhãn tiếng Việt đúng', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
          studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
          jlptMockSectionsProvider((
            level: StudyLevel.n5,
            language: AppLanguage.vi,
          )).overrideWith((ref) async => mockSections),
        ],
        child: const MaterialApp(home: JlptMockProScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Đề thi thử JLPT Pro'), findsWidgets);
    expect(
      find.text(
        'Mô phỏng đủ phần thi, có bấm giờ theo từng section và dự đoán khả năng đậu.',
      ),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Bắt đầu thi thử đầy đủ'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final startButton = find.text('Bắt đầu thi thử đầy đủ');
    expect(startButton, findsOneWidget);

    await tester.tap(startButton);
    await tester.pump();

    expect(find.text('Kết thúc ngay'), findsOneWidget);
    expect(find.text('Câu tiếp'), findsOneWidget);
  });

  testWidgets('JlptMockProScreen uses select then confirm for answers', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.vi),
          ),
          studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
          jlptMockSectionsProvider((
            level: StudyLevel.n5,
            language: AppLanguage.vi,
          )).overrideWith((ref) async => mockSections),
        ],
        child: const MaterialApp(home: JlptMockProScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.scrollUntilVisible(
      find.text('Bắt đầu thi thử đầy đủ'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Bắt đầu thi thử đầy đủ'));
    await tester.pump();

    expect(find.text('Tiến độ toàn bài • 0/2 đã làm'), findsOneWidget);
    expect(find.text('Trả lời'), findsOneWidget);

    await tester.tap(find.text('Đặt trước'));
    await tester.pump();

    expect(find.text('Tiến độ toàn bài • 0/2 đã làm'), findsOneWidget);

    await tester.tap(find.text('Trả lời'));
    await tester.pump();

    expect(find.text('Tiến độ toàn bài • 1/2 đã làm'), findsOneWidget);
  });

  testWidgets(
    'JlptMockProScreen mobile keeps all answers and confirm visible',
    (tester) async {
      tester.view.physicalSize = const Size(390, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appLanguageProvider.overrideWith(
              (ref) => AppLanguageController.test(AppLanguage.en),
            ),
            studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
            jlptMockSectionsProvider((
              level: StudyLevel.n5,
              language: AppLanguage.en,
            )).overrideWith((ref) async => mockSections),
          ],
          child: const MaterialApp(home: JlptMockProScreen()),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.scrollUntilVisible(
        find.text('Start full mock'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Start full mock'));
      await tester.pump();
      tester.view.physicalSize = const Size(390, 430);
      await tester.pump();

      for (final label in [
        'Đặt trước',
        'Hủy lịch',
        'Rời đi ngay',
        'Mượn tiền',
        'Answer',
      ]) {
        final finder = find.text(label);
        expect(finder, findsOneWidget);
        expect(finder.hitTestable(), findsOneWidget);
        expect(tester.getBottomLeft(finder).dy, lessThanOrEqualTo(430));
      }
    },
  );
}
