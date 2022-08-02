#import "AmapFlutterSearchPlugin.h"
#import "GeneratedAMapSearchApis.h"
#import "Helper.h"

@interface AmapFlutterSearchPlugin () <AmapSearchHostApi>
@property (nonatomic, copy) void (^completionHandle)(AmapApiResult *res, FlutterError *err);
@end

@implementation AmapFlutterSearchPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  AmapFlutterSearchPlugin* instance = [[AmapFlutterSearchPlugin alloc] init];
  AmapSearchHostApiSetup(registrar.messenger, instance);
}

- (nullable NSString *)getPlatformVersionWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    return [@"iOS" stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
}


- (void)setApiKeyApiKey:(nonnull NSString *)apiKey error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
	[AMapServices sharedServices].apiKey = apiKey;

	self.search = [[AMapSearchAPI alloc] init];
	self.search.delegate = self;
}


- (void)updatePrivacyAgreeIsAgree:(nonnull NSNumber *)isAgree error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
	[AMapSearchAPI updatePrivacyAgree: [isAgree boolValue] ? AMapPrivacyAgreeStatusDidAgree : AMapPrivacyAgreeStatusNotAgree];
}


- (void)updatePrivacyShowIsContains:(nonnull NSNumber *)isContains isShow:(nonnull NSNumber *)isShow error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
	[AMapSearchAPI updatePrivacyShow:[isContains boolValue] ? AMapPrivacyShowStatusDidShow : AMapPrivacyShowStatusNotShow
						 privacyInfo:[isShow boolValue] ? AMapPrivacyInfoStatusDidContain : AMapPrivacyInfoStatusNotContain];
}

- (void)searchPoiPageNum:(nonnull NSNumber *)pageNum pageSize:(nonnull NSNumber *)pageSize query:(nonnull NSString *)query ctgr:(nonnull NSString *)ctgr city:(nonnull NSString *)city center:(nullable id)center radiusInMeters:(nullable NSNumber *)radiusInMeters isDistanceSort:(nullable NSNumber *)isDistanceSort extensions:(nonnull NSString *)extensions completion:(nonnull void (^)(AmapApiResult * _Nullable, FlutterError * _Nullable))completion {
	// 如果有中心点传入，请求周边POI；没有请求关键字POI
	if (center != nil && radiusInMeters != nil && isDistanceSort != nil) {
		NSArray *latlngs = center;
		NSNumber *lat = latlngs[0];
		NSNumber *lng = latlngs[1];
		AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
		AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
		request.page = [pageNum integerValue];
		request.offset = [pageSize integerValue];
		request.keywords = query;
		request.types = ctgr;
		request.city = city;
		request.location = point;
		request.requireExtension = [extensions isEqualToString:@"base"] ? NO : YES;
		request.radius = [radiusInMeters integerValue];
		request.sortrule = [isDistanceSort integerValue];

		[self.search AMapPOIAroundSearch:request];
	} else {
		AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
		request.page = [pageNum integerValue];
		request.offset = [pageSize integerValue];
		request.keywords = query;
		request.types = ctgr;
		request.city = city;
		request.requireExtension = [extensions isEqualToString:@"base"] ? NO : YES;

		[self.search AMapPOIKeywordsSearch:request];
	}

	self.completionHandle = completion;
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
	NSNumber *code = [NSNumber numberWithInteger:error.code];
	AmapApiResult *res = [AmapApiResult makeWithData:nil message:nil code:code];
	self.completionHandle(res, nil);
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
	NSInteger length = response.pois.count;
	NSMutableArray *poiArray = [NSMutableArray arrayWithCapacity: length];
	[response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[poiArray addObject:[Helper poiToDictionary:obj]];
	}];

	NSInteger pageCount = (NSInteger)ceil((double)response.count/length);
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithInteger:pageCount],@"pageCount",
								poiArray,@"poiList",
								nil];
	NSNumber *code = @1000;
	AmapApiResult *res = [AmapApiResult makeWithData:dictionary message:nil code:code];
	self.completionHandle(res, nil);
}

@end
