import React from "react";
import { format } from "date-fns";

export default function MessageBubble({ message, isOwn, showSender }) {
  return (
    <div className={`flex w-full ${isOwn ? "justify-end" : "justify-start"} animate-slideIn`}>
      <div className={`flex max-w-[75%] flex-col gap-1 ${isOwn ? "items-end" : "items-start"}`}>
        {showSender && !isOwn && (
          <span className="px-1 text-xs font-medium text-slate-400">{message.sender.username}</span>
        )}
        <div
          className={`whitespace-pre-wrap break-words rounded-2xl px-4 py-2 text-sm shadow-sm ${
            isOwn
              ? "rounded-br-sm bg-brand-500 text-white"
              : "rounded-bl-sm bg-white text-slate-700"
          }`}
        >
          {message.content}
        </div>
        <span className="px-1 text-[11px] text-slate-400">
          {format(new Date(message.created_at), "HH:mm")}
        </span>
      </div>
    </div>
  );
}
