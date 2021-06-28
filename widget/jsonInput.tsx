/*
 * @Descripttion: json 输入
 * @Author: KuuBee
 * @Date: 2021-06-25 16:52:58
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-28 17:22:46
 */

import TextField from "@material-ui/core/TextField";
import { AppLanguage } from "../language";
import { FunctionComponent } from "react";
import { OutlinedInputProps } from "@material-ui/core";
import style from "../styles/widget/jsonInput.module.scss";
import dynamic from "next/dynamic";
import Paper from "@material-ui/core/Paper";
import EditIcon from "@material-ui/icons/Edit";
import IconButton from "@material-ui/core/IconButton";
import Tooltip from "@material-ui/core/Tooltip";
import { withStyles } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/core/styles";
import { VoidCallback } from "../core/utils";
// 动态导入
const ReactJson = dynamic(import("react-json-view"), { ssr: false });

export const JsonInput: FunctionComponent<{
  languageContent: AppLanguage.Key;
  value: string;
  className?: string;
  isShowParse?: boolean;
  onEdit?: VoidCallback;
  onChange?: OutlinedInputProps["onChange"];
}> = ({ languageContent, value, className, isShowParse, onChange, onEdit }) => {
  const _className = `${className ?? ""} ${style.JsonInput}`;
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

  const inputElement = isShowParse ? (
    <ReactJson
      enableClipboard={false}
      displayDataTypes={false}
      theme="tomorrow"
      src={JSON.parse(value)}
    />
  ) : (
    <StyledTextField
      multiline
      fullWidth
      variant="outlined"
      label={languageContent.jsonToBeConverted}
      placeholder={languageContent.enterYourJson}
      value={value}
      onChange={onChange}
    ></StyledTextField>
  );

  return (
    <div
      style={{
        position: "relative"
      }}
    >
      <ThemeProvider theme={{}}>
        <Paper className={_className}>
          {inputElement}
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
