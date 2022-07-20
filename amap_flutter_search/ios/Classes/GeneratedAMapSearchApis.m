// Autogenerated from Pigeon (v3.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "GeneratedAMapSearchApis.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ?: [NSNull null]),
        @"message": (error.message ?: [NSNull null]),
        @"details": (error.details ?: [NSNull null]),
        };
  }
  return @{
      @"result": (result ?: [NSNull null]),
      @"error": errorDict,
      };
}
static id GetNullableObject(NSDictionary* dict, id key) {
  id result = dict[key];
  return (result == [NSNull null]) ? nil : result;
}
static id GetNullableObjectAtIndex(NSArray* array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}



@interface AmapSearchHostApiCodecReader : FlutterStandardReader
@end
@implementation AmapSearchHostApiCodecReader
@end

@interface AmapSearchHostApiCodecWriter : FlutterStandardWriter
@end
@implementation AmapSearchHostApiCodecWriter
@end

@interface AmapSearchHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation AmapSearchHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[AmapSearchHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[AmapSearchHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *AmapSearchHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    AmapSearchHostApiCodecReaderWriter *readerWriter = [[AmapSearchHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void AmapSearchHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<AmapSearchHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.SearchHostApi.getPlatformVersion"
        binaryMessenger:binaryMessenger
        codec:AmapSearchHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getPlatformVersionWithError:)], @"AmapSearchHostApi api (%@) doesn't respond to @selector(getPlatformVersionWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSString *output = [api getPlatformVersionWithError:&error];
        callback(wrapResult(output, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}