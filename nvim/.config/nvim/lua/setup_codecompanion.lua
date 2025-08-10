local utils = require("utils")

return function()
  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
    },
  })
  utils.map("n", "<leader>a", ":CodeCompanionChat<CR>", utils.map_opts)
end
