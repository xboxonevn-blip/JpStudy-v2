import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/interlink_graph.dart';

const interlinkGraphAssetPath =
    'assets/data/content/interlink_graph/interlink_graph.json';

final interlinkGraphProvider = FutureProvider<InterlinkGraph>((ref) async {
  final raw = await rootBundle.loadString(interlinkGraphAssetPath);
  return InterlinkGraph.fromJson(jsonDecode(raw) as Map<String, Object?>);
});
