import { NextPage, NextPageContext } from "next";
import Head from "next/head";
import { ChangeEvent, useState } from "react";
import styles from "../styles/home.module.scss";
import { GenerateDart } from "../core/generateDart";
import { AppLanguage, languageSource } from "../language";
import parse, { ObjectNode } from "json-to-ast";
import Button from "@material-ui/core/Button";
import TextField from "@material-ui/core/TextField";
import Snackbar from "@material-ui/core/Snackbar";
import MuiAlert from "@material-ui/lab/Alert";
import { enUs } from "../language/en-us";
import { AppFAB } from "../widget/appFAB";
import { JsonInput } from "../widget/jsonInput";
import Grid from "@material-ui/core/Grid";
import { DartOutput } from "../widget/dartOutput";
import { AppHeader } from "../widget/appHeader";
import { useMemo } from "react";
import { Utils } from "../core/utils";

interface InitProp {
  lang?: string;
}

const Home: NextPage<InitProp> = ({ lang }) => {
  const [className, setCalssName] = useState<string>("AutoGenerate");
  const [inputValue, setinputValue] = useState<string>("");
  const [outputVal, setOututVal] = useState<string>("");
  const [success, setSuccess] = useState<boolean>(false);
  const [error, setError] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  // 默认语言
  const defaultLanguage = languageSource.filter((item) => item.enName === lang);
  const [language, setLanguage] = useState<AppLanguage.Type>(
    // 如果默认没有就选用 en-us
    defaultLanguage?.[0] ?? enUs
  );
  const languageContent = language.content;
  const [errorMsg, setErrorMsg] = useState(languageContent.errorMsg);
  const [isShowParse, setShowParse] = useState(false);

  const handleMenuClose = (select?: AppLanguage.Type) => {
    if (select) {
      setLanguage(select);
      history.pushState(
        null,
        "json to dart null safety",
        `?lang=${select.enName}`
      );
    }
  };

  const inputChange = async (val: ChangeEvent<HTMLTextAreaElement>) => {
    setinputValue(val.target.value);
  };
  // 转换Ast
  const toAst = (val: string): parse.ValueNode => {
    const res = JSON.stringify(JSON.parse(val), null, 4);
    return parse(res, {
      loc: false
    });
  };
  // 转换
  const convert = () => {
    try {
      setLoading(true);
      format();

      if (inputValue.match(/^\[/)) {
        setErrorMsg(languageContent.errorStructureMsg);
        setError(true);
        setLoading(false);
        return;
      }
      const res = toAst(inputValue);
      if (res.type !== "Object") throw "error type!";

      const resCode = new GenerateDart({
        type: "Object",
        children: [
          {
            key: {
              type: "Identifier",
              value: Utils._toCamelCase(className, "defalut"),
              raw: className
            },
            type: "Property",
            value: res as ObjectNode
          }
        ]
      }).getRes();
      setOututVal(resCode);
      setLoading(false);
      setSuccess(true);
      setShowParse(true);
    } catch (e) {
      setErrorMsg(languageContent.convertError);
      setError(true);
      setLoading(false);
    }
  };
  // 格式化
  const format = () => {
    try {
      // 校验是否为合法json
      JSON.parse(inputValue);
      setShowParse(true);
    } catch (error) {
      setErrorMsg(languageContent.wrongJsonFormat);
      setError(true);
      setLoading(false);
    }
  };
  const rootClassNameChange = (e: ChangeEvent<HTMLTextAreaElement>) => {
    setCalssName(e.target.value);
  };
  // 复制
  const copy = async () => {
    try {
      await navigator.clipboard.writeText(outputVal);
      setSuccess(true);
    } catch (error) {
      setErrorMsg(languageContent.copyFailed);
      setError(true);
    }
  };
  // 关闭 snackbar
  const handleClose = () => {
    setSuccess(false);
    setError(false);
  };
  return (
    <div>
      <AppHeader language={language} onClose={handleMenuClose}></AppHeader>
      <main className={styles.container}>
        <h2 className={styles.title}>
          <Button
            variant="contained"
            color="primary"
            style={{ marginRight: "10px" }}
            onClick={format}
          >
            {languageContent.formatJson}
          </Button>
          <Button
            variant="contained"
            color="secondary"
            style={{ marginRight: "10px" }}
            onClick={convert}
          >
            {languageContent.convertToDart}
          </Button>
          <TextField
            style={{
              width: "200px"
            }}
            label={languageContent.setRootClassName}
            defaultValue="AutoGenerate"
            onChange={rootClassNameChange}
          />
          <div style={{ flex: 1 }}></div>
          <Button variant="contained" color="secondary" onClick={copy}>
            {languageContent.copy}
          </Button>
        </h2>
        <Grid className={styles.content} container spacing={2}>
          <Grid item xl={6} lg={6} xs={12}>
            {useMemo(() => {
              return (
                <JsonInput
                  languageContent={languageContent}
                  isShowParse={isShowParse}
                  onEdit={() => setShowParse(false)}
                  onChange={(str) => setinputValue(str)}
                ></JsonInput>
              );
            }, [isShowParse, languageContent])}
          </Grid>
          <Grid item xl={6} lg={6} xs={12}>
            <DartOutput
              languageContent={languageContent}
              value={outputVal}
              loading={loading}
            ></DartOutput>
          </Grid>
        </Grid>
      </main>
      <Snackbar
        anchorOrigin={{ vertical: "top", horizontal: "right" }}
        open={success}
        autoHideDuration={3000}
        onClose={handleClose}
      >
        <MuiAlert severity="success" elevation={6} variant="filled">
          {languageContent.success}
        </MuiAlert>
      </Snackbar>
      <Snackbar
        anchorOrigin={{ vertical: "top", horizontal: "right" }}
        open={error}
        autoHideDuration={3000}
        onClose={handleClose}
      >
        <MuiAlert severity="error" elevation={6} variant="filled">
          {errorMsg}
        </MuiAlert>
      </Snackbar>
      <AppFAB></AppFAB>
    </div>
  );
};
Home.getInitialProps = async (ctx: NextPageContext) => {
  return ctx.query;
};
export default Home;
