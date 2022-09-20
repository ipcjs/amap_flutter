#import "AmapFlutterSearchPlugin.h"
#import "GeneratedAMapSearchApis.h"
#import "Helper.h"

typedef void (^CompletionHandle)(AmapApiResult *res, FlutterError *err);

@interface AmapFlutterSearchPlugin () <AmapSearchHostApi>
@property (nonatomic, strong) NSMutableDictionary *requestDictionary;
@end

@implementation AmapFlutterSearchPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  AmapFlutterSearchPlugin* instance = [[AmapFlutterSearchPlugin alloc] init];
  AmapSearchHostApiSetup(registrar.messenger, instance);
}

- (AMapSearchAPI *)search {
	if (_search == nil) {
		_search = [[AMapSearchAPI alloc] init];
		_search.delegate = self;
	}
	return _search;
}

- (NSMutableDictionary *)requestDictionary {
	if (_requestDictionary == nil) {
		_requestDictionary = [[NSMutableDictionary alloc] init];
	}
	return _requestDictionary;
}

- (nullable NSString *)getPlatformVersionWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    return [@"iOS" stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
}

- (void)setApiKeyApiKey:(nonnull NSString *)apiKey error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
	[AMapServices sharedServices].apiKey = apiKey;
}

- (void)updatePrivacyAgreeIsAgree:(nonnull NSNumber *)isAgree error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
	[AMapSearchAPI updatePrivacyAgree: [isAgree boolValue] ? AMapPrivacyAgreeStatusDidAgree : AMapPrivacyAgreeStatusNotAgree];
}

- (void)updatePrivacyShowIsContains:(nonnull NSNumber *)isContains isShow:(nonnull NSNumber *)isShow error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
	[AMapSearchAPI updatePrivacyShow:[isContains boolValue] ? AMapPrivacyShowStatusDidShow : AMapPrivacyShowStatusNotShow
						 privacyInfo:[isShow boolValue] ? AMapPrivacyInfoStatusDidContain : AMapPrivacyInfoStatusNotContain];
}

- (void)searchPoiPageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize query:(NSString *)query types:(NSString *)types city:(NSString *)city location:(id)location boundRadius:(NSNumber *)boundRadius isDistanceSort:(NSNumber *)isDistanceSort extensions:(NSString *)extensions completion:(void (^)(AmapApiResult * _Nullable, FlutterError * _Nullable))completion {
	// 如果有中心点传入，请求周边POI；没有请求关键字POI
	if (location != nil && boundRadius != nil) {
		AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
		request.page = [pageNum integerValue];
		request.offset = [pageSize integerValue];
		request.keywords = query;
		request.types = types;
		request.city = city;
		request.requireExtension = [extensions isEqualToString:@"all"];
        request.location = [Helper pointFromObject:location];
        request.sortrule = [isDistanceSort boolValue] ? 0 : 1;

		request.radius = [boundRadius integerValue];

		[self.requestDictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObject:completion forKey:[NSValue valueWithNonretainedObject:request]]];
		[self.search AMapPOIAroundSearch:request];
	} else {
		AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
		request.page = [pageNum integerValue];
		request.offset = [pageSize integerValue];
		request.keywords = query;
		request.types = types;
		request.city = city;
		request.requireExtension = [extensions isEqualToString:@"all"];
        request.location = [Helper pointFromObject:location];
        request.sortrule = [isDistanceSort boolValue] ? 0 : 1;

        [self.requestDictionary setObject:completion forKey: [NSValue valueWithNonretainedObject:request]];
		[self.search AMapPOIKeywordsSearch:request];
	}
}

- (void)regeocodePoint:(nonnull id)point radius:(nonnull NSNumber *)radius latLngType:(nonnull NSString *)latLngType extensionType:(nonnull NSString *)extensionType poiTypes:(nonnull NSString *)poiTypes mode:(nonnull NSString *)mode completion:(nonnull void (^)(AmapApiResult * _Nullable, FlutterError * _Nullable))completion {
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [Helper pointFromObject:point];
    request.radius = [radius integerValue];
    // latLngType, iOS这边不支持
    request.poitype = poiTypes;
    request.mode = mode;
    request.requireExtension = [extensionType isEqualToString:@"all"];
    
    [self.requestDictionary setObject:completion
                               forKey:[NSValue valueWithNonretainedObject:request]];
    [self.search AMapReGoecodeSearch: request];
}

- (void) onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSDictionary *data = response.regeocode == nil ? nil :  [Helper reGeocodeToDictionary:response.regeocode];
    AmapApiResult *result = [AmapApiResult makeWithData:data
                                                message:nil
                                                   code:@(AMapSearchErrorOK)];
    [self completionHandle:request result:result];
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
	[self completionHandle:request result:[AmapApiResult makeWithData:nil
                                                              message:nil
                                                                 code:@(error.code)]];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
	[self completionHandle:request result:[AmapApiResult makeWithData:[Helper poiSearchResponseToDictionary:response]
                                                              message:nil
                                                                 code: @(AMapSearchErrorOK)]];
}

- (void)completionHandle:(AMapSearchObject *)request result:(AmapApiResult *)res {
	NSValue *value = [NSValue valueWithNonretainedObject:request];
	CompletionHandle handle = [self.requestDictionary objectForKey:value];
	if (handle != nil) {
		[self.requestDictionary removeObjectForKey:value];
		handle(res, nil);
	} else {
		NSLog(@"没有匹配到请求相应的回调");
	}
}

@end
