import React from "react";

export default function TypingIndicator({ username }) {
  if (!username) return null;
  return (
    <div className="flex items-center gap-2 px-4 py-1 text-xs text-slate-400">
      <span>{username} is typing</span>
      <span className="flex gap-1">
        <span className="h-1.5 w-1.5 animate-pulseDot rounded-full bg-slate-400 [animation-delay:-0.32s]" />
        <span className="h-1.5 w-1.5 animate-pulseDot rounded-full bg-slate-400 [animation-delay:-0.16s]" />
        <span className="h-1.5 w-1.5 animate-pulseDot rounded-full bg-slate-400" />
      </span>
    </div>
  );
}
