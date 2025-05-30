import React from "react";
import { lazy } from "@loadable/component";

// Layouts
import AuthLayout from "./layouts/Auth";
import DashboardLayout from "./layouts/Dashboard";
import LandingLayout from "./layouts/Landing";

// Guards
import AuthGuard from "./components/guards/AuthGuard";
import SubscriptionGuard from "./components/guards/SubscriptionGuard"; // NEW: Subscription guard

// ASTRO Landing & Marketing
const AstroLanding = lazy(() => import("./pages/landing/AstroLanding"));
const Pricing = lazy(() => import("./pages/landing/Pricing"));
const Features = lazy(() => import("./pages/landing/Features"));

// ASTRO Main Dashboard
const MusicDashboard = lazy(() => import("./pages/dashboard/MusicDashboard"));

// Music Catalog Management
const Works = lazy(() => import("./pages/catalog/Works"));
const WorkDetails = lazy(() => import("./pages/catalog/WorkDetails"));
const Recordings = lazy(() => import("./pages/catalog/Recordings"));
const RecordingDetails = lazy(() => import("./pages/catalog/RecordingDetails"));
const Releases = lazy(() => import("./pages/catalog/Releases"));
const ReleaseDetails = lazy(() => import("./pages/catalog/ReleaseDetails"));
const Artists = lazy(() => import("./pages/catalog/Artists"));
const Publishers = lazy(() => import("./pages/catalog/Publishers"));

// Rights & Royalties
const Royalties = lazy(() => import("./pages/royalties/Royalties"));
const RoyaltyStatements = lazy(() => import("./pages/royalties/RoyaltyStatements"));
const RoyaltyDistribution = lazy(() => import("./pages/royalties/RoyaltyDistribution"));
const Agreements = lazy(() => import("./pages/agreements/Agreements"));
const AgreementDetails = lazy(() => import("./pages/agreements/AgreementDetails"));
const Copyrights = lazy(() => import("./pages/copyrights/Copyrights"));

// Industry Registrations
const CWRSubmissions = lazy(() => import("./pages/registrations/CWRSubmissions"));
const DDEXDeliveries = lazy(() => import("./pages/registrations/DDEXDeliveries"));
const PRORegistrations = lazy(() => import("./pages/registrations/PRORegistrations"));

// Analytics & Reports
const Analytics = lazy(() => import("./pages/analytics/Analytics"));
const StreamingAnalytics = lazy(() => import("./pages/analytics/StreamingAnalytics"));
const RoyaltyAnalytics = lazy(() => import("./pages/analytics/RoyaltyAnalytics"));
const Reports = lazy(() => import("./pages/reports/Reports"));

// NFT & Blockchain
const NFTDashboard = lazy(() => import("./pages/nft/NFTDashboard"));
const NFTMinting = lazy(() => import("./pages/nft/NFTMinting"));
const SmartContracts = lazy(() => import("./pages/nft/SmartContracts"));

// Sync Licensing
const SyncOpportunities = lazy(() => import("./pages/sync/SyncOpportunities"));
const SyncLicenses = lazy(() => import("./pages/sync/SyncLicenses"));

// Settings & Profile
const Profile = lazy(() => import("./pages/profile/Profile"));
const Settings = lazy(() => import("./pages/settings/Settings"));
const Subscription = lazy(() => import("./pages/settings/Subscription"));

// Auth Pages
const SignIn = lazy(() => import("./pages/auth/SignIn"));
const SignUp = lazy(() => import("./pages/auth/SignUp"));
const ResetPassword = lazy(() => import("./pages/auth/ResetPassword"));
const TwoFactor = lazy(() => import("./pages/auth/TwoFactor"));

// Error Pages
const Page404 = lazy(() => import("./pages/auth/Page404"));
const Page500 = lazy(() => import("./pages/auth/Page500"));

const routes = [
  // Public Landing Pages
  {
    path: "/",
    element: <LandingLayout />,
    children: [
      {
        path: "",
        element: <AstroLanding />,
      },
      {
        path: "pricing",
        element: <Pricing />,
      },
      {
        path: "features",
        element: <Features />,
      },
    ],
  },

  // Authentication Routes
  {
    path: "auth",
    element: <AuthLayout />,
    children: [
      {
        path: "sign-in",
        element: <SignIn />,
      },
      {
        path: "sign-up",
        element: <SignUp />,
      },
      {
        path: "reset-password",
        element: <ResetPassword />,
      },
      {
        path: "2fa",
        element: <TwoFactor />,
      },
      {
        path: "404",
        element: <Page404 />,
      },
      {
        path: "500",
        element: <Page500 />,
      },
    ],
  },

  // Protected Dashboard Routes
  {
    path: "dashboard",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <MusicDashboard />,
      },
    ],
  },

  // Music Catalog Routes
  {
    path: "catalog",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        path: "works",
        element: <Works />,
      },
      {
        path: "works/:id",
        element: <WorkDetails />,
      },
      {
        path: "recordings",
        element: <Recordings />,
      },
      {
        path: "recordings/:id",
        element: <RecordingDetails />,
      },
      {
        path: "releases",
        element: <Releases />,
      },
      {
        path: "releases/:id",
        element: <ReleaseDetails />,
      },
      {
        path: "artists",
        element: <Artists />,
      },
      {
        path: "publishers",
        element: <Publishers />,
      },
    ],
  },

  // Rights & Royalties Routes
  {
    path: "royalties",
    element: (
      <AuthGuard>
        <SubscriptionGuard requiredTier="ascend">
          <DashboardLayout />
        </SubscriptionGuard>
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Royalties />,
      },
      {
        path: "statements",
        element: <RoyaltyStatements />,
      },
      {
        path: "distribution",
        element: <RoyaltyDistribution />,
      },
    ],
  },

  // Agreements Routes
  {
    path: "agreements",
    element: (
      <AuthGuard>
        <SubscriptionGuard requiredTier="pro">
          <DashboardLayout />
        </SubscriptionGuard>
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Agreements />,
      },
      {
        path: ":id",
        element: <AgreementDetails />,
      },
    ],
  },

  // Copyright Routes
  {
    path: "copyrights",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Copyrights />,
      },
    ],
  },

  // Registration Routes
  {
    path: "registrations",
    element: (
      <AuthGuard>
        <SubscriptionGuard requiredTier="ascend">
          <DashboardLayout />
        </SubscriptionGuard>
      </AuthGuard>
    ),
    children: [
      {
        path: "cwr",
        element: <CWRSubmissions />,
      },
      {
        path: "ddex",
        element: <DDEXDeliveries />,
      },
      {
        path: "pro",
        element: <PRORegistrations />,
      },
    ],
  },

  // Analytics Routes
  {
    path: "analytics",
    element: (
      <AuthGuard>
        <SubscriptionGuard requiredTier="pro">
          <DashboardLayout />
        </SubscriptionGuard>
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Analytics />,
      },
      {
        path: "streaming",
        element: <StreamingAnalytics />,
      },
      {
        path: "royalties",
        element: <RoyaltyAnalytics />,
      },
    ],
  },

  // NFT Routes
  {
    path: "nft",
    element: (
      <AuthGuard>
        <SubscriptionGuard requiredTier="enterprise">
          <DashboardLayout />
        </SubscriptionGuard>
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <NFTDashboard />,
      },
      {
        path: "minting",
        element: <NFTMinting />,
      },
      {
        path: "contracts",
        element: <SmartContracts />,
      },
    ],
  },

  // Sync Licensing Routes
  {
    path: "sync",
    element: (
      <AuthGuard>
        <SubscriptionGuard requiredTier="pro">
          <DashboardLayout />
        </SubscriptionGuard>
      </AuthGuard>
    ),
    children: [
      {
        path: "opportunities",
        element: <SyncOpportunities />,
      },
      {
        path: "licenses",
        element: <SyncLicenses />,
      },
    ],
  },

  // Reports Routes
  {
    path: "reports",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Reports />,
      },
    ],
  },

  // Profile & Settings Routes
  {
    path: "profile",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Profile />,
      },
    ],
  },
  {
    path: "settings",
    element: (
      <AuthGuard>
        <DashboardLayout />
      </AuthGuard>
    ),
    children: [
      {
        path: "",
        element: <Settings />,
      },
      {
        path: "subscription",
        element: <Subscription />,
      },
    ],
  },

  // Catch-all 404
  {
    path: "*",
    element: <AuthLayout />,
    children: [
      {
        path: "*",
        element: <Page404 />,
      },
    ],
  },
];

export default routes;