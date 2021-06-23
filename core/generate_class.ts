/*
 * @Descripttion: 生成class
 * @Author: KuuBee
 * @Date: 2021-06-23 14:30:09
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-23 17:24:30
 */
import parse, { ObjectNode } from "json-to-ast";
import { GenerateDartType } from "./generate_dart_type";
import { Utils } from "./utils";

const constructorVariableAnnotate = "///-constructor-variable";
const declareVariableAnnotate = "///-declare-variable";
const fromJsonAnnotate = "///-from-json";
const toJsonAnnotate = "///-to-json";

export class GenerateCalss {
  constructor(public data: ObjectNode, public className: string) {
    this._clear();
  }

  // class 模板 之后的操作都在这个基础上进行
  dart = `class ${this.className} {
  ${this.className}({
    ${constructorVariableAnnotate}
  });
  ${declareVariableAnnotate}
  ${this.className}.fromJson(Map<String, dynamic> json) {
    ${fromJsonAnnotate}
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    ${toJsonAnnotate}
    return _data;
  }
}`;

  private _generate() {
    for (const item of this.data.children) {
      const dartType = new GenerateDartType(item.value, item.key.value);
      const currentKey = Utils._toCamelCase(item.key.value);
    }
  }

  // 构造函数语句
  private _insertConstructorVariable(type: GenerateDartType, key: string) {
    const insertCode = `${type.nullable ? "" : "required"} this.${key},`;
    this.dart.replace(
      constructorVariableAnnotate,
      `${insertCode}\n    ${constructorVariableAnnotate}`
    );
  }

  // 声明变量语句
  private _insertDeclareVariable(type: GenerateDartType, key: string) {
    const insertCode = `final ${type.dartType} ${key};`;
    this.dart.replace(
      declareVariableAnnotate,
      `${insertCode}\n  ${declareVariableAnnotate}`
    );
  }

  // fromJson语句
  private _insertFromJsonCode(
    type: GenerateDartType,
    key: string,
    rawKey: string
  ) {
    let insertCode = `${key} = json['${rawKey}'];`;

    switch (type.astType) {
      case "Object":
        insertCode = `${key}.fromJson(json['${rawKey}']);`;
        break;
      case "Array":
        insertCode = `List.from(json['${rawKey}']).map((e)=>${Utils._toCamelCase(
          rawKey,
          "defalut"
        )}.fromJson(e)).toList();`;
        break;
      default:
    }
    this.dart.replace(
      fromJsonAnnotate,
      `${insertCode}\n    ${fromJsonAnnotate}`
    );
  }

  // toJson语句
  private _insertToJson(type: GenerateDartType, key: string, rawKey: string) {
    let insertCode = `_data['${rawKey}'] = ${key};`;
    // TODO
    switch (type.astType) {
      case "Object":
        insertCode = `${key}.toJson();`;
        break;
      case "Array":
        insertCode = `List.from(json['${rawKey}']).map((e)=>${Utils._toCamelCase(
          rawKey,
          "defalut"
        )}.fromJson(e)).toList();`;
        break;
      default:
    }
    this.dart.replace(toJsonAnnotate, `${insertCode}\n  ${toJsonAnnotate}`);
  }

  private _clear() {
    this.dart
      .replace(constructorVariableAnnotate, "")
      .replace(declareVariableAnnotate, "")
      .replace(fromJsonAnnotate, "")
      .replace(toJsonAnnotate, "");
  }
}
