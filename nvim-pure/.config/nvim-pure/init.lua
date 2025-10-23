if vim.fn.has("nvim-0.12") == 0 then
  vim.notify("This configuration requires at least nvim-0.12", vim.log.levels.ERROR)
  return
end

local map_opts = { silent = true }
local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup("mat.cfg", {})

---------------------------------------------------------------------------------
--- Options
---------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Visual settings
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- File handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.local/state/nvim/undodir")
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

-- Behavior settings
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "exclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "UTF-8"

-- Folding settings
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Key mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

---------------------------------------------------------------------------------
--- Plugins
---------------------------------------------------------------------------------

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/numToStr/Navigator.nvim",
  "https://github.com/supermaven-inc/supermaven-nvim",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/zk-org/zk-nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/Wansmer/treesj",
  "https://github.com/kylechui/nvim-surround",
  "https://github.com/folke/flash.nvim",
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/chrisgrieser/nvim-recorder",
  "https://github.com/Robitx/gp.nvim",
})

local setup = function(module, opts)
  require(module).setup(opts or {})
end

setup("kanagawa", { transparent = true, theme = "dragon" })
vim.cmd.colorscheme("kanagawa")

setup("supermaven-nvim", {
  keymaps = { accept_suggestion = "<S-Tab>" },
  color = { suggestion_color = "#005f5f", cterm = 23 },
})

setup("oil", {
  skip_confirm_for_simple_edits = true,
  watch_for_changes = true,
  view_options = { show_hidden = true },
})

setup("gp", {
  providers = {
    anthropic = {
      endpoint = "https://api.anthropic.com/v1/messages",
      secret = os.getenv("ANTHROPIC_API_KEY"),
    },
  },
  agents = {
    {
      provider = "anthropic",
      name = "ChatClaude-4.5-Sonnet",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-sonnet-4-5-20250929" },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
  },
  default_command_agent = "ChatClaude-4.5-Sonnet",
  default_chat_agent = "ChatClaude-4.5-Sonnet",
})

setup("flash", { labels = "neioarst" })
setup("zk", { picker = "fzf_lua" })
setup("render-markdown", { file_types = { "markdown", "codecompanion" } })

setup("Navigator")
setup("mason")
setup("bqf")
setup("treesj")
setup("nvim-surround")
setup("recorder")

local formatters_by_ft = {
  lua = { "stylua" },
  rust = { "rustfmt", lsp_format = "fallback" },
  toml = { "taplo" },
}
for _, ft in ipairs({ "javascript ", "typescript", "typescriptreact", "javascriptreact ", "json", "jsonc ", "yaml ", "html" }) do
  formatters_by_ft[ft] = { "prettier", "eslint_d", stop_after_first = true }
end
setup("conform", {
  format_on_save = function(bufnr)
    local enable_autoformat = not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat
    return enable_autoformat and { timeout_ms = 500, lsp_format = "fallback" } or nil
  end,
  formatters_by_ft = formatters_by_ft,
})
map("n", "<leader>f", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.cmd("redrawstatus")
end, map_opts)
require("fzf-lua").setup({ "max-perf", winopts = { height = 1, width = 1 }, keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } } })

---------------------------------------------------------------------------------
--- Commands
---------------------------------------------------------------------------------

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Grep
if vim.fn.executable("rg") == 1 then
  function _G.RgFindFiles(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = "v:lua.RgFindFiles"
end

local function is_cmdline_type_find()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]

  return cmdline_cmd == "find" or cmdline_cmd == "fin"
end

vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
  pattern = { "*" },
  group = augroup,
  callback = function(ev)
    local function should_enable_autocomplete()
      local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]

      return is_cmdline_type_find() or cmdline_cmd == "help" or cmdline_cmd == "h"
    end

    if ev.event == "CmdlineChanged" and should_enable_autocomplete() then
      vim.opt.wildmode = "noselect:lastused,full"
      vim.fn.wildtrigger()
    end

    if ev.event == "CmdlineLeave" then
      vim.opt.wildmode = "full"
    end
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Cd the directory of the current file
vim.api.nvim_create_user_command("Cdc", function()
  vim.cmd("cd %:p:h")
end, {})
-- Edit the neovim config
vim.api.nvim_create_user_command("Config", function()
  vim.cmd("e $MYVIMRC")
end, {})

---------------------------------------------------------------------------------
--- LSP and completion
---------------------------------------------------------------------------------
map("n", "<leader>ld", vim.diagnostic.open_float, map_opts)
vim.lsp.enable({ "clangd", "bashls", "jsonls", "lua_ls", "ts_ls", "yamlls" })

local chars = {}
for i = 32, 126 do
  table.insert(chars, string.char(i))
end
local pumMap = function(insertKmap, pumKmap)
  map("i", insertKmap, function()
    if vim.fn.pumvisible() == 0 then
      return insertKmap
    else
      return pumKmap
    end
  end, { expr = true })
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/implementation") then
      pumMap("<Down>", "<C-n>")
      pumMap("<Up>", "<C-p>")
      pumMap("<CR>", "<C-y>")
    end
    if client:supports_method("textDocument/completion") then
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

---------------------------------------------------------------------------------
--- Statusbar
---------------------------------------------------------------------------------
local branch = "?git"
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  pattern = "*",
  callback = function()
    branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    if branch ~= "" and branch ~= nil then
      local git_status = vim.fn.system("git status --porcelain 2>/dev/null"):gsub("\n", "")
      local branch_color = git_status == "" and "%#StatusLineGitClean#" or "%#StatusLineGitDirty#"
      branch = " on  " .. branch_color .. branch .. "%#StatusLine#"
    end
  end,
})

vim.api.nvim_set_hl(0, "StatusLineGitClean", { fg = "#81b29a", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineGitDirty", { fg = "#c94f6d", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFileChanged", { fg = "#f4a261", bg = "NONE", bold = true })
function RENDER_STATUSBAR()
  local autoformat = (vim.g.disable_autoformat == true or vim.b.disable_autoformat) and "-" or "F"
  local supermaven = pcall(require, "supermaven-nvim.api") and require("supermaven-nvim.api").is_running() and "SMV" or "-"
  local cwd = vim.fn.getcwd() or ""
  local cwd_with_tilde = vim.fn.fnamemodify(cwd, ":~")
  local filename = vim.fn.expand("%:p")
  if filename ~= "" and filename ~= nil then
    local filename_color = vim.bo.modified and "%#StatusLineFileChanged#" or "%#StatusLine#"
    filename = " " .. filename_color .. (filename):sub(#cwd + 1) .. "%#StatusLine#"
  end
  return string.format("%s%s%s%%=%s | %s  [%s] %d,%d", cwd_with_tilde, branch, filename, autoformat, supermaven, vim.bo.filetype, vim.fn.line("."), vim.fn.col("."))
end

vim.o.statusline = "%{%v:lua.RENDER_STATUSBAR()%}"

---------------------------------------------------------------------------------
--- Keymap
---------------------------------------------------------------------------------
map("v", "<", "<gv", map_opts)
map("v", ">", ">gv", map_opts)
map({ "n", "v" }, "c", '"_c', map_opts)
map({ "n", "v" }, "C", '"_C', map_opts)
map("v", "p", "P", map_opts)
map({ "n", "v", "i" }, "<c-down>", ":NavigatorDown<CR>", map_opts)
map({ "n", "v", "i" }, "<c-up>", ":NavigatorUp<CR>", map_opts)
map({ "n", "v", "i" }, "<c-right>", ":NavigatorRight<CR>", map_opts)
map({ "n", "v", "i" }, "<c-left>", ":NavigatorLeft<CR>", map_opts)
map("n", "<leader>bo", ":%bd|e#|bd#<CR>", map_opts) -- close all buffers but the current one
map({ "n", "v", "i" }, "<C-x>", ":bd<CR>", map_opts)
map("n", "<leader>by", ":let @+ = expand('%:p')", map_opts)
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "<Down>", "gj", map_opts)
map("n", "<Up>", "gk", map_opts)
map("n", "<Esc>", ":noh<CR>", map_opts)
map("t", "<Esc>", "<C-\\><C-n>", map_opts)
map("n", "<Tab>", ":b#<CR>", map_opts)
map("n", "<leader>e", ":Oil<CR>", map_opts)
map("n", "<leader>s", ":SupermavenToggle<CR>:redrawstatus<CR>", map_opts)
map("n", "<leader>c", function()
  if vim.bo.buftype == "quickfix" then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, map_opts)
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

map("n", "<leader>sf", require("fzf-lua").files, map_opts)
map("n", "<leader>sw", require("fzf-lua").grep_cword, map_opts)
map("n", "<leader>sr", require("fzf-lua").oldfiles, map_opts)
map("n", "<leader>st", require("fzf-lua").live_grep, map_opts)
map("n", "<leader>sh", require("fzf-lua").helptags, map_opts)
map("n", "<leader>sd", require("fzf-lua").lsp_document_diagnostics, map_opts)
map("n", "<leader><leader>", require("fzf-lua").buffers, map_opts)

map("n", "gd", vim.lsp.buf.definition, map_opts)
map("n", "K", vim.lsp.buf.hover, map_opts)
map("n", "gr", vim.lsp.buf.references, map_opts)
map("n", "<leader>lr", vim.lsp.buf.rename, map_opts)
map("n", "gl", vim.diagnostic.setqflist, map_opts)
map({ "n", "i" }, "<S-Down>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, map_opts)
map({ "n", "i" }, "<S-Up>", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, map_opts)

map({ "n", "v" }, "<leader>aa", ":GpRewrite<CR>", map_opts)
map({ "n", "v" }, "<leader>ac", ":GpChatToggle<CR>", map_opts)
map({ "n", "v" }, "<leader>an", ":GpChatNew<CR>", map_opts)
map({ "n", "v" }, "<leader>ad", ":GpChatDelete<CR>", map_opts)
map({ "n", "v" }, "<leader>af", ":GpChatFinder<CR>", map_opts)
