// ignore_for_file: constant_identifier_names

import 'package:amap_flutter_search/src/amap_search.pigeon.dart';

/// Created by ipcjs on 2022/7/21.
class AMapException implements Exception {
  static const CODE_SUCCESS = 1000;
  const AMapException(
    this.code, {
    this.message,
  });

  final int code;
  final String? message;
  @override
  String toString() => 'AmapException($code, $message)';
}

/// 添加个前缀, 命名清晰点
typedef AMapApiResult = ApiResult;

extension AMapApiResultExt on Future<AMapApiResult> {
  Future<T> toData<T>(T Function(Map<dynamic, dynamic> json) fromJson) =>
      then<T>((result) {
        if (result.code == AMapException.CODE_SUCCESS) {
          if (result.data == null) {
            if (null is T) {
              return null as T;
            } else {
              throw ArgumentError('result.data可能为null, 请将T($T)声明成可空');
            }
          }
          return fromJson(result.data!);
        }
        return Future<T>.error(AMapException(
          result.code,
          message: result.message,
        ));
      });
}
