class GrammarDirectiveEContent {
  const GrammarDirectiveEContent({
    required this.form,
    required this.meaning,
    required this.usage,
    required this.etymology,
    required this.hanVietBridge,
    required this.humanMoment,
    required this.crossLinks,
    required this.fallbackReference,
  });

  final String form;
  final String meaning;
  final String usage;
  final String etymology;
  final String hanVietBridge;
  final String humanMoment;
  final List<GrammarDirectiveECrossLink> crossLinks;
  final GrammarDirectiveEFallbackReference fallbackReference;

  String get etymologyWithBridge {
    final parts = [etymology, hanVietBridge]
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    return parts.join('\n\n');
  }

  factory GrammarDirectiveEContent.fromJson(Map<String, dynamic> json) {
    return GrammarDirectiveEContent(
      form: _string(json['form']),
      meaning: _string(json['meaning']),
      usage: _string(json['usage']),
      etymology: _string(json['etymology']),
      hanVietBridge: _string(json['hanVietBridge']),
      humanMoment: _string(json['humanMoment']),
      crossLinks: _crossLinks(json['crossLinks']),
      fallbackReference: GrammarDirectiveEFallbackReference.fromJson(
        json['fallbackReference'],
      ),
    );
  }

  static String _string(Object? value) => (value ?? '').toString().trim();

  static List<GrammarDirectiveECrossLink> _crossLinks(Object? value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is Map)
          GrammarDirectiveECrossLink.fromJson(item.cast<String, dynamic>()),
    ];
  }
}

class GrammarDirectiveECrossLink {
  const GrammarDirectiveECrossLink({
    required this.pattern,
    required this.contrast,
  });

  final String pattern;
  final String contrast;

  factory GrammarDirectiveECrossLink.fromJson(Map<String, dynamic> json) {
    return GrammarDirectiveECrossLink(
      pattern: (json['pattern'] ?? '').toString().trim(),
      contrast: (json['contrast'] ?? '').toString().trim(),
    );
  }
}

class GrammarDirectiveEFallbackReference {
  const GrammarDirectiveEFallbackReference({
    required this.sourceCredit,
    required this.license,
    required this.sourceUrl,
  });

  final String sourceCredit;
  final String license;
  final String sourceUrl;

  factory GrammarDirectiveEFallbackReference.fromJson(Object? value) {
    if (value is! Map) {
      return const GrammarDirectiveEFallbackReference(
        sourceCredit: "Tae Kim's Guide to Japanese Grammar",
        license: 'CC-BY-NC-SA 3.0',
        sourceUrl: 'https://guidetojapanese.org/learn/grammar',
      );
    }
    final json = value.cast<String, dynamic>();
    return GrammarDirectiveEFallbackReference(
      sourceCredit:
          (json['sourceCredit'] ?? "Tae Kim's Guide to Japanese Grammar")
              .toString()
              .trim(),
      license: (json['license'] ?? 'CC-BY-NC-SA 3.0').toString().trim(),
      sourceUrl:
          (json['sourceUrl'] ?? 'https://guidetojapanese.org/learn/grammar')
              .toString()
              .trim(),
    );
  }
}
