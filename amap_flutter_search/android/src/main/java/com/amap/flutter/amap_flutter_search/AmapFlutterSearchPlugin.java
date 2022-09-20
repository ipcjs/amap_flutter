package com.amap.flutter.amap_flutter_search;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.ServiceSettings;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.ApiResult;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.SearchHostApi;
import com.amap.flutter.amap_flutter_search.utils.JsonMaps;
import com.amap.flutter.amap_flutter_search.utils.SimpleOnGeocodeSearchListener;
import com.amap.flutter.amap_flutter_search.utils.SimpleOnPoiSearchListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * AmapFlutterSearchPlugin
 */
public class AmapFlutterSearchPlugin implements FlutterPlugin, SearchHostApi {
  private static String TAG = "amap_flutter_search";
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
      @NonNull String types,
      @NonNull String city,
      @Nullable Object location,
      @Nullable Long boundRadius,
      @NonNull Boolean isDistanceSort,
      @NonNull String extensions,
      GeneratedAMapSearchApis.Result<ApiResult> result
  ) {
    PoiSearch.Query query = new PoiSearch.Query(queryText, types, city);
    query.setPageNum(pageNum.intValue());
    query.setPageSize(pageSize.intValue());
    query.setExtensions(extensions);
    query.setDistanceSort(isDistanceSort);
    if (location != null) {
      query.setLocation(JsonMaps.pointFromObject(location));
    }
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
    if (boundRadius != null && location != null) {
      poiSearch.setBound(new PoiSearch.SearchBound(JsonMaps.pointFromObject(location), boundRadius.intValue(), isDistanceSort));
    }
    poiSearch.setOnPoiSearchListener(new SimpleOnPoiSearchListener() {
      @Override
      public void onPoiSearched(PoiResult poiResult, int errorCode) {
        Map<String, Object> map = null;
        if (errorCode == AMapException.CODE_AMAP_SUCCESS) {
          map = new HashMap<>();
          List<Map<String, Object>> poiList = new ArrayList<>();
          int pageCount = 0;

          if (poiResult != null && poiResult.getPois() != null) {
            poiList = JsonMaps.map(poiResult.getPois(), JsonMaps::poiToMap);
            pageCount = poiResult.getPageCount();
          }

          map.put("pageCount", pageCount);
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

  @Override
  public void regeocode(@NonNull Object point, @NonNull Double radius, @NonNull String latLngType, @NonNull String extensionType, @NonNull String poiTypes, @NonNull String mode, GeneratedAMapSearchApis.Result<ApiResult> result) {
    GeocodeSearch geocodeSearch;
    try {
      geocodeSearch = new GeocodeSearch(context);
    } catch (AMapException e) {
      result.success(new ApiResult.Builder()
          .setCode((long) e.getErrorCode())
          .setMessage(e.getErrorMessage())
          .build());
      return;
    }

    RegeocodeQuery query = new RegeocodeQuery(JsonMaps.pointFromObject(point), radius.floatValue(), latLngType);
    query.setExtensions(extensionType);
    query.setPoiType(poiTypes);
    query.setMode(mode);
    geocodeSearch.setOnGeocodeSearchListener(new SimpleOnGeocodeSearchListener() {
      @Override
      public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int errorCode) {
        Map<String, Object> map = null;
        if (errorCode == AMapException.CODE_AMAP_SUCCESS) {
          if (regeocodeResult != null
              && regeocodeResult.getRegeocodeAddress() != null
              && regeocodeResult.getRegeocodeAddress().getFormatAddress() != null) {
            map = JsonMaps.regeocodeAddressToMap(regeocodeResult.getRegeocodeAddress());
          }
        }
        result.success(new ApiResult.Builder()
            .setCode((long) errorCode)
            .setData(map)
            .build());
      }
    });
    geocodeSearch.getFromLocationAsyn(query);
  }

}
