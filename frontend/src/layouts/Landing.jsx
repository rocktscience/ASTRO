import React from 'react';
import { Outlet } from 'react-router-dom';

import Main from '../components/Main';

const Landing = ({ children }) => (
  <div>
    <div className='container text-center py-3'>
      <h2>My ASTRO Dashboard</h2>
    </div>
    <Main>
      {children}
      <Outlet />
    </Main>
  </div>
);

export default Landing;
