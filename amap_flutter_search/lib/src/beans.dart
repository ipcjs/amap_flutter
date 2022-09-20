import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beans.g.dart';

/// Created by ipcjs on 2022/7/21.
///
/// @see https://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/com/amap/api/services/core/PoiItem.html
@immutable
@JsonSerializable()
class PoiItem {
  const PoiItem({
    required this.title,
    required this.cityName,
    required this.cityCode,
    required this.snippet,
    required this.poiId,
    required this.position,
    required this.adCode,
    required this.adName,
    required this.provinceCode,
    required this.provinceName,
    required this.postcode,
    required this.tel,
    required this.website,
    required this.poiExtension,
    required this.distance,
  });

  final String title;
  final String snippet;
  final String poiId;
  @JsonKey(fromJson: _latLngFromJson)
  final LatLng position;

  final String cityName;

  /// 高德地图的cityCode, 是类似手机区号的格式...要获取和[adCode], [provinceCode]类似
  /// 格式的城市代码, 请使用[cityCodeFixed]替代
  final String cityCode;
  final String adCode;
  final String adName;
  final String provinceCode;
  final String provinceName;
  final String postcode;
  final String tel;
  final String website;
  final PoiItemExtension poiExtension;

  /// 离[PoiSearchQuery.location]的距离, 只有在周边搜索(设置了[PoiSearchQuery.bound]参数)时才有效
  ///
  /// Android端用-1表示无效的值, iOS端用0表示无效值...
  final int distance;

  /// 实测在Android平台上[cityCode]返回的是城市电话区号...
  /// 这里通过取[adCode]的前4位, 尝试返回和[adCode], [provinceCode]类似格式的的城市代码
  String get cityCodeFixed {
    if (adCode.length != 6) {
      return cityCode;
    }
    // 取adCode的前4位当作城市代码
    return '${adCode.substring(0, 4)}00';
  }

  factory PoiItem.fromJson(Map<dynamic, dynamic> json) =>
      _$PoiItemFromJson(json);
  Map<String, dynamic> toJson() => _$PoiItemToJson(this);

  @override
  String toString() => 'PoiItem: ${toJson()}';
}

LatLng _latLngFromJson(Object obj) => LatLng.fromJson(obj)!;

/// @see https://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/com/amap/api/services/poisearch/PoiItemExtension.html
@immutable
@JsonSerializable()
class PoiItemExtension {
  const PoiItemExtension({
    required this.rating,
    required this.openTime,
  });
  final String rating;
  final String openTime;

  factory PoiItemExtension.fromJson(Map<String, dynamic> json) =>
      _$PoiItemExtensionFromJson(json);
  Map<String, dynamic> toJson() => _$PoiItemExtensionToJson(this);
}

/// @see https://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/com/amap/api/services/poisearch/PoiSearch.Query.html
class PoiSearchQuery {
  PoiSearchQuery({
    this.pageNum = 1,
    this.pageSize = 20,
    this.query = '',
    this.city = '',
    this.types = '',
    this.bound,
    this.extensionType = ExtensionType.base,
    this.location,
    this.isDistanceSort = true,
  }) : assert(
          !(bound?.radius != null && location == null),
          '设置搜索半径时, location不能为空',
        );
  final int pageNum;
  final int pageSize;
  final String query;

  /// Poi类型, 多个类型用`|`分隔
  ///
  /// - Android上对应`ctgr`参数
  /// - iOS上对应`types`参数
  final String types;
  final String city;
  final PoiSearchBound? bound;
  final ExtensionType extensionType;
  final LatLng? location;
  final bool isDistanceSort;
}

class PoiSearchBound {
  /// 在以[PoiSearchQuery.location]为中心的圆中搜索
  PoiSearchBound.circle([this.radius = 1000]) : points = null;

  /// 多边形搜索, 预留在这里, 当前未实现(
  PoiSearchBound.polygon(this.points) : radius = null {
    throw UnimplementedError('当前未实现');
  }

  final int? radius;
  final List<LatLng>? points;
}

enum ExtensionType {
  /// 默认, 只查询基础信息
  base,

  /// 设为该类型后, [PoiItem]的如下字段会有尽量填充值:
  /// - [PoiItem.adCode]
  /// - [PoiItem.provinceCode]
  /// - [PoiItem.cityCode]
  /// - [PoiItem.poiExtension]
  ///
  /// [RegeocodeResult]的如下字段会尽量填充值:(大部分字段因为暂时没用, 没有传到Dart层来)
  /// - [RegeocodeResult.roads]
  /// - [RegeocodeResult.crossroads]
  /// - [RegeocodeResult.pois]
  /// - [RegeocodeResult.aois]
  all,
}

@immutable
@JsonSerializable()
class PoiSearchResult {
  const PoiSearchResult({
    required this.poiList,
    required this.pageCount,
  });

  final List<PoiItem> poiList;
  final int pageCount;

  factory PoiSearchResult.fromJson(Map<dynamic, dynamic> json) =>
      _$PoiSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$PoiSearchResultToJson(this);

  @override
  String toString() => 'PoiSearchResult: ${toJson()}';
}

/// @see https://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/com/amap/api/services/geocoder/RegeocodeQuery.html
@immutable
class RegeocodeQuery {
  const RegeocodeQuery({
    required this.point,
    this.radius = 1000,
    this.latLngType = LatLngType.autonavi,
    this.extensionType = ExtensionType.base,
    this.poiTypes = '',
    this.mode = RegeocodeQueryMode.distance,
  });
  final LatLng point;

  /// 查找半径
  ///
  /// 单位米, 范围1-3000, 默认1000
  final double radius;

  /// iOS不支持该参数
  final LatLngType latLngType;
  final ExtensionType extensionType;
  final String poiTypes;
  final RegeocodeQueryMode mode;
}

enum LatLngType {
  /// wgs84坐标
  gps,

  /// 高德/gcj02坐标
  autonavi,
}

/// 返回策略
enum RegeocodeQueryMode {
  /// 按距离返回
  distance,

  /// 按权重返回
  score,
}

/// @see https://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/com/amap/api/services/geocoder/RegeocodeAddress.html
@immutable
@JsonSerializable()
class RegeocodeResult {
  const RegeocodeResult({
    required this.formatAddress,
    required this.district,
    required this.adCode,
    required this.cityCode,
    required this.city,
    required this.province,
    required this.countryCode,
    required this.country,
    required this.township,
    required this.towncode,
    required this.pois,
    required this.aois,
  });

  final String formatAddress;
  final String adCode;
  final String cityCode;
  final String countryCode;

  final String country;
  final String province;
  final String city;
  final String district;
  final String township;
  final String towncode;

  final List<PoiItem> pois;
  final List<AoiItem> aois;

  factory RegeocodeResult.fromJson(Map<dynamic, dynamic> json) =>
      _$RegeocodeResultFromJson(json);
  Map<String, dynamic> toJson() => _$RegeocodeResultToJson(this);

  @override
  String toString() => 'RegeocodeResult: ${toJson()}';
}

/// @see https://a.amap.com/lbs/static/unzip/Android_Map_Doc/Search/com/amap/api/services/geocoder/AoiItem.html
@immutable
@JsonSerializable()
class AoiItem {
  const AoiItem({
    required this.id,
    required this.name,
    required this.adCode,
    required this.center,
    required this.area,
  });
  @JsonKey(fromJson: _latLngFromJson)
  final LatLng center;
  final String adCode;
  final String id;
  final String name;
  final double area;

  factory AoiItem.fromJson(Map<String, dynamic> json) =>
      _$AoiItemFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AoiItemToJson(this);

  @override
  String toString() => 'AoiItem: ${toJson()}';
}
