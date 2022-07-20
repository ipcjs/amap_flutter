import 'dart:io';

import 'package:amap_flutter_base/amap_flutter_base.dart';
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

  @override
  Future<void> init({
    AMapApiKey? apiKey,
    AMapPrivacyStatement? privacyStatement,
  }) async {
    final platformKey = Platform.isIOS //
        ? apiKey?.iosKey
        : apiKey?.androidKey;
    if (platformKey != null) {
      await _api.setApiKey(platformKey);
    }

    if (privacyStatement?.hasContains != null ||
        privacyStatement?.hasShow != null) {
      await _api.updatePrivacyShow(
        privacyStatement?.hasContains ?? false,
        privacyStatement?.hasShow ?? false,
      );
    }

    if (privacyStatement?.hasAgree != null) {
      await _api.updatePrivacyAgree(
        privacyStatement?.hasAgree ?? false,
      );
    }
  }
}
