local config = {
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 60,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
	-- on_attach = function(bufnr)
	-- 	local function opts(desc)
	-- 		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	-- 	end
	-- 	local ok, api = pcall(require, "nvim-tree.api")
	-- 	assert(ok, "api module is not found")
	-- 	vim.keymap.set("n", "<CR>", api.node.open.tab_drop, opts("Tab drop"))
	-- end,
}
require("nvim-tree").setup(config)
