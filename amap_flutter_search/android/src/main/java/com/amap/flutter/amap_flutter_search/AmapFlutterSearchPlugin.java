package com.amap.flutter.amap_flutter_search;

import android.content.Context;

import androidx.annotation.NonNull;

import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.core.ServiceSettings;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.QueryPoiResult;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.SearchHostApi;
import com.amap.flutter.amap_flutter_search.utils.SimpleOnPoiSearchListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

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

  @Override
  public void queryPoi(GeneratedAMapSearchApis.Result<QueryPoiResult> result) {

    PoiSearch.Query query = new PoiSearch.Query("", "", "");
    query.setPageNum(0);
    query.setPageSize(20);
    PoiSearch poiSearch;
    try {
      poiSearch = new PoiSearch(context, query);
    } catch (AMapException e) {
      result.error(e);
      return;
    }
    poiSearch.setBound(new PoiSearch.SearchBound(new LatLonPoint(0, 0), 1000));
    poiSearch.setOnPoiSearchListener(new SimpleOnPoiSearchListener(){
      @Override
      public void onPoiSearched(PoiResult poiResult, int errorCode) {
        Map<String, Object> map = null;
        if (poiResult != null && poiResult.getPois() != null) {
          map = new HashMap<>();
          map.put("pageCount", poiResult.getPageCount());
        }
        result.success(new QueryPoiResult.Builder()
                .setCode((long) errorCode)
                .setResult(map)
                .build());
      }
    });
    poiSearch.searchPOIAsyn();
  }
}
