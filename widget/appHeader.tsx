/*
 * @Descripttion: appbar
 * @Author: KuuBee
 * @Date: 2021-06-28 16:51:05
 * @LastEditors: KuuBee
 * @LastEditTime: 2021-07-15 10:30:47
 */
import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import Button from "@material-ui/core/Button";
import Menu from "@material-ui/core/Menu";
import IconButton from "@material-ui/core/IconButton";
import GitHubIcon from "@material-ui/icons/GitHub";
import TranslateIcon from "@material-ui/icons/Translate";
import ExpandMoreIcon from "@material-ui/icons/ExpandMore";
import MenuItem from "@material-ui/core/MenuItem";
import { ThemeProvider } from "@material-ui/core/styles";
import { createMuiTheme } from "@material-ui/core/styles";
import { FunctionComponent, useState } from "react";
import styles from "../styles/widget/appHeader.module.scss";
import { AppLanguage, languageSource } from "../language";
import { palette } from "../core/theme";

type onCloseCallback = (select?: AppLanguage.Type) => void;

export const AppHeader: FunctionComponent<{
  language: AppLanguage.Type;
  onClose: onCloseCallback;
}> = ({ onClose, language }) => {
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const toGithub = () => {
    window.open("https://github.com/KuuBee/json-to-dart-null-safety");
  };
  const handleMenuClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget);
  };
  const _onClose: onCloseCallback = (select) => {
    onClose(select);
    setAnchorEl(null);
  };
  const TranslationMenuItem = languageSource.map((item) => (
    <MenuItem key={item.name} onClick={() => _onClose(item)}>
      {item.name}
    </MenuItem>
  ));
  // 避免 paper 样式的影响
  const theme = createMuiTheme({
    palette
  });
  return (
    <ThemeProvider theme={theme}>
      <AppBar position="static">
        <h1 className={styles.seo}>JSON to Dart null safety</h1>
        <Toolbar>
          <Typography
            style={{ marginRight: "10px", userSelect: "none" }}
            variant="h4"
          >
            JSON to Dart{" "}
          </Typography>
          <Typography
            style={{ color: "#FF946A", fontWeight: "bold", userSelect: "none" }}
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
            onClose={() => _onClose()}
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
    </ThemeProvider>
  );
};
