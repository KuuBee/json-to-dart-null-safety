import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../app_root.dart';
import '../theme.dart';
import '../utils/app_platform.dart';
import '../widget/app_content.dart';
import '../widget/app_sidebar.dart';
import '../widget/macos_title_bar.dart';
import 'json_content_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Tab> tabs = [];

  /// Creates a tab for the given index
  Tab generateTab(int index) {
    late Tab tab;
    tab = Tab(
      text: Text('Document $index'),
      semanticLabel: 'Document #$index',
      icon: const FlutterLogo(),
      body: const JsonContentPage(),
      onClosed: () {
        setState(() {
          tabs.remove(tab);

          if (currentIndex > 0) currentIndex--;
        });
      },
    );
    return tab;
  }

  @override
  Widget build(BuildContext context) {
    return TabView(
      tabs: tabs,
      currentIndex: currentIndex,
      onChanged: (index) => setState(() => currentIndex = index),
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      closeButtonVisibility: CloseButtonVisibilityMode.onHover,
      showScrollButtons: true,
      onNewPressed: () {
        setState(() {
          final index = tabs.length + 1;
          final tab = generateTab(index);
          tabs.add(tab);
        });
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = tabs.removeAt(oldIndex);
          tabs.insert(newIndex, item);

          if (currentIndex == newIndex) {
            currentIndex = oldIndex;
          } else if (currentIndex == oldIndex) {
            currentIndex = newIndex;
          }
        });
      },
    );
  }
}
