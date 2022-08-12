//
//  AMapCircleController.m
//  amap_flutter_map
//
//  Created by lly on 2020/11/12.
//

#import "AMapCircleController.h"
#import "AMapCircle.h"
#import "AMapJsonUtils.h"
#import "MACircle+Flutter.h"
#import "MACircleRenderer+Flutter.h"
#import "FlutterMethodChannel+MethodCallDispatch.h"

@interface AMapCircleController ()

@property (nonatomic,strong) NSMutableDictionary<NSString*,AMapCircle*> *circleDict;
@property (nonatomic,strong) FlutterMethodChannel *methodChannel;
@property (nonatomic,strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic,strong) MAMapView *mapView;

@end


/// 参考: [AmapPolygonController]
@implementation AMapCircleController

- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MAMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _methodChannel = methodChannel;
        _mapView = mapView;
        _circleDict = [NSMutableDictionary dictionaryWithCapacity:1];
        _registrar = registrar;
        
        __weak typeof(self) weakSelf = self;
        [_methodChannel addMethodName:@"circles#update" withHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            id circlesToAdd = call.arguments[@"circlesToAdd"];
            if ([circlesToAdd isKindOfClass:[NSArray class]]) {
                [weakSelf addCircles:circlesToAdd];
            }
            id circlesToChange = call.arguments[@"circlesToChange"];
            if ([circlesToChange isKindOfClass:[NSArray class]]) {
                [weakSelf changeCircles:circlesToChange];
            }
            id circleIdsToRemove = call.arguments[@"circleIdsToRemove"];
            if ([circleIdsToRemove isKindOfClass:[NSArray class]]) {
                [weakSelf removeCircleIds:circleIdsToRemove];
            }
            result(nil);
        }];
    }
    return self;
}

- (nullable AMapCircle *)circleForId:(NSString *)circleId {
    return _circleDict[circleId];
}

- (void)addCircles:(NSArray*)circlesToAdd {
    for (NSDictionary* circleDict in circlesToAdd) {
        AMapCircle *circle = [AMapJsonUtils modelFromDict:circleDict modelClass:[AMapCircle class]];
        // 先加入到字段中，避免后续的地图回到里，取不到对应的overlay数据
        if (circle.id_) {
            _circleDict[circle.id_] = circle;
        }
        [self.mapView addOverlay:circle.circle];
    }
}

- (void)changeCircles:(NSArray*)circlesToChange {
    for (NSDictionary* circleDict in circlesToChange) {
        AMapCircle *circle = [AMapJsonUtils modelFromDict:circleDict modelClass:[AMapCircle class]];
        AMapCircle *currentCircle = _circleDict[circle.id_];
        NSAssert(currentCircle != nil, @"需要修改的Circle不存在");
        [currentCircle updateCircle:circle];
        MAOverlayRenderer *render = [self.mapView rendererForOverlay:currentCircle.circle];
        if (render && [render isKindOfClass:[MACircleRenderer class]]) { // render没有复用，只要添加过，就一定可以获取到
            [(MACircleRenderer *)render updateRenderWithCircle:currentCircle];
        }
    }
}

- (void)removeCircleIds:(NSArray*)circleIdsToRemove {
    for (NSString* circleId in circleIdsToRemove) {
        if (!circleId) {
            continue;
        }
        AMapCircle* circle = _circleDict[circleId];
        if (!circle) {
            continue;
        }
        [self.mapView removeOverlay:circle.circle];
        [_circleDict removeObjectForKey:circleId];
    }
}

@end
