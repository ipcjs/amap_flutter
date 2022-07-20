package com.amap.flutter.amap_flutter_search;

import androidx.annotation.NonNull;


import com.amap.flutter.amap_flutter_search.GeneratedAmapSearch.SearchHostApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AmapFlutterSearchPlugin */
public class AmapFlutterSearchPlugin implements FlutterPlugin, SearchHostApi {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    SearchHostApi.setup(flutterPluginBinding.getBinaryMessenger(), this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    SearchHostApi.setup(binding.getBinaryMessenger(), null);
  }


  @NonNull
  @Override
  public String getPlatformVersion() {
    return "Android " + android.os.Build.VERSION.RELEASE;
  }
}
