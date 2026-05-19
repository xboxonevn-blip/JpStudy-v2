enum ConjugationKind { verb, adjective }

enum VerbClass {
  ichidan,
  godanU,
  godanKu,
  godanGu,
  godanSu,
  godanTsu,
  godanNu,
  godanBu,
  godanMu,
  godanRu,
  godanIkuException,
  suru,
  kuru,
  aruException,
}

enum AdjectiveClass { iAdjective, iiException, naAdjective }

class ConjugationSpec {
  const ConjugationSpec._({
    required this.kind,
    this.verbClass,
    this.adjectiveClass,
  });

  const ConjugationSpec.verb(VerbClass value)
    : this._(kind: ConjugationKind.verb, verbClass: value);

  const ConjugationSpec.adjective(AdjectiveClass value)
    : this._(kind: ConjugationKind.adjective, adjectiveClass: value);

  final ConjugationKind kind;
  final VerbClass? verbClass;
  final AdjectiveClass? adjectiveClass;

  static ConjugationSpec? fromJmDictPos(
    Iterable<String> posTags, {
    String? lemma,
  }) {
    final normalized = posTags
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .toList(growable: false);
    final lemmaText = (lemma ?? '').trim();

    bool has(String code, [String? descriptionNeedle]) {
      return normalized.any(
        (tag) =>
            tag == code ||
            tag.contains('&$code;') ||
            (descriptionNeedle != null && tag.contains(descriptionNeedle)),
      );
    }

    if (has('v5k-s', 'iku/yuku special class')) {
      return const ConjugationSpec.verb(VerbClass.godanIkuException);
    }
    if (has('v5r-i') && lemmaText == 'ある') {
      return const ConjugationSpec.verb(VerbClass.aruException);
    }
    if (has('vk', 'kuru verb')) {
      return const ConjugationSpec.verb(VerbClass.kuru);
    }
    if (has('vs') || has('vs-i') || has('vs-s')) {
      return const ConjugationSpec.verb(VerbClass.suru);
    }
    if (has('v1', 'ichidan verb')) {
      return const ConjugationSpec.verb(VerbClass.ichidan);
    }
    if (has('v5u')) return const ConjugationSpec.verb(VerbClass.godanU);
    if (has('v5k')) return const ConjugationSpec.verb(VerbClass.godanKu);
    if (has('v5g')) return const ConjugationSpec.verb(VerbClass.godanGu);
    if (has('v5s')) return const ConjugationSpec.verb(VerbClass.godanSu);
    if (has('v5t')) return const ConjugationSpec.verb(VerbClass.godanTsu);
    if (has('v5n')) return const ConjugationSpec.verb(VerbClass.godanNu);
    if (has('v5b')) return const ConjugationSpec.verb(VerbClass.godanBu);
    if (has('v5m')) return const ConjugationSpec.verb(VerbClass.godanMu);
    if (has('v5r')) return const ConjugationSpec.verb(VerbClass.godanRu);
    if (has('adj-ix') || lemmaText == 'いい') {
      return const ConjugationSpec.adjective(AdjectiveClass.iiException);
    }
    if (has('adj-i', 'adjective (keiyoushi)')) {
      return const ConjugationSpec.adjective(AdjectiveClass.iAdjective);
    }
    if (has('adj-na', 'adjectival nouns or quasi-adjectives')) {
      return const ConjugationSpec.adjective(AdjectiveClass.naAdjective);
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is ConjugationSpec &&
        other.kind == kind &&
        other.verbClass == verbClass &&
        other.adjectiveClass == adjectiveClass;
  }

  @override
  int get hashCode => Object.hash(kind, verbClass, adjectiveClass);
}
