require("core").plugins.add({ {
  src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
  version = vim.version.range("3"),
} }, "neo-tree", {
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  filesystem = { filtered_items = { hide_dotfiles = false } },
  window = { position = "float" },
})
