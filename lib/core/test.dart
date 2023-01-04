class RootClass {
  RootClass({
    required this.data,
    required this.list,
    required this.list2,
    required this.dataMap,
    required this.statusCode,
    required this.isSuccess,
  });

  factory RootClass.fromJson(Map<String, dynamic> json) => RootClass(
        data: List.from(json["data"]).map((e) => Data.fromJson(e)).toList(),
        list: json["list"],
        list2: json["list2"],
        dataMap: DataMap.fromJson(json["data_map"]),
        statusCode: json["status_code"],
        isSuccess: json["is_success"],
      );

  final List<Data> data;

  final List<int> list;

  final List<int> list2;

  final DataMap dataMap;

  final int statusCode;

  final bool isSuccess;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "data": data.map((e) => e.toJson()).toList(),
        "list": list,
        "list_2": list2,
        "data_map": DataMap().toJson(),
        "status_code": statusCode,
        "is_success": isSuccess,
      };
}

class Data {
  Data();
  factory Data.fromJson(Map<String, dynamic> e) => Data();
  String toJson() => '';
}

class DataMap {
  DataMap();
  factory DataMap.fromJson(Map<String, dynamic> e) => DataMap();
  String toJson() => '';
}
