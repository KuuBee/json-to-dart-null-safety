import { createMuiTheme } from "@material-ui/core/styles";
import { red } from "@material-ui/core/colors";
import { PaletteOptions } from "@material-ui/core/styles/createPalette";

export const palette: PaletteOptions = {
  primary: {
    main: "#3A95DF"
    // #556cd6
  },
  secondary: {
    main: "#FFE9D4"
    // #19857b
  },
  error: {
    main: red.A400
    // red.A400
  },
  background: {
    default: "#FAFAFA"
    // #fff
  }
};
// Create a theme instance.
export const theme = createMuiTheme({
  overrides: {
    MuiPaper: {
      root: {
        backgroundColor: "#1d1f21"
      }
    }
  },
  palette
});
