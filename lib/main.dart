import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/app.dart';
import 'package:jpstudy/core/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  
  // Note: Mobile ads initialization is skipped on desktop platforms
  // The google_mobile_ads package doesn't support Windows/macOS/Linux
  // On mobile, call MobileAds.instance.initialize() in a platform-specific entry point
  // or use conditional imports if ads are needed
  
  runApp(const ProviderScope(child: App()));
}
