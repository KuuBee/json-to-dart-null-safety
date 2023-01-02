import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:json_to_dart/core/index.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 必须加上这一行。
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // await windowManager.show();
    // await windowManager.focus();
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
  "status_code": 200
}""";

  void incrementCounter() {
    final  jsonList = json.decode(jsonStr2);
    final jsonMap = json.decode('{"a":1}');
    log('is List:type ${jsonList.runtimeType.toString()} is ${jsonList is List}');
    log('is Map:type ${jsonMap.runtimeType.toString()} is ${jsonMap is Map}');
    log('is String:type ${'aa'.runtimeType.toString()} is ${'aa' is String}');
    log('is num:type ${123.runtimeType.toString()} is ${123 is num}');
    log('is bool:type ${false.runtimeType.toString()} is ${false is bool}');
    final codeStr = generateClass('root_class', jsonList);
    log(codeStr);
  }

  incrementCounter();

  // runApp(const MyApp());
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
