local core = require("core")

if core.is_home() then
	return
end

require("claudecode").setup({
	terminal_cmd = "/Users/mat/.local/bin/claude",
	terminal = {
		split_width_percentage = 0.5,
	},
})
