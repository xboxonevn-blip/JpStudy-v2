import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/core/app_language.dart';

final appLanguageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.en);
