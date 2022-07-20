
import 'amap_flutter_search_platform_interface.dart';

class AmapFlutterSearch {
  Future<String?> getPlatformVersion() {
    return AmapFlutterSearchPlatform.instance.getPlatformVersion();
  }
}
