import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

import '../utils/Error.dart';
import 'app_json_view_line.dart';

const double leftPadding = 20.0;

const jsonStr3 = """[
  {
    "list0": 1,
    "list": [1,2,3,4],
    "list2": [1,2,3,4],
    "list3": ["1","2"],
    "list4": [1,null,2,3],
    "list5": [1,null,2,3],
    "list6": [
      {"a": 1},
      null
    ],
    "list7": [
      {"b": 1},
      null
    ],
    "list8": {
      "c": 1
    }
  },
  {
    "list0": 1,
    "list": null,
    "list2": null,
    "list3": ["1","2"],
    "list4": [1,4,2,3],
    "list5": null,
    "list6": [
      {"a": 1},
      {"a": 2}
    ],
    "list7": null,
    "list8": null
  }
]""";

const lightTheme = JsonViewTheme(
  backgroundColor: Colors.white,
  closeIcon: Icon(
    Icons.close,
    size: 18,
    color: Color(0xff4A5560),
  ),
  openIcon: Icon(
    Icons.add,
    size: 18,
    color: Color(0xff4A5560),
  ),
  keyStyle: TextStyle(
    color: Color(0xffC03F2A),
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  stringStyle: TextStyle(
    color: Color(0xffC03F2A),
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  defaultTextStyle: TextStyle(
    color: Color(0xffC03F2A),
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  boolStyle: TextStyle(
    fontSize: 14,
    color: Color(0xffA045A0),
  ),
  intStyle: TextStyle(
    fontSize: 14,
    color: Color(0xff282AD0),
  ),
  doubleStyle: TextStyle(
    fontSize: 14,
    color: Color(0xff282AD0),
  ),
  errorWidget: Text(
    'null',
    style: TextStyle(
      color: Color(0xffA045A0),
      fontSize: 14,
    ),
  ),
);

const darkTheme = JsonViewTheme(
  boolStyle: TextStyle(
    color: Color(0xffA045A0),
  ),
  errorWidget: Text(
    'null',
    style: TextStyle(color: Color(0xffA045A0)),
  ),
);

class AppJsonViewer extends StatefulWidget {
  const AppJsonViewer({
    Key? key,
    required this.jsonObj,
  }) : super(key: key);
  final dynamic jsonObj;

  @override
  State<AppJsonViewer> createState() => _AppJsonViewerState();
}

class _AppJsonViewerState extends State<AppJsonViewer> {
  get jsonObj => widget.jsonObj;

  get isMap => jsonObj is Map<String, dynamic>;

  get isArray => jsonObj is List<dynamic>;

  @override
  Widget build(BuildContext context) {
    if (isMap) {
      return _BaseAppMapJsonViewer(
        jsonObj: jsonObj,
      );
    } else if (isArray) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('['),
          ListView.builder(
            padding: const EdgeInsets.only(left: leftPadding),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jsonObj.length,
            itemBuilder: (_, index) {
              final current = jsonObj[index];
              return _BaseAppMapJsonViewer(jsonObj: current);
            },
          ),
          const Text(']'),
        ],
      );
    }
    return ErrorWidget(JsonToDartUnsupportedObjectError(jsonObj));
  }
}

class _BaseAppMapJsonViewer extends StatelessWidget {
  const _BaseAppMapJsonViewer({
    Key? key,
    required this.jsonObj,
  }) : super(key: key);
  final Map<String, dynamic> jsonObj;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, dynamic>> mapList = jsonObj.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('{'),
        Padding(
          padding: const EdgeInsets.only(left: leftPadding),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mapList.length,
            itemBuilder: (context, index) {
              final current = mapList[index];
              final key = current.key;
              final value = current.value;
              final isLast = index == mapList.length - 1;
              if (value is Map<String, dynamic>) {
                return _AppMapJsonView(
                  keyName: key,
                  value: value,
                  isLast: isLast,
                );
              } else if (value is List<dynamic>) {
                return _AppArrayJsonView(
                  keyName: key,
                  value: value,
                  isLast: isLast,
                );
              } else {
                return _AppBaseJsonView(
                  keyName: key,
                  value: value,
                  isLast: isLast,
                );
              }
            },
          ),
        ),
        const Text('}'),
      ],
    );
  }
}

class _AppBaseJsonView extends StatelessWidget {
  const _AppBaseJsonView({
    Key? key,
    required this.keyName,
    required this.value,
    required this.isLast,
  }) : super(key: key);
  final dynamic value;
  final String? keyName;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (keyName != null) Text('"$keyName":'),
        Text('${value?.toString() ?? 'null'}${isLast ? '' : ','}')
      ],
    );
  }
}

class _AppArrayJsonView extends StatefulWidget {
  const _AppArrayJsonView({
    Key? key,
    required this.keyName,
    required this.value,
    required this.isLast,
  }) : super(key: key);
  final String keyName;
  final List<dynamic> value;
  final bool isLast;

  @override
  State<_AppArrayJsonView> createState() => _AppArrayJsonViewState();
}

class _AppArrayJsonViewState extends State<_AppArrayJsonView> {
  List<dynamic> get value => widget.value;

  String get keyName => widget.keyName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('"$keyName":['),
        Padding(
          padding: const EdgeInsets.only(left: leftPadding),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (context, index) {
              final current = value[index];
              final isLast = index == value.length - 1;
              if (current is Map<String, dynamic>) {
                return _AppMapJsonView(
                  keyName: null,
                  value: current,
                  isLast: isLast,
                );
              } else {
                return _AppBaseJsonView(
                  keyName: null,
                  value: current,
                  isLast: isLast,
                );
              }
            },
          ),
        ),
        Text(']${widget.isLast ? '' : ','}'),
      ],
    );
  }
}

class _AppMapJsonView extends StatefulWidget {
  const _AppMapJsonView({
    required this.keyName,
    required this.value,
    required this.isLast,
  });

  final String? keyName;
  final Map<String, dynamic> value;
  final bool isLast;

  @override
  State<_AppMapJsonView> createState() => _AppMapJsonViewState();
}

class _AppMapJsonViewState extends State<_AppMapJsonView> {
  List<MapEntry<String, dynamic>> get jsonMapToList =>
      widget.value.entries.toList();

  String? get keyName => widget.keyName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        keyName == null ? const Text('{') : Text('"$keyName":{'),
        Container(
          padding: const EdgeInsets.only(left: leftPadding),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jsonMapToList.length,
            itemBuilder: (context, index) {
              final current = jsonMapToList[index];
              final key = current.key;
              final dynamic value = current.value;
              final isLast = index == jsonMapToList.length - 1;
              if (value is Map<String, dynamic>) {
                return _AppMapJsonView(
                  keyName: key,
                  value: value,
                  isLast: isLast,
                );
              } else if (value is List<dynamic>) {
                return _AppArrayJsonView(
                  keyName: key,
                  value: value,
                  isLast: isLast,
                );
              } else {
                return _AppBaseJsonView(
                  keyName: key,
                  value: value,
                  isLast: isLast,
                );
              }
            },
          ),
        ),
        Text('}${widget.isLast ? '' : ','}')
      ],
    );
  }
}

class AppJsonView2 extends StatelessWidget {
  const AppJsonView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JsonView.string(
      jsonStr3,
      theme: Theme.of(context).brightness == Brightness.dark
          ? darkTheme
          : lightTheme,
    );
  }
}
