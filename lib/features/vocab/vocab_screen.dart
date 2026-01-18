import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/content_repository.dart';
import 'package:jpstudy/features/vocab/widgets/flashcard_widget.dart';
import 'package:jpstudy/core/services/tts_service.dart';

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
        title: Text('${language.vocabTitle}$levelSuffix'),
        actions: [
          if (level != null)
            IconButton(
              icon: Icon(_isFlashcardMode ? Icons.list : Icons.style),
              tooltip: _isFlashcardMode
                  ? 'Switch to List View'
                  : 'Switch to Flashcards',
              onPressed: () {
                setState(() {
                  _isFlashcardMode = !_isFlashcardMode;
                });
              },
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
          level: e.level,
        )).toList();

        if (isFlashcardMode) {
          return _FlashcardView(items: items);
        }
        return _ListView(items: items, language: language);
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          language.vocabPreviewTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item.term),
              subtitle: Text(
                item.reading == null || item.reading!.isEmpty
                    ? item.meaning
                    : '${item.reading} • ${item.meaning}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up, size: 20),
                onPressed: () {
                   final text = item.reading ?? item.term;
                   TtsService.instance.speak(text);
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _FlashcardView extends StatefulWidget {
  const _FlashcardView({required this.items});

  final List<VocabItem> items;

  @override
  State<_FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<_FlashcardView> {
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
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.items.length,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_currentIndex + 1} / ${widget.items.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: FlashcardWidget(item: widget.items[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

