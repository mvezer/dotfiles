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
	zk_api.list(nil, { tags = { "quick-note" }, select = { "absPath" } }, function(error, node_list)
		if error ~= nil or node_list == nil or node_list[1]["absPath"] == nil then
			return
		end
		local quick_node_path = node_list[1]["absPath"]
		if quick_node_path ~= nil then
			vim.cmd("e " .. quick_node_path)
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
