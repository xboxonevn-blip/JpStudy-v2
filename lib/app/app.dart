import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/theme/app_theme.dart';
import 'package:jpstudy/features/home/home_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'JpStudy',
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}
