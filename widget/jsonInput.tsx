/*
 * @Descripttion: json 输入
 * @Author: KuuBee
 * @Date: 2021-06-25 16:52:58
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-07-01 11:51:01
 */

import TextField from "@material-ui/core/TextField";
import { AppLanguage } from "../language";
import { ChangeEvent, FunctionComponent, useState } from "react";
import style from "../styles/widget/jsonInput.module.scss";
import dynamic from "next/dynamic";
import Paper from "@material-ui/core/Paper";
import EditIcon from "@material-ui/icons/Edit";
import IconButton from "@material-ui/core/IconButton";
import Tooltip from "@material-ui/core/Tooltip";
import { withStyles } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/core/styles";
import { VoidCallback } from "../core/utils";
import { useEffect } from "react";
// 动态导入
const ReactJson = dynamic(import("react-json-view"), { ssr: false });

const StyledTextField = withStyles({
  root: {
    "&:hover fieldset": {
      borderColor: "#556cd6"
    },
    "& label": {
      color: "#556cd6"
    },
    "& fieldset": {
      borderColor: "#556cd6"
    }
  }
})(TextField);

type OnChangeCallback = (str: string) => void;

export const JsonInput: FunctionComponent<{
  languageContent: AppLanguage.Key;
  className?: string;
  isShowParse?: boolean;
  onEdit?: VoidCallback;
  onChange?: OnChangeCallback;
}> = ({ languageContent, className, isShowParse, onEdit, onChange }) => {
  const [value, setValue] = useState<string>("");
  const [json, setJson] = useState<any>({});
  const _className = `${className ?? ""} ${style.JsonInput}`;

  useEffect(() => {
    if (isShowParse) {
      try {
        setJson(JSON.parse(value));
      } catch (error) {
        console.log("json 解析失败");
      }
    }
  }, [isShowParse]);

  const _onChange = (
    e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const str = e.target.value;
    setValue(str);
    if (onChange) onChange(str);
  };

  return (
    <div
      style={{
        position: "relative"
      }}
    >
      <ThemeProvider theme={{}}>
        <Paper className={_className}>
          <ReactJson
            style={{ display: isShowParse ? "block" : "none" }}
            enableClipboard={false}
            displayDataTypes={false}
            theme="tomorrow"
            src={json}
          />
          <StyledTextField
            style={{
              display: isShowParse ? "none" : "block"
            }}
            multiline
            fullWidth
            variant="outlined"
            label={languageContent.jsonToBeConverted}
            placeholder={languageContent.enterYourJson}
            onChange={_onChange}
            value={value}
          ></StyledTextField>
          {isShowParse ? (
            <Tooltip title={languageContent.edit}>
              <IconButton
                color="primary"
                className={style.editButton}
                onClick={onEdit}
              >
                <EditIcon></EditIcon>
              </IconButton>
            </Tooltip>
          ) : (
            ""
          )}
        </Paper>
      </ThemeProvider>
    </div>
  );
};
