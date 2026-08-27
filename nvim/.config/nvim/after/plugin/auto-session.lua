vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup({
	allowed_dirs = { "~/workspace", "~/.dotfiles", "~/workshop" },
	session_lens = {
		picker = "fzf",
	},
})
