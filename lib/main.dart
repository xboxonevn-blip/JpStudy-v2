import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/app.dart';
import 'package:jpstudy/app/navigation/app_router.dart';
import 'package:jpstudy/core/analytics/analytics_consent_provider.dart';
import 'package:jpstudy/core/analytics/do_not_track.dart';
import 'package:jpstudy/core/auth/anonymous_auth_provider.dart';
import 'package:jpstudy/core/error_monitoring/sentry_setup.dart';
import 'package:jpstudy/core/onboarding_provider.dart';
import 'package:jpstudy/core/shared_preferences_provider.dart';
import 'package:jpstudy/core/notifications/notification_service.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/features/foundations/services/kana_progress_migration.dart';
import 'package:jpstudy/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  AppRouter.configurePreferences(preferences);
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      ...persistedAppBootstrapOverrides(preferences),
    ],
  );

  await runAppWithOptionalErrorMonitoring(
    config: ErrorMonitoringConfig.fromEnvironment(),
    consentGranted: preferences.getBool(prefAnalyticsConsent) ?? false,
    isSignedIn: false,
    doNotTrack: isDoNotTrackEnabled(),
    appRunner: () {
      runApp(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      _scheduleDeferredBootstrap(container, preferences);
    },
  );
}

void _scheduleDeferredBootstrap(
  ProviderContainer container,
  SharedPreferences preferences,
) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future<void>.delayed(const Duration(seconds: 45), () async {
      await _runDeferredBootstrap(container, preferences);
    });
  });
}

Future<void> _runDeferredBootstrap(
  ProviderContainer container,
  SharedPreferences preferences,
) async {
  var firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
  } catch (e, st) {
    debugPrint('Firebase initialization failed: $e\n$st');
  }
  if (firebaseInitialized) {
    try {
      await _activateFirebaseAppCheck();
    } catch (e, st) {
      debugPrint('Firebase App Check activation failed: $e\n$st');
    }
  }

  try {
    await NotificationService.instance.initialize();
  } catch (_) {}

  final database = container.read(databaseProvider);
  try {
    await KanaProgressMigration(
      dao: database.kanaSrsDao,
      preferences: preferences,
    ).runIfNeeded();
  } catch (e, st) {
    debugPrint('Kana migration failed: $e\n$st');
  }
  if (shouldRunAnonymousAuthBootstrap(
    legacyMigrationEnabled: legacyStorageMigrationEnabled,
    analyticsConsent: preferences.getBool(prefAnalyticsConsent),
  )) {
    try {
      await container
          .read(anonymousAuthServiceProvider)
          .ensureAuthenticated(preferences: preferences);
    } catch (e, st) {
      debugPrint('Anonymous auth bootstrap failed: $e\n$st');
    }
  }

  try {
    final userId = fb_auth.FirebaseAuth.instance.currentUser?.uid;
    await container.read(errorMonitoringControllerProvider).setUserId(userId);
  } catch (_) {}
}

@visibleForTesting
bool shouldRunAnonymousAuthBootstrap({
  required bool legacyMigrationEnabled,
  required bool? analyticsConsent,
}) {
  return legacyMigrationEnabled || (analyticsConsent ?? false);
}

Future<void> _activateFirebaseAppCheck() async {
  if (kIsWeb) {
    const siteKey = String.fromEnvironment('JPSTUDY_RECAPTCHA_SITE_KEY');
    if (siteKey.isEmpty) {
      if (kReleaseMode) {
        debugPrint(
          'WARNING: App Check disabled: JPSTUDY_RECAPTCHA_SITE_KEY is empty '
          'for this web build.',
        );
      }
      return;
    }
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(siteKey),
    );
    return;
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      await FirebaseAppCheck.instance.activate(
        providerAndroid: const AndroidPlayIntegrityProvider(),
      );
    case TargetPlatform.iOS:
      await FirebaseAppCheck.instance.activate(
        providerApple: const AppleAppAttestWithDeviceCheckFallbackProvider(),
      );
    default:
      return;
  }
}
