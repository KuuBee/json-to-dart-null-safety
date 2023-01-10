import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:context_menus/context_menus.dart';

import '../provider/app_provider.dart';

const borderWidth = 5.0;
const baseMaxWidth = 300.0;
const baseMinWidth = 100.0;
const maxWidth = baseMaxWidth - borderWidth;
const minWidth = baseMinWidth - borderWidth;

class SidebarContextMenu extends StatefulWidget {
  const SidebarContextMenu({Key? key}) : super(key: key);

  @override
  State<SidebarContextMenu> createState() => _SidebarContextMenuState();
}

class _SidebarContextMenuState extends State<SidebarContextMenu> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.contextMenuOverlay.hide();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 130,
        height: 300,
        decoration: BoxDecoration(
            color: const Color(0xffe7e3eb),
            border: Border.all(color: const Color(0xffc7c7c7)),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(3, 3),
              )
            ]),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          itemExtent: 40,
          children: [
            SidebarContextMenuItem(),
          ],
        ),
      ),
    );
  }
}

class SidebarContextMenuItem extends StatelessWidget {
  SidebarContextMenuItem({Key? key}) : super(key: key);

  final isHover = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        isHover.value = true;
      },
      onExit: (e) => isHover.value = false,
      child: ValueListenableBuilder(
        valueListenable: isHover,
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              color: value ? Colors.blueAccent : Colors.transparent,
            ),
            child: child,
          );
        },
        child: Text('新建'),
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
  double sidebarWidth = minWidth;
  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      contextMenu: SidebarContextMenu(),
      child: Row(
        children: [
          Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          GestureDetector(
            onHorizontalDragStart: (e) {
              context
                  .read<AppProvider>()
                  .setAppCursors(SystemMouseCursors.resizeColumn);
            },
            onHorizontalDragEnd: (e) {
              context
                  .read<AppProvider>()
                  .setAppCursors(SystemMouseCursors.basic);
            },
            onHorizontalDragCancel: () {
              context
                  .read<AppProvider>()
                  .setAppCursors(SystemMouseCursors.basic);
            },
            onHorizontalDragUpdate: (e) {
              setState(() {
                final globalPositionDx = e.globalPosition.dx;
                if (globalPositionDx < minWidth) {
                  sidebarWidth = minWidth;
                } else if (globalPositionDx > maxWidth) {
                  sidebarWidth = maxWidth;
                } else {
                  sidebarWidth = globalPositionDx;
                }
              });
            },
            child: MouseRegion(
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
      ),
    );
  }
}
