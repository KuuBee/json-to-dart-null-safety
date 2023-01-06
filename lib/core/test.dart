class RootClass {
  RootClass({
    required this.list,
    required this.list2,
    required this.list3,
    required this.list4,
    required this.list5,
    required this.list6,
    required this.list7,
    required this.list8,
  });

  factory RootClass.fromJson(Map<String, dynamic> json) => RootClass(
        list: json["list"],
        list2: json["list2"],
        list3: json["list3"],
        list4: json["list4"],
        list5: json["list5"],
        list6: List.from(json["list6"]).map((e) => List6.fromJson(e)).toList(),
        list7: List.from(json["list7"]).map((e) => List7.fromJson(e)).toList(),
        list8: List8.fromJson(json["list8"]),
      );

  final List<int>? list;

  final List<int>? list2;

  final List<String> list3;

  final List<int?> list4;

  final List<int?>? list5;

  final List<List6?> list6;

  final List<List7?>? list7;

  final List8? list8;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "list": list,
        "list_2": list2,
        "list_3": list3,
        "list_4": list4,
        "list_5": list5,
        "list_6": list6.map((e) => e?.toJson()).toList(),
        "list_7": list7?.map((e) => e?.toJson()).toList(),
        "list_8": list8?.toJson(),
      };
}

class List6 {
  List6();
  factory List6.fromJson(Map<String, dynamic> e) => List6();
  String toJson() => '';
}

class List7 {
  List7();
  factory List7.fromJson(Map<String, dynamic> e) => List7();
  String toJson() => '';
}

class List8 {
  List8();
  factory List8.fromJson(Map<String, dynamic> e) => List8();
  String toJson() => '';
}
