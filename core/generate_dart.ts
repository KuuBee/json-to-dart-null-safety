/*
 * @Descripttion: 转换入口
 * @Author: KuuBee
 * @Date: 2021-06-23 14:20:10
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-25 16:18:43
 */

import parse, { ArrayNode, LiteralNode, ObjectNode } from "json-to-ast";
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
    this._flatData([data]);
    console.log("_needParseData", this._needParseData);
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

  private _flatData(data: (ObjectNode | LiteralNode)[]) {
    let firstObjNode: ObjectNode | null = null;
    for (const item of data) {
      if (item.type === "Object") firstObjNode = item;
      break;
    }
    const newObjData: {
      [key: string]: (ObjectNode | LiteralNode)[];
    } = {};
    if (!firstObjNode) return;
    for (let i = 0; i < firstObjNode.children.length; i++) {
      const element = firstObjNode.children[i];
      const itemDataList: (ObjectNode | LiteralNode)[] = [];
      for (const obj of data) {
        if (obj.type === "Literal") continue;
        else {
          const currentData = obj.children[i].value;
          switch (currentData.type) {
            case "Object":
              itemDataList.push(currentData);
              break;
            case "Array":
              if (currentData.children.every((item) => item.type != "Array"))
                itemDataList.push(
                  ...(currentData.children as (ObjectNode | LiteralNode)[])
                );
              break;
            default:
              break;
          }
        }
      }
      if (itemDataList.length) newObjData[element.key.value] = itemDataList;
    }
    console.log(newObjData);
    for (const key in newObjData) {
      if (Object.prototype.hasOwnProperty.call(newObjData, key)) {
        const element = newObjData[key];
        if (this._needParseKeys.includes(key)) continue;
        this._needParseKeys.push(key);
        this._needParseData.push({
          key,
          data: {
            type: "Array",
            children: element
          }
        });
        this._flatData(element);
      }
    }
  }
}
