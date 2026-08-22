local laravel = require("laravel")
laravel.setup({
	features = { pickers = {
		provider = "fzf-lua",
	} },
})
vim.g.Laravel = laravel
