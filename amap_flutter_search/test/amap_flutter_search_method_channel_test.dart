import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amap_flutter_search/src/amap_flutter_search_method_channel.dart';

void main() {
  MethodChannelAmapFlutterSearch platform = MethodChannelAmapFlutterSearch();
  const MethodChannel channel = MethodChannel('amap_flutter_search');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
