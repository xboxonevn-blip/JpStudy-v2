import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/navigation/app_navigation_extensions.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/utils/grammar_english_notation.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

import '../../../data/db/app_database.dart';
import '../../../data/models/grammar_directive_e_content.dart';
import '../../../data/repositories/grammar_repository.dart';
import '../../conjugation/models/conjugation_practice_args.dart';
import '../../common/widgets/compact_ui.dart';
import '../../interlink/widgets/related_section.dart';
import '../widgets/grammar_directive_e_section.dart';
import '../widgets/grammar_example_widget.dart';
import 'grammar_practice_screen.dart';

class GrammarDetailScreen extends ConsumerWidget {
  const GrammarDetailScreen({super.key, required this.grammarId});

  final int grammarId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    final grammarAsync = ref.watch(grammarDetailProvider(grammarId));

    return Scaffold(
      appBar: AppBar(title: Text(_title(language))),
      body: grammarAsync.when(
        data: (data) {
          if (data == null) {
            return Center(child: Text(_notFound(language)));
          }

          final point = data.point;
          final examples = data.examples;
          final headline = _resolveHeadline(point, language);
          final meaning = _resolveMeaning(point, language);
          final connection = _resolveConnection(point, language);
          final explanation = _resolveExplanation(point, language);
          final conjugationFormKeys = _conjugationFormKeys(point);
          final directiveE = _buildDirectiveE(
            point,
            language,
            content: data.directiveE,
            form: connection,
            meaning: meaning,
            explanation: explanation,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFeatureCard(
                  icon: Icons.auto_stories_rounded,
                  title: headline,
                  subtitle: meaning,
                  status: AppStatusChip(
                    label: _statusLabel(language, point.isLearned),
                    tone: point.isLearned
                        ? AppStatusTone.success
                        : AppStatusTone.warning,
                  ),
                  primaryLabel: _practiceCheckLabel(language),
                  onPrimaryTap: () => context.openGrammarPractice(
                    extra: {
                      'ids': [grammarId],
                      'sessionType': GrammarSessionType.quick,
                      'blueprint': GrammarPracticeBlueprint.quiz,
                      'goalProfile': GrammarGoalProfile.balanced,
                      'gateGrammarId': grammarId,
                      'targetCount': 50,
                    },
                  ),
                  secondaryLabel: conjugationFormKeys.isEmpty
                      ? null
                      : _relatedConjugationLabel(language),
                  onSecondaryTap: conjugationFormKeys.isEmpty
                      ? null
                      : () => context.openConjugationPractice(
                          ConjugationPracticeArgs(
                            formKeys: conjugationFormKeys,
                            targetCount: 50,
                            source: 'grammar_detail',
                            grammarId: grammarId,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                AppStatusChip(
                  label: point.jlptLevel,
                  tone: AppStatusTone.primary,
                ),
                const SizedBox(height: 20),
                directiveE,
                if (examples.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _GrammarExamplesSection(
                    examples: examples,
                    language: language,
                  ),
                ],
                const SizedBox(height: 24),
                RelatedSection.lookup(
                  type: 'grammar',
                  level: point.jlptLevel,
                  lookupId:
                      'grammar:${point.jlptLevel.toLowerCase()}:$grammarId',
                  label: point.grammarPoint,
                  language: language,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('${language.loadErrorLabel}: $err')),
      ),
      floatingActionButton: null,
    );
  }

  String _resolveMeaning(GrammarPoint point, AppLanguage language) {
    return switch (language) {
      AppLanguage.en => resolveEnglishGrammarMeaning(
        meaningEn: point.meaningEn,
        titleEn: point.titleEn,
        connectionEn: point.connectionEn,
        connection: point.connection,
        grammarPoint: point.grammarPoint,
      ),
      AppLanguage.vi => (point.meaningVi ?? point.meaning).trim(),
      AppLanguage.ja => point.meaning.trim(),
    };
  }

  String _resolveHeadline(GrammarPoint point, AppLanguage language) {
    return switch (language) {
      AppLanguage.en => resolveEnglishGrammarConnection(
        connectionEn: point.connectionEn,
        connection: point.connection,
        grammarPoint: point.grammarPoint,
        titleEn: point.titleEn,
        meaningEn: point.meaningEn,
      ),
      AppLanguage.vi => point.grammarPoint.trim(),
      AppLanguage.ja => point.grammarPoint.trim(),
    };
  }

  String _resolveConnection(GrammarPoint point, AppLanguage language) {
    return switch (language) {
      AppLanguage.en => resolveEnglishGrammarConnection(
        connectionEn: point.connectionEn,
        connection: point.connection,
        grammarPoint: point.grammarPoint,
        titleEn: point.titleEn,
        meaningEn: point.meaningEn,
      ),
      AppLanguage.vi => point.connection.trim(),
      AppLanguage.ja => point.connection.trim(),
    };
  }

  String _resolveExplanation(GrammarPoint point, AppLanguage language) {
    return switch (language) {
      AppLanguage.en => resolveEnglishGrammarExplanation(
        explanationEn: point.explanationEn,
        explanation: point.explanation,
        label: _resolveMeaning(point, language),
      ),
      AppLanguage.vi => (point.explanationVi ?? point.explanation).trim(),
      AppLanguage.ja => point.explanation.trim(),
    };
  }

  GrammarDirectiveESection _buildDirectiveE(
    GrammarPoint point,
    AppLanguage language, {
    required GrammarDirectiveEContent? content,
    required String form,
    required String meaning,
    required String explanation,
  }) {
    final crossLinks = _crossLinksFromContent(content);
    return GrammarDirectiveESection(
      language: language,
      form: _preferContent(content?.form, form),
      meaning: _preferContent(content?.meaning, meaning),
      usage: _preferContent(content?.usage, _usageSummary(explanation)),
      etymology: _preferContent(
        content?.etymologyWithBridge,
        _etymologyText(point, language, form),
      ),
      humanMoment: _preferContent(
        content?.humanMoment,
        _humanMomentText(point, language),
      ),
      crossLinks: crossLinks.isEmpty
          ? _crossLinksFor(point, language)
          : crossLinks,
      fallbackReference: _fallbackReference(content?.fallbackReference),
    );
  }

  String _preferContent(String? primary, String fallback) {
    final value = primary?.trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  List<GrammarCrossLink> _crossLinksFromContent(
    GrammarDirectiveEContent? content,
  ) {
    if (content == null) return const [];
    return [
      for (final link in content.crossLinks)
        if (link.pattern.trim().isNotEmpty && link.contrast.trim().isNotEmpty)
          GrammarCrossLink(
            pattern: link.pattern.trim(),
            contrast: link.contrast.trim(),
          ),
    ];
  }

  GrammarFallbackReference _fallbackReference(
    GrammarDirectiveEFallbackReference? reference,
  ) {
    if (reference == null) {
      return const GrammarFallbackReference(
        sourceCredit: "Tae Kim's Guide to Japanese Grammar",
        license: 'CC-BY-NC-SA 3.0',
        sourceUrl: 'https://guidetojapanese.org/learn/grammar',
      );
    }
    return GrammarFallbackReference(
      sourceCredit: reference.sourceCredit,
      license: reference.license,
      sourceUrl: reference.sourceUrl,
    );
  }

  String _usageSummary(String explanation) {
    final cleaned = explanation.trim();
    if (cleaned.isEmpty) return '';
    final matches = RegExp(r'[^.!?。！？]+[.!?。！？]?')
        .allMatches(cleaned)
        .map((match) => match.group(0)!.trim())
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList(growable: false);
    return matches.isEmpty ? cleaned : matches.join(' ');
  }

  String _etymologyText(GrammarPoint point, AppLanguage language, String form) {
    final pattern = point.grammarPoint.trim();
    return switch (language) {
      AppLanguage.en =>
        'Root: read $pattern through its visible structure, $form. '
            'For Vietnamese learners, separate the grammar frame from the word '
            'meaning first; the frame carries the relation between clauses.',
      AppLanguage.vi =>
        'Gốc rễ: hãy đọc $pattern qua khung $form. Cầu Hán-Việt ở đây '
            'không phải dịch từng chữ, mà tách phần từ vựng ra khỏi khung ngữ '
            'pháp; chính khung đó cho biết câu đang xin phép, cấm đoán, nêu chủ '
            'đề, hay nối ý.',
      AppLanguage.ja =>
        '語源メモ: $pattern は $form という形で働きます。語彙の意味と文法の枠を分けて読むと、文の関係が見えます。',
    };
  }

  String _humanMomentText(GrammarPoint point, AppLanguage language) {
    final pattern = point.grammarPoint.trim();
    return switch (language) {
      AppLanguage.en =>
        'Dr. Linh note: do not memorize $pattern as one translated label. '
            'Ask what the speaker is doing with the sentence, then choose the '
            'Vietnamese wording.',
      AppLanguage.vi =>
        'Lưu ý từ Dr. Linh: đừng học $pattern như một nhãn dịch cố định. '
            'Hãy hỏi người nói đang làm gì với câu này rồi mới chọn cách nói '
            'tiếng Việt.',
      AppLanguage.ja => 'Dr. Linh メモ: $pattern を訳語だけで覚えず、話し手の目的を先に見ます。',
    };
  }

  List<GrammarCrossLink> _crossLinksFor(
    GrammarPoint point,
    AppLanguage language,
  ) {
    final haystack = [
      point.grammarPoint,
      point.connection,
      point.explanation,
    ].join('\n');
    if (haystack.contains('てもいい')) {
      return [
        GrammarCrossLink(
          pattern: 'てはいけない',
          contrast: switch (language) {
            AppLanguage.en => 'Permission versus prohibition.',
            AppLanguage.vi => 'Một bên là được phép; một bên là bị cấm.',
            AppLanguage.ja => '許可と禁止の違いです。',
          },
        ),
      ];
    }
    if (haystack.contains('てはいけない')) {
      return [
        GrammarCrossLink(
          pattern: 'てもいい',
          contrast: switch (language) {
            AppLanguage.en => 'Prohibition versus permission.',
            AppLanguage.vi => 'Một bên là bị cấm; một bên là được phép.',
            AppLanguage.ja => '禁止と許可の違いです。',
          },
        ),
      ];
    }
    if (haystack.contains('は')) {
      return [
        GrammarCrossLink(
          pattern: 'が',
          contrast: switch (language) {
            AppLanguage.en =>
              'Topic marker versus focus/new-information marker.',
            AppLanguage.vi =>
              'は dựng chủ đề; が đẩy trọng tâm hoặc thông tin mới lên trước.',
            AppLanguage.ja => '話題の は と焦点の が を分けます。',
          },
        ),
      ];
    }
    if (haystack.contains('が')) {
      return [
        GrammarCrossLink(
          pattern: 'は',
          contrast: switch (language) {
            AppLanguage.en => 'Focus/new information versus topic marker.',
            AppLanguage.vi =>
              'が nêu trọng tâm; は dựng nền chủ đề cho phần sau.',
            AppLanguage.ja => '焦点の が と話題の は を分けます。',
          },
        ),
      ];
    }
    return [
      GrammarCrossLink(
        pattern: point.connection.trim(),
        contrast: switch (language) {
          AppLanguage.en => 'Compare with patterns that reuse the same form.',
          AppLanguage.vi =>
            'So với các mẫu dùng cùng hình thức, hãy nhìn chức năng trong câu.',
          AppLanguage.ja => '同じ形を使う文型とは、文中の機能で比べます。',
        },
      ),
    ];
  }

  String _title(AppLanguage language) {
    return switch (language) {
      AppLanguage.en => 'Grammar',
      AppLanguage.vi => 'Điểm ngữ pháp',
      AppLanguage.ja => '文法ポイント',
    };
  }

  String _notFound(AppLanguage language) {
    return switch (language) {
      AppLanguage.en => 'Grammar point not found.',
      AppLanguage.vi => 'Không tìm thấy điểm ngữ pháp.',
      AppLanguage.ja => '文法ポイントが見つかりません。',
    };
  }

  String _practiceCheckLabel(AppLanguage language) {
    return switch (language) {
      AppLanguage.en => 'Practice check',
      AppLanguage.vi => 'Luyện tập để hiểu',
      AppLanguage.ja => '理解チェック',
    };
  }

  String _relatedConjugationLabel(AppLanguage language) {
    return switch (language) {
      AppLanguage.en => 'Practice related forms',
      AppLanguage.vi => 'Luyện chia thể liên quan',
      AppLanguage.ja => '関連する活用を練習',
    };
  }

  String _statusLabel(AppLanguage language, bool isLearned) {
    if (isLearned) {
      return switch (language) {
        AppLanguage.en => 'Understood ✓',
        AppLanguage.vi => 'Đã hiểu ✓',
        AppLanguage.ja => '理解済み ✓',
      };
    }
    return switch (language) {
      AppLanguage.en => 'In progress',
      AppLanguage.vi => 'Đang học',
      AppLanguage.ja => '学習中',
    };
  }

  List<String> _conjugationFormKeys(GrammarPoint point) {
    final haystack = [
      point.grammarPoint,
      point.connection,
      point.connectionEn ?? '',
      point.explanation,
      point.explanationVi ?? '',
      point.explanationEn ?? '',
    ].join('\n').toLowerCase();
    final keys = <String>[];
    void addIf(bool condition, String key) {
      if (condition && !keys.contains(key)) keys.add(key);
    }

    addIf(
      haystack.contains('vて') ||
          haystack.contains('v-て') ||
          haystack.contains('verbて') ||
          haystack.contains('verb-て') ||
          haystack.contains('て形') ||
          haystack.contains('thể `て`') ||
          haystack.contains('te-form'),
      'te',
    );
    addIf(
      haystack.contains('vない') ||
          haystack.contains('v-ない') ||
          haystack.contains('verbない') ||
          haystack.contains('verb-ない') ||
          haystack.contains('ない形') ||
          haystack.contains('nai-form') ||
          haystack.contains('negative form'),
      'nai',
    );
    addIf(
      haystack.contains('vた') ||
          haystack.contains('v-た') ||
          haystack.contains('verbた') ||
          haystack.contains('verb-た') ||
          haystack.contains('た形') ||
          haystack.contains('past form'),
      'ta',
    );
    addIf(
      haystack.contains('vます') ||
          haystack.contains('v-ます') ||
          haystack.contains('verbます') ||
          haystack.contains('verb-ます') ||
          haystack.contains('ます形') ||
          haystack.contains('polite form'),
      'masu',
    );
    return keys;
  }
}

class _GrammarExamplesSection extends StatefulWidget {
  const _GrammarExamplesSection({
    required this.examples,
    required this.language,
  });

  final List<GrammarExample> examples;
  final AppLanguage language;

  @override
  State<_GrammarExamplesSection> createState() =>
      _GrammarExamplesSectionState();
}

class _GrammarExamplesSectionState extends State<_GrammarExamplesSection>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.examples.length < 10;

  @override
  Widget build(BuildContext context) {
    final shouldCollapse = widget.examples.length >= 10;
    return AppSection(
      title: _title(widget.language),
      caption: _caption(widget.language, widget.examples.length),
      trailing: shouldCollapse
          ? Semantics(
              button: true,
              expanded: _expanded,
              child: AppButton(
                label: _expanded
                    ? _hideLabel(widget.language)
                    : _showLabel(widget.language),
                icon: _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                variant: AppButtonVariant.ghost,
                compact: false,
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            )
          : null,
      child: AppCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(16),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: _expanded
              ? _GrammarExampleList(
                  examples: widget.examples,
                  language: widget.language,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  String _title(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Examples',
    AppLanguage.vi => 'Ví dụ',
    AppLanguage.ja => '例文',
  };

  String _caption(AppLanguage language, int count) => switch (language) {
    AppLanguage.en => '$count example sentences',
    AppLanguage.vi => '$count câu ví dụ',
    AppLanguage.ja => '$count例',
  };

  String _showLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Show examples',
    AppLanguage.vi => 'Xem ví dụ',
    AppLanguage.ja => '例を見る',
  };

  String _hideLabel(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Hide examples',
    AppLanguage.vi => 'Ẩn ví dụ',
    AppLanguage.ja => '例を閉じる',
  };
}

class _GrammarExampleList extends StatelessWidget {
  const _GrammarExampleList({required this.examples, required this.language});

  final List<GrammarExample> examples;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: examples.length,
      separatorBuilder: (context, index) => const AppDivider(),
      itemBuilder: (context, index) {
        final ex = examples[index];
        return GrammarExampleWidget(
          language: language,
          japanese: ex.japanese,
          translation: ex.translation,
          translationVi: ex.translationVi,
          translationEn: ex.translationEn,
          showVietnamese: true,
        );
      },
    );
  }
}

final grammarDetailProvider =
    FutureProvider.family<
      ({
        GrammarPoint point,
        List<GrammarExample> examples,
        GrammarDirectiveEContent? directiveE,
      })?,
      int
    >((ref, id) {
      final repo = ref.watch(grammarRepositoryProvider);
      return repo.getGrammarDetail(id);
    });
