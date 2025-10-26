require("core").plugins.add("https://github.com/ibhagwan/fzf-lua", "fzf-lua", {
  "max-perf",
  winopts = { height = 1, width = 1 },
  keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
})
