/*
 * @Descripttion: 生成class
 * @Author: KuuBee
 * @Date: 2021-06-23 14:30:09
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-24 17:21:09
 */
import parse, { ObjectNode, ValueNode } from "json-to-ast";
import { GenerateDartType } from "./generate_dart_type";
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
    this.isEmpty ? "" : "\n}"
  });${declareVariableAnnotate}
  
  ${this.className}.fromJson(Map<String, dynamic> json)${
    this.isEmpty
      ? ";"
      : `{${fromJsonAnnotate}
}`
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};${toJsonAnnotate}
    return _data;
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
    const insertCode = `${type.nullable ? "" : "required"} this.${key},`;

    this.dart = this.dart.replace(
      constructorVariableAnnotate,
      `\n${insertCode}${constructorVariableAnnotate}`
    );
  }

  // 声明变量语句
  private _insertDeclareVariable(type: GenerateDartType, key: string) {
    const insertCode = `late final ${type.dartType} ${key};`;
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
    let insertCode = `${key} = json['${rawKey}'];`;

    console.log(type.astType, key);
    // console.log(type.astType);

    switch (type.astType) {
      case "Object":
        insertCode = `${key} = ${Utils._toCamelCase(
          key,
          "defalut"
        )}.fromJson(json['${rawKey}']);`;
        break;
      case "Array":
        if (type.isArrayObject)
          insertCode = `${key} = List.from(json['${rawKey}']).map((e)=>${Utils._toCamelCase(
            rawKey,
            "defalut"
          )}.fromJson(e)).toList();`;
        break;
      default:
    }
    this.dart = this.dart.replace(
      fromJsonAnnotate,
      `\n${insertCode}${fromJsonAnnotate}`
    );
  }

  // toJson语句
  private _insertToJson(type: GenerateDartType, key: string, rawKey: string) {
    let insertCode = `_data['${rawKey}'] = ${key};`;
    switch (type.astType) {
      case "Object":
        insertCode = `_data['${rawKey}'] = ${key}.toJson();`;
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
      `\n${insertCode}${toJsonAnnotate}`
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
