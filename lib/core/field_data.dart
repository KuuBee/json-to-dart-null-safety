enum JsonType {
  base,
  // 是否为map类型，后续需要添加其他class
  map,
  // 是否为基础类型列表如：[1,2,3,4,5]
  baseList,
  // 是否为map列表如：[{"a":1},{"a":2}]
  mapList,
}

class FieldData {
  // 类型相关字段
  // 是否可能为空
  final bool mayBeNull;
  // 如果为List，那么要判断其中子项是否为可能为null
  final bool mayBeListItemNull;
  // 具体类型
  final String type;
  final JsonType jsonType;
  // 是否为map类型，后续需要添加其他class
  // final bool isMap;
  // 是否为基础类型列表如：[1,2,3,4,5]
  // final bool isBaseList;
  // 是否为map列表如：[{"a":1},{"a":2}]
  // final bool isMapList;
  // toJson函数中的代码
  final String toJsonCode;
  // fromJson函数中的代码
  final String fromJsonCode;

  // 原始key值的数据
  final String rawName;
  // 小驼峰后的key值数据
  final String name;
  // 值
  final dynamic value;

  FieldData({
    required this.mayBeNull,
    required this.type,
    required this.jsonType,
    // this.isMap = false,
    // this.isBaseList = false,
    // this.isMapList = false,
    this.mayBeListItemNull = false,
    required this.name,
    required this.value,
    required this.rawName,
    required this.fromJsonCode,
    required this.toJsonCode,
  });
  // : assert((() {
  //     if (isMap) {
  //       return isMap != isBaseList && isMap != isMapList;
  //     }
  //     return true;
  //   })(), 'map 和 list 互斥'),
  //   assert((() {
  //     if (isBaseList) {
  //       return !isMapList;
  //     }
  //     if (isMapList) return !isBaseList;
  //     return true;
  //   })(), 'isBaseList 和 isMapList 互斥');
}
