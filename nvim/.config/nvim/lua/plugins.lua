local core = require("core")

-- basic dependencies
core.plugins.add("https://github.com/nvim-treesitter/nvim-treesitter")
core.plugins.add("https://github.com/nvim-lua/plenary.nvim")
core.plugins.add("https://github.com/MunifTanjim/nui.nvim")
core.plugins.add("https://github.com/nvim-tree/nvim-web-devicons")

-- kanagawa color scheme
-- core.plugins.add("https://github.com/rebelot/kanagawa.nvim", "kanagawa", { transparent = true, theme = "dragon" })
-- vim.cmd.colorscheme("kanagawa")

-- onedark color scheme
core.plugins.add("https://github.com/navarasu/onedark.nvim", "onedark", { transparent = true, style = "darker" })
vim.cmd.colorscheme("onedark")

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
core.plugins.add("https://github.com/zk-org/zk-nvim", "zk", {
  picker = "fzf_lua",
  lsp = {
    config = {
      name = "zk",
      cmd = { "zk", "lsp" },
      filetypes = { "markdown" },
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
    },
  },
})

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

core.plugins.add("https://github.com/lewis6991/gitsigns.nvim", "gitsigns")

-- Fancy bufferline
core.plugins.add("https://github.com/akinsho/bufferline.nvim", "bufferline", {
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

-- Marks helper
core.plugins.add("https://github.com/chentoast/marks.nvim", "marks")

-- lualine
local function filename_plus_project()
  local dir = vim.fn.getcwd() or ""
  local buffer_dir = vim.fn.expand("%")
  local project = "[" .. string.match(dir, ".+/(.+)$") .. "]"
  local relative_path = buffer_dir:gsub(dir, "")
  local modified_suffix = ""
  if vim.bo.modified then
    modified_suffix = "[+]"
  end
  return project .. " " .. relative_path .. " " .. modified_suffix
end

local function autoformat()
  if vim.g.disable_autoformat == true or vim.b.disable_autoformat == true then
    return "-"
  end

  return "󰦪"
end

local function supermaven()
  if require("supermaven-nvim.api").is_running() then
    return "󰬀"
  else
    return "-"
  end
end
core.plugins.add("https://github.com/nvim-lualine/lualine.nvim", "lualine", {
  options = {
    always_show_tabline = true,
    icons_enabled = true,
    theme = "auto",
    component_separators = "",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { filename_plus_project },
    lualine_x = { autoformat, supermaven },
    lualine_y = { { "filetype", icon_only = true }, { "lsp_status", icon = "󰬓" } },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
