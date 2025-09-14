local utils = require("utils")

utils.map("n", "<leader>ld", vim.diagnostic.open_float, utils.map_opts)
vim.lsp.enable({ "clangd", "bashls", "jsonls", "lua_ls", "ts_ls", "yamlls" })

local chars = {}
for i = 32, 126 do
  table.insert(chars, string.char(i))
end
local pumMap = function(insertKmap, pumKmap)
  utils.map("i", insertKmap, function()
    if vim.fn.pumvisible() == 0 then
      return insertKmap
    else
      return pumKmap
    end
  end, { expr = true })
end
utils.autocmd("LspAttach", {
  group = utils.augroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/implementation") then
      local bufopts = { noremap = true, silent = true, buffer = args.buf }
      utils.map("n", "gd", vim.lsp.buf.definition, bufopts)
      utils.map("n", "K", vim.lsp.buf.hover, bufopts)
      utils.map("n", "gr", vim.lsp.buf.references, bufopts)
      utils.map("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
      utils.map("n", "gl", vim.diagnostic.setqflist, bufopts)
      utils.map({ "n", "i" }, "<S-Down>", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, bufopts)
      utils.map({ "n", "i" }, "<S-Up>", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, bufopts)
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
