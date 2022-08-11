//
//  AMapCircle.h
//  amap_flutter_map
//
//  Created by lly on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMapCircle : NSObject

@property (nonatomic, copy) NSString *id_;

/// 边框宽度
@property (nonatomic, assign) CGFloat strokeWidth;

/// 边框颜色
@property (nonatomic, strong) UIColor *strokeColor;

/// 填充颜色
@property (nonatomic, strong) UIColor *fillColor;

/// 是否可见
@property (nonatomic, assign) bool visible;

@property (nonatomic, assign) CLLocationCoordinate2D center;

@property (nonatomic, assign) CLLocationDistance radius;

/// 由以上数据生成的circle对象
@property (nonatomic, strong,readonly) MACircle *circle;

- (void)updateCircle:(AMapCircle *)circle;

@end

NS_ASSUME_NONNULL_END
