import 'dart:io';

import 'package:flutter/foundation.dart';

class AppPlatform {
  static bool isWindows = kIsWeb ? false : Platform.isWindows;
  static bool isWeb = kIsWeb;
  static bool isMacOS = kIsWeb ? false : Platform.isMacOS;
}
