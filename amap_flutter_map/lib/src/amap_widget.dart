part of amap_flutter_map;

typedef void MapCreatedCallback(AMapController controller);

///用于展示高德地图的Widget
class AMapWidget extends StatefulWidget {
  ///高德开放平台的key
  ///
  final AMapApiKey? apiKey;

  /// 初始化时的地图中心点
  final CameraPosition initialCameraPosition;

  ///地图类型
  final MapType mapType;

  ///自定义地图样式
  final CustomStyleOptions? customStyleOptions;

  ///定位小蓝点
  final MyLocationStyleOptions? myLocationStyleOptions;

  ///缩放级别范围
  final MinMaxZoomPreference? minMaxZoomPreference;

  ///地图显示范围
  final LatLngBounds? limitBounds;

  ///显示路况开关
  final bool trafficEnabled;

  /// 地图poi是否允许点击
  final bool touchPoiEnabled;

  ///是否显示3D建筑物
  final bool buildingsEnabled;

  ///是否显示底图文字标注
  final bool labelsEnabled;

  ///是否显示指南针
  final bool compassEnabled;

  ///是否显示比例尺
  final bool scaleEnabled;

  ///是否支持缩放手势
  final bool zoomGesturesEnabled;

  ///是否支持滑动手势
  final bool scrollGesturesEnabled;

  ///是否支持旋转手势
  final bool rotateGesturesEnabled;

  ///是否支持倾斜手势
  final bool tiltGesturesEnabled;

  /// 地图上显示的Marker
  final Set<Marker> markers;

  /// 地图上显示的polyline
  final Set<Polyline> polylines;

  /// 地图上显示的polygon
  final Set<Polygon> polygons;

  /// 地图创建成功的回调, 收到此回调之后才可以操作地图
  final MapCreatedCallback? onMapCreated;

  /// 相机视角持续移动的回调
  final ArgumentCallback<CameraPosition>? onCameraMove;

  /// 相机视角移动结束的回调
  final ArgumentCallback<CameraPosition>? onCameraMoveEnd;

  /// 地图单击事件的回调
  final ArgumentCallback<LatLng>? onTap;

  /// 地图长按事件的回调
  final ArgumentCallback<LatLng>? onLongPress;

  /// 地图POI的点击回调，需要`touchPoiEnabled`true，才能回调
  final ArgumentCallback<AMapPoi>? onPoiTouched;

  ///位置回调
  final ArgumentCallback<AMapLocation>? onLocationChanged;

  ///需要应用到地图上的手势集合
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  ///高德合规声明配置
  ///
  /// 高德SDK合规使用方案请参考：https://lbs.amap.com/news/sdkhgsy
  final AMapPrivacyStatement ?privacyStatement;
  /// 创建一个展示高德地图的widget
  ///
  /// 如果使用的高德地图SDK的版本是8.1.0及以上版本，
  /// 在app首次启动时必须传入高德合规声明配置[privacyStatement],后续如果没有变化不需要重复设置
  /// <li>[privacyStatement.hasContains] 隐私权政策是否包含高德开平隐私权政策</li>
  /// <li>[privacyStatement.hasShow] 是否已经弹窗展示给用户</li>
  /// <li>[privacyStatement.hasAgree] 隐私权政策是否已经取得用户同意</li>
  /// 以上三个值，任何一个为false都会造成地图插件不工作（白屏情况）
  ///
  /// 高德SDK合规使用方案请参考：https://lbs.amap.com/news/sdkhgsy
  ///
  /// [AssertionError] will be thrown if [initialCameraPosition] is null;
  const AMapWidget({
    Key? key,
    this.privacyStatement,
    this.apiKey,
    this.initialCameraPosition = const CameraPosition(target: LatLng(39.909187, 116.397451), zoom: 10),
    this.mapType = MapType.normal,
    this.buildingsEnabled = true,
    this.compassEnabled = false,
    this.labelsEnabled = true,
    this.limitBounds,
    this.minMaxZoomPreference,
    this.rotateGesturesEnabled = true,
    this.scaleEnabled = true,
    this.scrollGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.touchPoiEnabled = true,
    this.trafficEnabled = false,
    this.zoomGesturesEnabled = true,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.customStyleOptions,
    this.myLocationStyleOptions,
    this.onCameraMove,
    this.onCameraMoveEnd,
    this.onLocationChanged,
    this.onTap,
    this.onLongPress,
    this.onPoiTouched,
    this.markers = const <Marker>{},
    this.polylines = const <Polyline>{},
    this.polygons = const <Polygon>{},
  }) : super(key: key);

  ///
  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<AMapWidget> {
  Map<String, Marker> _markers = <String, Marker>{};
  Map<String, Polyline> _polylines = <String, Polyline>{};
  Map<String, Polygon> _polygons = <String, Polygon>{};

  final Completer<AMapController> _controller = Completer<AMapController>();
  late _AMapOptions _mapOptions;

  @override
  Widget build(BuildContext context) {
    AMapUtil.init(context);
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'privacyStatement': widget.privacyStatement?.toMap(),
      'apiKey': widget.apiKey?.toMap(),
      'initialCameraPosition': widget.initialCameraPosition.toMap(),
      'options': _mapOptions.toMap(),
      'markersToAdd': serializeOverlaySet(widget.markers),
      'polylinesToAdd': serializeOverlaySet(widget.polylines),
      'polygonsToAdd': serializeOverlaySet(widget.polygons),
    };
    Widget mapView = _methodChannel.buildView(
      creationParams,
      widget.gestureRecognizers,
      onPlatformViewCreated,
    );
    return mapView;
  }

  @override
  void initState() {
    super.initState();
    _mapOptions = _AMapOptions.fromWidget(widget);
    _markers = keyByMarkerId(widget.markers);
    _polygons = keyByPolygonId(widget.polygons);
    _polylines = keyByPolylineId(widget.polylines);
    print('initState AMapWidget');
  }

  @override
  void dispose() async {
    super.dispose();
    AMapController controller = await _controller.future;
    controller.disponse();
    print('dispose AMapWidget with mapId: ${controller.mapId}');
  }

  @override
  void reassemble() {
    super.reassemble();
    print('reassemble AMapWidget');
  }

  @override
  void deactivate() async {
    super.deactivate();
    print('deactivate AMapWidget}');
  }

  @override
  void didUpdateWidget(covariant AMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
    _updateMarkers();
    _updatePolylines();
    _updatePolygons();
  }

  Future<void> onPlatformViewCreated(int id) async {
    final AMapController controller = await AMapController.init(
      id,
      widget.initialCameraPosition,
      this,
    );
    _controller.complete(controller);
    final MapCreatedCallback? _onMapCreated = widget.onMapCreated;
    if (_onMapCreated != null) {
      _onMapCreated(controller);
    }
  }

  void onMarkerTap(String markerId) {
    final Marker? _marker = _markers[markerId];
    if (_marker != null) {
      final ArgumentCallback<String>? _onTap = _marker.onTap;
      if (_onTap != null) {
        _onTap(markerId);
      }
    }
  }

  void onMarkerDragEnd(String markerId, LatLng position) {
    final Marker? _marker = _markers[markerId];
    if (_marker != null) {
      final MarkerDragEndCallback? _onDragEnd = _marker.onDragEnd;
      if (_onDragEnd != null) {
        _onDragEnd(markerId, position);
      }
    }
  }

  void onPolylineTap(String polylineId) {
    final Polyline? _polyline = _polylines[polylineId];
    if (_polyline != null) {
      final ArgumentCallback<String>? _onTap = _polyline.onTap;
      if (_onTap != null) {
        _onTap(polylineId);
      }
    }
  }

  void _updateOptions() async {
    final _AMapOptions newOptions = _AMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates = _mapOptions._updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final AMapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMapOptions(updates);
    _mapOptions = newOptions;
  }

  void _updateMarkers() async {
    final AMapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMarkers(MarkerUpdates.from(_markers.values.toSet(), widget.markers));
    _markers = keyByMarkerId(widget.markers);
  }

  void _updatePolylines() async {
    final AMapController controller = await _controller.future;
    controller._updatePolylines(PolylineUpdates.from(_polylines.values.toSet(), widget.polylines));
    _polylines = keyByPolylineId(widget.polylines);
  }

  void _updatePolygons() async {
    final AMapController controller = await _controller.future;
    controller._updatePolygons(PolygonUpdates.from(_polygons.values.toSet(), widget.polygons));
    _polygons = keyByPolygonId(widget.polygons);
  }
}

//高德地图参数设置
class _AMapOptions {
  ///地图类型
  final MapType mapType;

  ///自定义地图样式
  final CustomStyleOptions? customStyleOptions;

  ///定位小蓝点
  final MyLocationStyleOptions? myLocationStyleOptions;

  //缩放级别范围
  final MinMaxZoomPreference? minMaxZoomPreference;

  ///地图显示范围
  final LatLngBounds? limitBounds;

  ///显示路况开关
  final bool? trafficEnabled;

  /// 地图poi是否允许点击
  final bool? touchPoiEnabled;

  ///是否显示3D建筑物
  final bool? buildingsEnabled;

  ///是否显示底图文字标注
  final bool? labelsEnabled;

  ///是否显示指南针
  final bool? compassEnabled;

  ///是否显示比例尺
  final bool? scaleEnabled;

  ///是否支持缩放手势
  final bool? zoomGesturesEnabled;

  ///是否支持滑动手势
  final bool? scrollGesturesEnabled;

  ///是否支持旋转手势
  final bool? rotateGesturesEnabled;

  ///是否支持仰角手势
  final bool? tiltGesturesEnabled;

  _AMapOptions({
    this.mapType = MapType.normal,
    this.buildingsEnabled,
    this.customStyleOptions,
    this.myLocationStyleOptions,
    this.compassEnabled,
    this.labelsEnabled,
    this.limitBounds,
    this.minMaxZoomPreference,
    this.scaleEnabled,
    this.touchPoiEnabled,
    this.trafficEnabled,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.zoomGesturesEnabled,
  });

  static _AMapOptions fromWidget(AMapWidget map) {
    return _AMapOptions(
      mapType: map.mapType,
      buildingsEnabled: map.buildingsEnabled,
      compassEnabled: map.compassEnabled,
      labelsEnabled: map.labelsEnabled,
      limitBounds: map.limitBounds,
      minMaxZoomPreference: map.minMaxZoomPreference,
      scaleEnabled: map.scaleEnabled,
      touchPoiEnabled: map.touchPoiEnabled,
      trafficEnabled: map.trafficEnabled,
      rotateGesturesEnabled: map.rotateGesturesEnabled,
      scrollGesturesEnabled: map.scrollGesturesEnabled,
      tiltGesturesEnabled: map.tiltGesturesEnabled,
      zoomGesturesEnabled: map.zoomGesturesEnabled,
      customStyleOptions: map.customStyleOptions?.clone(),
      myLocationStyleOptions: map.myLocationStyleOptions?.clone(),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> optionsMap = <String, dynamic>{};
    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        optionsMap[fieldName] = value;
      }
    }

    addIfNonNull('mapType', mapType.index);
    addIfNonNull('buildingsEnabled', buildingsEnabled);
    addIfNonNull('customStyleOptions', customStyleOptions?.clone().toMap());
    addIfNonNull('compassEnabled', compassEnabled);
    addIfNonNull('labelsEnabled', labelsEnabled);
    addIfNonNull('limitBounds', limitBounds?.toJson());
    addIfNonNull('minMaxZoomPreference', minMaxZoomPreference?.toJson());
    addIfNonNull('scaleEnabled', scaleEnabled);
    addIfNonNull('touchPoiEnabled', touchPoiEnabled);
    addIfNonNull('trafficEnabled', trafficEnabled);
    addIfNonNull('rotateGesturesEnabled', rotateGesturesEnabled);
    addIfNonNull('scrollGesturesEnabled', scrollGesturesEnabled);
    addIfNonNull('tiltGesturesEnabled', tiltGesturesEnabled);
    addIfNonNull('zoomGesturesEnabled', zoomGesturesEnabled);
    addIfNonNull('myLocationStyle', myLocationStyleOptions?.clone().toMap());
    return optionsMap;
  }

  Map<String, dynamic> _updatesMap(_AMapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()
      ..removeWhere((String key, dynamic value) => (_checkChange(key, prevOptionsMap[key], value)));
  }

  bool _checkChange(String key, dynamic preValue, dynamic newValue) {
    if (key == 'myLocationStyle' || key == 'customStyleOptions') {
      return preValue?.toString() == newValue?.toString();
    } else {
      return preValue == newValue;
    }
  }
}
