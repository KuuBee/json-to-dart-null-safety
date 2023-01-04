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
  final className = StringUtilsExt.toPascalCase(name);
  name = StringUtilsExt.toCamelCase(name);

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
      String mapBody = '';
      for (var field in fieldDataset) {
        mapBody += '''
        ${field.name}:${field.fromJsonCode},
        ''';
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
      constructor.body = Code('$className($mapBody)');
      constructor.factory = true;
    }

    toJsonMethodBuilder(MethodBuilder m) {
      m.name = 'toJson';
      m.returns = const Reference('Map<String,dynamic>');
      m.lambda = true;
      String mapBody = '';
      for (var field in fieldDataset) {
        mapBody += '''
        "${StringUtilsExt.camelCaseToLowerUnderscore(field.name)}":${field.toJsonCode},
        ''';
      }
      m.body = Code('<String,dynamic>{'
          '$mapBody'
          '}');
    }

    fromJsonMethodBuilder(MethodBuilder m) {
      m.lambda = true;
      m.name = '_${name}FromJson';
      m.returns = Reference(className);
      m.requiredParameters.add(Parameter((p) {
        p.name = 'json';
        p.type = const Reference('Map<String,dynamic>');
      }));
      String mapBody = '';
      for (var field in fieldDataset) {
        mapBody += '''
        ${field.name}:${field.fromJsonCode},
        ''';
      }
      m.body = Code('$className($mapBody)');
    }

    // 添加class字段
    for (var field in fieldDataset) {
      fieldBuilder(FieldBuilder f) {
        f.name = field.name;
        f.modifier = FieldModifier.final$;
        final valIsMap = field.value is Map;
        final valIsList = field.value is List;
        if (valIsMap || valIsList) {
          f.type = Reference(field.type);
        } else {
          f.type = Reference(field.value.runtimeType.toString());
        }
      }

      c.fields.add(Field(fieldBuilder));
    }
    // 添加class类名
    c.name = className;
    // 添加默认构造函数
    c.constructors.add(Constructor(constructorBuilder));
    // 添加fromJson工厂函数（通过lambda表达式指向fromJson函数）
    c.constructors.add(Constructor(fromJsonConstructorBuilder));
    // 添加toJson函数
    c.methods.add(Method(toJsonMethodBuilder));
    // 添加fromJson函数
    // c.methods.add(Method(fromJsonMethodBuilder));
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
    // 数据去重
    final deduplicationValueList = value.toSet().toList();
    // 数据去空
    final withoutNullValueList =
        deduplicationValueList.where((element) => element != null).toList();
    // 如果去空数据不为空，那么取第一个值判断是否为Map
    // 这里对于不为完整数据结构的值会产生错误的结果
    // 如：[1,{"a":1}]；这样的数据
    // 所以这里想要正确的产出必须要求数据结构的一致性
    final isMap = withoutNullValueList.isEmpty
        ? false
        : deduplicationValueList.first is Map;
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

    final name = StringUtilsExt.toCamelCase(key);
    // 判断type
    String type;
    String toJsonCode;
    String fromJsonCode;
    if (withoutNullValueList.isEmpty) {
      toJsonCode = name;
      fromJsonCode = 'json[$name]';
      type = 'Null';
    } else if (isMap) {
      type = StringUtilsExt.toPascalCase(key);
      toJsonCode = '$type().toJson()';
      fromJsonCode = '${StringUtilsExt.toPascalCase(key)}'
          '.fromJson(json["$key"])';
    } else if (isMapList) {
      type = 'List<${StringUtilsExt.toPascalCase(key)}>';
      toJsonCode = '$name.map((e) => e.toJson()).toList()';
      //List.from(json['data']).map((e) => Data.fromJson(e)).toList()
      fromJsonCode = 'List.from(json["$key"])'
          '.map((e) => ${StringUtilsExt.toPascalCase(name)}.fromJson(e))'
          '.toList()';
    } else if (isBaseList) {
      type = 'List<${withoutNullValueList.first.first.runtimeType}>';
      toJsonCode = name;
      fromJsonCode = 'json["$key"]';
    } else {
      type = withoutNullValueList.first.runtimeType.toString();
      toJsonCode = name;
      fromJsonCode = 'json["$key"]';
    }
    // TODO map list和map的依赖收集还有点问题,List<int?>这种类型null也需要处理
    fieldDataset.add(
      FieldData(
        mayBeNull: deduplicationValueList.length > 1 &&
            deduplicationValueList.contains(null),
        type: type,
        name: name,
        value: value,
        rawName: key,
        isMap: isMap,
        isMapList: isMapList,
        isBaseList: isBaseList,
        toJsonCode: toJsonCode,
        fromJsonCode: fromJsonCode,
      ),
    );
  });
  return fieldDataset;
}
