import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/immersion_service.dart';

final immersionServiceProvider = Provider<ImmersionService>((ref) {
  return ImmersionService();
});
