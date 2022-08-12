//
//  MACircleRenderer+Flutter.h
//  amap_flutter_map
//
//  Created by lly on 2020/11/12.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AMapCircle;

@interface MACircleRenderer (Flutter)

- (void)updateRenderWithCircle:(AMapCircle *)circle;

@end

NS_ASSUME_NONNULL_END
