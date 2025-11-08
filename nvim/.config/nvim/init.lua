-- if vim.fn.has("nvim-0.12") == 0 then
--   vim.notify("This configuration requires at least nvim-0.12", vim.log.levels.ERROR)
--   return
-- end

require("options")
require("plugins")
require("commands")
require("lsp")
require("keymap")
