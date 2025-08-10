local o = vim.opt
local g = vim.g
g.mapleader = " "
o.clipboard = "unnamed,unnamedplus"
o.cmdheight = 1
o.number = true
o.signcolumn = "auto:4"
o.mouse = "a"
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.hlsearch = true
o.smartcase = true
o.updatetime = 250
o.timeoutlen = 400
o.completeopt = "menu,noinsert,popup,fuzzy"
o.termguicolors = true
o.hidden = true
o.shiftwidth = 2
o.tabstop = 2
o.expandtab = true
o.softtabstop = 2
o.list = true
o.listchars = { tab = "→ ", space = "·" }
o.cursorline = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]]) -- disable new line auto comment <3
vim.cmd([[autocmd TermOpen * startinsert]])

-- Plugins
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/navarasu/onedark.nvim",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/chentoast/marks.nvim",
  "https://github.com/numToStr/Navigator.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/supermaven-inc/supermaven-nvim",
  "https://github.com/folke/flash.nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/zk-org/zk-nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/toppair/peek.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/toppair/peek.nvim"
  -- after installing peek.nvim
  -- cd /home/mat/.local/share/nvim/site/pack/core/opt/peek.nvim
  -- deno task --quiet build:fast
})

-- Utils
local utils = require("utils")

-- Mappings
utils.map("v", "<", "<gv", utils.map_opts)
utils.map("v", ">", ">gv", utils.map_opts)
utils.map({ "n", "v" }, "c", '"_c', utils.map_opts)
utils.map({ "n", "v" }, "C", '"_C', utils.map_opts)
utils.map("v", "p", "P", utils.map_opts)
utils.map({ "n", "v", "i" }, "<c-v>", ":vsplit<CR>", utils.map_opts)
utils.map({ "n", "v", "i" }, "<c-down>", ":bnext<CR>", utils.map_opts)
utils.map({ "n", "v", "i" }, "<c-up>", ":bprevious<CR>", utils.map_opts)
utils.map({ "n", "v", "i" }, "<c-right>", ":NavigatorRight<CR>", utils.map_opts)
utils.map({ "n", "v", "i" }, "<c-left>", ":NavigatorLeft<CR>", utils.map_opts)
utils.map("n", "<leader>bo", ":%bd|e#|bd#<CR>", utils.map_opts) -- close all buffers but the current one
utils.map({ "n", "v", "i" }, "<C-x>", ":bd<CR>", utils.map_opts)
utils.map("n", "<leader>by", ":%y<CR>", utils.map_opts)
utils.map("n", "<leader>bY", ":let @+ = expand('%:p')", utils.map_opts)
utils.map("n", "<C-u>", "<C-u>zz")
utils.map("n", "<C-d>", "<C-d>zz")
utils.map("n", "<Down>", "gj", utils.map_opts)
utils.map("n", "<Up>", "gk", utils.map_opts)
utils.map("n", "<Esc>", ":noh<CR>", utils.map_opts)
utils.map("t", "<Esc>", "<C-\\><C-n>", utils.map_opts)
utils.map("n", "<Tab>", ":b#<CR>", utils.map_opts)

-- Highlight on yank
utils.autocmd("TextYankPost", {
  group = utils.augroup,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- utils.fzf.lua
local function setup_fzf()
  utils.map("n", "<leader>sf", utils.fzf.files, utils.map_opts)
  utils.map("n", "<leader>sr", utils.fzf.oldfiles, utils.map_opts)
  utils.map("n", "<leader>st", utils.fzf.live_grep, utils.map_opts)
  utils.map("n", "<leader>sh", utils.fzf.helptags, utils.map_opts)
  utils.map("n", "<leader>sd", utils.fzf.lsp_document_diagnostics, utils.map_opts)
  utils.map("n", "<leader><leader>", utils.fzf.buffers, utils.map_opts)
  utils.fzf.setup({ "max-perf", winopts = { height = 1, width = 1 } })
end

-- Oil
local function setup_oil()
  require("oil").setup({
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    view_options = { show_hidden = true },
  })
  utils.map("n", "<leader>e", ":Oil<cr>")
end

-- Supermaven
local function setup_supermaven()
  require("supermaven-nvim").setup({
    keymaps = { accept_suggestion = "<S-Tab>" },
    color = { suggestion_color = "#005f5f", cterm = 23 },
  })
  utils.map("n", "<leader>s", ":SupermavenToggle<CR>:redrawstatus<CR>", utils.map_opts)
end

-- Flash
local function setup_flash()
  require("flash").setup({ labels = "neioarst" })
  utils.map({ "n", "x", "o" }, "s", function()
    require("flash").jump()
    vim.api.nvim_feedkeys("zz", "n", false)
  end, { desc = "Flash" })
end

-- Peek (markdown preview)
local function setup_peek()
  require("peek").setup({
    app = { "vivaldi", "--new-window" },
  })
  utils.map("n", "<leader>m", require("peek").open, utils.map_opts)
end

-- Setup colorscheme
local function setup_colorscheme()
  local onedark = require("onedark")
  onedark.setup({ style = "deep", transparent = true })
  onedark.load()
end

require("Navigator").setup({})
require("zk").setup({})
require("marks").setup({ mappings = { delete_line = "M" } })
require("render-markdown").setup({ file_types = { "markdown", "codecompanion" } })
require("mason").setup({})
require("fidget").setup({})
-- vim.cmd([[colorscheme onedark]])

setup_colorscheme()
setup_fzf()
setup_oil()
setup_supermaven()
setup_flash()
setup_peek()
require("setup_conform")()
require("setup_codecompanion")()
require("setup_dap")()
require("setup_lsp")()
require("setup_statusbar")()
