import React from "react";
import { Outlet } from "react-router-dom";

import Settings from "../components/Settings";

const Auth = ({ children }) => (
  <React.Fragment>
    <div className="auth-full-page d-flex">
      <div className="auth-form p-3">
        {children}
        <Outlet />
      </div>
    </div>
    <Settings />
  </React.Fragment>
);

export default Auth;
