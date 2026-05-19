import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/conjugation/conjugation_class.dart';
import 'package:jpstudy/core/conjugation/conjugation_form.dart';
import 'package:jpstudy/core/conjugation/japanese_conjugator.dart';

void main() {
  group('ConjugationSpec.fromJmDictPos', () {
    test('maps JMdict verb and adjective POS tags to explicit classes', () {
      expect(
        ConjugationSpec.fromJmDictPos(const ['v5t'], lemma: '待つ'),
        const ConjugationSpec.verb(VerbClass.godanTsu),
      );
      expect(
        ConjugationSpec.fromJmDictPos(const ['v5k-s'], lemma: '行く'),
        const ConjugationSpec.verb(VerbClass.godanIkuException),
      );
      expect(
        ConjugationSpec.fromJmDictPos(const ['v1'], lemma: '起きる'),
        const ConjugationSpec.verb(VerbClass.ichidan),
      );
      expect(
        ConjugationSpec.fromJmDictPos(const ['vs'], lemma: '勉強する'),
        const ConjugationSpec.verb(VerbClass.suru),
      );
      expect(
        ConjugationSpec.fromJmDictPos(const ['adj-i'], lemma: '高い'),
        const ConjugationSpec.adjective(AdjectiveClass.iAdjective),
      );
      expect(
        ConjugationSpec.fromJmDictPos(const ['adj-ix'], lemma: 'いい'),
        const ConjugationSpec.adjective(AdjectiveClass.iiException),
      );
      expect(
        ConjugationSpec.fromJmDictPos(const ['adj-na'], lemma: '静か'),
        const ConjugationSpec.adjective(AdjectiveClass.naAdjective),
      );
      expect(ConjugationSpec.fromJmDictPos(const ['n'], lemma: '学校'), isNull);
    });
  });

  group('JapaneseConjugator verbs', () {
    const conjugator = JapaneseConjugator();

    test('generates te and ta forms for godan endings and 行く exception', () {
      const cases = <({String lemma, VerbClass klass, String te, String ta})>[
        (lemma: '買う', klass: VerbClass.godanU, te: '買って', ta: '買った'),
        (lemma: '書く', klass: VerbClass.godanKu, te: '書いて', ta: '書いた'),
        (lemma: '泳ぐ', klass: VerbClass.godanGu, te: '泳いで', ta: '泳いだ'),
        (lemma: '話す', klass: VerbClass.godanSu, te: '話して', ta: '話した'),
        (lemma: '待つ', klass: VerbClass.godanTsu, te: '待って', ta: '待った'),
        (lemma: '死ぬ', klass: VerbClass.godanNu, te: '死んで', ta: '死んだ'),
        (lemma: '遊ぶ', klass: VerbClass.godanBu, te: '遊んで', ta: '遊んだ'),
        (lemma: '読む', klass: VerbClass.godanMu, te: '読んで', ta: '読んだ'),
        (lemma: '帰る', klass: VerbClass.godanRu, te: '帰って', ta: '帰った'),
        (lemma: '行く', klass: VerbClass.godanIkuException, te: '行って', ta: '行った'),
      ];

      for (final item in cases) {
        final spec = ConjugationSpec.verb(item.klass);
        expect(
          conjugator.form(item.lemma, spec, ConjugationForm.te),
          item.te,
          reason: item.lemma,
        );
        expect(
          conjugator.form(item.lemma, spec, ConjugationForm.ta),
          item.ta,
          reason: item.lemma,
        );
      }
    });

    test(
      'distinguishes ichidan る verbs from godan る verbs by source class',
      () {
        expect(
          conjugator.form(
            '起きる',
            const ConjugationSpec.verb(VerbClass.ichidan),
            ConjugationForm.te,
          ),
          '起きて',
        );
        expect(
          conjugator.form(
            '帰る',
            const ConjugationSpec.verb(VerbClass.godanRu),
            ConjugationForm.te,
          ),
          '帰って',
        );
      },
    );

    test('generates core irregular verb forms', () {
      expect(
        conjugator.form(
          'する',
          const ConjugationSpec.verb(VerbClass.suru),
          ConjugationForm.nai,
        ),
        'しない',
      );
      expect(
        conjugator.form(
          '勉強する',
          const ConjugationSpec.verb(VerbClass.suru),
          ConjugationForm.te,
        ),
        '勉強して',
      );
      expect(
        conjugator.form(
          '来る',
          const ConjugationSpec.verb(VerbClass.kuru),
          ConjugationForm.masu,
        ),
        '来ます',
      );
      expect(
        conjugator.form(
          'ある',
          const ConjugationSpec.verb(VerbClass.aruException),
          ConjugationForm.nai,
        ),
        'ない',
      );
    });
  });

  group('JapaneseConjugator adjectives', () {
    const conjugator = JapaneseConjugator();

    test('generates core i-adjective and いい exception forms', () {
      expect(
        conjugator.form(
          '高い',
          const ConjugationSpec.adjective(AdjectiveClass.iAdjective),
          ConjugationForm.nai,
        ),
        '高くない',
      );
      expect(
        conjugator.form(
          '高い',
          const ConjugationSpec.adjective(AdjectiveClass.iAdjective),
          ConjugationForm.te,
        ),
        '高くて',
      );
      expect(
        conjugator.form(
          'いい',
          const ConjugationSpec.adjective(AdjectiveClass.iiException),
          ConjugationForm.ta,
        ),
        'よかった',
      );
      expect(
        conjugator.form(
          'いい',
          const ConjugationSpec.adjective(AdjectiveClass.iiException),
          ConjugationForm.adverbial,
        ),
        'よく',
      );
    });

    test('generates core na-adjective forms', () {
      expect(
        conjugator.form(
          '静か',
          const ConjugationSpec.adjective(AdjectiveClass.naAdjective),
          ConjugationForm.dictionary,
        ),
        '静かだ',
      );
      expect(
        conjugator.form(
          '静か',
          const ConjugationSpec.adjective(AdjectiveClass.naAdjective),
          ConjugationForm.te,
        ),
        '静かで',
      );
      expect(
        conjugator.form(
          '静か',
          const ConjugationSpec.adjective(AdjectiveClass.naAdjective),
          ConjugationForm.nai,
        ),
        '静かではない',
      );
    });
  });
}
