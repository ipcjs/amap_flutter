//
//  Helper.h
//  amap_flutter_search
//
//  Created by yinqiante on 2022/8/2.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

// 假设默认非空
NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject
+ (nullable AMapGeoPoint *)pointFromObject:(nullable id)object;
+ (nullable id)pointToObject:(nullable AMapGeoPoint *)point;
+ (NSDictionary *)reGeocodeToDictionary:(nullable AMapReGeocode *)obj;
+ (NSDictionary *)poiSearchResponseToDictionary:(AMapPOISearchResponse *)response;
@end

NS_ASSUME_NONNULL_END
