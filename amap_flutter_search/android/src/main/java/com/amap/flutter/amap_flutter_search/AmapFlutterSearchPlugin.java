package com.amap.flutter.amap_flutter_search;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.core.ServiceSettings;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.ApiResult;
import com.amap.flutter.amap_flutter_search.GeneratedAMapSearchApis.SearchHostApi;
import com.amap.flutter.amap_flutter_search.utils.JsonMaps;
import com.amap.flutter.amap_flutter_search.utils.SimpleOnPoiSearchListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * AmapFlutterSearchPlugin
 */
public class AmapFlutterSearchPlugin implements FlutterPlugin, SearchHostApi, GeocodeSearch.OnGeocodeSearchListener {
  private static String TAG = "amap_flutter_search";
  private Context context;
  @Nullable
  private GeocodeSearch geocodeSearch;
  private Map<Object, GeneratedAMapSearchApis.Result<ApiResult>> resultMap = new IdentityHashMap<>();

  GeocodeSearch getGeocodeSearch() throws AMapException {
    if (geocodeSearch == null) {
      geocodeSearch = new GeocodeSearch(context);
      geocodeSearch.setOnGeocodeSearchListener(this);
    }
    return geocodeSearch;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    SearchHostApi.setup(flutterPluginBinding.getBinaryMessenger(), this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    SearchHostApi.setup(binding.getBinaryMessenger(), null);
    context = null;
    geocodeSearch = null;
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
      @Nullable Object center,
      @Nullable Long radiusInMeters,
      @Nullable Boolean isDistanceSort,
      @NonNull String extensions,
      GeneratedAMapSearchApis.Result<ApiResult> result
  ) {
    PoiSearch.Query query = new PoiSearch.Query(queryText, types, city);
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
        if (errorCode == AMapException.CODE_AMAP_SUCCESS) {
          map = new HashMap<>();
          List<Map<String, Object>> poiList = new ArrayList<>();
          int pageCount = 0;
          if (poiResult != null && poiResult.getPois() != null) {
            for (PoiItem poi : poiResult.getPois()) {
              poiList.add(JsonMaps.poiToMap(poi));
            }
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
      geocodeSearch = getGeocodeSearch();
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
    resultMap.put(query, result);
    geocodeSearch.getFromLocationAsyn(query);
  }

  @Override
  public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int errorCode) {
    // TODO: 2022/8/5 ipcjs regeocodeResult在errorCode不为SUCCESS时, 貌似会为null...
    GeneratedAMapSearchApis.Result<ApiResult> result = resultMap.remove(regeocodeResult == null ? null : regeocodeResult.getRegeocodeQuery());
    if (result == null) {
      Log.w(TAG, String.format("onRegeocodeSearched: 未找到和%s对应的result对象", regeocodeResult));
      return;
    }

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

  @Override
  public void onGeocodeSearched(GeocodeResult geocodeResult, int errorCode) {
    // ignore
  }
}
