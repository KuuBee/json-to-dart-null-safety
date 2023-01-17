/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
/// http://www.apache.org/licenses/LICENSE-2.0
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

import 'dart:developer';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:macos_ui/macos_ui.dart';

import 'app_json_view.dart';

class AppContent extends StatefulWidget {
  const AppContent({Key? key}) : super(key: key);

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  bool dragging = false;
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('test.json'),
      ),
      children: [
        ResizablePane(
          minWidth: 180,
          startWidth: 200,
          windowBreakpoint: 0,
          resizableSide: ResizableSide.right,
          builder: (context, _) {
            return const AppJsonView();
          },
        ),
        ContentArea(
          builder: (context, _) {
            return const Center(child: Text('ccccc'));
          },
        ),
        ResizablePane(
          minWidth: 180,
          startWidth: 200,
          windowBreakpoint: 0,
          resizableSide: ResizableSide.left,
          builder: (context, _) {
            return const Center(child: Text('left'));
          },
        ),
      ],
      // child: DropTarget(
      //   onDragDone: (detail) async {
      //     log('detail:$detail');
      //     log('mimeType:${detail.files[0].mimeType}');
      //    final f = File.fromRawPath(await detail.files[0].readAsBytes()).toString();
      //    log('f:$f');
      //   },
      //   onDragEntered: (_) {
      //     setState(() {
      //       dragging = true;
      //     });
      //   },
      //   onDragExited: (_) {
      //     setState(() {
      //       dragging = false;
      //     });
      //   },
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: dragging ? Colors.blueAccent : Colors.redAccent,
      //     ),
      //   ),
      // ),
    );
  }
}
