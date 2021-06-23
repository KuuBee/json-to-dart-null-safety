/*
 * @Descripttion: 生成dart类型
 * @Author: KuuBee
 * @Date: 2021-06-23 14:31:51
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-23 16:50:33
 */
import { ArrayNode, ASTNode, LiteralNode, ObjectNode } from "json-to-ast";
import { Utils } from "./utils";

// AST node 类型
type AstType = "Object" | "Array" | "Literal";

// dart 基础类型
type DartBaseType =
  | "String"
  | "bool"
  | "int"
  | "double"
  | "dynamic"
  | "num"
  | "null";

export class GenerateDartType {
  constructor(
    public val: ASTNode,
    public key: string,
    // TODO
    public arrayMod: boolean = false
  ) {
    if (arrayMod)
      if (!(val.type === "Array")) throw "arrayMod下val必须为一个数组";
    this.dartType = this._getType();
    this.astType = this.val.type as AstType;
  }

  // 最终的类型
  dartType: string;
  // 是否可能为null
  // int? TestClass? List<int>? List<int?>?
  // 不包含 List<int?>
  nullable: boolean = false;

  astType: AstType;

  // 获取类型
  private _getType(): string {
    let res: string;
    switch (this.val.type) {
      case "Literal":
        res = this._getDartBaseType((this.val as LiteralNode).value);
        this.nullable = res === "null";
        break;
      case "Object":
        res = Utils._toCamelCase(Utils._toUnderline(this.key), "defalut");
        break;
      case "Array":
        res = this._getDartArrayType(this.val as ArrayNode);
        break;
      default:
        res = "dynamic";
    }
    return res;
  }
  // 获取基础类型
  private _getDartBaseType(data: any): DartBaseType {
    // 默认为 dynamic 类型 兜底
    let resType: DartBaseType = "dynamic";
    const dataType = typeof data;
    switch (dataType) {
      case "number": {
        if (Number.isInteger(data)) resType = "int";
        else resType = "double";
        break;
      }
      case "string":
        resType = "String";
        break;
      case "boolean":
        resType = "bool";
        break;
      case "object":
        resType = "null";
        break;
      default:
        break;
    }
    return resType;
  }
  // 获取数组类型
  private _getDartArrayType(data: ArrayNode) {
    const children = data.children;
    let typeList: AstType[] = [];
    let valList: any[] = [];
    for (const item of children) {
      typeList.push(item.type);
      switch (this.val.type) {
        case "Literal":
          valList.push((this.val as LiteralNode).value);
          break;
        default:
          valList.push((this.val as ArrayNode | ObjectNode).children);
      }
    }
    // 不包含null的数组数据
    let notNullValList: any[];
    // 最终结果
    let resType: string;
    // 当前数组是否包含null
    const hasNull: boolean = valList.includes(null);
    // 当去重后长度为1时 表示不为 nullable
    if (Array.from(new Set(typeList)).length === 1 && !hasNull) {
      notNullValList = typeList;
    } else {
      notNullValList = typeList.filter((item) => item != null);
    }
    const singleNodeType = notNullValList[0];
    // 当为 基础数据数组 [1,2,3,4]
    if (singleNodeType === "Literal") {
      const singleType = this._getDartBaseType(valList[0]);
      // 这里有个特殊情况 如果数组为 [1,2,3.2,4.6] 这种情况
      // 类型应扩展为 num
      if (singleType === "int" || singleType === "double") {
        if (
          Array.from(
            new Set(valList.map((item) => this._getDartBaseType(item)))
          ).length === 1
        )
          resType = singleType;
        else resType = "num";
      } else resType = this._getDartBaseType(valList[0]);
    }
    // 当为 对象数组 [{a:1,b:2},{a:2,b:4}]
    else if (singleNodeType === "Object")
      resType = Utils._toCamelCase(Utils._toUnderline(this.key), "defalut");
    // 当为 数组数组 [[1,2,3],[4,5,6]]
    // TODO 当 arrayMod 为 true 时支持
    else throw "不支持多维数组";
    return `List<${resType}${hasNull && resType != "null" ? "?" : ""}>`;
  }
}
