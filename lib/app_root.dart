import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/page/home_page.dart';
import 'package:json_to_dart/provider/app_provider.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'Json to Dart',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              fontSize: 16,
              color: Color(0xff222222),
            ),
          ),
        ),
        home: ContextMenuOverlay(
          child: Selector<AppProvider, MouseCursor>(
            selector: (context, provider) => provider.cursor,
            builder: (context, cursor, child) {
              return MouseRegion(
                cursor: cursor,
                child: child,
              );
            },
            child: const SafeArea(
              child: HomePage(),
            ),
          ),
        ),
      ),
    );
  }
}
