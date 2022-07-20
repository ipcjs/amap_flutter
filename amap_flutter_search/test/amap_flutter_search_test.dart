import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amap_flutter_search/amap_flutter_search.dart';
import 'package:amap_flutter_search/amap_flutter_search_platform_interface.dart';
import 'package:amap_flutter_search/src/amap_flutter_search_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmapFlutterSearchPlatform
    with MockPlatformInterfaceMixin
    implements AmapFlutterSearchPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> init({
    AMapApiKey? apiKey,
    AMapPrivacyStatement? privacyStatement,
  }) async {
    // no-op
  }

  @override
  Future<Map<String, dynamic>> queryPoi() {
    // TODO: implement queryPoi
    throw UnimplementedError();
  }
}

void main() {
  final AmapFlutterSearchPlatform initialPlatform =
      AmapFlutterSearchPlatform.instance;

  test('$MethodChannelAmapFlutterSearch is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmapFlutterSearch>());
  });

  test('getPlatformVersion', () async {
    AmapFlutterSearch amapFlutterSearchPlugin = AmapFlutterSearch();
    MockAmapFlutterSearchPlatform fakePlatform =
        MockAmapFlutterSearchPlatform();
    AmapFlutterSearchPlatform.instance = fakePlatform;

    expect(await amapFlutterSearchPlugin.getPlatformVersion(), '42');
  });
}
