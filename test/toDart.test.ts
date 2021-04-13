/*
 * @Descripttion:
 * @Author: KuuBee
 * @Date: 2021-04-13 10:35:05
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-04-13 14:51:05
 */
import { GenerateBase } from "../utils/toDart";

describe("GenerateBase class test", () => {
  const generateBase = new GenerateBase();
  test("_getDartBaseType function test", () => {
    const _getDartBaseType = (generateBase as any)._getDartBaseType.bind(
      generateBase
    );
    expect(_getDartBaseType("str")).toBe("String");
    expect(_getDartBaseType(0)).toBe("int");
    expect(_getDartBaseType(1)).toBe("int");
    expect(_getDartBaseType(-1)).toBe("int");
    expect(_getDartBaseType(1.1)).toBe("double");
    expect(_getDartBaseType(-1.1)).toBe("double");
    expect(_getDartBaseType(true)).toBe("bool");
    expect(_getDartBaseType(false)).toBe("bool");
    expect(_getDartBaseType(null)).toBe("Null");
    expect(_getDartBaseType(undefined)).toBe("dynamic");
    expect(_getDartBaseType({})).toBe("dynamic");
    expect(_getDartBaseType([])).toBe("dynamic");
  });
  test("_toCamelCase function test", () => {
    const _toCamelCase = (generateBase as any)._toCamelCase;
    expect(_toCamelCase("a_a", "small")).toBe("aA");
    expect(_toCamelCase("_a_a")).toBe("_aA");
    expect(_toCamelCase("_a_a", "defalut")).toBe("_aA");
    expect(_toCamelCase("a_a", "defalut")).toBe("AA");
  });
  test("_toUnderline function test", () => {
    const _toUnderline = (generateBase as any)._toUnderline;
    expect(_toUnderline("AA")).toBe("a_a");
    expect(_toUnderline("A_A")).toBe("a_a");
  });
  test("_isBaseType function test", () => {
    const _isBaseType = (generateBase as any)._isBaseType.bind(generateBase);
    expect(_isBaseType("String")).toBeTruthy();
    expect(_isBaseType("int")).toBeTruthy();
    expect(_isBaseType("double")).toBeTruthy();
    expect(_isBaseType("bool")).toBeTruthy();
    expect(_isBaseType("Null")).toBeTruthy();
    expect(_isBaseType("dynamic")).toBeTruthy();
    expect(_isBaseType("List<int?>?")).toBeFalsy();
    expect(_isBaseType("Map<String,int?>?")).toBeFalsy();
  });
});
export {};
