import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

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
    Icons.arrow_drop_up,
    size: 18,
    color: Color(0xff4A5560),
  ),
  openIcon: Icon(
    Icons.arrow_drop_down,
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

class AppJsonView extends StatelessWidget {
  const AppJsonView({Key? key}) : super(key: key);

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
