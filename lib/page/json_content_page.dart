import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

import '../widget/app_json_view.dart';

class JsonContentPage extends StatefulWidget {
  const JsonContentPage({super.key});

  @override
  State<JsonContentPage> createState() => _JsonContentPageState();
}

class _JsonContentPageState extends State<JsonContentPage> {
  @override
  void initState() {
    WindowManager.instance.getBounds().then((value) {
      print(value);
      print(value.height);
      print(value.width);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    return Row(
      children: [
        TextBox(
          maxLines: null,
        ),
        Container(
          child: AppJsonViewer(jsonObj: jsonDecode("""[
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
]""")),
        )
      ],
    );
  }
}
