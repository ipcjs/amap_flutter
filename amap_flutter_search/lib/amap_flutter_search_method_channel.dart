import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amap_flutter_search_platform_interface.dart';

/// An implementation of [AmapFlutterSearchPlatform] that uses method channels.
class MethodChannelAmapFlutterSearch extends AmapFlutterSearchPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('amap_flutter_search');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
