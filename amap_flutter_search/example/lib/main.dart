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
    final result = await _search.searchPoi(PoiSearchQuery(
      extensionType: PoiSearchExtensionType.base,
      bound: PoiSearchBound(
        center: const LatLng(22.613214474316194, 114.04325930881298),
      ),
    ));
    if (mounted) {
      setState(() {
        poiList = result.poiList;
      });
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
            itemBuilder: (context, index) => ListTile(
              title: Text(poiList[index].title),
              subtitle: Text(poiList[index].toString()),
            ),
            itemCount: poiList.length,
          ),
        ),
      ),
    );
  }
}
