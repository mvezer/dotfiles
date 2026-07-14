local zk = require("zk")
local zk_api = require("zk.api")

zk.setup({
	picker = "fzf_lua",
})

local function get_note_title()
	local title = vim.fn.input("Note title: ")
	if title == "" or title == nil then
		return
	end
	return title
end

vim.api.nvim_create_user_command("AddNote", function()
	local title = get_note_title()
	if title == nil then
		return
	end
	zk.new({ title = title })
end, {})

vim.api.nvim_create_user_command("AddQuickNote", function()
	zk_api.list(nil, { select = { "path", "title" }, tags = { "quick-note" } }, function(err, notes)
		if err ~= nil or notes == nil or #notes == 0 then
			zk.new({ title = "Quick note" })
		else
			vim.cmd("e " .. notes[1].path)
		end
	end)
end, {})
