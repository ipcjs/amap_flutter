/// 高德地图搜索功能
library amap_flutter_search;

export 'package:amap_flutter_base/amap_flutter_base.dart'
    show AMapApiKey, AMapPrivacyStatement;

import 'package:amap_flutter_base/amap_flutter_base.dart';

import 'amap_flutter_search_platform_interface.dart';

class AmapFlutterSearch {
  static final _instance = AmapFlutterSearch._();

  /// 保证单例
  factory AmapFlutterSearch() => _instance;
  AmapFlutterSearch._();

  AmapFlutterSearchPlatform get _platform => AmapFlutterSearchPlatform.instance;

  Future<String?> getPlatformVersion() {
    return _platform.getPlatformVersion();
  }

  Future<void> init({
    AMapApiKey? apiKey,
    AMapPrivacyStatement? privacyStatement,
  }) =>
      _platform.init(
        apiKey: apiKey,
        privacyStatement: privacyStatement,
      );

  Future<Map<String, dynamic>> queryPoi() => _platform.queryPoi();
}
