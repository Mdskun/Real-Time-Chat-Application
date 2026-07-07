import React, { useEffect, useState } from "react";
import { LogOut, MessageCircle, Plus } from "lucide-react";
import api from "../api/axios.js";
import { useAuth } from "../context/AuthContext.jsx";
import ChatWindow from "../components/ChatWindow.jsx";
import RoomList from "../components/RoomList.jsx";
import NewChatModal from "../components/NewChatModal.jsx";
import UserAvatar from "../components/UserAvatar.jsx";

export default function ChatPage() {
  const { user, logout } = useAuth();
  const [rooms, setRooms] = useState([]);
  const [activeRoom, setActiveRoom] = useState(null);
  const [showModal, setShowModal] = useState(false);

  const loadRooms = () => {
    api.get("/chat/rooms/").then(({ data }) => setRooms(data));
  };

  useEffect(() => {
    loadRooms();
  }, []);

  const handleRoomCreated = (room) => {
    setShowModal(false);
    setRooms((prev) => {
      const exists = prev.find((r) => r.id === room.id);
      return exists ? prev : [room, ...prev];
    });
    setActiveRoom(room);
  };

  return (
    <div className="flex h-screen w-full overflow-hidden bg-white">
      <aside className="flex w-full max-w-xs flex-col border-r border-slate-200 bg-white">
        <div className="flex items-center justify-between px-4 py-4">
          <div className="flex items-center gap-2">
            <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-brand-500 text-white">
              <MessageCircle size={18} />
            </div>
            <span className="text-lg font-semibold text-slate-800">Pulse</span>
          </div>
          <button
            onClick={() => setShowModal(true)}
            className="flex h-9 w-9 items-center justify-center rounded-full bg-brand-50 text-brand-600 transition hover:bg-brand-100"
            title="New conversation"
          >
            <Plus size={18} />
          </button>
        </div>

        <RoomList
          rooms={rooms}
          activeRoomId={activeRoom?.id}
          onSelect={setActiveRoom}
          currentUser={user}
        />

        <div className="flex items-center justify-between border-t border-slate-200 px-4 py-3">
          <div className="flex items-center gap-2">
            <UserAvatar name={user?.username} online />
            <span className="text-sm font-medium text-slate-700">{user?.username}</span>
          </div>
          <button
            onClick={logout}
            title="Log out"
            className="text-slate-400 transition hover:text-red-500"
          >
            <LogOut size={18} />
          </button>
        </div>
      </aside>

      {activeRoom ? (
        <ChatWindow key={activeRoom.id} room={activeRoom} />
      ) : (
        <div className="flex flex-1 flex-col items-center justify-center gap-3 text-slate-300">
          <MessageCircle size={56} />
          <p className="text-sm">Select a conversation or start a new one</p>
        </div>
      )}

      {showModal && (
        <NewChatModal onClose={() => setShowModal(false)} onCreated={handleRoomCreated} />
      )}
    </div>
  );
}
