import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tts_service_stub.dart'
    if (dart.library.js_interop) 'tts_service_web.dart';
import 'tts_types.dart';

export 'tts_types.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => createTtsService());
