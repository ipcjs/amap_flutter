//
//  Helper.m
//  amap_flutter_search
//
//  Created by yinqiante on 2022/8/2.
//

#import "Helper.h"

@implementation Helper
+ (NSArray *)map:(nullable NSArray *)array withBlock:(id(^)(id obj))transform {
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [results addObject:transform(obj)];
    }];
    return results;
}

+ (nullable AMapGeoPoint *) pointFromObject:(nullable id)object {
    if(!object) return nil;
        
    NSArray *latlngs = object;
    NSNumber *lat = latlngs[0];
    NSNumber *lng = latlngs[1];
    
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:[lat doubleValue]
                                                   longitude:[lng doubleValue]];
    return point;
}

+ (nullable id)pointToObject:(nullable AMapGeoPoint *)point {
    if (!point) return nil;

    return @[@(point.latitude), @(point.longitude)];
}

+ (NSDictionary *)reGeocodeToDictionary:(nullable AMapReGeocode *)obj {
    AMapAddressComponent *comp = obj.addressComponent;
    return @{
            @"formatAddress": obj.formattedAddress ?: @"",
            @"district": comp.district ?: @"",
            @"adCode": comp.adcode ?: @"",
            @"cityCode": comp.citycode ?: @"",
            @"city": comp.city ?: @"",
            @"province": comp.province ?: @"",
            @"countryCode": comp.countryCode ?: @"",
            @"country": comp.country ?: @"",
            @"township": comp.township ?: @"",
            @"towncode": comp.towncode ?: @"",
            @"pois": [Helper map:obj.pois withBlock:^id(AMapPOI *obj) {
                return [Helper poiToDictionary:obj];
            }],
            @"aois": [Helper map:obj.aois withBlock:^id(AMapAOI *obj) {
                return [Helper aoiToDictionary:obj];
            }],
    };
}

+ (NSDictionary *)poiSearchResponseToDictionary:(AMapPOISearchResponse *)response {
    NSUInteger length = response.pois.count;
    return @{
        @"pageCount": @((NSInteger)ceil((double)response.count / length)),
        @"poiList": [Helper map:response.pois withBlock:^id(AMapPOI *obj) {
            return [Helper poiToDictionary:obj];
        }],
    };
}

+ (NSDictionary *)poiExtensionToDictionary:(nullable AMapPOIExtension *)obj{
    // 在nil对象上读取属性, 返回nil...
    NSString *rating = [NSString stringWithFormat:@"%.1f",obj.rating];
    return @{
        @"rating": rating,
        @"openTime": obj.openTime ?: @"",
    };
}

+ (NSDictionary *)poiToDictionary:(nullable AMapPOI *)obj {
    return @{
            @"title": obj.name ?: @"",
			@"cityName": obj.city ?: @"",
			@"cityCode": obj.citycode ?: @"",
			@"snippet": obj.address ?: @"",
			@"poiId": obj.uid ?: @"",
			@"position": [Helper pointToObject:obj.location] ?: [NSNull null],
			@"adCode": obj.adcode ?: @"",
			@"adName": obj.district ?: @"",
			@"provinceCode": obj.pcode ?: @"",
			@"provinceName": obj.province ?: @"",
			@"postcode": obj.postcode ?: @"",
			@"tel": obj.tel ?: @"",
			@"website": obj.website ?: @"",
            @"poiExtension": [Helper poiExtensionToDictionary:obj.extensionInfo],
            @"distance": @(obj.distance),
    };
}

+ (NSDictionary *)aoiToDictionary:(nullable AMapAOI *)obj {
    return @{
        @"name": obj.name ?: @"",
        @"id": obj.uid ?: @"",
        @"adCode": obj.adcode ?: @"",
        @"area": @(obj.area),
        @"center": [Helper pointToObject:obj.location] ?: [NSNull null],
    };
}

@end
