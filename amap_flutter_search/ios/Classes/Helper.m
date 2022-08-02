//
//  Helper.m
//  amap_flutter_search
//
//  Created by yinqiante on 2022/8/2.
//

#import "Helper.h"

@implementation Helper
+ (NSDictionary *)poiToDictionary:(AMapPOI *)obj {
	NSString *title = [self toNonnull:obj.name];
	NSString *cityName = [self toNonnull:obj.city];
	NSString *cityCode = [self toNonnull:obj.citycode];
	NSString *snippet = [self toNonnull:obj.address];
	NSString *poiId = [self toNonnull:obj.uid];
	NSString *adCode = [self toNonnull:obj.adcode];
	NSString *adName = [self toNonnull:obj.district];
	NSString *provinceCode = [self toNonnull:obj.pcode];
	NSString *provinceName = [self toNonnull:obj.province];
	NSString *postcode = [self toNonnull:obj.postcode];
	NSString *tel = [self toNonnull:obj.tel];
	NSString *website = [self toNonnull:obj.website];
	NSString *openTime = [self toNonnull:obj.extensionInfo.openTime];
	CGFloat lat = obj.location.latitude;
	CGFloat lng = obj.location.longitude;
	CGFloat rating = obj.extensionInfo.rating;
	return [NSDictionary dictionaryWithObjectsAndKeys:
			title,@"title",
			cityName,@"cityName",
			cityCode,@"cityCode",
			snippet,@"snippet",
			poiId,@"poiId",
			[NSArray arrayWithObjects:[NSNumber numberWithFloat:lat], [NSNumber numberWithFloat:lng], nil],@"position",
			adCode,@"adCode",
			adName,@"adName",
			provinceCode,@"provinceCode",
			provinceName,@"provinceName",
			postcode,@"postcode",
			tel,@"tel",
			website,@"website",
			[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.1f",rating],@"rating",openTime,@"openTime",nil],@"poiExtension",
			nil];
}

+ (NSString *)toNonnull:(nullable NSString *)string {
	return string == nil ? @"" : string;
}
@end
