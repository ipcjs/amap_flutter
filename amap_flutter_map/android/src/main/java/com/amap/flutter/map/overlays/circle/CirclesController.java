package com.amap.flutter.map.overlays.circle;

import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.amap.api.maps.AMap;
import com.amap.api.maps.model.Circle;
import com.amap.api.maps.model.CircleOptions;
import com.amap.flutter.map.MyMethodCallHandler;
import com.amap.flutter.map.overlays.AbstractOverlayController;
import com.amap.flutter.map.utils.Const;
import com.amap.flutter.map.utils.ConvertUtil;
import com.amap.flutter.map.utils.LogUtil;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * 参考{@link com.amap.flutter.map.overlays.polygon.PolygonsController}
 * <p>
 * Created by ipcjs on 2022/8/11.
 */
public class CirclesController
        extends AbstractOverlayController<CircleController>
        implements MyMethodCallHandler {

    private static final String CLASS_NAME = "CirclesController";

    public CirclesController(MethodChannel methodChannel, AMap amap) {
        super(methodChannel, amap);
    }

    @Override
    public void doMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String methodId = call.method;
        LogUtil.i(CLASS_NAME, "doMethodCall===>" + methodId);
        switch (methodId) {
            case Const.METHOD_CIRCLE_UPDATE:
                invokePolylineOptions(call, result);
                break;
        }
    }

    @Override
    public String[] getRegisterMethodIdArray() {
        return Const.METHOD_ID_LIST_FOR_CIRCLE;
    }

    /**
     * @param methodCall
     * @param result
     */
    public void invokePolylineOptions(MethodCall methodCall, MethodChannel.Result result) {
        if (null == methodCall) {
            return;
        }
        Object listToAdd = methodCall.argument("circlesToAdd");
        addByList((List<Object>) listToAdd);
        Object listToChange = methodCall.argument("circlesToChange");
        updateByList((List<Object>) listToChange);
        Object listIdToRemove = methodCall.argument("circleIdsToRemove");
        removeByIdList((List<Object>) listIdToRemove);
        result.success(null);
    }

    public void addByList(List<Object> circlesToAdd) {
        if (circlesToAdd != null) {
            for (Object circleToAdd : circlesToAdd) {
                add(circleToAdd);
            }
        }
    }

    private void add(Object polylineObj) {
        if (null != amap) {
            CircleOptionsBuilder builder = new CircleOptionsBuilder();
            String dartId = CircleUtil.interpretOptions(polylineObj, builder);
            if (!TextUtils.isEmpty(dartId)) {
                CircleOptions options = builder.build();
                final Circle circle = amap.addCircle(options);
                CircleController circleController = new CircleController(circle);
                controllerMapByDartId.put(dartId, circleController);
                idMapByOverlyId.put(circle.getId(), dartId);
            }
        }

    }

    private void updateByList(List<Object> overlaysToChange) {
        if (overlaysToChange != null) {
            for (Object overlayToChange : overlaysToChange) {
                update(overlayToChange);
            }
        }
    }

    private void update(Object toUpdate) {
        Object dartId = ConvertUtil.getKeyValueFromMapObject(toUpdate, "id");
        if (null != dartId) {
            CircleController controller = controllerMapByDartId.get(dartId);
            if (null != controller) {
                CircleUtil.interpretOptions(toUpdate, controller);
            }
        }
    }

    private void removeByIdList(List<Object> toRemoveIdList) {
        if (toRemoveIdList == null) {
            return;
        }
        for (Object toRemoveId : toRemoveIdList) {
            if (toRemoveId == null) {
                continue;
            }
            String dartId = (String) toRemoveId;
            final CircleController controller = controllerMapByDartId.remove(dartId);
            if (controller != null) {

                idMapByOverlyId.remove(controller.getId());
                controller.remove();
            }
        }
    }
}
