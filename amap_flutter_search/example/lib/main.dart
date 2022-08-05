import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amap_flutter_search/amap_flutter_search.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AmapFlutterSearch().init(
    apiKey: const AMapApiKey(
      androidKey: '011689ce44dada05b481e7a5b46f361d',
      iosKey: 'd50ed2c21af0d0a4d1cc9983d36fdb68',
    ),
    privacyStatement: const AMapPrivacyStatement(
      hasContains: true,
      hasShow: true,
      hasAgree: true,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _search = AmapFlutterSearch();
  List<PoiItem> poiList = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    const center = LatLng(22.613214474316194, 114.04325930881298);
    var futureBase = _search.searchPoi(PoiSearchQuery(
      extensionType: ExtensionType.base,
      bound: PoiSearchBound(
        center: center,
      ),
    ));
    var futureAll = _search.searchPoi(PoiSearchQuery(
      extensionType: ExtensionType.all,
      bound: PoiSearchBound(
        center: center,
      ),
    ));
    // 模拟同时执行多个请求, Native层需要能够区分各自的响应
    final results = await Future.wait([futureBase, futureAll]);

    if (mounted) {
      setState(() {
        poiList = results[1].poiList;
      });
    }
  }

  Future<void> _handlePoiTap(BuildContext context, PoiItem poi) async {
    final result = await _search.regeocode(RegeocodeQuery(
      point: poi.position,
      extensionType: ExtensionType.all,
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            itemBuilder: (context, index) {
              var poi = poiList[index];
              return ListTile(
                onTap: () => _handlePoiTap(context, poi),
                title: Text(poi.title),
                subtitle: Text(poi.toString()),
              );
            },
            itemCount: poiList.length,
          ),
        ),
      ),
    );
  }
}
