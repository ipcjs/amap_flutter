package com.amap.flutter.amap_flutter_search;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.core.ServiceSettings;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.ApiResult;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.SearchHostApi;
import com.amap.flutter.amap_flutter_search.utils.SimpleOnPoiSearchListener;
import com.amap.flutter.amap_flutter_search.utils.JsonMaps;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * AmapFlutterSearchPlugin
 */
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
  public void searchPoi(
      @NonNull Long pageNum,
      @NonNull Long pageSize,
      @NonNull String queryText,
      @NonNull String ctgr,
      @NonNull String city,
      @Nullable Object center,
      @Nullable Long radiusInMeters,
      @Nullable Boolean isDistanceSort,
      @NonNull String extensions,
      GeneratedAMapSearchApis.Result<ApiResult> result
  ) {
    PoiSearch.Query query = new PoiSearch.Query(queryText, ctgr, city);
    query.setPageNum(pageNum.intValue());
    query.setPageSize(pageSize.intValue());
    query.setExtensions(extensions);
    PoiSearch poiSearch;
    try {
      poiSearch = new PoiSearch(context, query);
    } catch (AMapException e) {
      result.success(new ApiResult.Builder()
          .setCode((long) e.getErrorCode())
          .setMessage(e.getErrorMessage())
          .build());
      return;
    }
    if (center != null && radiusInMeters != null && isDistanceSort != null) {
      poiSearch.setBound(new PoiSearch.SearchBound(JsonMaps.pointFromObject(center), radiusInMeters.intValue(), isDistanceSort));
    }
    poiSearch.setOnPoiSearchListener(new SimpleOnPoiSearchListener() {
      @Override
      public void onPoiSearched(PoiResult poiResult, int errorCode) {
        Map<String, Object> map = null;
        if (poiResult != null && poiResult.getPois() != null) {
          ArrayList<PoiItem> pois = poiResult.getPois();
          List<Map<String, Object>> poiList = new ArrayList<>(pois.size());
          for (PoiItem poi : pois) {
            poiList.add(JsonMaps.poiToMap(poi));
          }

          map = new HashMap<>();
          map.put("pageCount", poiResult.getPageCount());
          map.put("poiList", poiList);
        }
        result.success(new ApiResult.Builder()
            .setCode((long) errorCode)
            .setData(map)
            .build());
      }
    });
    poiSearch.searchPOIAsyn();
  }
}
