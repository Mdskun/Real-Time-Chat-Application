import React from "react";
import { formatDistanceToNowStrict } from "date-fns";
import UserAvatar from "./UserAvatar.jsx";

export default function RoomList({ rooms, activeRoomId, onSelect, currentUser }) {
  if (rooms.length === 0) {
    return (
      <div className="flex flex-1 items-center justify-center px-6 text-center text-sm text-slate-400">
        No conversations yet. Start one with the + button above.
      </div>
    );
  }

  return (
    <div className="flex-1 overflow-y-auto">
      {rooms.map((room) => {
        const isActive = room.id === activeRoomId;
        const other = room.participants.find((p) => p.id !== currentUser?.id);
        const unread = room.last_message && !room.last_message.is_read && room.last_message.sender.id !== currentUser?.id;

        return (
          <button
            key={room.id}
            onClick={() => onSelect(room)}
            className={`flex w-full items-center gap-3 border-l-2 px-4 py-3 text-left transition ${
              isActive
                ? "border-brand-500 bg-brand-50"
                : "border-transparent hover:bg-slate-50"
            }`}
          >
            <UserAvatar name={room.display_name} online={other?.is_online} />
            <div className="min-w-0 flex-1">
              <div className="flex items-center justify-between gap-2">
                <span className="truncate text-sm font-medium text-slate-800">
                  {room.display_name}
                </span>
                {room.last_message && (
                  <span className="shrink-0 text-xs text-slate-400">
                    {formatDistanceToNowStrict(new Date(room.last_message.created_at))}
                  </span>
                )}
              </div>
              <div className="flex items-center justify-between gap-2">
                <p className="truncate text-xs text-slate-500">
                  {room.last_message ? room.last_message.content : "Say hello 👋"}
                </p>
                {unread && <span className="h-2 w-2 shrink-0 rounded-full bg-brand-500" />}
              </div>
            </div>
          </button>
        );
      })}
    </div>
  );
}
