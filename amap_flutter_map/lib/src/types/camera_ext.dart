import 'package:flutter/material.dart';

import 'camera.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google;

///
/// - [CameraUpdate]与[google.CameraUpdate]的json格式一致, 但缺少[zoomBy]方法
/// - [CameraPosition]与[google.CameraPosition]完全一致
///
/// Created by ipcjs on 2022/4/15.
extension CameraUpdateExt on google.CameraUpdate {}
