#import <Flutter/Flutter.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AmapFlutterSearchPlugin : NSObject<FlutterPlugin, AMapSearchDelegate>
@property (nonatomic,retain) AMapSearchAPI *search;
@end
