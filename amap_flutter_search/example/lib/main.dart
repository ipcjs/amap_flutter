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
  static const center = LatLng(22.613214474316194, 114.04325930881298);
  final _search = AmapFlutterSearch();
  List<PoiItem> poiList = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
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

  Future<void> _handleRegeocode(
    BuildContext context,
    LatLng position, {
    ExtensionType extensionType = ExtensionType.base,
  }) async {
    final result = await _search.regeocode(RegeocodeQuery(
      point: position,
      extensionType: extensionType,
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Builder(
              builder: (context) => AppBar(
                    title: const Text('Plugin example app'),
                    actions: [
                      IconButton(
                        onPressed: () => _handleRegeocode(
                          context,
                          center,
                          extensionType: ExtensionType.all,
                        ),
                        icon: const Icon(Icons.work),
                      ),
                      IconButton(
                        onPressed: () =>
                            _handleRegeocode(context, const LatLng(0.1, 0.1)),
                        icon: const Icon(Icons.work_off),
                      ),
                    ],
                  )),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            itemBuilder: (context, index) {
              var poi = poiList[index];
              return ListTile(
                onTap: () => _handleRegeocode(context, poi.position),
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
