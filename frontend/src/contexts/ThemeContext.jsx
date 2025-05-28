import React from "react";

import { BS_THEME } from "../constants";

const initialState = {
  bsTheme: BS_THEME.LIGHT,
};

const ThemeContext = React.createContext(initialState);

export default ThemeContext;
