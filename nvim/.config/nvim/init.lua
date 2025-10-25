if vim.fn.has("nvim-0.12") == 0 then
  vim.notify("This configuration requires at least nvim-0.12", vim.log.levels.ERROR)
  return
end

local core = require("core")

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

-- Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---------------------------------------------------------------------------------
--- Plugins
---------------------------------------------------------------------------------

-- basic dependencies
core.plugins.add("https://github.com/nvim-treesitter/nvim-treesitter")
core.plugins.add("https://github.com/nvim-lua/plenary.nvim")
core.plugins.add("https://github.com/MunifTanjim/nui.nvim")
core.plugins.add("https://github.com/nvim-tree/nvim-web-devicons")

-- kanagawa color scheme
core.plugins.add("https://github.com/rebelot/kanagawa.nvim", "kanagawa", { transparent = true, theme = "dragon" })
vim.cmd.colorscheme("kanagawa")

-- tmux-neovim interop.
core.plugins.add("https://github.com/numToStr/Navigator.nvim", "Navigator")

-- supermaven - AI code completion (https://supermaven.com)
core.plugins.add("https://github.com/supermaven-inc/supermaven-nvim", "supermaven-nvim", {
  keymaps = { accept_suggestion = "<S-Tab>" },
  color = { suggestion_color = "#005f5f", cterm = 23 },
})

-- GPT prompt
core.plugins.add("https://github.com/Robitx/gp.nvim", "gp", {
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
      model = { model = "claude-sonnet-4-5-20250929" },
      system_prompt = [[
You are a general AI assistant.

The user provided the additional info about how they would like you to respond:

- If you're unsure don't guess and say you don't know instead.
- Ask question if you need clarification to provide better answer.
- Think deeply and carefully from first principles step by step.
- Zoom out first to see the big picture and then zoom in to details.
- Use Socratic method to improve your thinking and coding skills.
- Don't elide any code from your output if the answer requires coding.
- Take a deep breath; You've got this!
]],
    },
  },
  default_command_agent = "ChatClaude-4.5-Sonnet",
  default_chat_agent = "ChatClaude-4.5-Sonnet",
})

-- formatting
local formatters_by_ft = {
  lua = { "stylua" },
  rust = { "rustfmt", lsp_format = "fallback" },
  toml = { "taplo" },
}
for _, ft in ipairs({
  "javascript ",
  "typescript",
  "typescriptreact",
  "javascriptreact ",
  "json",
  "jsonc ",
  "yaml ",
  "html",
}) do
  formatters_by_ft[ft] = { "prettier", "eslint_d", stop_after_first = true }
end
core.plugins.add("https://github.com/stevearc/conform.nvim", "conform", {
  format_on_save = function(bufnr)
    local enable_autoformat = not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat
    return enable_autoformat and { timeout_ms = 500, lsp_format = "fallback" } or nil
  end,
  formatters_by_ft = formatters_by_ft,
})

-- file explorer
core.plugins.add({ {
  src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
  version = vim.version.range("3"),
} }, "neo-tree", {
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  filesystem = { filtered_items = { hide_dotfiles = false } },
  window = { position = "float" },
})

-- Flash navigation
core.plugins.add("https://github.com/folke/flash.nvim", "flash", { labels = "neioarst" })

-- Zettelkasten note taking
core.plugins.add("https://github.com/zk-org/zk-nvim", "zk", { picker = "fzf_lua" })

-- Markdown text renderer
core.plugins.add("https://github.com/MeanderingProgrammer/render-markdown.nvim", "render-markdown", {
  file_types = { "markdown", "codecompanion" },
})

-- LSP installer
core.plugins.add("https://github.com/mason-org/mason.nvim", "mason")

-- Quickfix list enhacements
core.plugins.add("https://github.com/kevinhwang91/nvim-bqf", "bqf")

-- FZF
core.plugins.add("https://github.com/ibhagwan/fzf-lua", "fzf-lua", {
  "max-perf",
  winopts = { height = 1, width = 1 },
  keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
})

-- Smart split/join
core.plugins.add("https://github.com/Wansmer/treesj", "treesj")

-- Neovim surround
core.plugins.add("https://github.com/kylechui/nvim-surround", "nvim-surround")

-- Macro recording helper
core.plugins.add("https://github.com/chrisgrieser/nvim-recorder", "nvim-recorder")

-- Fancy bufferline
core.plugins.add("https://github.com/akinsho/bufferline.nvim", "bufferline")

-- Marks helper
core.plugins.add("https://github.com/chentoast/marks.nvim", "marks")

---------------------------------------------------------------------------------
--- Commands
---------------------------------------------------------------------------------
-- disable new line auto comment
vim.api.nvim_create_autocmd("FileType", {
  group = core.augroup,
  callback = function()
    vim.cmd("set formatoptions-=ro")
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = core.augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Grep with rg
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
  group = core.augroup,
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
  group = core.augroup,
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
  group = core.augroup,
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

vim.api.nvim_create_user_command("UpdatePlugins", core.plugins.fzf, {})
vim.api.nvim_create_user_command("Plugins", core.plugins.fzf, {})
vim.api.nvim_create_user_command("ListPlugins", function()
  for _, plugin in ipairs(core.plugins.get_all()) do
    print(plugin)
  end
end, {})
vim.api.nvim_create_user_command("UpdateAllPlugins", function()
  vim.pack.update(core.plugins.get_all())
end, {})

---------------------------------------------------------------------------------
--- LSP and completion
---------------------------------------------------------------------------------
core.map_key("n", "<leader>ld", vim.diagnostic.open_float)
vim.lsp.enable({ "clangd", "bashls", "jsonls", "lua_ls", "ts_ls", "yamlls" })

local chars = {}
for i = 32, 126 do
  table.insert(chars, string.char(i))
end
local pumMap = function(insertKmap, pumKmap)
  core.map_key("i", insertKmap, function()
    if vim.fn.pumvisible() == 0 then
      return insertKmap
    else
      return pumKmap
    end
  end, { expr = true })
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = core.augroup,
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
--- Statusline
---------------------------------------------------------------------------------
local mode_icons = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK", -- Ctrl-V
  c = "COMMAND",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK", -- Ctrl-S
  R = "REPLACE",
  r = "REPLACE",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local mode_colors = {
  n = "StatusLineModeNormal",
  i = "StatusLineModeInsert",
  v = "StatusLineModeVisual",
  V = "StatusLineModeVisualLine",
  ["\22"] = "StatusLineModeVisualBlock", -- Ctrl-V
  c = "StatusLineModeCommand",
  s = "StatusLineModeSelect",
  S = "StatusLineModeSelectLine",
  ["\19"] = "StatusLineModeSelectBlock", -- Ctrl-S
  R = "StatusLineModeSelectReplace",
  r = "StatusLineModeSelectReplace",
  ["!"] = "StatusLineModeSelectShell",
  t = "StatusLineModeSelectTerminal",
}

local branch = "?git"
vim.api.nvim_create_autocmd("BufEnter", {
  group = core.augroup,
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

local function mode_info()
  local mode = vim.fn.mode()

  local mode_upper = "  " .. mode:upper()
  return { icon = mode_icons[mode] or mode_upper, color = mode_colors[mode] or "StatusLineModeNormal" }
end

vim.api.nvim_set_hl(0, "StatusLineGitClean", { fg = "#81b29a", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineGitDirty", { fg = "#c94f6d", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineFileChanged", { fg = "#f4a261", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeNormal", { fg = "#0d0c0c", bg = "#87a987" })
vim.api.nvim_set_hl(0, "StatusLineModeInsert", { fg = "#c5c9c5", bg = "#c94f6d" })
vim.api.nvim_set_hl(0, "StatusLineModeVisual", { fg = "#0d0c0c", bg = "#e6c384" })
vim.api.nvim_set_hl(0, "StatusLineModeVisualLine", { fg = "#0d0c0c", bg = "#e6c384" })
vim.api.nvim_set_hl(0, "StatusLineModeVisualBlock", { fg = "#0d0c0c", bg = "#e6c384" })
vim.api.nvim_set_hl(0, "StatusLineModeCommand", { fg = "#0d0c0c", bg = "#8ba4b0" })
vim.api.nvim_set_hl(0, "StatusLineModeSelect", { fg = "#c8c093", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineModeSelectLine", { fg = "#c8c093", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineModeSelectBlock", { fg = "#c8c093", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineModeSelectReplace", { fg = "#c8c093", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineModeSelectShell", { fg = "#c8c093", bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLineModeSelectTerminal", { fg = "#c8c093", bg = "NONE" })

function RENDER_STATUSBAR()
  local mode = "%#" .. mode_info().color .. "#" .. "[" .. mode_info().icon .. "]" .. "%#StatusLine#"
  local autoformat = (vim.g.disable_autoformat == true or vim.b.disable_autoformat) and "-" or "F"
  local supermaven = pcall(require, "supermaven-nvim.api") and require("supermaven-nvim.api").is_running() and "SMV" or "-"
  local cwd = vim.fn.getcwd() or ""
  local cwd_with_tilde = vim.fn.fnamemodify(cwd, ":~")
  local filename = vim.fn.expand("%:p")
  if filename ~= "" and filename ~= nil then
    local filename_color = vim.bo.modified and "%#StatusLineFileChanged#" or "%#StatusLine#"
    filename = " " .. filename_color .. (filename):sub(#cwd + 1) .. "%#StatusLine#"
  end
  return string.format("%s %s%s%s%%=%s | %s  [%s] %d,%d", mode, cwd_with_tilde, branch, filename, autoformat, supermaven, vim.bo.filetype, vim.fn.line("."), vim.fn.col("."))
end

vim.o.statusline = "%{%v:lua.RENDER_STATUSBAR()%}"
---------------------------------------------------------------------------------
--- Keymap
---------------------------------------------------------------------------------
core.map_key("v", "<", "<gv")
core.map_key("v", ">", ">gv")
core.map_key({ "n", "v" }, "c", '"_c')
core.map_key({ "n", "v" }, "C", '"_C')
core.map_key("v", "p", "P")
core.map_key({ "n", "v", "i" }, "<c-down>", ":NavigatorDown<CR>")
core.map_key({ "n", "v", "i" }, "<c-up>", ":NavigatorUp<CR>")
core.map_key({ "n", "v", "i" }, "<c-right>", ":NavigatorRight<CR>")
core.map_key({ "n", "v", "i" }, "<c-left>", ":NavigatorLeft<CR>")
core.map_key("n", "<leader>bo", ":%bd|e#|bd#<CR>") -- close all buffers but the current one
core.map_key({ "n", "v", "i" }, "<C-x>", ":bd<CR>")
core.map_key("n", "<leader>by", ":let @+ = expand('%:p')")
core.map_key("n", "Y", "y$", { desc = "Yank to end of line" })
core.map_key("n", "<C-u>", "<C-u>zz")
core.map_key("n", "<C-d>", "<C-d>zz")
core.map_key("n", "<Down>", "gj")
core.map_key("n", "<Up>", "gk")
core.map_key("n", "<Esc>", ":noh<CR>")
core.map_key("t", "<Esc>", "<C-\\><C-n>")
core.map_key("n", "<S-Tab>", ":bprevious<CR>")
core.map_key("n", "<Tab>", ":bnext<CR>")
core.map_key("n", "<leader>e", ":Neotree toggle=true source=filesystem<CR>")
core.map_key("n", "<leader>s", ":SupermavenToggle<CR>:redrawstatus<CR>")
core.map_key("n", "<leader>f", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.cmd("redrawstatus")
end)
core.map_key("n", "<leader>c", function()
  if vim.bo.buftype == "quickfix" then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end)
core.map_key({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

core.map_key("n", "<leader>sf", require("fzf-lua").files)
core.map_key("n", "<leader>sw", require("fzf-lua").grep_cword)
core.map_key("n", "<leader>sr", require("fzf-lua").oldfiles)
core.map_key("n", "<leader>st", require("fzf-lua").live_grep)
core.map_key("n", "<leader>sh", require("fzf-lua").helptags)
core.map_key("n", "<leader>sd", require("fzf-lua").lsp_document_diagnostics)
core.map_key("n", "<leader>sm", require("fzf-lua").marks)
core.map_key("n", "<leader><leader>", require("fzf-lua").buffers)

core.map_key("n", "gd", vim.lsp.buf.definition)
core.map_key("n", "K", vim.lsp.buf.hover)
core.map_key("n", "gr", vim.lsp.buf.references)
core.map_key("n", "<leader>lr", vim.lsp.buf.rename)
core.map_key("n", "<leader>ls", ":Neotree toggle=true source=document_symbols<CR>")
core.map_key("n", "gl", vim.diagnostic.setqflist)
core.map_key({ "n", "i" }, "<S-Down>", function()
  vim.diagnostic.jump({ count = 1, float = true })
end)
core.map_key({ "n", "i" }, "<S-Up>", function()
  vim.diagnostic.jump({ count = -1, float = true })
end)

core.map_key({ "n", "v" }, "<leader>aa", ":GpRewrite<CR>")
core.map_key({ "n", "v" }, "<leader>ac", ":GpChatToggle<CR>")
core.map_key({ "n", "v" }, "<leader>an", ":GpChatNew<CR>")
core.map_key({ "n", "v" }, "<leader>ad", ":GpChatDelete<CR>")
core.map_key({ "n", "v" }, "<leader>af", ":GpChatFinder<CR>")
