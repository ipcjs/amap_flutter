package com.amap.flutter.amap_flutter_search;

import android.content.Context;

import androidx.annotation.NonNull;


import com.amap.api.services.core.ServiceSettings;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.SearchHostApi;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** AmapFlutterSearchPlugin */
public class AmapFlutterSearchPlugin implements FlutterPlugin, SearchHostApi {
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    SearchHostApi.setup(flutterPluginBinding.getBinaryMessenger(), this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    SearchHostApi.setup(binding.getBinaryMessenger(), null);
    context = null;
  }


  @NonNull
  @Override
  public String getPlatformVersion() {
    return "Android " + android.os.Build.VERSION.RELEASE;
  }

  @Override
  public void setApiKey(@NonNull String apiKey) {
    ServiceSettings.getInstance().setApiKey(apiKey);
  }

  @Override
  public void updatePrivacyShow(@NonNull Boolean isContains, @NonNull Boolean isShow) {
    ServiceSettings.updatePrivacyShow(context, isContains, isShow);
  }

  @Override
  public void updatePrivacyAgree(@NonNull Boolean isAgree) {
    ServiceSettings.updatePrivacyAgree(context, isAgree);
  }
}
