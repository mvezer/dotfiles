local M = {
  map_opts = { silent = true },
  map = vim.keymap.set,
  augroup = vim.api.nvim_create_augroup("mat.cfg", { clear = true }),
  autocmd = vim.api.nvim_create_autocmd,
  -- fzf = require("fzf-lua"),
  -- is_quickfix_active = function()
  --   return vim.bo.buftype == "quickfix"
  -- end,
}
return M
