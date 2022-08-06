//
//  Helper.m
//  amap_flutter_search
//
//  Created by yinqiante on 2022/8/2.
//

#import "Helper.h"

@implementation Helper
+ (AMapGeoPoint *) pointFromObject:(nonnull id)object {
    NSArray *latlngs = object;
    NSNumber *lat = latlngs[0];
    NSNumber *lng = latlngs[1];
    
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:[lat doubleValue]
                                                   longitude:[lng doubleValue]];
    return point;
}

+ (nonnull id)pointToObject:(AMapGeoPoint *)point {
    return [NSArray arrayWithObjects:
                [NSNumber numberWithFloat:point.latitude],
                [NSNumber numberWithFloat:point.longitude],
                nil];
}

+ (NSDictionary *)reGeocodeToDictionary:(AMapReGeocode *)obj {
    AMapAddressComponent *comp = obj.addressComponent;
    return [NSDictionary dictionaryWithObjectsAndKeys:
            obj.formattedAddress,@"formatAddress",
            comp.district,@"district",
            comp.adcode,@"adCode",
            comp.citycode,@"cityCode",
            comp.city,@"city",
            comp.province,@"province",
            comp.countryCode,@"countryCode",
            comp.country,@"country",
            comp.township,@"township",
            comp.towncode,@"towncode",
            [Helper poisToArray:obj.pois],@"pois",
            nil];
}

+ (NSArray *)poisToArray:(NSArray<AMapPOI *> *)pois {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:pois.count];
    [pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[Helper poiToDictionary:obj]];
    }];
    return array;
}

+ (NSDictionary *)poiExtensionToDictionary:(nullable AMapPOIExtension *)obj{
    // 在nil对象上读取属性, 返回nil...
    NSString *rating = [NSString stringWithFormat:@"%.1f",obj.rating];
    NSString *openTime = obj.openTime == nil ? @"" : obj.openTime;
    return [NSDictionary dictionaryWithObjectsAndKeys:
            rating, @"rating",
            openTime, @"openTime",
            nil];
}

+ (NSDictionary *)poiToDictionary:(AMapPOI *)obj {
    NSDictionary *poiExtension = [Helper poiExtensionToDictionary:obj.extensionInfo];
    
	return [NSDictionary dictionaryWithObjectsAndKeys:
			obj.name,@"title",
			obj.city,@"cityName",
			obj.citycode,@"cityCode",
			obj.address,@"snippet",
			obj.uid,@"poiId",
			[Helper pointToObject:obj.location],@"position",
			obj.adcode,@"adCode",
			obj.district,@"adName",
			obj.pcode,@"provinceCode",
			obj.province,@"provinceName",
			obj.postcode,@"postcode",
			obj.tel,@"tel",
			obj.website,@"website",
            poiExtension,@"poiExtension",
			nil];
}

+ (NSString *)toNonnull:(nullable NSString *)string {
	return string == nil ? @"" : string;
}
@end
