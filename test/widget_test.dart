// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:json_to_dart/version.dart';
import 'package:test/test.dart';

void main() {
  group('测试版本号正则判断', () {
    const test0 = '1';
    const test1 = '1.1';
    const test2 = '2.2.2';
    const test3 = '3.3.3 (1223)';
    const test4 = '4.4.4.1441';
    // ---
    const test5 = '10.01.03C';
    const test6 = '6.3.19 Beta';
    const test7 = '1.8.7.5(N6)';
    const test8 = 'v10.26';
    const test9 = '9.10.00N';
    const test10 = '5.11.12 (8425)';
    const test11 = '6.5.40-Release.9059101';
    const test12 = '2022 V22.7.0.1';
    test(test0, () {
      final res = versionPattern(test0);
      expect(res, null);
    });
    test(test1, () {
      final res = versionPattern(test1);
      expect(res, const VersionData(major: 1, minor: 1));
    });
    test(test2, () {
      final res = versionPattern(test2);
      expect(res, const VersionData(major: 2, minor: 2, revision: 2));
    });
  });
}
