import 'conjugation_class.dart';
import 'conjugation_form.dart';

class JapaneseConjugator {
  const JapaneseConjugator();

  String form(String lemma, ConjugationSpec spec, ConjugationForm form) {
    final normalized = lemma.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(lemma, 'lemma', 'Lemma cannot be empty.');
    }
    return switch (spec.kind) {
      ConjugationKind.verb => _verbForm(normalized, spec.verbClass!, form),
      ConjugationKind.adjective => _adjectiveForm(
        normalized,
        spec.adjectiveClass!,
        form,
      ),
    };
  }

  String _verbForm(String lemma, VerbClass klass, ConjugationForm form) {
    return switch (klass) {
      VerbClass.ichidan => _ichidan(lemma, form),
      VerbClass.suru => _suru(lemma, form),
      VerbClass.kuru => _kuru(lemma, form),
      VerbClass.aruException => _aru(lemma, form),
      _ => _godan(lemma, klass, form),
    };
  }

  String _ichidan(String lemma, ConjugationForm form) {
    final stem = _dropLast(lemma);
    return switch (form) {
      ConjugationForm.dictionary => lemma,
      ConjugationForm.masu => '$stemます',
      ConjugationForm.nai => '$stemない',
      ConjugationForm.ta => '$stemた',
      ConjugationForm.te => '$stemて',
      ConjugationForm.ba => '$stemれば',
      ConjugationForm.tara => '$stemたら',
      ConjugationForm.volitional => '$stemよう',
      ConjugationForm.potential => '$stemられる',
      ConjugationForm.passive => '$stemられる',
      ConjugationForm.causative => '$stemさせる',
      ConjugationForm.causativePassive => '$stemさせられる',
      ConjugationForm.imperative => '$stemろ',
      ConjugationForm.adverbial => _unsupported(form, lemma),
    };
  }

  String _godan(String lemma, VerbClass klass, ConjugationForm form) {
    final stem = _dropLast(lemma);
    final row = _godanRow[klass]!;
    return switch (form) {
      ConjugationForm.dictionary => lemma,
      ConjugationForm.masu => '$stem${row.i}ます',
      ConjugationForm.nai => '$stem${row.a}ない',
      ConjugationForm.ta => '$stem${_godanTaEnding(klass)}',
      ConjugationForm.te => '$stem${_godanTeEnding(klass)}',
      ConjugationForm.ba => '$stem${row.e}ば',
      ConjugationForm.tara => '${_godan(lemma, klass, ConjugationForm.ta)}ら',
      ConjugationForm.volitional => '$stem${row.o}う',
      ConjugationForm.potential => '$stem${row.e}る',
      ConjugationForm.passive => '$stem${row.a}れる',
      ConjugationForm.causative => '$stem${row.a}せる',
      ConjugationForm.causativePassive => '$stem${row.a}せられる',
      ConjugationForm.imperative => '$stem${row.e}',
      ConjugationForm.adverbial => _unsupported(form, lemma),
    };
  }

  String _suru(String lemma, ConjugationForm form) {
    final stem = lemma.endsWith('する')
        ? lemma.substring(0, lemma.length - 'する'.length)
        : lemma;
    return switch (form) {
      ConjugationForm.dictionary => lemma,
      ConjugationForm.masu => '$stemします',
      ConjugationForm.nai => '$stemしない',
      ConjugationForm.ta => '$stemした',
      ConjugationForm.te => '$stemして',
      ConjugationForm.ba => '$stemすれば',
      ConjugationForm.tara => '$stemしたら',
      ConjugationForm.volitional => '$stemしよう',
      ConjugationForm.potential => '$stemできる',
      ConjugationForm.passive => '$stemされる',
      ConjugationForm.causative => '$stemさせる',
      ConjugationForm.causativePassive => '$stemさせられる',
      ConjugationForm.imperative => '$stemしろ',
      ConjugationForm.adverbial => _unsupported(form, lemma),
    };
  }

  String _kuru(String lemma, ConjugationForm form) {
    final prefix = lemma.endsWith('来る')
        ? lemma.substring(0, lemma.length - '来る'.length)
        : lemma.endsWith('くる')
        ? lemma.substring(0, lemma.length - 'くる'.length)
        : '';
    return switch (form) {
      ConjugationForm.dictionary => lemma,
      ConjugationForm.masu => '$prefix来ます',
      ConjugationForm.nai => '$prefix来ない',
      ConjugationForm.ta => '$prefix来た',
      ConjugationForm.te => '$prefix来て',
      ConjugationForm.ba => '$prefix来れば',
      ConjugationForm.tara => '$prefix来たら',
      ConjugationForm.volitional => '$prefix来よう',
      ConjugationForm.potential => '$prefix来られる',
      ConjugationForm.passive => '$prefix来られる',
      ConjugationForm.causative => '$prefix来させる',
      ConjugationForm.causativePassive => '$prefix来させられる',
      ConjugationForm.imperative => '$prefix来い',
      ConjugationForm.adverbial => _unsupported(form, lemma),
    };
  }

  String _aru(String lemma, ConjugationForm form) {
    return switch (form) {
      ConjugationForm.dictionary => lemma,
      ConjugationForm.masu => 'あります',
      ConjugationForm.nai => 'ない',
      ConjugationForm.ta => 'あった',
      ConjugationForm.te => 'あって',
      ConjugationForm.ba => 'あれば',
      ConjugationForm.tara => 'あったら',
      ConjugationForm.volitional => 'あろう',
      ConjugationForm.potential => _unsupported(form, lemma),
      ConjugationForm.passive => _unsupported(form, lemma),
      ConjugationForm.causative => _unsupported(form, lemma),
      ConjugationForm.causativePassive => _unsupported(form, lemma),
      ConjugationForm.imperative => 'あれ',
      ConjugationForm.adverbial => _unsupported(form, lemma),
    };
  }

  String _adjectiveForm(
    String lemma,
    AdjectiveClass klass,
    ConjugationForm form,
  ) {
    return switch (klass) {
      AdjectiveClass.iAdjective => _iAdjective(lemma, form),
      AdjectiveClass.iiException => _iAdjective('よい', form, dictionary: 'いい'),
      AdjectiveClass.naAdjective => _naAdjective(lemma, form),
    };
  }

  String _iAdjective(String lemma, ConjugationForm form, {String? dictionary}) {
    final stem = lemma.endsWith('い') ? _dropLast(lemma) : lemma;
    return switch (form) {
      ConjugationForm.dictionary => dictionary ?? lemma,
      ConjugationForm.nai => '$stemくない',
      ConjugationForm.ta => '$stemかった',
      ConjugationForm.te => '$stemくて',
      ConjugationForm.ba => '$stemければ',
      ConjugationForm.tara => '$stemかったら',
      ConjugationForm.volitional => '$stemかろう',
      ConjugationForm.adverbial => '$stemく',
      ConjugationForm.masu ||
      ConjugationForm.potential ||
      ConjugationForm.passive ||
      ConjugationForm.causative ||
      ConjugationForm.causativePassive ||
      ConjugationForm.imperative => _unsupported(form, lemma),
    };
  }

  String _naAdjective(String lemma, ConjugationForm form) {
    return switch (form) {
      ConjugationForm.dictionary => '$lemmaだ',
      ConjugationForm.nai => '$lemmaではない',
      ConjugationForm.ta => '$lemmaだった',
      ConjugationForm.te => '$lemmaで',
      ConjugationForm.ba => '$lemmaなら',
      ConjugationForm.tara => '$lemmaだったら',
      ConjugationForm.volitional => '$lemmaだろう',
      ConjugationForm.adverbial => '$lemmaに',
      ConjugationForm.masu ||
      ConjugationForm.potential ||
      ConjugationForm.passive ||
      ConjugationForm.causative ||
      ConjugationForm.causativePassive ||
      ConjugationForm.imperative => _unsupported(form, lemma),
    };
  }

  String _godanTeEnding(VerbClass klass) {
    return switch (klass) {
      VerbClass.godanU ||
      VerbClass.godanTsu ||
      VerbClass.godanRu ||
      VerbClass.godanIkuException => 'って',
      VerbClass.godanMu || VerbClass.godanBu || VerbClass.godanNu => 'んで',
      VerbClass.godanKu => 'いて',
      VerbClass.godanGu => 'いで',
      VerbClass.godanSu => 'して',
      _ => throw ArgumentError.value(klass, 'klass', 'Not a godan class.'),
    };
  }

  String _godanTaEnding(VerbClass klass) {
    return switch (klass) {
      VerbClass.godanU ||
      VerbClass.godanTsu ||
      VerbClass.godanRu ||
      VerbClass.godanIkuException => 'った',
      VerbClass.godanMu || VerbClass.godanBu || VerbClass.godanNu => 'んだ',
      VerbClass.godanKu => 'いた',
      VerbClass.godanGu => 'いだ',
      VerbClass.godanSu => 'した',
      _ => throw ArgumentError.value(klass, 'klass', 'Not a godan class.'),
    };
  }

  String _dropLast(String value) {
    if (value.isEmpty) return value;
    return value.substring(0, value.length - 1);
  }

  Never _unsupported(ConjugationForm form, String lemma) {
    throw UnsupportedError('Form ${form.name} is not supported for $lemma.');
  }
}

class _GodanRow {
  const _GodanRow({
    required this.a,
    required this.i,
    required this.e,
    required this.o,
  });

  final String a;
  final String i;
  final String e;
  final String o;
}

const _godanRow = <VerbClass, _GodanRow>{
  VerbClass.godanU: _GodanRow(a: 'わ', i: 'い', e: 'え', o: 'お'),
  VerbClass.godanKu: _GodanRow(a: 'か', i: 'き', e: 'け', o: 'こ'),
  VerbClass.godanGu: _GodanRow(a: 'が', i: 'ぎ', e: 'げ', o: 'ご'),
  VerbClass.godanSu: _GodanRow(a: 'さ', i: 'し', e: 'せ', o: 'そ'),
  VerbClass.godanTsu: _GodanRow(a: 'た', i: 'ち', e: 'て', o: 'と'),
  VerbClass.godanNu: _GodanRow(a: 'な', i: 'に', e: 'ね', o: 'の'),
  VerbClass.godanBu: _GodanRow(a: 'ば', i: 'び', e: 'べ', o: 'ぼ'),
  VerbClass.godanMu: _GodanRow(a: 'ま', i: 'み', e: 'め', o: 'も'),
  VerbClass.godanRu: _GodanRow(a: 'ら', i: 'り', e: 'れ', o: 'ろ'),
  VerbClass.godanIkuException: _GodanRow(a: 'か', i: 'き', e: 'け', o: 'こ'),
};
