import React from 'react';

const Code = ({ children }) => {
  return (
    <pre className='rounded p-3 bg-dark text-white'>
      <code>{children}</code>
    </pre>
  );
};
export default Code;
