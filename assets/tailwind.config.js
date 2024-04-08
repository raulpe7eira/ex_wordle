// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/ex_wordle_web.ex",
    "../lib/ex_wordle_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
      },
      keyframes: {
        pop: {
          '0%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.1)' },
          '75%': { transform: 'scale(0.9)' },
          '100%': { transform: 'scale(1)' },
        },
        rotate: {
          '0%': { transform: 'rotateX(0deg)' },
          '50%': { transform: 'rotateX(90deg)' },
          '100%': { transform: 'rotateX(0deg)' },
        },
        unpop: {
          '0%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.1)' },
          '75%': { transform: 'scale(0.9)' },
          '100%': { transform: 'scale(1)' },
        },
        wiggle: {
          '0%': { transform: 'translateX(0px)' },
          '25%': { transform: 'translateX(-5px)' },
          '50%': { transform: 'translateX(0px)' },
          '75%': { transform: 'translateX(5px)' },
          '100%': { transform: 'translateX(0px)' },
        },
      },
      animation: {
        pop: 'pop 0.2s ease-out',
        rotate: 'rotate 0.6s ease-out forwards',
        unpop: 'unpop 0.2s ease-out',
        wiggle: 'wiggle 0.2s linear 5',
      },
      transitionDelay: {
        '0': '0ms',
        '150': '300ms',
        '300': '600ms',
        '450': '900ms',
        '600': '1200ms',
        '750': '1500ms',
        '900': '1800ms',
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents({
        "hero": ({ name, fullPath }) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, { values })
    }),

    // Register new dynamic animate-delay styles into app.css
    plugin(({ matchUtilities, theme }) => {
      matchUtilities(
        { "animate-delay": (value) => { return { "animation-delay": value } } },
        { values: theme("transitionDelay") }
      )
    }),
  ],
  safelist: [
    "animate-delay-0",
    "animate-delay-150",
    "animate-delay-300",
    "animate-delay-450",
    "animate-delay-600",
    "animate-delay-750",
    "animate-delay-900",
  ],
}
