import 'dart:ui' show Offset;

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// 一些工具方法
///
/// Created by ipcjs on 2022/4/15.
extension OffsetExt on Offset {
  Object toJson() => <dynamic>[dx, dy];
}

extension LatLngListExt on List<LatLng> {
  List<Object> toJson() => this.map<Object>((e) => e.toJson()).toList();
}

extension LatLngListListExt on List<List<LatLng>> {
  List<List<Object>> toJson() =>
      this.map<List<Object>>((e) => e.toJson()).toList();
}

extension MapExt on Map<String, dynamic> {
  void addIfNonNull(String fieldName, dynamic value) {
    if (value != null) {
      this[fieldName] = value;
    }
  }
}
