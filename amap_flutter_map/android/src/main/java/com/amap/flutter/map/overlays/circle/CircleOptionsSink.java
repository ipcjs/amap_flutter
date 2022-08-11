package com.amap.flutter.map.overlays.circle;

import com.amap.api.maps.model.LatLng;

/**
 * Created by ipcjs on 2022/8/11.
 */
interface CircleOptionsSink {
    //边框宽度
    void setStrokeWidth(float strokeWidth);

    //边框颜色
    void setStrokeColor(int color);

    //填充颜色
    void setFillColor(int color);

    //是否显示
    void setVisible(boolean visible);

    void setZIndex(float zIndex);

    void setRadius(double radius);

    void setCenter(LatLng center);
}
