/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,jsx}"],
  theme: {
    extend: {
      colors: {
        brand: {
          50: "#eef4ff",
          100: "#dbe6fe",
          400: "#6d8cff",
          500: "#4f6bff",
          600: "#3d54e6",
          700: "#3143b8",
        },
      },
      keyframes: {
        pulseDot: {
          "0%, 80%, 100%": { transform: "scale(0.6)", opacity: "0.4" },
          "40%": { transform: "scale(1)", opacity: "1" },
        },
        slideIn: {
          "0%": { transform: "translateY(6px)", opacity: "0" },
          "100%": { transform: "translateY(0)", opacity: "1" },
        },
      },
      animation: {
        pulseDot: "pulseDot 1.4s infinite ease-in-out both",
        slideIn: "slideIn 0.18s ease-out",
      },
    },
  },
  plugins: [],
};
