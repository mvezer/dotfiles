local default_map_opts = { silent = true }
local map_key = function(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, opts or default_map_opts)
end

local augroup = vim.api.nvim_create_augroup("mat.cfg", {})

local plugins = {}

---------------------------------------------------------------------------------
--- Plugin management functions and commands
---------------------------------------------------------------------------------
---
---Gets all the names of the installed plugins
---@return string[] Plugin names
plugins.get_all = function()
	local plugin_info = vim.pack.get()
	local plugin_names = {}
	for _, plugin in ipairs(plugin_info) do
		table.insert(plugin_names, plugin.spec.name)
	end
	return plugin_names
end

local function is_quickfix_open()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "quickfix" then
			return true
		end
	end
	return false
end

local function open_url(url)
	if vim.fn.has("mac") == 1 then
		vim.fn.system({ "open", url })
	elseif vim.fn.has("unix") == 1 then
		vim.fn.system({ "xdg-open", url })
	else
		vim.notify("Unsupported operating system", vim.log.levels.ERROR)
		return
	end
end

return {
	is_quickfix_open = is_quickfix_open,
	plugins = plugins,
	map_key = map_key,
	augroup = augroup,
	open_url = open_url,
}
