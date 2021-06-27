/*
 * @Descripttion: json 输入
 * @Author: KuuBee
 * @Date: 2021-06-25 16:52:58
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-25 17:20:14
 */

import TextField from "@material-ui/core/TextField";
import { AppLanguage } from "../language";
import { FunctionComponent } from "react";
import { OutlinedInputProps } from "@material-ui/core";
import style from '../styles/widget/JsonInput.module.scss'
import dynamic from "next/dynamic";

const ReactJson = dynamic(import('react-json-view'), { ssr: false });

export const JsonInput: FunctionComponent<{
  languageContent: AppLanguage.Key;
  value: string;
  className?: string;
  onChange?: OutlinedInputProps["onChange"];
}> = ({ languageContent, value, className, onChange }) => {
  const _className = `${className ?? ''} ${style.JsonInput}`;
  let jsonObj = {};
  let isParseSuccess = false;

  try {
    jsonObj = JSON.parse(value);
    isParseSuccess = true;
  } catch (error) {
    console.warn(error);
  }

  return (
    <div className={_className}>
      {isParseSuccess
        ? <ReactJson src={jsonObj} />
        : <TextField
          multiline
          fullWidth
          variant="outlined"
          label={languageContent.jsonToBeConverted}
          placeholder={languageContent.enterYourJson}
          value={value}
          onChange={onChange}
        ></TextField>}
    </div>
  );
};