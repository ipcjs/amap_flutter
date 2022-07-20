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

///
@HostApi()
abstract class SearchHostApi {
  String getPlatformVersion();

  void setApiKey(String apiKey);

  void updatePrivacyShow(bool isContains, bool isShow);

  void updatePrivacyAgree(bool isAgree);

  @async
  QueryPoiResult queryPoi();
}

class QueryPoiResult {
  QueryPoiResult(this.result, this.code);
  Map<String?, Object?>? result;
  int code;
}
