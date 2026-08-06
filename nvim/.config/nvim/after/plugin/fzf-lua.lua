require("fzf-lua").setup({
	"max-perf",
	winopts = { height = 1, width = 1 },
	keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
	buffes = {
		ignore_current_buffer = false,
		sort_lastused = false,
	},
})
