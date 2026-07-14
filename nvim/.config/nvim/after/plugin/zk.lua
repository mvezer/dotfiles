local zk = require("zk")
local zk_api = require("zk.api")

zk.setup({
	picker = "fzf_lua",
})

local selected_text = function()
	local mode = vim.api.nvim_get_mode().mode
	local opts = {}
	-- \22 is an escaped version of <c-v>
	if mode == "v" or mode == "V" or mode == "\22" then
		opts.type = mode
	end
	return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), opts)
end

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

vim.api.nvim_create_user_command("AddNoteFromSelection", function()
	local content = selected_text()
	if content == nil or selected_text == "" then
		return
	end
	local title = get_note_title()
	if title == nil then
		return
	end

	zk.new({ title = title, content = content })
end, {})
