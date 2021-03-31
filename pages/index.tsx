import { NextPage } from "next";
import Head from "next/head";
import { ChangeEvent, useState } from "react";
import styles from "../styles/Home.module.scss";
import { GenerateDart } from "../utils/toDart";
import SyntaxHighlighter from "react-syntax-highlighter";
import { httpClient } from "../config/http";
import parse from "json-to-ast";
import Button from "@material-ui/core/Button";
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import TextField from "@material-ui/core/TextField";
import Typography from "@material-ui/core/Typography";
import Paper from "@material-ui/core/Paper";
import Snackbar from "@material-ui/core/Snackbar";
import MuiAlert from "@material-ui/lab/Alert";
import CircularProgress from "@material-ui/core/CircularProgress";
import IconButton from "@material-ui/core/IconButton";
import GitHubIcon from "@material-ui/icons/GitHub";

const Home: NextPage = () => {
  const [inputVal, setInputVal] = useState("");
  const [outputVal, setOututVal] = useState<string>("");
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState(false);
  const [errorMsg, setErrorMsg] = useState("哦！好像出现了什么问题。");
  const [loading, setLoading] = useState(false);
  const [rootClassName, setRootClassName] = useState("AutoGenerate");

  const inputChange = async (val: ChangeEvent<HTMLTextAreaElement>) => {
    setInputVal(val.target.value);
  };
  // 转换Ast
  const toAst = async (val: string): Promise<parse.ValueNode> => {
    try {
      const res = JSON.stringify(JSON.parse(val), null, 4);
      setInputVal(res);
      const {
        data: { data }
      } = await httpClient.post<{ data: parse.ValueNode }>("json-to-ast", {
        json: res
      });
      return data;
    } catch (error) {
      setErrorMsg("哦！转换失败了，请稍后尝试。");
      setError(true);
      throw error;
    }
  };
  // 转换
  const convert = async () => {
    setLoading(true);
    format();
    const res = await toAst(inputVal);
    const resCode = new GenerateDart({ className: rootClassName }).toDart(res);
    setOututVal(resCode);
    setLoading(false);
    setSuccess(true);
  };
  // 格式化
  const format = () => {
    try {
      setInputVal(JSON.stringify(JSON.parse(inputVal), null, 4));
    } catch (error) {
      setErrorMsg("错误的JSON格式!");
      setError(true);
      throw error;
    }
  };
  const rootClassNameChange = (e: ChangeEvent<HTMLTextAreaElement>) => {
    setRootClassName(e.target.value);
  };
  // 复制
  const copy = async () => {
    try {
      await navigator.clipboard.writeText(outputVal);
      setSuccess(true);
    } catch (error) {
      setErrorMsg("复制失败！");
      setError(true);
    }
  };
  // 关闭 snackbar
  const handleClose = () => {
    setSuccess(false);
    setError(false);
  };
  const toGithub = () => {
    window.open("https://github.com/KuuBee/json-to-dart-null-safety");
  };
  return (
    <div>
      <Head>
        <title>JSON to Dart</title>
        <link rel="icon" href="/favicon.ico" />
        <meta name="description" content="JSON to dart null safety" />
        <meta name="keywords" content="JSON Dart null safety" />
        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap"
        />
        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/icon?family=Material+Icons"
        />
      </Head>
      <AppBar position="static">
        <Toolbar>
          <Typography style={{ marginRight: "10px" }} variant="h4">
            JSON to Dart{" "}
          </Typography>
          <Typography
            style={{ color: "#ff5252", fontWeight: "bold" }}
            variant="h4"
          >
            {/* #ff5252 #90caf9 */}
            null safety
          </Typography>
          <span style={{ flex: 1 }}></span>
          <IconButton
            edge="start"
            color="inherit"
            aria-label="menu"
            onClick={toGithub}
          >
            <GitHubIcon />
          </IconButton>
        </Toolbar>
      </AppBar>
      <main className={styles.container}>
        <h2 className={styles.title}>
          <Button
            variant="contained"
            color="primary"
            style={{ marginRight: "10px" }}
            onClick={format}
          >
            格式化JSON
          </Button>
          <Button
            variant="contained"
            color="secondary"
            style={{ marginRight: "10px" }}
            onClick={convert}
          >
            转换为Dart
          </Button>
          <TextField
            label="设置根类名"
            defaultValue={rootClassName}
            onChange={rootClassNameChange}
          />
          <div style={{ flex: 1 }}></div>
          <Button variant="contained" color="secondary" onClick={copy}>
            复制
          </Button>
        </h2>
        <div className={styles.content}>
          <TextField
            multiline
            fullWidth
            className={styles.input}
            variant="outlined"
            label="待转换的JSON"
            placeholder="输入您的JSON"
            value={inputVal}
            onChange={inputChange}
          ></TextField>
          <Paper className={styles.output} elevation={3}>
            <span
              style={{ display: outputVal || loading ? "none" : "block" }}
              className={styles.placeholder}
            >
              请在左侧输入JSON后点击转换
            </span>
            <span
              style={{ display: loading ? "block" : "none" }}
              className={styles.loading}
            >
              <CircularProgress></CircularProgress>
            </span>
            <SyntaxHighlighter language="dart">{outputVal}</SyntaxHighlighter>
          </Paper>
        </div>
      </main>
      <Snackbar
        anchorOrigin={{ vertical: "top", horizontal: "right" }}
        open={success}
        autoHideDuration={6000}
        onClose={handleClose}
      >
        <MuiAlert severity="success" elevation={6} variant="filled">
          操作成功！
        </MuiAlert>
      </Snackbar>
      <Snackbar
        anchorOrigin={{ vertical: "top", horizontal: "right" }}
        open={error}
        autoHideDuration={6000}
        onClose={handleClose}
      >
        <MuiAlert severity="error" elevation={6} variant="filled">
          {errorMsg}
        </MuiAlert>
      </Snackbar>
    </div>
  );
};
Home.getInitialProps = async () => {
  return { a: 1 };
};
export default Home;
