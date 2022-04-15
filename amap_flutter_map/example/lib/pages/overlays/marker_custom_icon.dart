import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/const_config.dart';
import 'package:flutter/material.dart';

class MarkerCustomIconPage extends BasePage {
  MarkerCustomIconPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static final LatLng markerPosition = const LatLng(39.909187, 116.397451);
  final Map<String, Marker> _initMarkerMap = <String, Marker>{};
  String? _currentMarkerId;
  bool _hasInitMarker = false;
  static final String _startIconPath = 'assets/start.png';
  static final String _endIconPath = 'assets/end.png';
  String _iconPath = _startIconPath;
  void _initMarker(BuildContext context) async {
    if (_hasInitMarker) {
      return;
    }
    Marker marker = Marker(
        position: markerPosition,
        icon: BitmapDescriptor.fromIconPath(_iconPath));
    setState(() {
      _hasInitMarker = true;
      _currentMarkerId = marker.id;
      _initMarkerMap[marker.id] = marker;
    });
  }

  void _updateMarkerIcon() async {
    Marker marker = _initMarkerMap[_currentMarkerId]!;
    setState(() {
      _iconPath = _iconPath == _startIconPath ? _endIconPath : _startIconPath;
      _initMarkerMap[_currentMarkerId!] =
          marker.copyWith(iconParam: BitmapDescriptor.fromIconPath(_iconPath));
    });
  }

  TextButton _createMyFloatButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        //文字颜色
        foregroundColor: MaterialStateProperty.all(Colors.white),
        //水波纹颜色
        overlayColor: MaterialStateProperty.all(Colors.blueAccent),
        //背景颜色
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(MaterialState.pressed)) {
            return Colors.blueAccent;
          }
          //默认背景颜色
          return Colors.blue;
        }),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initMarker(context);
    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      markers: Set<Marker>.of(_initMarkerMap.values),
    );
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 10,
              child: amap,
            ),
            Expanded(
              flex: 1,
              child: _createMyFloatButton('更改图标', _updateMarkerIcon),
            ),
          ],
        ));
  }
}
