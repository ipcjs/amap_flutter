import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/amap_flutter_search_method_channel.dart';
import 'src/beans.dart';

abstract class AmapFlutterSearchPlatform extends PlatformInterface {
  /// Constructs a AmapFlutterSearchPlatform.
  AmapFlutterSearchPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmapFlutterSearchPlatform _instance = MethodChannelAmapFlutterSearch();

  /// The default instance of [AmapFlutterSearchPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmapFlutterSearch].
  static AmapFlutterSearchPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmapFlutterSearchPlatform] when
  /// they register themselves.
  static set instance(AmapFlutterSearchPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init({
    AMapApiKey? apiKey,
    AMapPrivacyStatement? privacyStatement,
  }) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<PoiSearchResult> searchPoi(PoiSearchQuery query) {
    throw UnimplementedError('queryPoi() has not been implemented.');
  }

  Future<RegeocodeResult?> regeocode(RegeocodeQuery query) {
    throw UnimplementedError('regeocode() has not been implemented.');
  }
}
