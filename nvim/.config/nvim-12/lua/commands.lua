local core = require("core")

-- disable new line auto comment
vim.api.nvim_create_autocmd("FileType", {
	group = core.augroup,
	callback = function()
		vim.cmd("set formatoptions-=ro")
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = core.augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Grep with rg
if vim.fn.executable("rg") == 1 then
	function _G.RgFindFiles(cmdarg, _cmdcomplete)
		local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
		if #cmdarg == 0 then
			return fnames
		else
			return vim.fn.matchfuzzy(fnames, cmdarg)
		end
	end

	vim.o.findfunc = "v:lua.RgFindFiles"
end

-- local function is_cmdline_type_find()
--   local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
--
--   return cmdline_cmd == "find" or cmdline_cmd == "fin"
-- end

-- vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
--   pattern = { "*" },
--   group = core.augroup,
--   callback = function(ev)
--     local function should_enable_autocomplete()
--       local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
--
--       return is_cmdline_type_find() or cmdline_cmd == "help" or cmdline_cmd == "h"
--     end
--
--     if ev.event == "CmdlineChanged" and should_enable_autocomplete() then
--       vim.opt.wildmode = "noselect:lastused,full"
--       vim.fn.wildtrigger()
--     end
--
--     if ev.event == "CmdlineLeave" then
--       vim.opt.wildmode = "full"
--     end
--   end,
-- })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
	group = core.augroup,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
	group = core.augroup,
	callback = function()
		local dir = vim.fn.expand("<afile>:p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Cd the directory of the current file
vim.api.nvim_create_user_command("Cdc", function()
	vim.cmd("cd %:p:h")
end, {})
-- Edit the neovim config
vim.api.nvim_create_user_command("Config", function()
	vim.cmd("e $MYVIMRC")
end, {})

vim.api.nvim_create_user_command("UpdatePlugins", core.plugins.fzf, {})
vim.api.nvim_create_user_command("Plugins", core.plugins.fzf, {})
vim.api.nvim_create_user_command("ListPlugins", function()
	for _, plugin in ipairs(core.plugins.get_all()) do
		print(plugin)
	end
end, {})
vim.api.nvim_create_user_command("UpdateAllPlugins", function()
	vim.pack.update(core.plugins.get_all())
end, {})

vim.api.nvim_create_user_command("NNew", function()
	local title = vim.fn.input("Note title: ")
	if title ~= nil or title ~= "" then
		require("zk").new({ title = title })
	end
end, {})
-- Auto-chaange root dir
local root_names = { ".git", "Makefile", "package.json", "init.lua" }
local root_cache = {}
vim.api.nvim_create_autocmd("BufEnter", {
	group = core.augroup,
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if path == "" then
			return
		end
		path = vim.fs.dirname(path)

		local root = root_cache[path]
		if root == nil then
			local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
			if root_file == nil then
				return
			end
			root = vim.fs.dirname(root_file)
			root_cache[path] = root
		end

		vim.fn.chdir(root)
	end,
})
