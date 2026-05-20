import 'dart:io';

import 'package:jpstudy/core/conjugation/conjugation_lemma_builder.dart';

Future<void> main(List<String> args) async {
  final contentRoot = Directory(
    _optionalValue(args, '--content-root') ?? 'assets/data/content',
  );
  final jmdictCache = File(
    _optionalValue(args, '--jmdict-cache') ??
        'tooling/_tmpcache/jmdict_kanjidic/parsed/jmdict_e_min.json',
  );
  final output = File(
    _optionalValue(args, '--output') ??
        'assets/data/content/conjugation/lemmas.json',
  );
  final generatedAtText = _optionalValue(args, '--generated-at');
  final generatedAt = generatedAtText == null
      ? null
      : DateTime.parse(generatedAtText).toUtc();

  final report = await ConjugationLemmaBuilder.build(
    contentRoot: contentRoot,
    jmdictCache: jmdictCache,
    generatedAt: generatedAt,
  );

  await output.parent.create(recursive: true);
  await output.writeAsString(report.toPrettyJson());
  stdout.writeln(report.toSummaryJson());
}

String? _optionalValue(List<String> args, String name) {
  final index = args.indexOf(name);
  if (index < 0 || index + 1 >= args.length) return null;
  return args[index + 1];
}
