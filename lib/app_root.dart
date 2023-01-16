import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/page/home_page.dart';
import 'package:json_to_dart/provider/app_provider.dart';
import 'package:macos_ui/macos_ui.dart';
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
      child: MacosApp(
        title: 'Json to Dart',
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        home: ContextMenuOverlay(
          child: Selector<AppProvider, MouseCursor>(
            selector: (context, provider) => provider.cursor,
            builder: (context, cursor, child) {
              return MouseRegion(
                cursor: cursor,
                child: child,
              );
            },
            child: const HomePage(),
          ),
        ),
      ),
    );
  }
}
