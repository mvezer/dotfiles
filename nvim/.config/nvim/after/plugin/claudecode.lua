local core = require("core")

if core.is_home() then
	return
end

require("claudecode").setup({
	terminal_cmd = "/opt/homebrew/bin/claude",
})
