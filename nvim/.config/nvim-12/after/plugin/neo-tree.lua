require("neo-tree").setup({
	sources = { "filesystem", "buffers", "git_status", "document_symbols" },
	filesystem = { filtered_items = { hide_dotfiles = false } },
	window = { position = "float" },
})
