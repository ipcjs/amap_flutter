import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/const_config.dart';
import 'package:flutter/material.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';

class ShowMapPage extends BasePage {
  ShowMapPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _ShowMapPageBody();
  }
}

class _ShowMapPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<_ShowMapPageBody> {
  List<Widget> _approvalNumberWidget = <Widget>[];
  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      onMapCreated: onMapCreated,
    );

    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Positioned(
              right: 10,
              bottom: 15,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _approvalNumberWidget),
              ))
        ],
      ),
    );
  }

  late AMapController _mapController;
  void onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
      getApprovalNumber();
    });
  }

  /// 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    String mapContentApprovalNumber =
      (await _mapController.getMapContentApprovalNumber())!;
    //卫星地图审图号
    String satelliteImageApprovalNumber =
      (await _mapController.getSatelliteImageApprovalNumber())!;
    setState(() {
        _approvalNumberWidget.add(Text(mapContentApprovalNumber));
        _approvalNumberWidget.add(Text(satelliteImageApprovalNumber));
    });
    print('地图审图号（普通地图）: $mapContentApprovalNumber');
    print('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }
}
