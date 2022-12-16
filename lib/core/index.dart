import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

String generateClass(String name, Map<String, dynamic> data) {
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
      m.name = '_${name}ToJson';
      m.returns = const Reference('Map<String,dynamic>');
      m.lambda = true;
      String mapBody = '';
      data.forEach((key, value) {
        mapBody += '''
        $key:$key,
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
        $key:json['$key'],
        ''';
      });
      m.body = Code('$name($mapBody)');
    }

    // 添加class字段
    data.forEach((key, value) {
      fieldBuilder(FieldBuilder f) {
        f.name = key;
        f.modifier = FieldModifier.final$;
        final valIsObj = value is Map || value is List;
        if (valIsObj) {
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
