//
//  Helper.m
//  amap_flutter_search
//
//  Created by yinqiante on 2022/8/2.
//

#import "Helper.h"

@implementation Helper
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
            @"pois": [Helper poisToArray:obj.pois],
    };
}

+ (NSArray *)poisToArray:(nullable NSArray<AMapPOI *> *)pois {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:pois.count];
    [pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[Helper poiToDictionary:obj]];
    }];
    return array;
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
    };
}

@end
