import 'dart:developer';

import 'package:basic_utils/basic_utils.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import '../utils/basic_utils_extension.dart';
import 'field_data.dart';

String generateClass(String name, Map<String, dynamic> data) {
  // TODO
  final List<FieldData> fieldDataList = _dependencyCollection();

  name = StringUtilsExt.toPascalCase(name);

  classBuilder(ClassBuilder c) {
    constructorBuilder(ConstructorBuilder constructor) {
      final parameterList = <Parameter>[];
      data.forEach((key, value) {
        final p = Parameter((p) {
          p.name = key;
          p.toThis = true;
          p.named = true;
          p.required = true;
        });
        parameterList.add(p);
      });
      constructor.optionalParameters.addAll(parameterList);
    }

    fromJsonConstructorBuilder(ConstructorBuilder constructor) {
      final parameterList = <Parameter>[];
      data.forEach((key, value) {
        final p = Parameter((p) {
          p.name = key;
          p.toThis = true;
          p.named = true;
          p.required = true;
        });
        parameterList.add(p);
      });
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
      data.forEach((key, value) {
        mapBody += '''
        ${StringUtilsExt.camelCaseToLowerUnderscore(key)}:${StringUtilsExt
            .toCamelCase(key)},
        ''';
      });
      m.body = Code('<String,dynamic>{'
          '$mapBody'
          '}');
    }

    fromJsonMethodBuilder(MethodBuilder m) {
      m.lambda = true;
      m.name = '_${name}FromJson';
      m.returns = Reference(name);
      m.requiredParameters.add(Parameter((p) {
        p.name = 'json';
        p.type = const Reference('Map<String,dynamic>');
      }));
      String mapBody = '';
      data.forEach((key, value) {
        mapBody += '''
        ${StringUtilsExt.toCamelCase(key)}:json['$key'],
        ''';
      });
      m.body = Code('$name($mapBody)');
    }

    // 添加class字段
    data.forEach((key, value) {
      fieldBuilder(FieldBuilder f) {
        f.name = StringUtilsExt.toCamelCase(key);
        f.modifier = FieldModifier.final$;
        final valIsMap = value is Map;
        final valIsList = value is List;
        if (valIsMap || valIsList) {
          log("value:${value.runtimeType}");
          f.type = Reference(key);
        } else {
          f.type = Reference(value.runtimeType.toString());
        }
      }

      c.fields.add(Field(fieldBuilder));
    });
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

// TODO 依赖收集
// 能走到这里的必须是个List Map
// 如果是个基础类型的List直接报错
List<FieldData> _dependencyCollection(List<Map<String, dynamic>> data) {
  return [];
}