import React, { Suspense } from "react";
import { useRoutes } from "react-router-dom";
import { Provider } from "react-redux";
import { HelmetProvider, Helmet } from "react-helmet-async";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

import "./i18n";
import routes from "./routes";
import { store } from "./redux/store";

import Loader from "./components/Loader";

import ThemeProvider from "./contexts/ThemeProvider";
import SidebarProvider from "./contexts/SidebarProvider";
import LayoutProvider from "./contexts/LayoutProvider";
import MusicProvider from "./contexts/MusicProvider";
import Web3Provider from "./contexts/Web3Provider";
import ChartJsDefaults from "./utils/ChartJsDefaults";

import AuthProvider from "./contexts/JWTProvider";
// import AuthProvider from "./contexts/FirebaseAuthProvider";
// import AuthProvider from "./contexts/Auth0Provider";
// import AuthProvider from "./contexts/CognitoProvider";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
    },
  },
});

const App = () => {
  const content = useRoutes(routes);

  return (
    <HelmetProvider>
      <Helmet
        titleTemplate="%s | ASTRO - Music Rights Administration Platform"
        defaultTitle="ASTRO - Empowering Music Rights Worldwide"
      />
      <Suspense fallback={<Loader />}>
        <QueryClientProvider client={queryClient}>
          <Provider store={store}>
            <ThemeProvider>
              <SidebarProvider>
                <LayoutProvider>
                  <Web3Provider>
                    <MusicProvider>
                      <ChartJsDefaults />
                      <AuthProvider>{content}</AuthProvider>
                    </MusicProvider>
                  </Web3Provider>
                </LayoutProvider>
              </SidebarProvider>
            </ThemeProvider>
          </Provider>
        </QueryClientProvider>
      </Suspense>
    </HelmetProvider>
  );
};

export default App;
