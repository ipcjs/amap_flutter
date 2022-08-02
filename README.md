# amap_flutter

将高德地图官方插件中的LatLng/LatlngBounds/Marker/Polyline/Polygon等模型类, 替换成Google地图中对应的模型类, 方便整合

- [master](https://github.com/ipcjs/amap_flutter/tree/master)分支: 修改之后的代码
- [upstream](https://github.com/ipcjs/amap_flutter/tree/upstream)分支: 高德原始的代码, 用于追踪高德官方的修改, 高德发布新版本后需要将文件commit到这个分支, 然后merge到master分支  

## Packages

- [amap_flutter_base](amap_flutter_base): 基础包, 改成依赖Google
- [amap_flutter_map](amap_flutter_map): 地图, 改成依赖Google
- [amap_flutter_location](amap_flutter_location): 定位, 基本上[未修改](https://github.com/ipcjs/amap_flutter/commits/master/amap_flutter_location)
- [amap_flutter_search](amap_flutter_search): 搜索, 封装原生的搜索功能
