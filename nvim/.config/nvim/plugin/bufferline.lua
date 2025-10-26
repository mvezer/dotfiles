require("core").plugins.add("https://github.com/akinsho/bufferline.nvim", "bufferline", {
  options = {
    style_preset = 4,
    show_buffer_close_icons = false,
    color_icons = false,
    indicator = { style = "underline" },
    pick = {
      alphabet = "neioarstgmluyqwfpbj",
    },
  },
})
