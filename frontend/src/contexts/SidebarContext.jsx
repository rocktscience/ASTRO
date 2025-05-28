import React from "react";

import {
  SIDEBAR_POSITION,
  SIDEBAR_BEHAVIOR,
  SIDEBAR_THEME,
} from "../constants";

const initialState = {
  isOpen: true,
  position: SIDEBAR_POSITION.LEFT,
  behavior: SIDEBAR_BEHAVIOR.STICKY,
  theme: SIDEBAR_THEME.DARK,
};

const SidebarContext = React.createContext(initialState);

export default SidebarContext;
