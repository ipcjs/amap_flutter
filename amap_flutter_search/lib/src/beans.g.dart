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

RegeocodeResult _$RegeocodeResultFromJson(Map json) => RegeocodeResult(
      formatAddress: json['formatAddress'] as String,
      district: json['district'] as String,
      adCode: json['adCode'] as String,
      cityCode: json['cityCode'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      countryCode: json['countryCode'] as String,
      country: json['country'] as String,
      township: json['township'] as String,
      towncode: json['towncode'] as String,
      pois: (json['pois'] as List<dynamic>)
          .map((e) => PoiItem.fromJson(e as Map))
          .toList(),
    );

Map<String, dynamic> _$RegeocodeResultToJson(RegeocodeResult instance) =>
    <String, dynamic>{
      'formatAddress': instance.formatAddress,
      'adCode': instance.adCode,
      'cityCode': instance.cityCode,
      'countryCode': instance.countryCode,
      'country': instance.country,
      'province': instance.province,
      'city': instance.city,
      'district': instance.district,
      'township': instance.township,
      'towncode': instance.towncode,
      'pois': instance.pois.map((e) => e.toJson()).toList(),
    };
