/*
 * @Descripttion: toDart
 * @Author: KuuBee
 * @Date: 2021-03-27 14:37:39
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-05-14 15:23:31
 */

import parse, {
  ArrayNode,
  LiteralNode,
  ObjectNode,
  ValueNode
} from "json-to-ast";

// 如果为null就转换为 dynamic
type DartBaseType = "String" | "bool" | "int" | "double" | "dynamic";
// 生成参数时的变量类型
type GenerateVariableType = "base" | "object" | "arrayBase" | "arrayObject";
interface GenerateDartOptions {
  className: string;
}
interface GenerateArrayDartOptions extends GenerateDartOptions {
  val: ObjectNode[];
}
interface IterationValType<T = any> {
  key: string;
  type: "Object" | "Array" | "Literal";
  val: T[];
}

export class GenerateBase {
  constructor(protected opt?: GenerateDartOptions) {}
  // 用于缓存结果
  protected _res: string = "";
  // 一些静态参数
  protected readonly _property = "--property--";
  protected readonly _constructor = "--constructor--";
  protected readonly _fromJson = "--fromJson--";
  protected readonly _toJson = "--toJson--";
  protected readonly _baseRegExp = `\\n\\s*`;
  protected readonly _jsTypeToDartType: {
    [key: string]: "String" | "bool";
  } = {
    string: "String",
    boolean: "bool"
  };
  protected readonly _baseDartType = [
    "String",
    "bool",
    "int",
    "double",
    "Null",
    "dynamic"
  ];

  protected get _propertyRegExp() {
    return new RegExp(`${this._baseRegExp}${this._property}`);
  }
  protected get _constructorRegExp() {
    return new RegExp(`${this._baseRegExp}${this._constructor}`);
  }
  protected get _fromJsonRegExp() {
    return new RegExp(`${this._baseRegExp}${this._fromJson}`);
  }
  protected get _toJsonRegExp() {
    return new RegExp(`${this._baseRegExp}${this._toJson}`);
  }
  protected get _className(): string {
    if (this.opt?.className) {
      const className = this.opt.className;
      return this._toCamelCase(className, "defalut");
    }
    return this.opt?.className ?? "AutoGenerate";
  }

  /**
   * @description: 删除注释，获取最终结果
   */
  getRes() {
    this._res = this._res
      .replace(this._propertyRegExp, "")
      .replace(this._constructorRegExp, "")
      .replace(this._fromJsonRegExp, "")
      .replace(this._toJsonRegExp, "");
    return this._res;
  }

  /**
   * @description: 获取 dart 基础类型
   * @param {string} val
   */
  protected _getDartBaseType(val: string | number | boolean | null) {
    // 默认为 dynamic 类型 兜底
    let type: DartBaseType = "dynamic";
    const _valType = typeof val;
    // 如果有基础类型就直接返回
    if (this._jsTypeToDartType[_valType])
      return this._jsTypeToDartType[_valType];
    // 如果是 number 类型 就行细分
    if (_valType === "number") {
      if (Number.isInteger(val)) return "int";
      return "double";
    }
    // 如果为 null 直接返回
    if (val === null) return "Null";
    return type;
  }
  /**
   * @description: _ 转 驼峰
   * @param key 输入字符
   * @param type defalut大驼峰 small小驼峰
   */
  protected _toCamelCase(
    key: string,
    // 大驼峰/小驼峰
    type: "defalut" | "small" = "small"
  ): string {
    const small = key.replaceAll(/\B_([a-zA-Z])/g, (_match, p1: string) =>
      p1.toLocaleUpperCase()
    );
    if (type === "defalut")
      return small.replace(/(^[a-z])/, (_match, p1: string) =>
        p1.toLocaleUpperCase()
      );
    return small;
  }
  /**
   * @description: 驼峰转下划线
   * @param {string} key
   */
  protected _toUnderline(key: string): string {
    key = key.replace(/^\S/, (match) => {
      return match.toLocaleLowerCase();
    });
    const res = key
      .replaceAll(/_?[A-Z]/g, (match) =>
        match.includes("_")
          ? match.toLocaleLowerCase()
          : `_${match.toLocaleLowerCase()}`
      )
      .replace(/^[a-z]/i, (match) => match.toLocaleLowerCase());
    return res;
  }
  /**
   * @description: 判断当前类型是否为基础类型
   * @param {string} type
   */
  protected _isBaseType(type: string): boolean {
    return this._baseDartType.some((item) => {
      const res = new RegExp(`^${item}`).test(type);
      if (res && item === "List") return type.match(/^List<\S+>\??/);
      return res;
    });
  }
}

export class GenerateDart extends GenerateBase {
  constructor(protected opt?: GenerateDartOptions) {
    super(opt);
  }

  /**
   * @description: js 类型转换为 dart 类型
   * @param val 值
   * @param variableName 参数名称 仅在 valType 的值为 object 时需要填写
   * @param valType 当前值的 ast 类型
   */
  //
  private _getDartType(
    val: string | number | boolean | null | ObjectNode | ArrayNode,
    variableName: string = "",
    valType: GenerateVariableType = "base"
  ): string {
    // 是一个对象
    if (valType === "object") {
      return this._toCamelCase(variableName, "defalut");
    }
    // 是一个基础类型数组
    if (valType === "arrayBase") {
      const list = (val as ArrayNode).children;
      let type = "Null",
        nullFlag = false;
      list.forEach((item) => {
        if (item.type !== "Literal") return; //alert("不支持的类型");
        const _type = this._getDartBaseType(item.value);
        if (_type !== "Null") {
          type = _type;
        }
        if (_type === "Null" && !nullFlag) nullFlag = true;
      });
      return `List<${type}${type !== "Null" && nullFlag ? "?" : ""}>`;
    }
    if (valType === "arrayObject") {
      const list = (val as ArrayNode).children;
      let type = "Null",
        nullFlag = false;
      list.forEach((item) => {
        // 如果 ast 类型不为 Object 则只能为 null
        if (item.type !== "Object") nullFlag = true;
        type = this._toCamelCase(variableName, "defalut");
      });
      return `List<${type}${type !== "Null" && nullFlag ? "?" : ""}>`;
    }
    return this._getDartBaseType(val as any);
  }
  /**
   * @description: 创建一个空的class模板
   * @param {*}
   * @return {*}
   */
  generateClass(
    { isEmpty }: { isEmpty: boolean } = { isEmpty: false }
  ): GenerateDart {
    if (isEmpty)
      this._res = `\n  class ${this._className} {

        ${this._className}();
  
        ${this._className}.fromJson(Map<String, dynamic> json) {
          // Empty Class
        }
        Map<String, dynamic> toJson() =><String, dynamic>{};
      }`;
    else
      this._res = `\n  class ${this._className} {
      ${this._property}

      ${this._className}({
        ${this._constructor}
      });

      ${this._className}.fromJson(Map<String, dynamic> json) {
        ${this._fromJson}
      }
      Map<String, dynamic> toJson() {
        final _data = <String, dynamic>{};
        ${this._toJson}
        return _data;
      }
    }`;
    return this;
  }
  // 创建一个变量
  generateVariable({
    variableName,
    val,
    valType = "base"
  }: {
    variableName: string;
    val: string | number | boolean | null | ObjectNode | ArrayNode;
    valType?: GenerateVariableType;
  }): GenerateDart {
    const camelCaseName = this._toCamelCase(variableName);
    const type = this._getDartType(val, variableName, valType);
    this._insertProperty(type, camelCaseName);
    this._insertConstructorProperty(camelCaseName);
    this._insertFromJsonProperty(camelCaseName, variableName, valType, type);
    this._insertToJsonProperty(camelCaseName, type);
    return this;
  }
  // 一键转换
  toDart(data: parse.ValueNode): string {
    if (data.type === "Object") {
      this.generateClass({ isEmpty: !data.children.length });

      data.children.forEach(({ key: { value: key }, value }) => {
        const { type } = value;
        switch (type) {
          case "Literal":
            this.generateVariable({
              variableName: key,
              val: (value as LiteralNode).value
            });
            break;
          case "Object":
            this.generateVariable({
              variableName: key,
              val: value as ObjectNode,
              valType: "object"
            });
            const newClassRes = new GenerateDart({ className: key }).toDart(
              value
            );
            this._res += newClassRes;
            break;
          case "Array":
            // FIXME 这样写不太靠谱 最好还是迭代一下
            // FIXME 空数组异常
            const { type } = (value as ArrayNode).children[0];
            // 基础类型数组
            if (type === "Literal") {
              this.generateVariable({
                variableName: key,
                val: value as ArrayNode,
                valType: "arrayBase"
              });
            }
            // 数组对象
            if (type === "Object") {
              this.generateVariable({
                variableName: key,
                val: value as ArrayNode,
                valType: "arrayObject"
              });
              const res = new GenerateArrayDart({
                className: key,
                val: (value as ArrayNode).children as unknown as ObjectNode[]
              }).toDart();
              this._res += res;
            }
            break;
          default:
            break;
        }
      });
    }
    return this.getRes();
  }

  // 插入属性
  private _insertProperty(type: string, variableName: string): string {
    const baseCode = `late ${type} ${variableName};`;

    this._res = this._res.replace(
      this._propertyRegExp,
      `
      ${baseCode}
      ${this._property}`
    );
    return baseCode;
  }
  // 插入构造函数
  private _insertConstructorProperty(variableName: string) {
    const baseCode = `required this.${variableName},`;
    this._res = this._res.replace(
      this._constructorRegExp,
      `
        ${baseCode}
      ${this._constructor}`
    );
    return baseCode;
  }
  // 插入FromJson函数
  private _insertFromJsonProperty(
    camelCaseName: string,
    variableName: string,
    valType: GenerateVariableType = "base",
    // 如果 valType 为 object｜arrayObject｜arrayBase 则此项必填
    type?: string
  ) {
    let baseCode: string;
    if (valType === "base")
      baseCode = `${camelCaseName} = json['${variableName}'];`;
    else if (valType === "arrayBase")
      baseCode = `${camelCaseName} = ${type}.from(json['${variableName}']);`;
    else if (valType === "arrayObject")
      if (type?.match(/List<.*\?>/)) {
        baseCode = `${camelCaseName} = json['${variableName}'] != null?List<dynamic>.from(json['${variableName}']).map((e)=>${type.match(
          /(?<=List<)[a-zA-Z0-9]*(?=\??>\??)/
        )}.fromJson(e)).toList():null;`;
      } else {
        baseCode = `${camelCaseName} = List<dynamic>.from(json['${variableName}']).map((e)=>${type?.match(
          /(?<=List<)[a-zA-Z0-9]*(?=\??>\??)/
        )}.fromJson(e)).toList();`;
      }
    else
      baseCode = `${camelCaseName} = ${type}.fromJson(json['${variableName}']);`;
    this._res = this._res.replace(
      this._fromJsonRegExp,
      `
        ${baseCode}
      ${this._fromJson}`
    );
    return baseCode;
  }
  private _insertToJsonProperty(key: string, type: string) {
    const jsonKey = this._toUnderline(key);

    let baseCode = `_data['${jsonKey}'] = ${key};`;
    const typeMatch = type.match(/^List<(\S+)>(\??)/);
    if (this._baseDartType.includes(type))
      // 基本类型
      baseCode = `_data['${jsonKey}'] = ${key};`;
    else if (typeMatch) {
      // 数组类型
      if (this._baseDartType.includes(typeMatch[1])) {
        // 基础数组类型
        baseCode = `_data['${jsonKey}'] = ${key};`;
      } else {
        // 对象数组
        if (typeMatch[2]) {
          // 当前列表可能为null 即 List<Obj>?
          baseCode = `if(${key} != null){
            _data['${jsonKey}'] = ${key}.map((e)=>e${
            /\?$/.test(typeMatch[1]) ? "?" : ""
          }.toJson()).toList();
          }else _data['${jsonKey}'] = null;
          `;
        } else {
          //  可以直接迭代
          baseCode = `_data['${jsonKey}'] = ${key}.map((e)=>e${
            /\?$/.test(typeMatch[1]) ? "?" : ""
          }.toJson()).toList();`;
        }
      }
    } else {
      // 对象类型
      baseCode = `_data['${jsonKey}'] = ${key}.toJson();`;
    }
    this._res = this._res.replace(
      this._toJsonRegExp,
      `
        ${baseCode}
    ${this._toJson}`
    );
  }
}

// 用于处理数组对象
export class GenerateArrayDart extends GenerateBase {
  constructor(protected opt: GenerateArrayDartOptions) {
    super(opt);
  }

  private get val(): IterationValType[] {
    const keyArr: parse.PropertyNode[] = [];
    // 获取全部可能存在的key
    this.opt.val?.forEach((item) => {
      item.children?.forEach((subItem) => {
        if (
          // 防止重复添加
          !keyArr.some((someItem) => someItem.key.value === subItem.key.value)
        ) {
          keyArr.push(subItem);
        }
      });
    });
    return keyArr.map((item) => {
      let type: ("Object" | "Array" | "Literal")[] = [];
      const val = this.opt.val.map(({ children }) => {
        // 通过外部key查找内部
        const findOne = children.find(
          (findItem) => findItem.key.value === item.key.value
        );
        // 如果没找到 直接返回null
        if (findOne === null || findOne === undefined) return null;

        // if (!(children?.[index]?.value?.type ?? false)) return null;
        // 如果 type 为 Literal 必须检查 val 是否为 null
        // 如果为 null 则放弃这个 type
        // 但有一种情况就是全部都为 null 直接赋值 Literal
        // 为了避免出现这种情况 [null,[...]]
        if (findOne.value.type === "Literal") {
          if ((findOne.value as LiteralNode).value)
            type.push(findOne.value.type);
        } else type.push(findOne.value.type);
        if (findOne.value.type === "Literal")
          return (findOne.value as LiteralNode).value;
        if (findOne.value.type === "Array")
          return (findOne.value as ArrayNode).children;
        if (findOne.value.type === "Object") return findOne.value as ObjectNode;
      });
      return {
        key: item.key.value,
        // 如果 type 没找到 那就代表值为 null 所以 type 写死为 Literal
        type: type[0] ?? "Literal",
        val: val
      };
    });
  }

  // 创建一个class
  generateClass(
    { isEmpty }: { isEmpty: boolean } = { isEmpty: false }
  ): GenerateArrayDart {
    if (isEmpty)
      this._res = `\n  class ${this._className} {

      ${this._className}();

      ${this._className}.fromJson(Map<String, dynamic> json) {
        // Empty Class
      }

      Map<String, dynamic> toJson() =><String, dynamic>{};
    }`;
    else
      this._res = `\n  class ${this._className} {
      ${this._property}

      ${this._className}({
        ${this._constructor}
      });

      ${this._className}.fromJson(Map<String, dynamic> json) {
        ${this._fromJson}
      }

      Map<String, dynamic> toJson() {
        final _data = <String, dynamic>{};
        ${this._toJson}
        return _data;
      }
    }`;
    return this;
  }
  // 创建一个变量
  generateVariable(
    key: string,
    val: IterationValType,
    valType: GenerateVariableType = "base"
  ): GenerateArrayDart {
    const camelCaseName = this._toCamelCase(key);

    const type = this._getDartType(val, key, valType);

    this._insertProperty(type, camelCaseName);
    this._insertConstructorProperty(camelCaseName);
    this._insertFromJsonProperty(camelCaseName, key, valType, type);
    this._instertToJson(camelCaseName, type);
    return this;
  }

  toDart() {
    this.generateClass({ isEmpty: !this.val.length });
    this.val.forEach((item) => {
      let type: GenerateVariableType;
      // 基础类型
      if (item.type === "Literal") type = "base";
      // 数组
      else if (item.type === "Array") {
        const isObjArr = item.val?.some((subItem: ValueNode[]) => {
          return subItem?.some((lastItem) => lastItem.type === "Object");
        });
        if (isObjArr) {
          type = "arrayObject";
          const val = item.val
            .flat()
            .filter((fliterItem) => fliterItem?.type === "Object");
          const res = new GenerateArrayDart({
            className: this._toCamelCase(item.key, "defalut"),
            val
          }).toDart();
          this._res += res;
        } else type = "arrayBase";
        // 对象
      } else {
        type = "object";
        const val = item.val
          .flat()
          .filter((fliterItem) => fliterItem?.type === "Object");
        const res = new GenerateArrayDart({
          className: this._toCamelCase(item.key, "defalut"),
          val
        }).toDart();
        this._res += res;
      }
      this.generateVariable(item.key, item, type);
    });
    return this.getRes();
  }

  private _getDartType(
    val: IterationValType,
    key: string = "",
    valType: GenerateVariableType = "base"
  ): string {
    // 对象
    if (valType === "object") {
      let type: string = "Null",
        nullFlag: boolean = false;
      nullFlag = val.val.some((item) => {
        return !item;
      });
      type = this._toCamelCase(key, "defalut");
      return `${type}${nullFlag ? "?" : ""}`;
    }
    // 基础类型数组
    if (valType === "arrayBase") {
      const list: LiteralNode[][] = val.val;
      let type: string = "Null",
        ListNullFlag: boolean = false,
        itemNullFlag: boolean = false;
      list.forEach((item) => {
        if (item !== null)
          item.forEach((subItem) => {
            const _type = this._getDartBaseType(subItem.value);
            if (_type !== "Null") {
              type = _type;
            }
            if (_type === "Null" && !itemNullFlag) itemNullFlag = true;
          });
        else ListNullFlag = true;
      });
      return `List<${type}${type !== "Null" && itemNullFlag ? "?" : ""}>${
        ListNullFlag ? "?" : ""
      }`;
    }
    // 数组对象
    if (valType === "arrayObject") {
      const list: ValueNode[][] = val.val;
      let type = "Null",
        listNullFlage = false,
        nullFlag = false;
      list.forEach((item) => {
        if (item)
          item.forEach((subItem) => {
            if (subItem.type === "Object")
              type = this._toCamelCase(key, "defalut");
            if (subItem.type === "Literal") nullFlag = true;
          });
        else listNullFlage = true;
      });
      return `List<${type}${type !== "Null" && nullFlag ? "?" : ""}>${
        listNullFlage ? "?" : ""
      }`;
    }
    // 如果上面都没走 那就是基础类型
    // 基础类型
    let type: string = "Null",
      nullFlag: boolean = false;
    val.val.forEach((item: any) => {
      if (val.type !== "Literal") return;
      const _type = this._getDartBaseType(item);
      if (_type !== "Null") {
        type = _type;
      }
      if (_type === "Null" && !nullFlag) nullFlag = true;
    });
    return `${type}${type !== "Null" && nullFlag ? "?" : ""}`;
  }

  // 插入属性
  private _insertProperty(type: string, variableName: string): string {
    const baseCode = `late ${type} ${variableName};`;

    this._res = this._res.replace(
      this._propertyRegExp,
      `
      ${baseCode}
      ${this._property}`
    );
    return baseCode;
  }
  // 插入构造函数
  private _insertConstructorProperty(variableName: string) {
    const baseCode = `required this.${variableName},`;
    this._res = this._res.replace(
      this._constructorRegExp,
      `
        ${baseCode}
      ${this._constructor}`
    );
    return baseCode;
  }
  // 插入FromJson函数
  private _insertFromJsonProperty(
    camelCaseName: string,
    variableName: string,
    valType: GenerateVariableType = "base",
    // 如果 valType 为 object｜arrayObject｜arrayBase 则此项必填
    type?: string
  ) {
    let baseCode: string;
    // 基础类型
    if (valType === "base")
      baseCode = `${camelCaseName} = json['${variableName}'];`;
    // 基础数组 | 数组对象
    else if (valType === "arrayBase" || valType === "arrayObject") {
      const objFunc = `List<dynamic>.from(json['${variableName}']).map((e){
        ${type?.match(/List<.*\?>\??/) ? "if(e == null)return null;" : ""}
        return ${type?.match(/(?<=List<)[a-zA-Z0-9]*(?=\??>\??)/)}.fromJson(e);
      }).toList()`;
      const baseFunc = `${type?.replace(
        /(^List\<.*>)\?/,
        "$1"
      )}.from(json['${variableName}'])`;
      const fromFunc = valType === "arrayBase" ? baseFunc : objFunc;

      // 判断 List 类型有 ?
      if (!type?.match(/^List<.*>\?$/))
        baseCode = `${camelCaseName} = ${fromFunc};`;
      else
        baseCode = `${camelCaseName} = json['${variableName}'] != null?${fromFunc}:null;`;
    }
    // 对象类型
    else {
      const func = `${type?.match(
        /[a-z0-9]*/i
      )}.fromJson(json['${variableName}'])`;
      if (type?.match(/[a-z0-9]*\?/i))
        baseCode = `${camelCaseName} = json['${variableName}'] != null?${func}:null;`;
      else baseCode = `${camelCaseName} = ${func};`;
    }
    this._res = this._res.replace(
      this._fromJsonRegExp,
      `
        ${baseCode}
      ${this._fromJson}`
    );
    return baseCode;
  }
  private _instertToJson(key: string, type: string) {
    const jsonKey = this._toUnderline(key);
    let baseCode = `_data['${jsonKey}'] = ${key};`;
    const typeMatch = type.match(/^List<(\S+)>(\??)/);
    if (this._baseDartType.includes(type))
      // 基本类型
      baseCode = `_data['${jsonKey}'] = ${key};`;
    else if (typeMatch) {
      // 数组类型
      if (this._baseDartType.includes(typeMatch[1])) {
        // 基础数组类型
        baseCode = `_data['${jsonKey}'] = ${key};`;
      } else {
        // 对象数组
        if (typeMatch[2]) {
          // 当前列表可能为null 即 List<Obj>?
          baseCode = `if(${key} != null){
            _data['${jsonKey}'] = ${key}.map((e)=>e${
            /\?$/.test(typeMatch[1]) ? "?" : ""
          }.toJson()).toList();
          }else _data['${jsonKey}'] = null;
          `;
        } else {
          //  可以直接迭代
          baseCode = `_data['${jsonKey}'] = ${key}.map((e)=>e${
            /\?$/.test(typeMatch[1]) ? "?" : ""
          }.toJson()).toList();`;
        }
      }
    } else {
      // 对象类型
      baseCode = `_data['${jsonKey}'] = ${key}${
        /\?$/.test(type) ? "?" : ""
      }.toJson();`;
    }
    this._res = this._res.replace(
      this._toJsonRegExp,
      `
        ${baseCode}
    ${this._toJson}`
    );
  }
}
