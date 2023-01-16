import 'package:flutter/material.dart';

class SidebarWorkspace extends StatefulWidget {
  const SidebarWorkspace({Key? key}) : super(key: key);

  @override
  State<SidebarWorkspace> createState() => _SidebarWorkspaceState();
}

class _SidebarWorkspaceState extends State<SidebarWorkspace> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Text('工作区标题'),
        ),
        // ListView.builder(
        //   itemExtent: 40,
        //   itemCount: 4,
        //   itemBuilder: (context, index) {
        //     return Container(
        //       child: Text('test.json'),
        //     );
        //   },
        // )
      ],
    );
  }
}
