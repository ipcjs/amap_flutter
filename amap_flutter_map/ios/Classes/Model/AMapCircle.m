//
//  AMapCircle.m
//  amap_flutter_map
//
//  Created by lly on 2020/11/12.
//

#import "AMapCircle.h"
#import "AMapConvertUtil.h"
#import "MACircle+Flutter.h"

@interface AMapCircle ()

@property (nonatomic, strong,readwrite) MACircle *circle;

@end


@implementation AMapCircle

- (instancetype)init {
    self = [super init];
    if (self) {
        _visible = YES;
    }
    return self;
}

- (MACircle *)circle {
    if (_circle == nil) {
        _circle = [[MACircle alloc] initWithCircleId:self.id_];
        [_circle setCircleWithCenterCoordinate:self.center radius:self.radius];
    }
    return _circle;
}

//更新polyline
- (void)updateCircle:(AMapCircle *)circle {
    NSAssert((circle != nil && [self.id_ isEqualToString:circle.id_]), @"更新AMapCircle数据异常");
    self.strokeWidth = circle.strokeWidth;
    self.strokeColor = circle.strokeColor;
    self.fillColor = circle.fillColor;
    self.visible = circle.visible;
    self.center = circle.center;
    self.radius = circle.radius;
    
    if (_circle) {
        [_circle setCircleWithCenterCoordinate:self.center radius:self.radius];
    }
}

@end
