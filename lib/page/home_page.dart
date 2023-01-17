import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import '../widget/app_content.dart';
import '../widget/app_sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      endSidebar: Sidebar(
        startWidth: 200,
        minWidth: 200,
        maxWidth: 300,
        shownByDefault: false,
        builder: (context, scrollController) {
          return const Center(
            child: Text('End Sidebar'),
          );
        },
      ),
      sidebar: Sidebar(
          minWidth: 200,
          dragClosed: false,
          top: const MacosListTile(
            title: Text('Json to Dart'),
            subtitle: Text('null safety'),
          ),
          bottom: const MacosListTile(
            leading: MacosIcon(CupertinoIcons.profile_circled),
            title: Text('kuubee'),
            subtitle: Text('tim@apple.com'),
          ),
          builder: (context, controller) {
            return SidebarItems(
              currentIndex: pageIndex,
              onChanged: (i) => setState(() {
                log('i:$i');
                pageIndex = i;
              }),
              items: [
                SidebarItem(
                  leading: const MacosIcon(CupertinoIcons.folder),
                  label: const Text('工作区1'),
                  trailing: Text(
                    '3',
                    style: TextStyle(
                      color: MacosTheme.brightnessOf(context) == Brightness.dark
                          ? MacosColors.tertiaryLabelColor.darkColor
                          : MacosColors.tertiaryLabelColor,
                    ),
                  ),
                  disclosureItems: [
                    const SidebarItem(
                      leading: MacosIcon(CupertinoIcons.doc),
                      label: Text('test.json'),
                    ),
                    const SidebarItem(
                      leading: MacosIcon(CupertinoIcons.doc),
                      label: Expanded(
                        child: Text(
                          'test2test2test2test2.json',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
      child: const AppContent(),
      // appBar: AppBar(),
      // body: Row(
      //   children: const [
      //     AppSidebar(),
      //     Expanded(child: AppContent()),
      //   ],
      // ),
    );
  }
}
