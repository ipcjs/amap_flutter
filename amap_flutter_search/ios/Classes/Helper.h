//
//  Helper.h
//  amap_flutter_search
//
//  Created by yinqiante on 2022/8/2.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject
+ (NSDictionary *)poiToDictionary:(AMapPOI *)obj;
+ (AMapGeoPoint *)pointFromObject:(nonnull id)object;
+ (nonnull id)pointToObject:(AMapGeoPoint *)point;
+ (NSArray *)poisToArray:(NSArray<AMapPOI *> *)pois;
+ (NSDictionary *)reGeocodeToDictionary:(AMapReGeocode *)obj;
@end

NS_ASSUME_NONNULL_END
