import 'dart:developer';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class AppContent extends StatefulWidget {
  const AppContent({Key? key}) : super(key: key);

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  bool dragging = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropTarget(
        onDragDone: (detail) async {
          log('detail:$detail');
          log('mimeType:${detail.files[0].mimeType}');
         final f = File.fromRawPath(await detail.files[0].readAsBytes()).toString();
         log('f:$f');
        },
        onDragEntered: (_) {
          setState(() {
            dragging = true;
          });
        },
        onDragExited: (_) {
          setState(() {
            dragging = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: dragging ? Colors.blueAccent : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
