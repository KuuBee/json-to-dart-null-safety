/*
 * @Descripttion: 生成class
 * @Author: KuuBee
 * @Date: 2021-06-23 14:30:09
 * @LastEditors: Raphael ARABEYRE
 * @LastEditTime: 2022-05-012 22:51:22
 */
import parse, { ObjectNode, ValueNode } from "json-to-ast";
import { GenerateDartType } from "./generateDartType";
import { Utils } from "./utils";

const constructorVariableAnnotate = "///-constructor-variable";
const declareVariableAnnotate = "///-declare-variable";
const fromJsonAnnotate = "///-from-json";
const toJsonAnnotate = "///-to-json";

export class GenerateCalss {
  constructor(public data: ObjectNode[], public className: string) {
    this._generate();
    this._clear();
  }

  get isEmpty(): boolean {
    if (this.data.length <= 0) return true;
    return this.data.every((item) => item.children.length <= 0);
  }

  // class 模板 之后的操作都在这个基础上进行
  dart = `class ${this.className} {
  ${this.className}(${this.isEmpty ? "" : "{"}${constructorVariableAnnotate}${
    this.isEmpty ? "" : "\n\u0020\u0020}"
  });${declareVariableAnnotate}
  
  ${this.className}.fromJson(Map${
    this.isEmpty ? "" : "<String, dynamic>"
  } json)${
    this.isEmpty
      ? ";"
      : `{${fromJsonAnnotate}
\u0020\u0020}`
  }

  Map<String, dynamic> toJson() {
\u0020\u0020\u0020\u0020final _data = <String, dynamic>{};${toJsonAnnotate}
\u0020\u0020\u0020\u0020return _data;
  }
}`;

  private _generate() {
    let firstCanUseData: ObjectNode | null = null;
    for (const item of this.data) {
      if (item.type === "Object") firstCanUseData = item;
      break;
    }
    if (!firstCanUseData) return;

    for (let j = 0; j < firstCanUseData.children.length; j++) {
      const valList: ValueNode[] = [];
      for (let i = 0; i < this.data.length; i++) {
        valList.push(this.data[i].children[j].value);
      }
      const rawKey = firstCanUseData.children[j].key.value;

      const dartType = new GenerateDartType({
        valList,
        key: rawKey,
        arrayMod: true
      });

      const currentKey = Utils._toCamelCase(rawKey);
      this._insertConstructorVariable(dartType, currentKey);
      this._insertDeclareVariable(dartType, currentKey);
      this._insertFromJsonCode(dartType, currentKey, rawKey);
      this._insertToJson(dartType, currentKey, rawKey);
    }
  }

  // 构造函数语句
  private _insertConstructorVariable(type: GenerateDartType, key: string) {
    const insertCode = `\u0020\u0020\u0020\u0020${
      type.nullable ? "" : "required"
    } this.${key},`;

    this.dart = this.dart.replace(
      constructorVariableAnnotate,
      `\n${insertCode}${constructorVariableAnnotate}`
    );
  }

  // 声明变量语句
  private _insertDeclareVariable(type: GenerateDartType, key: string) {
    const insertCode = `\u0020\u0020late final ${type.dartType} ${key};`;
    this.dart = this.dart.replace(
      declareVariableAnnotate,
      `\n${insertCode}${declareVariableAnnotate}`
    );
  }

  // fromJson语句
  private _insertFromJsonCode(
    type: GenerateDartType,
    key: string,
    rawKey: string
  ) {
    let insertCode = `${key} = ${
      type.nullable ? "null" : `json['${rawKey}']  as ${type.dartType}`
    };`;
    switch (type.astType) {
      case "Object":
        if (!type.nullable)
          insertCode = `${key} = ${Utils._toCamelCase(
            key,
            "defalut"
          )}.fromJson(json['${rawKey}'] as Map<String, dynamic>);`;
        else
          insertCode = `${key} = json['${rawKey}'] == null
          ? null
          : ${Utils._toCamelCase(key, "defalut")}.fromJson(json['${rawKey}'] as Map<String, dynamic>);`;
        break;
      case "Array":
        if (type.isArrayObject)
          insertCode = `${key} = List.from(json['${rawKey}']${
            type.nullable ? "??[]" : ""
          } as Iterable<dynamic>).map((e)=>${Utils._toCamelCase(
            rawKey,
            "defalut"
          )}.fromJson(e as Map<String, dynamic>)).toList();`;
        else {
          // 这里不清楚 List.castFrom 是否会对性能产生影响
          insertCode = `${key} = List.castFrom<dynamic, ${
            type.arrayType
          }>(json['${rawKey}']${type.nullable ? "??[]" : ""} as List<dynamic>);`;
        }
        break;
      default:
        insertCode = `${key} = json['${rawKey}'] as ${type.dartType};`;
    }
    this.dart = this.dart.replace(
      fromJsonAnnotate,
      `\n\u0020\u0020\u0020\u0020${insertCode}${fromJsonAnnotate}`
    );
  }

  // toJson语句
  private _insertToJson(type: GenerateDartType, key: string, rawKey: string) {
    let insertCode = `_data['${rawKey}'] = ${key};`;
    switch (type.astType) {
      case "Object":
        insertCode = `_data['${rawKey}'] = ${key}${
          type.nullable ? "?" : ""
        }.toJson();`;
        break;
      case "Array": {
        if (type.isArrayObject)
          insertCode = `_data['${rawKey}'] = ${key}.map((e)=>e.toJson()).toList();`;
        break;
      }
      default:
    }
    this.dart = this.dart.replace(
      toJsonAnnotate,
      `\n\u0020\u0020\u0020\u0020${insertCode}${toJsonAnnotate}`
    );
  }

  private _clear() {
    this.dart = this.dart
      .replace(constructorVariableAnnotate, "")
      .replace(declareVariableAnnotate, "")
      .replace(fromJsonAnnotate, "")
      .replace(toJsonAnnotate, "");
  }
}
