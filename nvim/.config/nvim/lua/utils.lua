local M = {
  map_opts = { silent = true },
  map = vim.keymap.set,
  augroup = vim.api.nvim_create_augroup("mat.cfg", { clear = true }),
  autocmd = vim.api.nvim_create_autocmd,
  fzf = require("fzf-lua"),
}
return M
