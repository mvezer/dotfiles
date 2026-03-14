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
	pattern = {
		"lua",
		"typescript",
		"markdown",
		"json",
		"tsx",
		"javascript",
		"yaml",
		"rust",
		"go",
	},
	callback = function()
		vim.treesitter.start()
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.wo[0][0].foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			-- ["@class.outer"] = "<c-v>", -- blockwise
		},
		-- If you set this to `true` (default is `false`) then any textobject is
		-- extended to include preceding or succeeding whitespace. Succeeding
		-- whitespace has priority in order to act similarly to eg the built-in
		-- `ap`.
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * selection_mode: eg 'v'
		-- and should return true of false
		include_surrounding_whitespace = false,
	},
})

-- require("composite-highlighting").setup({
-- 	-- Your configuration here
-- 	languages = {
-- 		{ parser = "gotmpl", extension = "yaml" },
-- 		-- Add other template languages if needed
-- 		-- { parser = "jinja", extension = "jinja2", injection_node = "template_data" },
-- 	},
-- })
