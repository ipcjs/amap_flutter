import 'package:pigeon/pigeon.dart';

/// Created by ipcjs on 2022/7/20.
@ConfigurePigeon(PigeonOptions(
  javaOut:
      'android/src/main/java/com/amap/flutter/amap_flutter_search/GeneratedAMapSearchApis.java',
  javaOptions: JavaOptions(package: 'com.amap.flutter.amap_flutter_search'),
  dartOut: 'lib/src/amap_search.pigeon.dart',
  objcHeaderOut: 'ios/Classes/GeneratedAMapSearchApis.h',
  objcSourceOut: 'ios/Classes/GeneratedAMapSearchApis.m',
  objcOptions: ObjcOptions(
    prefix: 'Amap',
  ),
))

/// ## 搜索接口
///
/// ## 为什么不用pigeon生成的Model类
/// pigeon生成的Model类存在如下问题:
/// 1. 无法给Model属性设置默认值
/// 2. 不在当前模板中的类, 不能使用
///
/// 故针对复杂的方法调用, 参数"打平"成超长的参数列表, 返回值使用Map<String?, Object?>来接收数据
///
/// 如: [SearchHostApi.searchPoi]
@HostApi()
abstract class SearchHostApi {
  String getPlatformVersion();

  void setApiKey(String apiKey);

  void updatePrivacyShow(bool isContains, bool isShow);

  void updatePrivacyAgree(bool isAgree);

  /// - [center], [LatLng]是外部的类, 不能在当前模板中使用, 故这里声明成[LatLng.toJson]的返回值类型: [Object]
  @async
  ApiResult searchPoi(
    int pageNum,
    int pageSize,
    String query,
    String types,
    String city,
    Object? location,
    int? boundRadius,
    bool isDistanceSort,
    String extensions,
  );

  /// 地理位置逆编码
  @async
  ApiResult regeocode(
    Object point,
    double radius,
    String latLngType,
    String extensionType,
    String poiTypes,
    String mode,
  );
}

class ApiResult {
  ApiResult(this.data, this.code, this.message);
  Map<String?, Object?>? data;
  String? message;
  int code;
}
