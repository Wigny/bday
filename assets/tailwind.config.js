// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

import plugin from "tailwindcss/plugin";
import { fontFamily } from "tailwindcss/defaultTheme";

/** @type {import('tailwindcss').Config} */
const config = {
  content: [
    "./js/**/*.js",
    "../lib/bday_web.ex",
    "../lib/bday_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        "ivory": "#FFFAF0",
        "blossom": "#DE6693",
        "mauve": "#693045",
        "blush": "#F8DCDD",
      }
    },
    fontFamily: {
      sans: ['"Aristelle Sans"', ...fontFamily.sans]
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => {
      addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"]);
      addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"]);
      addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"]);
    }),


  ]
};

export default config;
