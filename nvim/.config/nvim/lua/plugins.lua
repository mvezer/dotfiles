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
  "https://github.com/matbme/JABS.nvim",
  "https://github.com/gpanders/vim-oldfiles",
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

require("Navigator").setup({})
require("zk").setup({})
require("marks").setup({ mappings = { delete_line = "M" } })
require("render-markdown").setup({ file_types = { "markdown", "codecompanion" } })
require("mason").setup({})
require("bqf").setup({})
require("conform_setup")()
require("jabs").setup({
  use_devicons = false,
  split_filename = true,
  symbols = {
    current = "C",
    split = "S",
    alternate = "A",
    hidden = "H",
    locked = "L",
    ro = "R",
    edited = "E",
    terminal = "T",
    default_file = "D",
    terminal_symbol = ">_",
  },
})
