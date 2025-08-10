return function()
  vim.api.nvim_set_hl(0, "StatusLineGitClean", { fg = "#81b29a", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineGitDirty", { fg = "#c94f6d", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineFileChanged", { fg = "#f4a261", bg = "NONE", bold = true })
  function RENDER_STATUSBAR()
    local autoformat = (vim.g.disable_autoformat == true or vim.b.disable_autoformat) and "-" or "F"
    local supermaven = pcall(require, "supermaven-nvim.api") and require("supermaven-nvim.api").is_running() and "SMV" or "-"
    local cwd = vim.fn.getcwd() or ""
    local cwd_with_tilde = vim.fn.fnamemodify(cwd, ":~")
    local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    if branch ~= "" and branch ~= nil then
      local git_status = vim.fn.system("git status --porcelain 2>/dev/null"):gsub("\n", "")
      local branch_color = git_status == "" and "%#StatusLineGitClean#" or "%#StatusLineGitDirty#"
      branch = " on  " .. branch_color .. branch .. "%#StatusLine#"
    end
    local filename = vim.fn.expand("%:p")
    if filename ~= "" and filename ~= nil then
      local filename_color = vim.bo.modified and "%#StatusLineFileChanged#" or "%#StatusLine#"
      filename = " " .. filename_color .. (filename):sub(#cwd + 1) .. "%#StatusLine#"
    end
    return string.format("%s%s%s%%=%s | %s | %s | %d,%d", cwd_with_tilde, branch, filename, autoformat, supermaven, vim.bo.filetype, vim.fn.line("."), vim.fn.col("."))
  end

  vim.o.statusline = "%{%v:lua.RENDER_STATUSBAR()%}"
end
