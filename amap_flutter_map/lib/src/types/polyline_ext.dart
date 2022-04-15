import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google;

import 'polyline.dart';
import 'polyline_updates.dart';
import '_ext.dart';

/// Created by ipcjs on 2022/4/15.
extension PolylineExt on google.Polyline {
  /// [Polyline.toMap]对比[google.Polyline.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('id', polylineId.value);
    json['points'] = points.toJson();
    addIfPresent('width', width);
    addIfPresent('visible', visible);
    addIfPresent('geodesic', geodesic);
    // 将color拆分成两部分
    addIfPresent('alpha', color.opacity);
    addIfPresent('color', color.withAlpha(0xff).value);

    // 做一个简单的映射
    DashLineType dashLineType;
    if (patterns.isEmpty) {
      dashLineType = DashLineType.none;
    } else if (patterns.contains(google.PatternItem.dot)) {
      dashLineType = DashLineType.circle;
    } else {
      dashLineType = DashLineType.square;
    }
    addIfPresent('dashLineType', dashLineType.index);

    // 如果是自定义的Cap, 则会显示arrow...
    addIfPresent(
        'capType',
        (const {
                  google.Cap.buttCap: CapType.butt,
                  google.Cap.squareCap: CapType.square,
                  google.Cap.roundCap: CapType.round,
                }[this.startCap] ??
                CapType.arrow)
            .index);
    // 不支持
    // addIfPresent('endCap', endCap.toJson());

    addIfPresent(
        'joinType',
        (const {
          google.JointType.bevel: JoinType.bevel,
          google.JointType.mitered: JoinType.miter,
          google.JointType.round: JoinType.round,
        }[jointType])!
            .index);

    if (this is AMapPolyline) {
      addIfPresent(
          'customTexture', (this as AMapPolyline).customTexture?.toJson());
    }

    // 不支持
    // addIfPresent('consumeTapEvents', consumeTapEvents);
    // 不支持
    // addIfPresent('zIndex', zIndex);
    return json;
  }
}

extension PolylineUpdatesExt on google.PolylineUpdates {
  /// [PolylineUpdates.toMap] 对比 [google.MapsObjectUpdates.toJson]
  Map<String, dynamic> toAMapJson() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    updateMap.addIfNonNull(
        'polylinesToAdd', serializePolylineSet(polylinesToAdd));
    updateMap.addIfNonNull(
        'polylinesToChange', serializePolylineSet(polylinesToChange));
    updateMap.addIfNonNull('polylineIdsToRemove',
        polylineIdsToRemove.map((e) => e.value).toList());

    return updateMap;
  }
}

/// 对比[google.serializePolylineSet]
List<Map<String, dynamic>> serializePolylineSet(
    Set<google.Polyline> polylines) {
  return polylines.map<Map<String, dynamic>>((e) => e.toAMapJson()).toList();
}

class AMapPolyline extends google.Polyline {
  /// 自定义纹理图片,注意: 如果设置了自定义纹理图片，则color的设置将无效;
  final google.BitmapDescriptor? customTexture;

  AMapPolyline({
    this.customTexture,
    required google.PolylineId polylineId,
    bool consumeTapEvents = false,
    Color color = Colors.black,
    google.Cap endCap = google.Cap.buttCap,
    bool geodesic = false,
    google.JointType jointType = google.JointType.mitered,
    List<google.LatLng> points = const [],
    List<google.PatternItem> patterns = const [],
    google.Cap startCap = google.Cap.buttCap,
    bool visible = true,
    int width = 10,
    int zIndex = 0,
    VoidCallback? onTap,
  }) : super(
          polylineId: polylineId,
          consumeTapEvents: consumeTapEvents,
          color: color,
          endCap: endCap,
          geodesic: geodesic,
          jointType: jointType,
          points: points,
          patterns: patterns,
          startCap: startCap,
          visible: visible,
          width: width,
          zIndex: zIndex,
          onTap: onTap,
        );

  AMapPolyline copyWith({
    Color? colorParam,
    bool? consumeTapEventsParam,
    google.Cap? endCapParam,
    bool? geodesicParam,
    google.JointType? jointTypeParam,
    List<google.PatternItem>? patternsParam,
    List<google.LatLng>? pointsParam,
    google.Cap? startCapParam,
    bool? visibleParam,
    int? widthParam,
    int? zIndexParam,
    VoidCallback? onTapParam,
    google.BitmapDescriptor? customTextureParam,
  }) {
    return AMapPolyline(
      polylineId: polylineId,
      customTexture: customTextureParam ?? customTexture,
      color: colorParam ?? this.color,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      endCap: endCapParam ?? endCap,
      geodesic: geodesicParam ?? geodesic,
      jointType: jointTypeParam ?? jointType,
      patterns: patternsParam ?? patterns,
      points: pointsParam ?? points,
      startCap: startCapParam ?? startCap,
      visible: visibleParam ?? visible,
      width: widthParam ?? width,
      onTap: onTapParam ?? onTap,
      zIndex: zIndexParam ?? zIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is AMapPolyline &&
          runtimeType == other.runtimeType &&
          customTexture == other.customTexture;
}
