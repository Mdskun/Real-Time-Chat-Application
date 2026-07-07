import React from "react";

const COLORS = [
  "bg-rose-400",
  "bg-amber-400",
  "bg-emerald-400",
  "bg-sky-400",
  "bg-violet-400",
  "bg-pink-400",
  "bg-teal-400",
];

function colorFor(name = "") {
  const idx = name.split("").reduce((acc, c) => acc + c.charCodeAt(0), 0) % COLORS.length;
  return COLORS[idx];
}

export default function UserAvatar({ name, size = 10, online }) {
  const initials = (name || "?").slice(0, 2).toUpperCase();
  return (
    <div className="relative shrink-0" style={{ width: `${size * 0.25}rem`, height: `${size * 0.25}rem` }}>
      <div
        className={`flex h-full w-full items-center justify-center rounded-full ${colorFor(
          name
        )} text-sm font-semibold text-white`}
      >
        {initials}
      </div>
      {online !== undefined && (
        <span
          className={`absolute bottom-0 right-0 h-2.5 w-2.5 rounded-full border-2 border-white ${
            online ? "bg-emerald-500" : "bg-slate-300"
          }`}
        />
      )}
    </div>
  );
}
