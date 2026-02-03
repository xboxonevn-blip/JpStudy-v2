import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/immersion_service.dart';

final immersionServiceProvider = Provider<ImmersionService>((ref) {
  return ImmersionService();
});

final readArticlesProvider =
    StateNotifierProvider<ReadArticlesNotifier, Set<String>>((ref) {
  final service = ref.watch(immersionServiceProvider);
  return ReadArticlesNotifier(service);
});

class ReadArticlesNotifier extends StateNotifier<Set<String>> {
  ReadArticlesNotifier(this._service) : super({}) {
    _load();
  }

  final ImmersionService _service;

  Future<void> _load() async {
    final ids = await _service.getReadArticleIds();
    state = ids;
  }

  Future<void> toggle(String id) async {
    final isRead = state.contains(id);
    final newState = {...state};
    if (isRead) {
      newState.remove(id);
    } else {
      newState.add(id);
    }
    state = newState;
    await _service.markArticleAsRead(id, !isRead);
  }
}
