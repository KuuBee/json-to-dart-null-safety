class RootClass {
  RootClass({
    required this.list0,
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
    list0: json["list0"],
    list: json["list"] == null ? null : List<int>.from(json["list"]),
    list2: json["list2"] == null ? null : List<int>.from(json["list2"]),
    list3: List<String>.from(json["list3"]),
    list4: List<int?>.from(json["list4"]),
    list5: json["list5"] == null ? null : List<int?>.from(json["list5"]),
    list6: List.from(json["list6"])
        .map((e) => e == null ? null : List6.fromJson(e))
        .toList(),
    list7: json["list7"] == null
        ? null
        : List.from(json["list7"])
        .map((e) => e == null ? null : List7.fromJson(e))
        .toList(),
    list8: json["list8"] == null ? null : List8.fromJson(json["list8"]),
  );

  final int list0;

  final List<int>? list;

  final List<int>? list2;

  final List<String> list3;

  final List<int?> list4;

  final List<int?>? list5;

  final List<List6?> list6;

  final List<List7?>? list7;

  final List8? list8;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "list_0": list0,
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
  List6({required this.a});

  factory List6.fromJson(Map<String, dynamic> json) => List6(
    a: json["a"],
  );

  final int a;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "a": a,
  };
}

class List7 {
  List7({required this.b});

  factory List7.fromJson(Map<String, dynamic> json) => List7(
    b: json["b"],
  );

  final int b;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "b": b,
  };
}

class List8 {
  List8({required this.c});

  factory List8.fromJson(Map<String, dynamic> json) => List8(
    c: json["c"],
  );

  final int c;

  Map<String, dynamic> toJson() => <String, dynamic>{
    "c": c,
  };
}