import React, { createContext, useContext, useReducer } from 'react';

const MusicContext = createContext();

const initialState = {
  currentWork: null,
  selectedWorks: [],
  playingTrack: null,
  catalogFilter: {
    type: 'all',
    status: 'all',
    search: '',
  },
  royaltyPeriod: {
    startDate: null,
    endDate: null,
  },
  selectedCurrency: 'USD',
  uploadProgress: {},
};

function musicReducer(state, action) {
  switch (action.type) {
    case 'SET_CURRENT_WORK':
      return { ...state, currentWork: action.payload };
    case 'SET_SELECTED_WORKS':
      return { ...state, selectedWorks: action.payload };
    case 'SET_PLAYING_TRACK':
      return { ...state, playingTrack: action.payload };
    case 'UPDATE_CATALOG_FILTER':
      return { 
        ...state, 
        catalogFilter: { ...state.catalogFilter, ...action.payload } 
      };
    case 'SET_ROYALTY_PERIOD':
      return { ...state, royaltyPeriod: action.payload };
    case 'SET_CURRENCY':
      return { ...state, selectedCurrency: action.payload };
    case 'UPDATE_UPLOAD_PROGRESS':
      return {
        ...state,
        uploadProgress: {
          ...state.uploadProgress,
          [action.payload.id]: action.payload.progress,
        },
      };
    default:
      return state;
  }
}

export const MusicProvider = ({ children }) => {
  const [state, dispatch] = useReducer(musicReducer, initialState);

  const value = {
    ...state,
    dispatch,
    // Helper functions
    setCurrentWork: (work) => dispatch({ type: 'SET_CURRENT_WORK', payload: work }),
    setSelectedWorks: (works) => dispatch({ type: 'SET_SELECTED_WORKS', payload: works }),
    setPlayingTrack: (track) => dispatch({ type: 'SET_PLAYING_TRACK', payload: track }),
    updateCatalogFilter: (filter) => dispatch({ type: 'UPDATE_CATALOG_FILTER', payload: filter }),
    setRoyaltyPeriod: (period) => dispatch({ type: 'SET_ROYALTY_PERIOD', payload: period }),
    setCurrency: (currency) => dispatch({ type: 'SET_CURRENCY', payload: currency }),
    updateUploadProgress: (id, progress) => 
      dispatch({ type: 'UPDATE_UPLOAD_PROGRESS', payload: { id, progress } }),
  };

  return (
    <MusicContext.Provider value={value}>
      {children}
    </MusicContext.Provider>
  );
};

export const useMusic = () => {
  const context = useContext(MusicContext);
  if (!context) {
    throw new Error('useMusic must be used within a MusicProvider');
  }
  return context;
};

export default MusicProvider;