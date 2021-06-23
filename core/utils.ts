/*
 * @Descripttion: 工具人方法
 * @Author: KuuBee
 * @Date: 2021-06-23 15:21:23
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-23 15:21:24
 */
export class Utils {
  /**
   * @description: _ 转 驼峰
   * @param key 输入字符
   * @param type defalut大驼峰 small小驼峰
   */
  static _toCamelCase(
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
  static _toUnderline(key: string): string {
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
}
