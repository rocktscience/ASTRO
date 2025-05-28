import { useEffect } from "react";
import useLocalStorage from "./useLocalStorage";

function useSettingsState(key, initialValue) {
  const [value, setValue] = useLocalStorage(key, initialValue);

  useEffect(() => {
    // Set data attribute on html element
    document.documentElement.dataset[key] = value;
  }, [value, key]);

  return [value, setValue];
}

export default useSettingsState;
