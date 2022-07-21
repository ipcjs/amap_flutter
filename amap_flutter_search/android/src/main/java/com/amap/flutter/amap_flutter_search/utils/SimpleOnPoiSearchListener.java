package com.amap.flutter.amap_flutter_search.utils;

import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;

public class SimpleOnPoiSearchListener implements PoiSearch.OnPoiSearchListener {
  @Override
  public void onPoiSearched(PoiResult poiResult, int errorCode) {
  }

  @Override
  public void onPoiItemSearched(PoiItem poiItem, int errorCode) {
  }
}
