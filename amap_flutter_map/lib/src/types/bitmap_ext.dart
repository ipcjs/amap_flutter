import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google;
import 'package:amap_flutter_base/amap_flutter_base.dart' show AMapUtil;

import 'bitmap.dart';

///
/// [BitmapDescriptor]与[google.BitmapDescriptor]的json格式一致, 但如下几个方法有区别
///
/// Created by ipcjs on 2022/4/15.
class AMapBitmapDescriptor {
  const AMapBitmapDescriptor._();

  static google.BitmapDescriptor fromIconPath(String iconPath) =>
      google.BitmapDescriptor.fromJson(<dynamic>[
        'fromAsset',
        iconPath,
      ]);

  static google.BitmapDescriptor defaultMarkerWithHue(double hue) {
    assert(0.0 <= hue && hue < 360.0);
    String filename = "BLUE.png";
    if (hue == BitmapDescriptor.hueRed) {
      filename = "RED.png";
    } else if (hue == BitmapDescriptor.hueOrange) {
      filename = "ORANGE.png";
    } else if (hue == BitmapDescriptor.hueYellow) {
      filename = "YELLOW.png";
    } else if (hue == BitmapDescriptor.hueGreen) {
      filename = "GREEN.png";
    } else if (hue == BitmapDescriptor.hueCyan) {
      filename = "CYAN.png";
    } else if (hue == BitmapDescriptor.hueAzure) {
      filename = "AZURE.png";
    } else if (hue == BitmapDescriptor.hueBlue) {
      filename = "BLUE.png";
    } else if (hue == BitmapDescriptor.hueViolet) {
      filename = "VIOLET.png";
    } else if (hue == BitmapDescriptor.hueMagenta) {
      filename = "MAGENTA.png";
    } else if (hue == BitmapDescriptor.hueRose) {
      filename = "ROSE.png";
    }
    return google.BitmapDescriptor.fromJson(<dynamic>[
      'fromAssetImage',
      "packages/amap_flutter_map/res/$filename",
      AMapUtil.devicePixelRatio
    ]);
  }
}
