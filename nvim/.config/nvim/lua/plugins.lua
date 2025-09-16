vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/chentoast/marks.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/numToStr/Navigator.nvim",
  "https://github.com/supermaven-inc/supermaven-nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/zk-org/zk-nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/gpanders/vim-oldfiles",
  "https://github.com/folke/flash.nvim",
  "https://github.com/ibhagwan/fzf-lua",
})

require("supermaven-nvim").setup({
  keymaps = { accept_suggestion = "<S-Tab>" },
  color = { suggestion_color = "#005f5f", cterm = 23 },
})
require("oil").setup({
  skip_confirm_for_simple_edits = true,
  watch_for_changes = true,
  view_options = { show_hidden = true },
})
require("flash").setup({ labels = "neioarst" })
require("Navigator").setup({})
require("zk").setup({ picker = "fzf_lua" })
require("marks").setup({ mappings = { delete_line = "M" } })
require("render-markdown").setup({ file_types = { "markdown", "codecompanion" } })
require("mason").setup({})
require("bqf").setup({})
require("conform_setup")()
require("fzf-lua").setup({ "max-perf", winopts = { height = 1, width = 1 }, keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } } })
