require("obsidian").setup({
	picker = {
		name = "fzf-lua",
	},
	legacy_commands = false,
	workspaces = {
		{
			name = "private",
			path = "~/Obsidian/private",
		},
	},
})
