package com.amap.flutter.amap_flutter_search.utils;

import androidx.annotation.NonNull;

import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.PoiItemExtension;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class JsonMaps {
  private JsonMaps() {
  }

  @NonNull
  public static Map<String, Object> poiToMap(@NonNull PoiItem poi) {
    Map<String, Object> poiMap = new HashMap<>();
    poiMap.put("title", poi.getTitle());
    poiMap.put("cityName", poi.getCityName());
    poiMap.put("cityCode", poi.getCityCode());
    poiMap.put("adCode", poi.getAdCode());
    poiMap.put("adName", poi.getAdName());
    poiMap.put("provinceCode", poi.getProvinceCode());
    poiMap.put("provinceName", poi.getProvinceName());
    poiMap.put("postcode", poi.getPostcode());
    poiMap.put("tel", poi.getTel());
    poiMap.put("website", poi.getWebsite());
    poiMap.put("poiExtension", poiExceptionToMap(poi.getPoiExtension()));
    poiMap.put("snippet", poi.getSnippet());
    poiMap.put("poiId", poi.getPoiId());
    poiMap.put("position", pointToObject(poi.getLatLonPoint()));
    return poiMap;
  }

  @NonNull
  public static Object pointToObject(@NonNull LatLonPoint point) {
    List<Double> list = new ArrayList<>();
    list.add(point.getLatitude());
    list.add(point.getLongitude());
    return list;
  }
  @NonNull
  public static LatLonPoint pointFromObject(@NonNull Object value) {
    List<Double> list = (List<Double>) value;
    return new LatLonPoint(list.get(0), list.get(1));
  }

  public  static  Map<String, Object> poiExceptionToMap(PoiItemExtension extension){
    Map<String, Object> map = new HashMap<>();
    map.put("rating", extension.getmRating());
    map.put("openTime", extension.getOpentime());
    return map;
  }
}
