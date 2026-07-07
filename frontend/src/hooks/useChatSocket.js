import { useCallback, useEffect, useRef, useState } from "react";
import { WS_BASE_URL } from "../api/axios.js";

export function useChatSocket(roomId, { onMessage, onTyping, onPresence } = {}) {
  const socketRef = useRef(null);
  const [connected, setConnected] = useState(false);
  const handlersRef = useRef({ onMessage, onTyping, onPresence });
  handlersRef.current = { onMessage, onTyping, onPresence };

  useEffect(() => {
    if (!roomId) return undefined;

    const token = localStorage.getItem("access_token");
    const socket = new WebSocket(`${WS_BASE_URL}/chat/${roomId}/?token=${token}`);
    socketRef.current = socket;

    socket.onopen = () => setConnected(true);
    socket.onclose = () => setConnected(false);
    socket.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.type === "message") {
        handlersRef.current.onMessage?.(data.message);
      } else if (data.type === "typing") {
        handlersRef.current.onTyping?.(data.user, data.is_typing);
      } else if (data.type === "presence") {
        handlersRef.current.onPresence?.(data.user, data.is_online);
      }
    };

    return () => {
      socket.close();
      socketRef.current = null;
    };
  }, [roomId]);

  const sendMessage = useCallback((content) => {
    if (socketRef.current?.readyState === WebSocket.OPEN) {
      socketRef.current.send(JSON.stringify({ type: "message", content }));
    }
  }, []);

  const sendTyping = useCallback((isTyping) => {
    if (socketRef.current?.readyState === WebSocket.OPEN) {
      socketRef.current.send(JSON.stringify({ type: "typing", is_typing: isTyping }));
    }
  }, []);

  return { connected, sendMessage, sendTyping };
}
