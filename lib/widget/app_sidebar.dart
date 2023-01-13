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
  const SidebarContextMenu({
    Key? key,
    this.children = const [],
  }) : super(key: key);
  final List<SidebarContextMenuItem> children;

  @override
  State<SidebarContextMenu> createState() => _SidebarContextMenuState();
}

class _SidebarContextMenuState extends State<SidebarContextMenu> {
  final itemExtent = 25.0;
  final sidePadding = 3.0;
  get widgetHeight =>
      widget.children.length * itemExtent + sidePadding * 2 + sidePadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(sidePadding),
      width: 130,
      height: widgetHeight,
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
      child: ListView.builder(
        itemExtent: itemExtent,
        itemCount: widget.children.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => widget.children[index],
      ),
    );
  }
}

class SidebarContextMenuItem extends StatelessWidget {
  SidebarContextMenuItem(
    this.text, {
    Key? key,
    this.onTap,
  }) : super(key: key);
  final VoidCallback? onTap;
  final String text;

  final isHover = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
          isHover.value = false;
          context.contextMenuOverlay.hide();
        },
        child: MouseRegion(
          onEnter: (e) {
            isHover.value = true;
          },
          onExit: (e) => isHover.value = false,
          child: ValueListenableBuilder(
            valueListenable: isHover,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: value ? Colors.blueAccent : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 14,
                          color: value
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyText1?.color,
                        ),
                  ),
                ),
              );
            },
          ),
        ),
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
      contextMenu: SidebarContextMenu(
        children: [
          SidebarContextMenuItem('1上传文件'),
          SidebarContextMenuItem('2删除'),
          SidebarContextMenuItem('3删除'),
          SidebarContextMenuItem('4删除'),
          SidebarContextMenuItem('5删除'),
          SidebarContextMenuItem('6删除'),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  ExpansionTile(title: Text('title'), children: [
                    Text('1'),
                    Text('2'),
                    Text('3'),
                  ]),
                ],
              ),
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
