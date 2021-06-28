/*
 * @Descripttion: 输出结果
 * @Author: KuuBee
 * @Date: 2021-06-28 15:08:39
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-06-28 17:22:05
 */
import Paper from "@material-ui/core/Paper";
import { FunctionComponent } from "react";
import { AppLanguage } from "../language";
import CircularProgress from "@material-ui/core/CircularProgress";
import SyntaxHighlighter from "react-syntax-highlighter";
import style from "react-syntax-highlighter/dist/cjs/styles/hljs/tomorrow-night";
import styles from "../styles/widget/dartOutput.module.scss";

export const DartOutput: FunctionComponent<{
  languageContent: AppLanguage.Key;
  value: string;
  loading: boolean;
}> = ({ languageContent, value, loading }) => {
  return (
    <Paper className={styles.dartOutput} elevation={3}>
      <div
        style={{ display: value || loading ? "none" : "block" }}
        className={styles.placeholder}
      >
        {languageContent.noContentMsg}
      </div>
      <div
        style={{ display: loading ? "block" : "none" }}
        className={styles.loading}
      >
        <CircularProgress></CircularProgress>
      </div>
      <SyntaxHighlighter style={style} language="dart">
        {value}
      </SyntaxHighlighter>
    </Paper>
  );
};
