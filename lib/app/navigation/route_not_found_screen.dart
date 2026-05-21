import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/features/common/widgets/compact_ui.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class RouteNotFoundScreen extends ConsumerWidget {
  const RouteNotFoundScreen({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    return Scaffold(
      body: AppPageShell(
        child: AppSectionCard(
          child: AppEmptyState(
            icon: Icons.travel_explore_rounded,
            title: _title(language),
            message: _message(language, location),
            actionLabel: _action(language),
            onActionTap: () => context.go(AppRoutePath.home),
          ),
        ),
      ),
    );
  }

  String _title(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Page not found',
    AppLanguage.vi => 'Trang không tồn tại',
    AppLanguage.ja => 'ページが見つかりません',
  };

  String _message(AppLanguage language, String location) => switch (language) {
    AppLanguage.en =>
      'JpStudy could not open "$location". The route may have moved.',
    AppLanguage.vi =>
      'JpStudy chưa mở được "$location". Có thể đường dẫn này đã đổi.',
    AppLanguage.ja => '「$location」を開けませんでした。ルートが変更された可能性があります。',
  };

  String _action(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Back to home',
    AppLanguage.vi => 'Quay lại trang chủ',
    AppLanguage.ja => 'ホームへ戻る',
  };
}
