package com.amap.flutter.map.overlays.circle;

import static com.amap.flutter.map.utils.ConvertUtil.toBoolean;
import static com.amap.flutter.map.utils.ConvertUtil.toDouble;
import static com.amap.flutter.map.utils.ConvertUtil.toFloat;
import static com.amap.flutter.map.utils.ConvertUtil.toFloatPixels;
import static com.amap.flutter.map.utils.ConvertUtil.toInt;
import static com.amap.flutter.map.utils.ConvertUtil.toLatLng;
import static com.amap.flutter.map.utils.ConvertUtil.toMap;

import java.util.Map;

/**
 * Created by ipcjs on 2022/8/11.
 */
class CircleUtil {

    static String interpretOptions(Object o, CircleOptionsSink sink) {
        final Map<?, ?> data = toMap(o);
        final Object fillColor = data.get("fillColor");
        if (fillColor != null) {
            sink.setFillColor(toInt(fillColor));
        }
        final Object strokeColor = data.get("strokeColor");
        if (strokeColor != null) {
            sink.setStrokeColor(toInt(strokeColor));
        }
        final Object visible = data.get("visible");
        if (visible != null) {
            sink.setVisible(toBoolean(visible));
        }
        final Object strokeWidth = data.get("strokeWidth");
        if (strokeWidth != null) {
            sink.setStrokeWidth(toFloatPixels(strokeWidth));
        }
        final Object zIndex = data.get("zIndex");
        if (zIndex != null) {
            sink.setZIndex(toFloat(zIndex));
        }
        final Object center = data.get("center");
        if (center != null) {
            sink.setCenter(toLatLng(center));
        }
        final Object radius = data.get("radius");
        if (radius != null) {
            sink.setRadius(toDouble(radius));
        }
        final String circleId = (String) data.get("id");
        if (circleId == null) {
            throw new IllegalArgumentException("circleId was null");
        } else {
            return circleId;
        }
    }


}
