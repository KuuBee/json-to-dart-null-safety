import { NextPage } from "next";
import Head from "next/head";
import { ChangeEvent, useEffect, useState } from "react";
import styles from "../styles/Home.module.scss";
import { GenerateDart } from "../utils/toDart";
import SyntaxHighlighter from "react-syntax-highlighter";
import { AppLanguage, languageSource } from "../language";
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
import Menu from "@material-ui/core/Menu";
import MenuItem from "@material-ui/core/MenuItem";
import TranslateIcon from "@material-ui/icons/Translate";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import { enUs } from "../language/en-us";

const Home: NextPage = () => {
  const [inputVal, setInputVal] = useState("");
  const [outputVal, setOututVal] = useState<string>("");
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState(false);
  const [loading, setLoading] = useState(false);
  const [rootClassName, setRootClassName] = useState("AutoGenerate");
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [language, setLanguage] = useState<AppLanguage.Type>(enUs);
  const languageContent = language.content;
  const [errorMsg, setErrorMsg] = useState(languageContent.errorMsg);

  useEffect(() => {
    const selectLanguaeStr = localStorage.language;
    if (!localStorage.language) {
      // 读取缓存查询是否有历史选中语言
      // 如果没有就读取浏览器语言
      // 和已存在的语言对比 如果找到了 就设置查询值
      // 如果没找到就保持英语
      const res = languageSource.filter(
        (item) => item.enName === navigator.language.toLocaleLowerCase()
      );
      if (res.length) {
        localStorage.language = JSON.stringify(res[0]);
        setLanguage(res[0]);
      }
      return;
    }
    const selectLanguaeObj = JSON.parse(selectLanguaeStr) as AppLanguage.Type;
    if (selectLanguaeObj.name !== language.name) setLanguage(selectLanguaeObj);
  }, [language]);

  const TranslationMenuItem = languageSource.map((item) => (
    <MenuItem key={item.name} onClick={() => handleMenuClose(item)}>
      {item.name}
    </MenuItem>
  ));

  const handleMenuClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = (select?: AppLanguage.Type) => {
    if (select) {
      setLanguage(select);
      localStorage.language = JSON.stringify(select);
    }
    setAnchorEl(null);
  };

  const inputChange = async (val: ChangeEvent<HTMLTextAreaElement>) => {
    setInputVal(val.target.value);
  };
  // 转换Ast
  const toAst = (val: string): parse.ValueNode => {
    try {
      const res = JSON.stringify(JSON.parse(val), null, 4);
      setInputVal(res);
      return parse(res, {
        loc: false
      });
    } catch (error) {
      setErrorMsg(languageContent.convertError);
      setError(true);
      throw error;
    }
  };
  // 转换
  const convert = () => {
    setLoading(true);
    format();
    if (inputVal.match(/^\[/)) {
      setErrorMsg(languageContent.errorStructureMsg);
      setError(true);
      setLoading(false);
      return;
    }
    const res = toAst(inputVal);
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
      setErrorMsg(languageContent.wrongJsonFormat);
      setError(true);
      setLoading(false);
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
      setErrorMsg(languageContent.copyFailed);
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
      </Head>
      <AppBar position="static">
        <h1 className={styles.seo}>JSON to Dart null safety</h1>
        <Toolbar>
          <Typography style={{ marginRight: "10px" }} variant="h4">
            JSON to Dart{" "}
          </Typography>
          <Typography
            style={{ color: "#ff5252", fontWeight: "bold" }}
            variant="h4"
          >
            null safety
          </Typography>
          <span style={{ flex: 1 }}></span>
          <Button
            disableElevation
            variant="contained"
            color="primary"
            startIcon={<TranslateIcon />}
            endIcon={<ExpandMoreIcon />}
            style={{ marginRight: "10px" }}
            onClick={handleMenuClick}
          >
            {language?.name}
          </Button>
          <Menu
            keepMounted
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={() => handleMenuClose()}
          >
            {TranslationMenuItem}
          </Menu>
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
            label={languageContent.setRootClassName}
            defaultValue={rootClassName}
            onChange={rootClassNameChange}
          />
          <div style={{ flex: 1 }}></div>
          <Button variant="contained" color="secondary" onClick={copy}>
            {languageContent.copy}
          </Button>
        </h2>
        <div className={styles.content}>
          <TextField
            multiline
            fullWidth
            className={styles.input}
            variant="outlined"
            label={languageContent.jsonToBeConverted}
            placeholder={languageContent.enterYourJson}
            value={inputVal}
            onChange={inputChange}
          ></TextField>
          <Paper className={styles.output} elevation={3}>
            <span
              style={{ display: outputVal || loading ? "none" : "block" }}
              className={styles.placeholder}
            >
              {languageContent.noContentMsg}
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
          {languageContent.success}
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
export default Home;
