import React, { useRef, useState } from "react";
import { Send } from "lucide-react";

export default function MessageInput({ onSend, onTyping }) {
  const [value, setValue] = useState("");
  const typingTimeout = useRef(null);

  const handleChange = (e) => {
    setValue(e.target.value);
    onTyping?.(true);
    clearTimeout(typingTimeout.current);
    typingTimeout.current = setTimeout(() => onTyping?.(false), 1200);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const trimmed = value.trim();
    if (!trimmed) return;
    onSend(trimmed);
    setValue("");
    onTyping?.(false);
    clearTimeout(typingTimeout.current);
  };

  return (
    <form onSubmit={handleSubmit} className="flex items-center gap-3 border-t border-slate-200 bg-white p-4">
      <input
        value={value}
        onChange={handleChange}
        placeholder="Type a message..."
        className="flex-1 rounded-full border border-slate-200 bg-slate-50 px-4 py-2.5 text-sm outline-none transition focus:border-brand-500 focus:ring-2 focus:ring-brand-100"
      />
      <button
        type="submit"
        disabled={!value.trim()}
        className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-brand-500 text-white shadow-md shadow-brand-500/30 transition hover:bg-brand-600 disabled:cursor-not-allowed disabled:opacity-40"
      >
        <Send size={18} />
      </button>
    </form>
  );
}
