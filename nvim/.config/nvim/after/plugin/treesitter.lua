local ensure_installed = {
	"lua",
	"typescript",
	"markdown",
	"json",
	"tsx",
	"javascript",
	"yaml",
	"rust",
	"go",
}
local treesitter = require("nvim-treesitter")
treesitter.install(ensure_installed):wait(300000)

vim.api.nvim_create_autocmd("FileType", {
	pattern = ensure_installed,
	callback = function()
		vim.treesitter.start()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
