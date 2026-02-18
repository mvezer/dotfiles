require("dired").setup({
	path_separator = "/", -- Use '/' as the path separator
	show_hidden = true, -- Show hidden files
	show_icons = false, -- Show icons (patched font required)
	show_banner = true, -- Do not show the banner
	hide_details = false, -- Show file details by default
	sort_order = "name", -- Sort files by name by default
	override_cwd = true, -- Override cwd by default

	-- Define keybindings for various 'dired' actions
	keybinds = {
		dired_enter = "<CR>",
		dired_back = "-",
		dired_up = "<Backspace>",
		dired_rename = "r",
		dired_delete = "d",
		dired_delete_range = "d",
		dired_create = "a",
		dired_copy = "y",
		dired_copy_range = "y",
		dired_paste = "p",
		dired_move = "m",
		dired_move_range = "m",
		dired_quit = "<Esc>",
	},

	-- Define colors for different file types and attributes
	-- colors = {
	-- 	DiredDimText = { link = {}, bg = "NONE", fg = "505050", gui = "NONE" },
	-- 	DiredDirectoryName = { link = {}, bg = "NONE", fg = "9370DB", gui = "NONE" },
	-- 	-- ... (define more colors as needed)
	-- 	DiredMoveFile = { link = {}, bg = "NONE", fg = "ff3399", gui = "bold" },
	-- },
})
