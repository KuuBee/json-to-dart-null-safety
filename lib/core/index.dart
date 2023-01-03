import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../utils/basic_utils_extension.dart';
import 'field_data.dart';

class TestAA {
  String toJson() {
    return '';
  }
}

String generateClass(String name, List<Map<String, dynamic>> data) {
  final List<FieldData> fieldDataset = _dependencyCollection(data);

  name = StringUtilsExt.toPascalCase(name);

  classBuilder(ClassBuilder c) {
    constructorBuilder(ConstructorBuilder constructor) {
      final parameterList = <Parameter>[];
      for (var field in fieldDataset) {
        final p = Parameter((p) {
          p.name = field.name;
          p.toThis = true;
          p.named = true;
          p.required = true;
        });
        parameterList.add(p);
      }
      constructor.optionalParameters.addAll(parameterList);
    }

    fromJsonConstructorBuilder(ConstructorBuilder constructor) {
      final parameterList = <Parameter>[];
      for (var field in fieldDataset) {
        final p = Parameter((p) {
          p.name = field.name;
          p.toThis = true;
          p.named = true;
          p.required = true;
        });
        parameterList.add(p);
      }
      constructor.requiredParameters.add(
        Parameter(
          (p) {
            p.type = const Reference('Map<String,dynamic>');
            p.name = 'json';
          },
        ),
      );
      constructor.name = 'fromJson';
      constructor.lambda = true;
      constructor.body = Code('_${name}FromJson(json)');
      constructor.factory = true;
    }

    toJsonMethodBuilder(MethodBuilder m) {
      m.name = 'toJson';
      m.returns = const Reference('Map<String,dynamic>');
      m.lambda = true;
      String mapBody = '';
      for (var field in fieldDataset) {
        String valueToJson = '';
        if (field.isMap) {
          valueToJson = '${field.type}.toJson()';
        } else if (field.isMapList) {
          valueToJson =
              '${field.name}.map((e) => e.toJson()).toList()';
        } else {
          valueToJson = field.name;
        }
        mapBody += '''
        ${StringUtilsExt.camelCaseToLowerUnderscore(field.name)}:$valueToJson,
        ''';
      }
      m.body = Code('<String,dynamic>{'
          '$mapBody'
          '}');
    }

    // TODO 完善转换
    fromJsonMethodBuilder(MethodBuilder m) {
      m.lambda = true;
      m.name = '_${name}FromJson';
      m.returns = Reference(name);
      m.requiredParameters.add(Parameter((p) {
        p.name = 'json';
        p.type = const Reference('Map<String,dynamic>');
      }));
      String mapBody = '';
      for (var field in fieldDataset) {
        mapBody += '''
        ${field.name}:json['${field.rawName}'],
        ''';
      }
      m.body = Code('$name($mapBody)');
    }

    // 添加class字段
    for (var field in fieldDataset) {
      fieldBuilder(FieldBuilder f) {
        f.name = field.name;
        f.modifier = FieldModifier.final$;
        final valIsMap = field.value is Map;
        final valIsList = field.value is List;
        if (valIsMap || valIsList) {
          log('key:${field.name}');
          log('value:${field.value}');
          log('type:${field.type}');
          f.type = Reference(field.type);
        } else {
          f.type = Reference(field.value.runtimeType.toString());
        }
      }

      c.fields.add(Field(fieldBuilder));
    }
    // 添加class类名
    c.name = name;
    // 添加默认构造函数
    c.constructors.add(Constructor(constructorBuilder));
    // 添加fromJson工厂函数（通过lambda表达式指向fromJson函数）
    c.constructors.add(Constructor(fromJsonConstructorBuilder));
    // 添加toJson函数
    c.methods.add(Method(toJsonMethodBuilder));
    // 添加fromJson函数
    c.methods.add(Method(fromJsonMethodBuilder));
  }

  final classInst = Class(classBuilder);
  final emitter = DartEmitter.scoped();
  // return classInst.accept(emitter).toString();
  return DartFormatter().format('${classInst.accept(emitter)}');
}

// 能走到这里的必须是个List Map
// 如果是个基础类型的List直接报错
List<FieldData> _dependencyCollection(List<Map<String, dynamic>> dataset) {
  final fieldDataset = <FieldData>[];
  final mapDepend = <String, List<dynamic>>{};
  for (var data in dataset) {
    data.forEach((key, value) {
      mapDepend[key] ??= [];
      mapDepend[key]!.add(value);
    });
  }
  mapDepend.forEach((key, value) {
    final deduplicationValueList = value.toSet().toList();
    final withoutNullValueList =
        deduplicationValueList.where((element) => element != null).toList();
    final isMap = withoutNullValueList.isEmpty
        ? false
        : deduplicationValueList.first is Map;
    log('withoutNullValueList:$withoutNullValueList');
    final isBaseList = withoutNullValueList.every((element) {
      if (element is List) {
        return element.every((element) => !(element is Map || element is List));
      }
      return false;
    });
    final isMapList = withoutNullValueList.every((element) {
      if (element is List) {
        element = element.where((element) => element != null).toList();
        if (element.isNotEmpty) {
          return element.first is Map;
        }
      }
      return false;
    });

    String type;
    if (withoutNullValueList.isEmpty) {
      type = 'Null';
    } else if (isMap) {
      type = StringUtilsExt.toPascalCase(key);
    } else if (isMapList) {
      type = 'List<${StringUtilsExt.toPascalCase(key)}>';
    } else if (isBaseList) {
      type = 'List<${withoutNullValueList.first.first.runtimeType}>';
    } else {
      type = withoutNullValueList.first.runtimeType.toString();
    }
    fieldDataset.add(
      FieldData(
        mayBeNull: deduplicationValueList.length > 1 &&
            deduplicationValueList.contains(null),
        type: type,
        name: StringUtilsExt.toCamelCase(key),
        value: value,
        rawName: key,
        isMap: isMap,
        isMapList: isMapList,
        isBaseList: isBaseList,
      ),
    );
  });
  return fieldDataset;
}
