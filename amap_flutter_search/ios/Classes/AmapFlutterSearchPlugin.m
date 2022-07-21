#import "AmapFlutterSearchPlugin.h"
#import "GeneratedAMapSearchApis.h"

@interface AmapFlutterSearchPlugin () <AmapSearchHostApi>
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
    // TODO: impl
}


- (void)updatePrivacyAgreeIsAgree:(nonnull NSNumber *)isAgree error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    // TODO: impl
}


- (void)updatePrivacyShowIsContains:(nonnull NSNumber *)isContains isShow:(nonnull NSNumber *)isShow error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    // TODO: impl
}

- (void)searchPoiPageNum:(nonnull NSNumber *)pageNum pageSize:(nonnull NSNumber *)pageSize query:(nonnull NSString *)query ctgr:(nonnull NSString *)ctgr city:(nonnull NSString *)city center:(nullable id)center radiusInMeters:(nullable NSNumber *)radiusInMeters isDistanceSort:(nullable NSNumber *)isDistanceSort extensions:(nonnull NSString *)extensions completion:(nonnull void (^)(AmapApiResult * _Nullable, FlutterError * _Nullable))completion {
    completion([AmapApiResult makeWithData:nil message:nil code:@1001], nil);
}

@end
