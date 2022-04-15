# amap_flutter_map

基于[高德开放平台地图SDK](https://lbs.amap.com/api/)的flutter插件

## Usage
使用Flutter插件，请参考[在Flutter里使用Packages](https://flutter.cn/docs/development/packages-and-plugins/using-packages), 添加amap_flutter_map的引用

## 准备工作
* 登录[高德开放平台官网](https://lbs.amap.com/)申请ApiKey。Android平台申请配置key请参考[Android获取key](https://lbs.amap.com/api/poi-sdk-android/develop/create-project/get-key/?sug_index=2), iOS平台申请配置请参考[iOS获取key](https://lbs.amap.com/api/poi-sdk-ios/develop/create-project/get-key/?sug_index=1)。
* 引入高德地图SDK，Android平台请参考[Android Sudio配置工程](https://lbs.amap.com/api/android-sdk/guide/create-project/android-studio-create-project), iOS平台请参考[ios安装地图SDK](https://lbs.amap.com/api/ios-sdk/guide/create-project/cocoapods)
* iOS端插件使用特殊配置:Flutter 1.22.0 之前(之后的版本可以不添加该配置)，iOS端的UiKitView还只是preview状态, 默认是不支持的, 需要手动打开开关, 需要在iOS工程的info.plist添加如下配置:
``` XML
<key>io.flutter.embedded_views_preview</key>
<string>YES</string>
```

## 使用示例
``` Dart
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:flutter/material.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

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
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10.0,
  );
  List<Widget> _approvalNumberWidget = List<Widget>();
  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      initialCameraPosition: _kInitialPosition,
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

  AMapController _mapController;
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
        await _mapController?.getMapContentApprovalNumber();
    //卫星地图审图号
    String satelliteImageApprovalNumber =
        await _mapController?.getSatelliteImageApprovalNumber();
    setState(() {
      if (null != mapContentApprovalNumber) {
        _approvalNumberWidget.add(Text(mapContentApprovalNumber));
      }
      if (null != satelliteImageApprovalNumber) {
        _approvalNumberWidget.add(Text(satelliteImageApprovalNumber));
      }
    });
    print('地图审图号（普通地图）: $mapContentApprovalNumber');
    print('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }
}

```

## 已知问题：
1. Flutter插件在iOS端，MapView销毁时，一定概率触发Main Thread Checker的报警，
经过对比测试确认是Flutter的bug所致；https://github.com/flutter/flutter/issues/68490 
（对比1.25.0-8.1.pre版本已修复，从github的issues中得知，有其它开发着反馈1.24.0-6.0.pre已修复；该问题依赖Flutter升级修复） 




