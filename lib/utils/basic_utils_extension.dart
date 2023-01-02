import 'package:basic_utils/basic_utils.dart';

extension StringUtilsExt on StringUtils {
  static toCamelCase(String s) {
    final str = StringUtils.toPascalCase(s);
    return '${str[0].toLowerCase()}${StringUtils.removeCharAtPosition(str, 1)}';
  }

  static toPascalCase(String s)=>StringUtils.toPascalCase(s);
  static camelCaseToLowerUnderscore(s) => StringUtils.camelCaseToLowerUnderscore(s);
}
