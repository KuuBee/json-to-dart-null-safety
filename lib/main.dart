import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:json_to_dart/core/index.dart';
import 'package:json_to_dart/core/test2.dart';
import 'package:json_to_dart/utils/Error.dart';
import 'package:window_manager/window_manager.dart';

import 'app_root.dart';

void main() async {
  const pattern = r''
      // 主版本号
      r'(?<major>\d+)'
      // 子版本号
      r'\.(?<minor>\d+)?'
      // 修正号
      r'\.?(?<revision>\d+)?'
      // 第三个点后的版本号
      r'(?:\.?(?<dotBuildNumber>\d+))?'
      // 处理这种形式的版本号 6.5.40-Release.9059101
      r'(?:.*?release\.(?<releaseBuildNumber>\d+))?'
      // 括号版本号/编译版本号
      r'(?<other>.*?(?:\((?<bracketsVersion>\d+)\))|(?<buildNumber>\.\d+))?';
  final regExp = RegExp(
    pattern,
    caseSensitive: false,
  );
  const test1 = '1.1';
  const test0 = '1';
  const test2 = '2.2.2';
  const test3 = '3.3.3 (1223)';
  const test4 = '4.4.4.1441';
  // ---
  const test5 = '10.01.03C';
  const test6 = '6.3.19 Beta';
  const test7 = '1.8.7.5(N6)';
  const test8 = 'v10.26';
  const test9 = '9.10.00N';
  const test10 = '5.11.12 (8425)';
  const test11 = '6.5.40-Release.9059101';
  const test12 = '2022 V22.7.0.1';
  final regExpMatch = regExp.firstMatch(test12);
  if (regExpMatch != null) {
    final major = regExpMatch.namedGroup('major');
    final minor = regExpMatch.namedGroup('minor');
    final revision = regExpMatch.namedGroup('revision');
    final dotBuildNumber = regExpMatch.namedGroup('dotBuildNumber');
    final releaseBuildNumber = regExpMatch.namedGroup('releaseBuildNumber');
    final bracketsVersion = regExpMatch.namedGroup('bracketsVersion');
    final buildNumber = regExpMatch.namedGroup('buildNumber');
    log('major:$major,num:${int.tryParse(major ?? '')}');
    log('minor:$minor,num:${int.tryParse(minor ?? '')}');
    log('revision:$revision,num:${int.tryParse(revision ?? '')}');
    log('dotBuildNumber:$dotBuildNumber,num:${int.tryParse(dotBuildNumber ?? '')}');
    log('releaseBuildNumber:$releaseBuildNumber,num:${int.tryParse(releaseBuildNumber ?? '')}');
    log('bracketsVersion:$bracketsVersion,num:${int.tryParse(bracketsVersion ?? '')}');
    log('buildNumber:$buildNumber,num:${int.tryParse(buildNumber ?? '')}');
  }
  return;
  WidgetsFlutterBinding.ensureInitialized();
  // 必须加上这一行。
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.white,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  const jsonStr =
      '[{"id":"2a587d36-d581-44ab-aa6d-18bcbfe6c2a2","deviceId":"b26f1e0edceb6399","mobileInfo":{"id":"31641395-a98b-4b66-aa38-3bc3ad1f1d2b","manufacture":"huawei","model":"ags3-w00d","rom":"emotionui_12.0.0","appVersion":"224801","marketName":"AGS3-W00D"},"onlineStatus":{"id":"635a500a-f4b4-447b-bf91-f462dd0fa1ec","lastOnlineTime":1671088418955},"parentId":"dq16ornycp3u8w27bejv9hli54g0kmas","childId":null,"pushId":"2e873fa05239f775a19cfdcc833135e0","type":"Android","hasbinded":true,"isOnline":true,"deviceType":"Android"},{"id":"dq16ornycp3u8w27bejv9hli54g0kmas","deviceId":"dq16ornycp3u8w27bejv9hli54g0kmas","mobileInfo":null,"onlineStatus":{"id":"f959ef15-4e21-4d39-9b8f-ad2728761f02","lastOnlineTime":1670485874070},"parentId":"dq16ornycp3u8w27bejv9hli54g0kmas","childId":null,"pushId":null,"type":"Windows","hasbinded":true,"isOnline":false,"deviceType":"Windows"}]';
  const jsonStr2 = """{
  "data": [
    {
      "name": "小明",
      "age": 20,
      "favorite_food": [
        "苹果",
        "栗子",
        "西瓜"
      ],
      "marital_status": false,
      "mate": null,
      "cars": [],
      "friends": [
        {
          "name": "小红",
          "age": 22,
          "favorite_food": [
            "苹果",
            "栗子",
            "西瓜"
          ],
          "cars": []
        },
        {
          "name": "小美",
          "age": 21,
          "favorite_food": [
            "苹果",
            "栗子",
            "西瓜"
          ],
          "cars": []
        }
      ],
      "academic_qualifications": {
        "education": "junior college",
        "graduated": true
      }
    },
    {
      "name": "小水",
      "age": 18,
      "favorite_food": [
        "夕张王甜瓜",
        "田助黑皮西瓜",
        "美人姬草莓"
      ],
      "marital_status": false,
      "mate": null,
      "cars": [
        "劳斯莱斯银魅",
        "兰博基尼爱马仕",
        "法拉力"
      ],
      "friends": [],
      "academic_qualifications": {
        "education": "undergraduate",
        "graduated": false
      }
    }
  ],
  "list": [
    1,
    2,
    3,
    4
  ],
  "list2": [1,2,3,4,null],
  "data_map": {
    "key": "键",
    "value": "值"
  },
  "status_code": 200,
  "is_success": true
}""";
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
  const jsonStr4 = "[1,2,3]";

  void incrementCounter(String jsonStr) {
    final dynamic jsonData = json.decode(jsonStr);

    if (jsonData is List) {
      for (var item in jsonData) {
        final rootJson = RootClass.fromJson(item);
        for (var element in rootJson.list6) {
          log('list6 key:a,val:${element?.a}');
        }
        log('rootJson.list:${rootJson.list6}');
      }
    }
  }

  // incrementCounter(jsonStr3);

  runApp(const AppRoot());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '1',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
