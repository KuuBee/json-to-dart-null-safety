/*
 * @Descripttion: 转换入口
 * @Author: KuuBee
 * @Date: 2021-06-23 14:20:10
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-24 16:55:36
 */

import parse, { ArrayNode, ObjectNode } from "json-to-ast";
import { GenerateCalss } from "./generate_class";
import { Utils } from "./utils";

interface NeedParseData {
  key: string;
  data: ObjectNode | ArrayNode;
}

export interface ArrayObject {
  [key: string]: any[];
}

export class GenerateDart {
  constructor(data: ObjectNode) {
    this._flatData(data);
  }

  getRes(): string {
    const res: string[] = this._needParseData
      .map((item) => {
        const className = Utils._toCamelCase(item.key, "defalut");
        if (item.data.type === "Array")
          return new GenerateCalss(
            item.data.children as ObjectNode[],
            className
          );
        else return new GenerateCalss([item.data as ObjectNode], className);
      })
      .map((item) => item.dart);
    return res.join("\n\n");
  }

  private _needParseData: NeedParseData[] = [];
  private _needParseKeys: string[] = [];

  private _flatData(data: ObjectNode) {
    let iterationData: ObjectNode | null = null;
    for (const item of data.children) {
      if (this._needParseKeys.includes(item.key.value)) continue;
      switch (item.value.type) {
        case "Object":
          {
            iterationData = item.value;
            this._needParseData.push({
              key: item.key.value,
              data: item.value
            });
            this._needParseKeys.push(item.key.value);
          }
          break;
        case "Array":
          if (
            !item.value.children.every((subItem) => subItem.type === "Literal")
          ) {
            for (const subItem of item.value.children) {
              if (subItem.type === "Object") {
                iterationData = subItem;
                break;
              }
            }
            this._needParseData.push({
              key: item.key.value,
              data: item.value
            });
            this._needParseKeys.push(item.key.value);
          }
          break;
        default:
          break;
      }
      if (iterationData) this._flatData(iterationData);
    }
  }
}
