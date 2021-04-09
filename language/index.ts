/*
 * @Descripttion: 语言根目录
 * @Author: KuuBee
 * @Date: 2021-04-09 10:42:45
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-04-09 10:42:45
 */
import { enUs } from "./en-us";
import { zhCn } from "./zh-cn";

export namespace AppLanguage {
  export interface Type {
    name: string;
    enName: string;
    content: Key;
  }
  export interface Key {
    formatJson: string;
    convertToDart: string;
    copy: string;
    noContentMsg: string;
    jsonToBeConverted: string;
    enterYourJson: string;
    setRootClassName: string;
    success: string;
    copyFailed: string;
    wrongJsonFormat: string;
    errorStructureMsg: string;
    convertError: string;
    errorMsg: string;
  }
}
export const languageSource: AppLanguage.Type[] = [enUs, zhCn];
