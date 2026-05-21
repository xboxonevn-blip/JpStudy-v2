import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/utils/mimikara_catalog_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled Mimikara N3 catalog and first unit terms', () async {
    final catalog = await loadMimikaraUnitCatalog('N3');

    expect(catalog.levelCode, 'N3');
    expect(catalog.units.length, greaterThanOrEqualTo(12));
    expect(catalog.totalTerms, greaterThan(700));
    expect(catalog.units.first.previewTerms, isNotEmpty);

    final detail = await loadMimikaraUnitDetail(
      'N3',
      catalog.units.first.unitId,
    );
    expect(detail, isNotNull);
    expect(detail!.entries, isNotEmpty);
    expect(detail.entries.first.term, isNotEmpty);
    expect(detail.entries.first.meaningVi, isNotEmpty);
  });

  test(
    'Mimikara loader rejects banned source names from learner assets',
    () async {
      for (final level in const ['N5', 'N4', 'N3', 'N2', 'N1']) {
        final catalog = await loadMimikaraUnitCatalog(level);
        expect(catalog.sourceCredit, isNot(contains('thocodehoctiengnhat')));
        expect(catalog.sourceCredit, isNot(contains('nhaikanji')));
        for (final unit in catalog.units) {
          expect(unit.title, isNot(contains('thocodehoctiengnhat')));
          expect(unit.title, isNot(contains('nhaikanji')));
        }
      }
    },
  );
}
