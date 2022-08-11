import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google;

import '_ext.dart';
import 'polygon.dart';
import 'polygon_updates.dart';

/// Created by ipcjs on 2022/8/11.
extension CircleExt on google.Circle {
  /// [Polygon.toMap]对比[google.Polygon.toJson], 参考[google.Circle.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('id', circleId.value);
    // 不支持
    // addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('fillColor', fillColor.value);
    addIfPresent('center', center.toJson());
    addIfPresent('radius', radius);
    addIfPresent('strokeColor', strokeColor.value);
    addIfPresent('strokeWidth', strokeWidth);
    addIfPresent('visible', visible);
    // Android支持, iOS不支持...
    addIfPresent('zIndex', zIndex);
    return json;
  }
}

extension CircleUpdatesExt on google.CircleUpdates {
  /// [PolygonUpdates.toMap] 对比 [google.MapsObjectUpdates.toJson], 参考[google.MapsObjectUpdates.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    updateMap.addIfNonNull('circlesToAdd', serializeCircleSet(circlesToAdd));
    updateMap.addIfNonNull(
        'circlesToChange', serializeCircleSet(circlesToChange));
    updateMap.addIfNonNull(
        'circleIdsToRemove', circleIdsToRemove.map((e) => e.value).toList());

    return updateMap;
  }
}

/// 对比[google.serializeCircleSet]
List<Map<String, dynamic>> serializeCircleSet(Set<google.Circle> circles) {
  return circles.map<Map<String, dynamic>>((e) => e.toAMapJson()).toList();
}
