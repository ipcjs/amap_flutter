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
  });

  final String title;
  final String snippet;
  final String poiId;
  @JsonKey(fromJson: _latLngFromJson)
  final LatLng position;

  final String cityName;
  final String cityCode;
  final String adCode;
  final String adName;
  final String provinceCode;
  final String provinceName;
  final String postcode;
  final String tel;
  final String website;
  final PoiItemExtension poiExtension;

  factory PoiItem.fromJson(Map<dynamic, dynamic> json) =>
      _$PoiItemFromJson(json);
  Map<String, dynamic> toJson() => _$PoiItemToJson(this);

  @override
  String toString() => "PoiItem: ${toJson()}";
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
    this.ctgr = '',
    this.bound,
    this.extensionType = PoiSearchExtensionType.base,
  });
  final int pageNum;
  final int pageSize;
  final String query;
  final String ctgr;
  final String city;
  final PoiSearchBound? bound;
  final PoiSearchExtensionType extensionType;
}

class PoiSearchBound {
  PoiSearchBound({
    required this.center,
    this.radiusInMeters = 1000,
    this.isDistanceSort = true,
  });
  final LatLng center;
  final int radiusInMeters;
  final bool isDistanceSort;
}

enum PoiSearchExtensionType {
  /// 默认, 只查询基础信息
  base,

  /// 设为该类型后, 如下字段会有尽量填充值:
  /// - [PoiItem.adCode]
  /// - [PoiItem.provinceCode]
  /// - [PoiItem.cityCode]
  /// - [PoiItem.poiExtension]
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
  String toString() => "PoiSearchResult: ${toJson()}";
}
