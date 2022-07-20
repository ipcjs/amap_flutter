import 'package:amap_flutter_search/src/amap_search.pigeon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../amap_flutter_search_platform_interface.dart';

/// An implementation of [AmapFlutterSearchPlatform] that uses method channels.
class MethodChannelAmapFlutterSearch extends AmapFlutterSearchPlatform {
  final SearchHostApi _api = SearchHostApi();

  @override
  Future<String?> getPlatformVersion() async {
    return _api.getPlatformVersion();
  }
}
