import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:json_to_dart/page/home_page.dart';
import 'package:json_to_dart/page/setting_page.dart';
import 'package:json_to_dart/provider/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:window_manager/window_manager.dart';

import 'provider/app_datebase.dart';
import 'theme.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppDatebaseProvider()),
        ChangeNotifierProvider(create: (_) => AppTheme()),
        ChangeNotifierProvider(
            create: (context) =>
                AppProvider(context.read<AppDatebaseProvider>().db)),
      ],
      child: Builder(builder: (context) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: "Json to Dart",
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: appTheme.color,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.child,
    required this.shellContext,
    required this.state,
  }) : super(key: key);

  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;

  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');

  List<NavigationPaneItem> get originalItems {
    final projectList = context.read<AppProvider>().projectList;
    // return [
    //   PaneItem(
    //     key: const Key('/'),
    //     icon: const Icon(FluentIcons.home),
    //     title: const Text('Home'),
    //     body: const SizedBox.shrink(),
    //     onTap: () {
    //       if (router.location != '/') router.pushNamed('home');
    //     },
    //   )
    // ];
    final List<NavigationPaneItem> res = projectList
        .map((item) => PaneItem(
              key: Key("/"),
              icon: const Icon(FluentIcons.home),
              title: Text(item.name),
              body: const SizedBox.shrink(),
              onTap: () {
                if (router.location != '/') router.pushNamed('home');
              },
            ))
        .toList();
    final List<NavigationPaneItem> res2 = [1, 2, 3]
        .map((item) => PaneItem(
              key: Key("/"),
              icon: const Icon(FluentIcons.home),
              title: Text('321312'),
              body: const SizedBox.shrink(),
              onTap: () {
                if (router.location != '/') router.pushNamed('home');
              },
            ))
        .toList();
    print(res2);
    return [
      PaneItem(
        key: Key("/"),
        icon: const Icon(FluentIcons.home),
        title: Text('321312'),
        body: const SizedBox.shrink(),
        onTap: () {
          if (router.location != '/') router.pushNamed('home');
        },
      )
    ];
  }

  //  [
  // PaneItem(
  //   key: const Key('/'),
  //   icon: const Icon(FluentIcons.home),
  //   title: const Text('Home'),
  //   body: const SizedBox.shrink(),
  //   onTap: () {
  //     if (router.location != '/') router.pushNamed('home');
  //   },
  // ),
  // PaneItemExpander(
  //   icon: const Icon(FluentIcons.account_management),
  //   title: const Text('Account'),
  //   body: const SizedBox.shrink(),
  //   items: [
  //     PaneItem(
  //       icon: const Icon(FluentIcons.mail),
  //       title: const Text('Mail'),
  //       body: const SizedBox.shrink(),
  //     ),
  //     PaneItem(
  //       icon: const Icon(FluentIcons.calendar),
  //       title: const Text('Calendar'),
  //       body: const SizedBox.shrink(),
  //     ),
  //   ],
  // ),
  // PaneItemHeader(header: const Text('Inputs')),
  // PaneItem(
  //   key: const Key('/settings'),
  //   icon: const Icon(FluentIcons.settings),
  //   title: const Text('Settings'),
  //   body: const SizedBox.shrink(),
  //   onTap: () {
  //     if (router.location != '/settings') {
  //       router.pushNamed('settings');
  //     }
  //   },
  // ),
  // ];
  final List<NavigationPaneItem> footerItems = [
    // PaneItemSeparator(),
    // PaneItem(
    //   key: const Key('/settings'),
    //   icon: const Icon(FluentIcons.settings),
    //   title: const Text('Settings'),
    //   body: const SizedBox.shrink(),
    //   onTap: () {
    //     if (router.location != '/settings') {
    //       router.pushNamed('settings');
    //     }
    //   },
    // ),
    // _LinkPaneItemAction(
    //   icon: const Icon(FluentIcons.open_source),
    //   title: const Text('Source code'),
    //   link: 'https://github.com/bdlukaa/fluent_ui',
    //   body: const SizedBox.shrink(),
    // ),
  ];

  @override
  void initState() {
    windowManager.addListener(this);
    context.read<AppProvider>().initProject();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = router.location;
    int indexOriginal = originalItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == Key(location));

    if (indexOriginal == -1) {
      int indexFooter = footerItems
          .where((element) => element.key != null)
          .toList()
          .indexWhere((element) => element.key == Key(location));
      if (indexFooter == -1) {
        return 0;
      }
      return originalItems
              .where((element) => element.key != null)
              .toList()
              .length +
          indexFooter;
    } else {
      return indexOriginal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FluentLocalizations.of(context);

    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);
    if (widget.shellContext != null) {
      if (router.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          const title = Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text("test1111"),
          );
          if (kIsWeb) {
            return title;
          }
          return const DragToMoveArea(
            child: title,
          );
        }(),
        actions: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
            // content: const Text('Dark Mode'),
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: ToggleSwitch(
              checked: FluentTheme.of(context).brightness.isDark,
              onChanged: (v) {
                if (v) {
                  appTheme.mode = ThemeMode.dark;
                } else {
                  appTheme.mode = ThemeMode.light;
                }
              },
            ),
          ),
          if (!kIsWeb) const WindowButtons(),
        ]),
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
      pane: NavigationPane(
        // selected: _calculateSelectedIndex(context),
        header: SizedBox(
          height: kOneLineTileHeight,
          child: ShaderMask(
            shaderCallback: (rect) {
              final color = appTheme.color.defaultBrushFor(
                theme.brightness,
              );
              return LinearGradient(
                colors: [
                  color,
                  color,
                ],
              ).createShader(rect);
            },
          ),
        ),
        displayMode: appTheme.displayMode,
        indicator: () {
          switch (appTheme.indicator) {
            case NavigationIndicators.end:
              return const EndNavigationIndicator();
            case NavigationIndicators.sticky:
            default:
              return const StickyNavigationIndicator();
          }
        }(),
        items: originalItems,
        footerItems: footerItems,
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      // showDialog(
      //   context: context,
      //   builder: (_) {
      //     return ContentDialog(
      //       title: const Text('Confirm close'),
      //       content: const Text('Are you sure you want to close this window?'),
      //       actions: [
      //         FilledButton(
      //           child: const Text('Yes'),
      //           onPressed: () {
      //             Navigator.pop(context);
      //             windowManager.destroy();
      //           },
      //         ),
      //         Button(
      //           child: const Text('No'),
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FluentThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class _LinkPaneItemAction extends PaneItem {
  _LinkPaneItemAction({
    required super.icon,
    required this.link,
    required super.body,
    super.title,
  });

  final String link;

  @override
  Widget build(
    BuildContext context,
    bool selected,
    VoidCallback? onPressed, {
    PaneDisplayMode? displayMode,
    bool showTextOnTop = true,
    bool? autofocus,
    int? itemIndex,
  }) {
    return Link(
      uri: Uri.parse(link),
      builder: (context, followLink) => super.build(
        context,
        selected,
        followLink,
        displayMode: displayMode,
        showTextOnTop: showTextOnTop,
        itemIndex: itemIndex,
        autofocus: autofocus,
      ),
    );
  }
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(
          shellContext: _shellNavigatorKey.currentContext,
          state: state,
          child: child,
        );
      },
      routes: [
        /// Home
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),

        /// Settings
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => SettingPage(),
        ),
      ],
    ),
  ],
);
