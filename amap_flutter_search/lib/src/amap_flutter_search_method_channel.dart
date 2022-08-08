import 'dart:io';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:amap_flutter_search/amap_flutter_search_platform_interface.dart';
import 'amap_exception.dart';
import 'amap_search.pigeon.dart';
import 'beans.dart';

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

  @override
  Future<PoiSearchResult> searchPoi(PoiSearchQuery query) => _api
      .searchPoi(
        query.pageNum,
        query.pageSize,
        query.query,
        query.types,
        query.city,
        query.bound?.center.toJson(),
        query.bound?.radiusInMeters,
        query.bound?.isDistanceSort,
        query.extensionType.name,
      ) //
      .toData(PoiSearchResult.fromJson);

  @override
  Future<RegeocodeResult?> regeocode(RegeocodeQuery query) => _api
      .regeocode(
        query.point.toJson(),
        query.radius,
        query.latLngType.name,
        query.extensionType.name,
        query.poiTypes,
        query.mode.name,
      )
      .toData<RegeocodeResult?>(RegeocodeResult.fromJson)
      // 原生层(iOS & Android), 虽然存在返回null的执行分支, 但未搜索到数据时, 返回的是
      // 所有字段为空字符串的数据, 这里将这种数据转换为null, 方便外部处理
      .then((value) => value?.formatAddress.isEmpty == true ? null : value);
}
