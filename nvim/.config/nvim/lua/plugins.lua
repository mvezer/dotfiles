local plugin_spec = {
  { "nvim-treesitter/nvim-treesitter" },
  {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = true
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },
  {
    "supermaven-inc/supermaven-nvim",
    opts = { keymaps = { accept_suggestion = "<S-Tab>" }, color = { suggestion_color = "#005f5f", cterm = 23 } }
  },
  {
    "stevearc/oil.nvim",
    opts = { skip_confirm_for_simple_edits = true, watch_for_changes = true, view_options = { show_hidden = true } }
  },
  { "numToStr/Navigator.nvim",        opts = {} },
  {
    "stevearc/conform.nvim",
    config = require("plugin_setup/conform")
  },
  { "MeanderingProgrammer/render-markdown.nvim", opts = { file_types = { "markdown", "codecompanion" } } },
  { "mason-org/mason.nvim",                      opts = {} },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = { "clangd", "bash-language-server", "json-lsp", "lua-language-server", "eslint-lsp", "eslint_d", "prettier", "prettierd", "typescript-language-server", "yaml-language-server" }
    }
  },
  { "kevinhwang91/nvim-bqf", opts = {} },
  { "zk-org/zk-nvim",        config = function() require("zk").setup({ picker = "fzf_lua" }) end },
  { "folke/flash.nvim",      opts = { labels = "neioarst" } },
  {
    "ibhagwan/fzf-lua",
    opts = { max_perf = true, winopts = { height = 1, width = 1 }, keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } } }
  },
  { "j-hui/fidget.nvim",         opts = { progress = { ignore_done_already = true } } },
  { "Robitx/gp.nvim",            config = require("plugin_setup/gp") },
  { "nvim-lualine/lualine.nvim", config = require("plugin_setup/lualine"),            dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "chentoast/marks.nvim",      opts = { mappings = { delete_line = "M" } } },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  }
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugin_spec)
