import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/main.dart';

void main() {
  group('anonymous auth bootstrap gate', () {
    test('skips anonymous auth when analytics is denied and migration is off', () {
      expect(
        shouldRunAnonymousAuthBootstrap(
          legacyMigrationEnabled: false,
          analyticsConsent: false,
        ),
        isFalse,
      );
    });

    test('runs anonymous auth for opted-in analytics or legacy migration', () {
      expect(
        shouldRunAnonymousAuthBootstrap(
          legacyMigrationEnabled: false,
          analyticsConsent: true,
        ),
        isTrue,
      );
      expect(
        shouldRunAnonymousAuthBootstrap(
          legacyMigrationEnabled: true,
          analyticsConsent: false,
        ),
        isTrue,
      );
    });
  });
}
