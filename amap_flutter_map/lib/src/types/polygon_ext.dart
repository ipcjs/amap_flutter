import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google;

import '_ext.dart';
import 'polygon.dart';
import 'polygon_updates.dart';

/// Created by ipcjs on 2022/4/15.
extension PolygonExt on google.Polygon {
  /// [Polygon.toMap]对比[google.Polygon.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('id', polygonId.value);
    json['points'] = points.toJson();
    addIfPresent('strokeWidth', strokeWidth);
    addIfPresent('strokeColor', strokeColor.toARGB32());
    addIfPresent('fillColor', fillColor.toARGB32());
    addIfPresent('visible', visible);
    // 不支持
    // addIfPresent('consumeTapEvents', consumeTapEvents);
    // 不支持
    // addIfPresent('zIndex', zIndex);
    // 不支持
    // addIfPresent('geodesic', geodesic);
    // 不支持
    // json['holes'] = holes.toJson();

    // google没有这个属性
    // addIfPresent('joinType', joinType.index);
    return json;
  }
}

extension PolygonUpdatesExt on google.PolygonUpdates {
  /// [PolygonUpdates.toMap] 对比 [google.MapsObjectUpdates.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    updateMap.addIfNonNull('polygonsToAdd', serializePolygonSet(polygonsToAdd));
    updateMap.addIfNonNull(
        'polygonsToChange', serializePolygonSet(polygonsToChange));
    updateMap.addIfNonNull(
        'polygonIdsToRemove', polygonIdsToRemove.map((e) => e.value).toList());

    return updateMap;
  }
}

/// 对比[google.serializePolygonSet]
List<Map<String, dynamic>> serializePolygonSet(Set<google.Polygon> polygons) {
  return polygons.map<Map<String, dynamic>>((e) => e.toAMapJson()).toList();
}
