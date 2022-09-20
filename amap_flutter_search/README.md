# amap_flutter_search

高德地图搜索插件

原生SDK版本:

- Android: `9.3.1`([文档下载](https://github.com/ipcjs/amap_flutter/files/9604883/search-9.3.1-javadoc.zip))
- iOS: `9.3.1`

### 创建工程

```shell
flutter create --template=plugin --platforms=android,ios --ios-language=objc --android-language=java --org=com.amap.flutter amap_flutter_search
```

### 代码生成

```shell
# 生成amap_search接口
flutter pub run pigeon --input ./pigeons/amap_search.dart
# 生成json转换方法
flutter pub run build_runner watch --delete-conflicting-outputs
```


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

