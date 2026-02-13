/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/assets/tailwind/**/*.css",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {}
  },
  plugins: []
};
