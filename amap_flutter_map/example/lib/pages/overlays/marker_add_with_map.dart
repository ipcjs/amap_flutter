import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/const_config.dart';
import 'package:flutter/material.dart';

class MarkerAddWithMapPage extends BasePage {
  MarkerAddWithMapPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static final LatLng mapCenter = const LatLng(39.909187, 116.397451);
  final _initMarkerMap = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 10; i++) {
      LatLng position = LatLng(mapCenter.latitude + sin(i * pi / 12.0) / 20.0,
          mapCenter.longitude + cos(i * pi / 12.0) / 20.0);
      Marker marker =
          Marker(markerId: MarkerId(i.toString()), position: position);
      _initMarkerMap[marker.markerId] = marker;
    }

    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      markers: Set<Marker>.of(_initMarkerMap.values),
    );
    return Container(
      child: amap,
    );
  }
}
