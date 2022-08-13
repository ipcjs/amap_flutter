import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/const_config.dart';
import 'package:flutter/material.dart';

/// Created by ipcjs on 2022/8/11.
class CircleDemoPage extends BasePage {
  const CircleDemoPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _State();
}

class _State extends State<_Body> {
  AMapController? _controller;
  LatLng? _topLeft;
  ScreenCoordinate? _topLeftPoint;
  void _onMapCreated(AMapController controller) {
    _controller = controller;
    _refresh();
  }

  Future<void> _refresh() async {
    if (_controller == null) return;

    final latLng = await _controller!.getLatLng(ScreenCoordinate(x: 0, y: 0));
    final point = await _controller!.getScreenCoordinate(latLng);
    if (mounted) {
      setState(() {
        _topLeft = latLng;
        _topLeftPoint = point;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      privacyStatement: ConstConfig.amapPrivacyStatement,
      initialCameraPosition:
          CameraPosition(target: LatLng(39.828809, 116.360364), zoom: 13),
      onMapCreated: _onMapCreated,
      circles: {
        Circle(
          circleId: CircleId('circle'),
          center: LatLng(39.835334, 116.3710069),
          radius: 1000,
          strokeWidth: 4,
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.white,
        ),
      },
    );

    return Stack(
      children: [
        map,
        TextButton(
          onPressed: () => _refresh(),
          child: Text('topLeft: ${_topLeftPoint} -> ${_topLeft?.toJson()}'),
        ),
      ],
    );
  }
}
