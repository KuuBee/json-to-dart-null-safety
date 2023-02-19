import 'package:flutter/material.dart';

class AppJsonViewLine extends StatelessWidget {
  const AppJsonViewLine({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.blueAccent,
          padding: EdgeInsets.only(right: 10),
          child: Text('|'),
        ),
        Expanded(child: child),
      ],
    );
  }
}
