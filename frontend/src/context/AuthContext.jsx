import React, { createContext, useContext, useEffect, useState } from "react";
import api from "../api/axios.js";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem("access_token");
    if (!token) {
      setLoading(false);
      return;
    }
    api
      .get("/auth/me/")
      .then(({ data }) => setUser(data))
      .catch(() => {
        localStorage.clear();
      })
      .finally(() => setLoading(false));
  }, []);

  const login = async (username, password) => {
    const { data } = await api.post("/auth/login/", { username, password });
    localStorage.setItem("access_token", data.access);
    localStorage.setItem("refresh_token", data.refresh);
    setUser(data.user);
    return data.user;
  };

  const register = async (username, email, password) => {
    await api.post("/auth/register/", { username, email, password });
    return login(username, password);
  };

  const logout = () => {
    localStorage.clear();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, setUser, login, register, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
