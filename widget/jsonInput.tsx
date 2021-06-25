/*
 * @Descripttion: json 输入
 * @Author: KuuBee
 * @Date: 2021-06-25 16:52:58
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-25 17:20:14
 */

import { NextComponentType } from "next";
import styles from "../styles/widget/JsonInput.module.scss";
import TextField from "@material-ui/core/TextField";
import { AppLanguage } from "../language";
import { FunctionComponent } from "react";
import { OutlinedInputProps } from "@material-ui/core";

export const JsonInput: FunctionComponent<{
  languageContent: AppLanguage.Key;
  value: string;
  className: string;
  onChange?: OutlinedInputProps["onChange"];
}> = ({ languageContent, value, className, onChange }) => {
  return (
    <TextField
      multiline
      fullWidth
      className={className}
      variant="outlined"
      label={languageContent.jsonToBeConverted}
      placeholder={languageContent.enterYourJson}
      value={value}
      onChange={onChange}
    ></TextField>
  );
};
