local core = require("core")

core.map_key("n", "<leader>ld", vim.diagnostic.open_float)
vim.lsp.enable({ "clangd", "bashls", "jsonls", "lua_ls", "ts_ls", "yamlls", "rust_analyzer", "pyright", "gopls" })

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
