import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          AppSidebar(),
          Expanded(child: AppContent()),
        ],
      ),
    );
  }
}

class AppSidebar extends StatefulWidget {
  const AppSidebar({Key? key}) : super(key: key);

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final maxWidth = 299.0;
  final minWidth = 99.0;
  double sidebarWidth = 99.0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: sidebarWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: (e) {
            setState(() {
              sidebarWidth += e.delta.dx;
              if (sidebarWidth < minWidth) {
                sidebarWidth = minWidth;
              } else if (sidebarWidth > maxWidth) {
                sidebarWidth = maxWidth;
              }
            });
          },
          child: MouseRegion(
            // TODO 添加全局指针改变
            cursor: SystemMouseCursors.resizeColumn,
            child: Container(
              width: 1,
              decoration: const BoxDecoration(
                color: Colors.redAccent,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({Key? key}) : super(key: key);

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('12312312312'),
    );
  }
}
