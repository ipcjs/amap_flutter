import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/widgets/amap_switch_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class PolylineDemoPage extends BasePage {
  PolylineDemoPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
  _State();

// Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  PolylineId? selectedPolylineId;

  void _onMapCreated(AMapController controller) {}

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final int polylineCount = _polylines.length;
    final double offset = polylineCount * -(0.01);
    points.add(LatLng(39.938698 + offset, 116.275177));
    points.add(LatLng(39.966069 + offset, 116.289253));
    points.add(LatLng(39.944226 + offset, 116.306076));
    points.add(LatLng(39.966069 + offset, 116.322899));
    points.add(LatLng(39.938698 + offset, 116.336975));
    return points;
  }

  int _polylineIdValue = 0;
  void _add() {
    final polylineId = PolylineId((_polylineIdValue++).toString());
    final Polyline polyline = Polyline(
        polylineId: polylineId,
        color: colors[++colorsIndex % colors.length],
        width: 10,
        points: _createPoints(),
        onTap: () => _onPolylineTapped(polylineId));
    setState(() {
      _polylines[polyline.polylineId] = polyline;
    });
  }

  void _remove() {
    final Polyline? selectedPolyline = _polylines[selectedPolylineId];
    //有选中的Marker
    if (selectedPolyline != null) {
      setState(() {
        _polylines.remove(selectedPolylineId);
      });
    } else {
      print('无选中的Polyline，无法删除');
    }
  }

  void _changeWidth() {
    final Polyline? selectedPolyline = _polylines[selectedPolylineId]!;
    //有选中的Polyline
    if (selectedPolyline != null) {
      int currentWidth = selectedPolyline.width;
      if (currentWidth < 50) {
        currentWidth += 10;
      } else {
        currentWidth = 5;
      }

      setState(() {
        _polylines[selectedPolylineId!] =
            selectedPolyline.copyWith(widthParam: currentWidth);
      });
    } else {
      print('无选中的Polyline，无法修改宽度');
    }
  }

  void _onPolylineTapped(PolylineId polylineId) {
    print('Polyline: $polylineId 被点击了');
    setState(() {
      selectedPolylineId = polylineId;
    });
  }

  static final _dashLineTypes = <List<PatternItem>>[
    [],
    [PatternItem.dash(1), PatternItem.gap(1)],
    [PatternItem.dot, PatternItem.gap(1)],
  ];
  Future<void> _changeDashLineType() async {
    final Polyline? polyline = _polylines[selectedPolylineId];
    if (polyline == null) {
      return;
    }
    final currentType = polyline.patterns;

    final currentIndex = _dashLineTypes
        .indexWhere((element) => listEquals(currentType, element));

    setState(() {
      _polylines[selectedPolylineId!] = polyline.copyWith(
          patternsParam:
              _dashLineTypes[(currentIndex + 1) % _dashLineTypes.length]);
    });
  }

  static final _capTypes = [
    Cap.buttCap,
    Cap.roundCap,
    Cap.squareCap,
    // 目前任意自定义的Cap, 都会被映射成CapType.arrow...
    Cap.customCapFromBitmap(AMapBitmapDescriptor.fromIconPath('arrow')),
  ];
  void _changeCapType() {
    final Polyline? polyline = _polylines[selectedPolylineId]!;
    if (polyline == null) {
      return;
    }
    final capType = _capTypes[
        (_capTypes.indexOf(polyline.startCap) + 1) % _capTypes.length];
    setState(() {
      _polylines[selectedPolylineId!] =
          polyline.copyWith(startCapParam: capType, endCapParam: capType);
    });
  }

  static const _jointTypes = [
    JointType.bevel,
    JointType.round,
    JointType.mitered,
  ];
  void _changeJointType() {
    final Polyline polyline = _polylines[selectedPolylineId]!;
    final jointType = _jointTypes[
        (_jointTypes.indexOf(polyline.jointType) + 1) % _jointTypes.length];
    setState(() {
      _polylines[selectedPolylineId!] =
          polyline.copyWith(jointTypeParam: jointType);
    });
  }

  Future<void> _changeAlpha() async {
    final Polyline polyline = _polylines[selectedPolylineId]!;
    final double current = polyline.color.a;
    setState(() {
      _polylines[selectedPolylineId!] = polyline.copyWith(
        colorParam: polyline.color
            .withValues(alpha: current < 0.1 ? 1.0 : current * 0.75),
      );
    });
  }

  Future<void> _toggleVisible(value) async {
    final Polyline polyline = _polylines[selectedPolylineId]!;
    setState(() {
      _polylines[selectedPolylineId!] = polyline.copyWith(
        visibleParam: value,
      );
    });
  }

  void _changeColor() {
    final Polyline polyline = _polylines[selectedPolylineId]!;
    setState(() {
      _polylines[selectedPolylineId!] = polyline.copyWith(
        colorParam: colors[++colorsIndex % colors.length],
      );
    });
  }

  void _changePoints() {
    final Polyline polyline = _polylines[selectedPolylineId]!;
    List<LatLng> currentPoints = polyline.points;
    List<LatLng> newPoints = <LatLng>[];
    newPoints.addAll(currentPoints);
    newPoints.add(LatLng(39.835347, 116.34575));

    setState(() {
      _polylines[selectedPolylineId!] = polyline.copyWith(
        pointsParam: newPoints,
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      onMapCreated: _onMapCreated,
      polylines: Set<Polyline>.of(_polylines.values),
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          TextButton(
                            child: const Text('添加'),
                            onPressed: _add,
                          ),
                          TextButton(
                            child: const Text('删除'),
                            onPressed:
                                (selectedPolylineId == null) ? null : _remove,
                          ),
                          TextButton(
                            child: const Text('修改线宽'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeWidth,
                          ),
                          TextButton(
                            child: const Text('修改透明度'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeAlpha,
                          ),
                          AMapSwitchButton(
                            label: Text('显示'),
                            onSwitchChanged: (selectedPolylineId == null)
                                ? null
                                : _toggleVisible,
                            defaultValue: true,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          TextButton(
                            child: const Text('修改颜色'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeColor,
                          ),
                          TextButton(
                            child: const Text('修改线头样式'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeCapType,
                          ),
                          TextButton(
                            child: const Text('修改连接样式'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeJointType,
                          ),
                          TextButton(
                            child: const Text('修改虚线类型'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changeDashLineType,
                          ),
                          TextButton(
                            child: const Text('修改坐标'),
                            onPressed: (selectedPolylineId == null)
                                ? null
                                : _changePoints,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
