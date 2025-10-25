local core = require("core")

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
