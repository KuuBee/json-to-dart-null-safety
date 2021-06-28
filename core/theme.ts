import { createMuiTheme } from "@material-ui/core/styles";
import { red } from "@material-ui/core/colors";
import { PaletteOptions } from "@material-ui/core/styles/createPalette";

export const palette: PaletteOptions = {
  primary: {
    main: "#556cd6"
  },
  secondary: {
    main: "#19857b"
  },
  error: {
    main: red.A400
  },
  background: {
    default: "#fff"
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
