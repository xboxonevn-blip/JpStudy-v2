import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/vocab/widgets/flashcard_widget.dart';
import '../common/widgets/clay_button.dart';
import '../common/widgets/clay_card.dart';
import '../../theme/app_theme_v2.dart';

class VocabScreen extends ConsumerStatefulWidget {
  const VocabScreen({super.key});

  @override
  ConsumerState<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends ConsumerState<VocabScreen> {
  bool _isFlashcardMode = false;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final level = ref.watch(studyLevelProvider);
    final levelSuffix = level == null ? '' : ' (${level.shortLabel})';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${language.vocabTitle}$levelSuffix'),
        actions: [
          if (level != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(_isFlashcardMode ? Icons.list_rounded : Icons.style_rounded),
                tooltip: _isFlashcardMode
                    ? 'Switch to List View'
                    : 'Switch to Flashcards',
                onPressed: () {
                  setState(() {
                    _isFlashcardMode = !_isFlashcardMode;
                  });
                },
              ),
            ),
        ],
      ),
      body: level == null
          ? Center(child: Text(language.selectLevelToViewVocab))
          : _VocabContent(
              language: language,
              level: level,
              isFlashcardMode: _isFlashcardMode,
            ),
    );
  }
}

class _VocabContent extends ConsumerWidget {
  const _VocabContent({
    required this.language,
    required this.level,
    required this.isFlashcardMode,
  });

  final AppLanguage language;
  final StudyLevel level;
  final bool isFlashcardMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabPreviewProvider(level.shortLabel));
    final dueTermsAsync = ref.watch(allDueTermsProvider);

    return vocabAsync.when(
      data: (dataItems) {
        if (dataItems.isEmpty) {
          return Center(child: Text(language.vocabScreenBody));
        }
        // Map database entities (VocabData) to domain models (VocabItem)
        final items = dataItems.map((e) => VocabItem(
          id: e.id,
          term: e.term,
          reading: e.reading,
          meaning: e.meaning,
          meaningEn: e.meaningEn,
          kanjiMeaning: null,
          level: e.level,
        )).toList();

        return Column(
          children: [
            if (dueTermsAsync.hasValue && dueTermsAsync.value!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClayButton(
                  label: '${language.reviewAction} (${dueTermsAsync.value!.length})',
                  icon: Icons.rate_review,
                  style: ClayButtonStyle.primary,
                  isExpanded: true,
                  onPressed: () => context.push('/vocab/review'),
                ),
              ),
            Expanded(
              child: isFlashcardMode
                  ? _FlashcardView(items: items)
                  : _ListView(items: items, language: language),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text(language.loadErrorLabel)),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView({required this.items, required this.language});

  final List<VocabItem> items;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1, // Title + items
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              language.vocabPreviewTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          );
        }
        final item = items[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClayCard(
           color: Colors.white,
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                item.term,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item.reading == null || item.reading!.isEmpty
                    ? (language == AppLanguage.en ? (item.meaningEn ?? item.meaning) : item.meaning)
                    : '${item.reading} • ${language == AppLanguage.en ? (item.meaningEn ?? item.meaning) : item.meaning}',
                style: TextStyle(color: AppThemeV2.textSub),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlashcardView extends ConsumerStatefulWidget {
  const _FlashcardView({required this.items});

  final List<VocabItem> items;

  @override
  ConsumerState<_FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends ConsumerState<_FlashcardView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final progress = (_currentIndex + 1) / widget.items.length;
    
    return Column(
      children: [
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildProgressBar(progress),
        ),
        const SizedBox(height: 8),
        Text(
          '${_currentIndex + 1} / ${widget.items.length}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppThemeV2.textSub,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: FlashcardWidget(
                    item: widget.items[index],
                    language: language,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      height: 16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeV2.neutral,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppThemeV2.secondary,
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

