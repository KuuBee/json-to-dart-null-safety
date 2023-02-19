import 'package:flutter/material.dart';
import 'package:json_to_dart/utils/iconfont.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:window_manager/window_manager.dart';

class MacosTitleBar extends StatefulWidget {
  const MacosTitleBar({Key? key}) : super(key: key);

  @override
  State<MacosTitleBar> createState() => _MacosTitleBarState();
}

class _MacosTitleBarState extends State<MacosTitleBar> {
  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: SizedBox(
        height: 51.0,
        child: Row(
          children: const [
            MacosIcon(
              IconFont.macos_close,
              size: 16,
            ),
            SizedBox(width: 8),
            MacosIcon(
              IconFont.macos_minimize,
              size: 16,
            ),
            SizedBox(width: 8),
            MacosIcon(
              IconFont.macos_maximize,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
