import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UI code does not call markKnown self-attestation', () {
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path
          .replaceAll('\\', '/')
          .endsWith('lib/core/srs/cross_modal_srs.dart')) {
        continue;
      }
      final source = entity.readAsStringSync();
      if (source.contains('markKnown(') || source.contains('.markKnown')) {
        offenders.add(entity.path);
      }
    }
    expect(offenders, isEmpty);
  });
}
