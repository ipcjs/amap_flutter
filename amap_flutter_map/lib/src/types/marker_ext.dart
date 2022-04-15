import 'package:flutter/painting.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google;

import '_ext.dart';
import 'marker.dart';
import 'marker_updates.dart';

/// Created by ipcjs on 2022/4/15.
extension MarkerExt on google.Marker {
  /// [Marker.toMap]对比[google.Marker.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('id', markerId.value);
    addIfPresent('alpha', alpha);
    addIfPresent('anchor', anchor.toJson());
    // 不知道是否支持
    // addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('clickable', onTap != null);
    addIfPresent('draggable', draggable);
    // 不支持
    // addIfPresent('flat', flat);
    addIfPresent('icon', icon.toJson());
    addIfPresent('infoWindowEnable', infoWindow != google.InfoWindow.noText);
    addIfPresent('infoWindow', infoWindow._toAMapJson());
    addIfPresent('position', position.toJson());
    addIfPresent('rotation', rotation);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    return json;
  }
}

extension InfoWindowExt on google.InfoWindow {
  /// [InfoWindow._toMap]对比[google.InfoWindow._toJson]
  Map<String, dynamic> _toAMapJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('title', title);
    addIfPresent('snippet', snippet);
    // 不支持
    // addIfPresent('anchor', anchor.toJson());
    return json;
  }
}

extension MarkerUpdatesExt on google.MarkerUpdates {
  /// [MarkerUpdates.toMap] 对比 [google.MapsObjectUpdates.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    updateMap.addIfNonNull('markersToAdd', serializeMarkerSet(markersToAdd));
    updateMap.addIfNonNull(
        'markersToChange', serializeMarkerSet(markersToChange));
    updateMap.addIfNonNull(
        'markerIdsToRemove', markerIdsToRemove.map((e) => e.value).toList());

    return updateMap;
  }
}

/// 对比[google.serializeMarkerSet]
List<Map<String, dynamic>> serializeMarkerSet(Set<google.Marker> markers) {
  return markers.map<Map<String, dynamic>>((e) => e.toAMapJson()).toList();
}
