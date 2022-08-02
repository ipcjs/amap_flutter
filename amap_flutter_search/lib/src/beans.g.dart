// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beans.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoiItem _$PoiItemFromJson(Map json) => PoiItem(
      title: json['title'] as String,
      cityName: json['cityName'] as String,
      cityCode: json['cityCode'] as String,
      snippet: json['snippet'] as String,
      poiId: json['poiId'] as String,
      position: _latLngFromJson(json['position'] as Object),
      adCode: json['adCode'] as String,
      adName: json['adName'] as String,
      provinceCode: json['provinceCode'] as String,
      provinceName: json['provinceName'] as String,
      postcode: json['postcode'] as String,
      tel: json['tel'] as String,
      website: json['website'] as String,
      poiExtension: PoiItemExtension.fromJson(
          Map<String, dynamic>.from(json['poiExtension'] as Map)),
    );

Map<String, dynamic> _$PoiItemToJson(PoiItem instance) => <String, dynamic>{
      'title': instance.title,
      'snippet': instance.snippet,
      'poiId': instance.poiId,
      'position': instance.position.toJson(),
      'cityName': instance.cityName,
      'cityCode': instance.cityCode,
      'adCode': instance.adCode,
      'adName': instance.adName,
      'provinceCode': instance.provinceCode,
      'provinceName': instance.provinceName,
      'postcode': instance.postcode,
      'tel': instance.tel,
      'website': instance.website,
      'poiExtension': instance.poiExtension.toJson(),
    };

PoiItemExtension _$PoiItemExtensionFromJson(Map json) => PoiItemExtension(
      rating: json['rating'] as String,
      openTime: json['openTime'] as String,
    );

Map<String, dynamic> _$PoiItemExtensionToJson(PoiItemExtension instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'openTime': instance.openTime,
    };

PoiSearchResult _$PoiSearchResultFromJson(Map json) => PoiSearchResult(
      poiList: (json['poiList'] as List<dynamic>)
          .map((e) => PoiItem.fromJson(e as Map))
          .toList(),
      pageCount: json['pageCount'] as int,
    );

Map<String, dynamic> _$PoiSearchResultToJson(PoiSearchResult instance) =>
    <String, dynamic>{
      'poiList': instance.poiList.map((e) => e.toJson()).toList(),
      'pageCount': instance.pageCount,
    };
