class FieldData {
  // 类型相关字段
  final bool mayBeNull;
  final String type;
  final bool isMap;
  final bool isBaseList;
  final bool isMapList;

  //
  final String name;
  final dynamic value;

  FieldData({
    required this.mayBeNull,
    required this.type,
    this.isMap = false,
    this.isBaseList = false,
    this.isMapList = false,
    required this.name,
    required this.value,
  })  : assert((() {
          if (isMap) {
            return isMap != isBaseList && isMap != isMapList;
          }
          return true;
        })(), 'map 和 list 互斥'),
        assert((() {
          if (isBaseList) {
            return !isMapList;
          }
          if (isMapList) return !isBaseList;
          return true;
        })(), 'isBaseList 和 isMapList 互斥');
}
