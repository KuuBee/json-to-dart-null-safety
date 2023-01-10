import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  MouseCursor _cursor = SystemMouseCursors.basic;

  // app全局指针
  MouseCursor get cursor => _cursor;

  setAppCursors(MouseCursor cursor) {
    _cursor = cursor;
    notifyListeners();
  }
}
