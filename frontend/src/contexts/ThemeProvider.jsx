import React from "react";

import { BS_THEME } from "../constants";
import useSettingsState from "../hooks/useSettingsState";

import ThemeContext from "./ThemeContext";

function ThemeProvider({ children }) {
  const [bsTheme, setBsTheme] = useSettingsState("bsTheme", BS_THEME.LIGHT);

  return (
    <ThemeContext.Provider
      value={{
        bsTheme,
        setBsTheme,
      }}
    >
      {children}
    </ThemeContext.Provider>
  );
}

export default ThemeProvider;
