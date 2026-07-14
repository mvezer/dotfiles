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
	zk_api.list(nil, { select = { "absPath", "title" }, tags = { "quick-note" } }, function(err, notes)
		if err ~= nil or notes == nil or #notes == 0 then
			zk.new({ title = "Quick note" })
		else
			vim.cmd("e " .. notes[1].absPath)
		end
	end)
end, {})

vim.api.nvim_create_user_command("AddNoteFromSelection", function(opts)
	local content
	if opts.range > 0 then
		local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
		content = table.concat(lines, "\n")
	end
	if content == nil or #content == 0 then
		return
	end
	local title = get_note_title()
	if title == nil then
		return
	end

	zk.new({ title = title, content = content })
end, { range = true })
