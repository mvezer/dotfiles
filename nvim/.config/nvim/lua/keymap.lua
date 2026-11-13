local core = require("core")

local function send_to_claude(with_lines)
	local ref = "@" .. vim.fn.expand("%:.")
	if with_lines then
		local a, b = vim.fn.line("v"), vim.fn.line(".")
		if a > b then
			a, b = b, a
		end
		ref = ref .. (a == b and ("#L" .. a) or ("#L" .. a .. "-" .. b))
	end
	if vim.env.HERDR_PANE_ID then
		-- first claude agent herdr knows about, preferring this workspace
		local ok, res = pcall(vim.json.decode, vim.fn.system({ "herdr", "agent", "list" }))
		local target
		for _, a in ipairs(ok and res.result and res.result.agents or {}) do
			if a.agent == "claude" and (not target or a.workspace_id == vim.env.HERDR_WORKSPACE_ID) then
				target = a
			end
		end
		if target then
			vim.fn.system({ "herdr", "pane", "send-text", target.pane_id, ref .. " " })
			return
		end
	end
	local panes = vim.fn.systemlist("tmux list-panes -s -F '#{pane_id} #{pane_current_command}'")
	for _, p in ipairs(panes) do
		local id, cmd = p:match("^(%S+) (.+)$")
		-- shortcut: matches the claude binary name; native installs may show a version like "2.1.3"
		if cmd == "claude" or cmd:match("^%d+%.%d+%.%d+$") then
			vim.fn.system({ "tmux", "send-keys", "-t", id, "-l", ref .. " " })
			return
		end
	end
	vim.fn.setreg("+", ref) -- no claude pane found: put it on the clipboard instead
	vim.notify("no claude pane, copied " .. ref)
end

local function smart_dd()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		vim.api.nvim_feedkeys('"_dd', "n", false)
	else
		vim.api.nvim_feedkeys("dd", "n", false)
	end
end

core.map_key("v", "<", "<gv")
core.map_key("v", ">", ">gv")
core.map_key({ "n", "v" }, "c", '"_c')
core.map_key({ "n", "v" }, "C", '"_C')
core.map_key("v", "p", "P")
-- in herdr: move between nvim splits, then hand over to herdr at the edge; otherwise Navigator (tmux)
local function navigate(dir, wincmd, navigator)
	return function()
		if not vim.env.HERDR_PANE_ID then
			return vim.cmd(navigator)
		end
		local win = vim.api.nvim_get_current_win()
		vim.cmd.wincmd(wincmd)
		if win == vim.api.nvim_get_current_win() then
			vim.system({ "herdr", "pane", "focus", "--direction", dir, "--current" })
		end
	end
end
core.map_key({ "n", "i", "t" }, "<c-down>", navigate("down", "j", "NavigatorDown"))
core.map_key({ "n", "i", "t" }, "<c-up>", navigate("up", "k", "NavigatorUp"))
core.map_key({ "n", "i", "t" }, "<c-right>", navigate("right", "l", "NavigatorRight"))
core.map_key({ "n", "i", "t" }, "<c-left>", navigate("left", "h", "NavigatorLeft"))

--- buffer management
-- local buffer_manager = require("buffer_manager.ui")
-- core.map_key("n", "<leader><leader>", buffer_manager.toggle_quick_menu)
core.map_key("n", "<leader><leader>", "<Cmd>FzfLua buffers<CR>")
core.map_key("n", "<leader>bo", ":%bd|e#|bd#<CR>") -- close all buffers but the current one
-- core.map_key("n", "<leader>bs", function()
-- 	buffer_manager.save_menu_to_file(vim.fn.stdpath("data") .. "/buffers")
-- 	vim.notify("saved buffer list")
-- end) -- save buffer list to file
-- core.map_key("n", "<leader>bl", function()
-- 	buffer_manager.load_menu_from_file(vim.fn.stdpath("data") .. "/buffers")
-- 	vim.notify("loaded buffer list")
-- end) -- load buffer list from file
-- core.map_key("n", "<Tab>", buffer_manager.nav_next) -- next buffer
-- core.map_key("n", "<S-Tab>", buffer_manager.nav_prev) -- prev buffer

core.map_key("n", "<Tab>", "<Cmd>bnext<CR>") -- next buffer
core.map_key("n", "<S-Tab>", "<Cmd>bprevious<CR>") -- prev buffer
core.map_key({ "n" }, "<C-x>", ":bd<CR>") --- delete buffer

core.map_key("n", "<leader>by", ":let @+ = expand('%:p')")
core.map_key("n", "Y", "y$", { desc = "Yank to end of line" })
core.map_key("n", "<C-u>", "<C-u>zz")
core.map_key("n", "<C-d>", "<C-d>zz")
core.map_key("n", "<Down>", "gj")
core.map_key("n", "<Up>", "gk")
core.map_key("n", "<Esc>", ":noh<CR>")
core.map_key("t", "<Esc>", "<C-\\><C-n>")
core.map_key("n", "<leader>e", ":Oil<CR>")
core.map_key("n", "<leader>E", function()
	require("nvim-tree.api").tree.toggle({
		path = "<args>",
		find_file = false,
		update_root = false,
		focus = true,
	})
end)
core.map_key("n", "<leader>s", ":SupermavenToggle<CR>:redrawstatus<CR>")
core.map_key("n", "dd", smart_dd)

core.map_key("n", "<leader>f", function()
	vim.b.disable_autoformat = not vim.b.disable_autoformat
	vim.cmd("redrawstatus")
end)
core.map_key("n", "<leader>c", function()
	if core.is_quickfix_open() then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end)
core.map_key("n", "<leader>a", function()
	require("nvim-autopairs").toggle()
end, { desc = "Toggle autopairs" })
core.map_key({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
local fzf = require("fzf-lua")
core.map_key("n", "<leader>sf", fzf.files)
core.map_key("n", "<leader>sw", fzf.grep_cword)
core.map_key("n", "<leader>sr", fzf.oldfiles)
core.map_key("n", "<leader>st", fzf.live_grep)
core.map_key("n", "<leader>sh", fzf.helptags)
core.map_key("n", "<leader>sd", fzf.lsp_document_diagnostics)
core.map_key("n", "<leader>sm", fzf.marks)
core.map_key("n", "<leader>sc", fzf.colorschemes)
core.map_key("n", "<leader>sb", fzf.buffers)
core.map_key("n", "<leader>sn", ":ZkNotes<CR>")

core.map_key("n", "gd", vim.lsp.buf.definition)
core.map_key("n", "K", vim.lsp.buf.hover)
core.map_key("n", "gr", require("fzf-lua").lsp_references)

core.map_key("n", "<leader>lr", vim.lsp.buf.rename)
core.map_key("n", "<leader>ls", ":Neotree toggle=true source=document_symbols<CR>")
core.map_key("n", "<leader>ll", function()
	vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } })
end)
-- kotlin specific lsp stuff
core.map_key("n", "<leader>ld", vim.diagnostic.open_float)
core.map_key("n", "<leader>gl", ":Gitsigns setqflist<CR>")
core.map_key("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")
core.map_key("n", "<leader>gb", ":BlameToggle<CR>")
core.map_key("n", "<leader>gs", ":FzfLua git_status<CR>")
core.map_key("n", "<leader>gh", ":FzfLua git_hunks<CR>")
core.map_key({ "n", "i" }, "<S-Down>", ":cn<CR>")
core.map_key({ "n", "i" }, "<S-Up>", ":cp<CR>")

core.map_key("n", "<leader>m", ":TSJToggle<CR>")
core.map_key("n", "<leader>M", ":MarkdownPreview<CR>")

-- Autosession
core.map_key("n", "<leader>S", ":AutoSession save<CR>")

-- debug stuff
core.map_key("n", "<leader>db", ":DapToggleBreakpoint<CR>")
core.map_key("n", "<leader>dd", ":DapViewToggle<CR>")
core.map_key("n", "<leader>dc", ":DapContinue<CR>")
core.map_key("n", "<leader>dD", ":DapDisconnect<CR>")
core.map_key("n", "<leader>do", ":DapStepOver<CR>")
core.map_key("n", "<leader>dO", ":DapStepOut<CR>")
core.map_key("n", "<leader>di", ":DapStepInto<CR>")
core.map_key("n", "gx", ":OpenUrlInLine<CR>")
core.map_key("n", "<leader>o", ":Outline<CR>")

-- notes
core.map_key("n", "<leader>na", ":AddNote<CR>")
core.map_key("n", "<leader>nq", ":AddQuickNote<CR>")
core.map_key("n", "<leader>nn", ":ZkNotes<CR>")
core.map_key("n", "<leader>nt", ":ZkTags<CR>")
core.map_key("n", "<leader>nl", ":ZkInsertLink<CR>")
core.map_key("n", "<leader>ni", ":ZkIndex<CR>")
core.map_key("", "<leader>ns", ":AddNoteFromSelection<CR>")

if core.is_home() then
	-- opencode
	local opencode_api = require("opencode.api")
	core.map_key({ "n", "t" }, "<c-a>", opencode_api.toggle) -- toggle opencode code split
	core.map_key("v", "<c-a>", opencode_api.add_visual_selection) -- send selected text to opencode
else
	-- Claude code
	-- core.map_key({ "n", "t" }, "<c-a>", "<Cmd>ClaudeCode<CR>") -- toggle claude code split
	-- core.map_key("v", "<c-a>", "<Cmd>ClaudeCodeSend<CR>") -- send selected text range to claude
	core.map_key("n", "<c-a>", function()
		send_to_claude(false)
	end) -- send file
	core.map_key("v", "<c-a>", function()
		send_to_claude(true)
	end) -- send file and lines
end

-- laravel.nvim
core.map_key("n", "<leader>la", ":Laravel<CR>")

-- markdown-toggle
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local toggle = require("markdown-toggle")
		core.map_key("n", "<CR>", toggle.checkbox)
	end,
})

-- kotlin copy fq class name
vim.api.nvim_create_autocmd("FileType", {
	pattern = "kotlin",
	callback = function()
		core.map_key("n", "<leader>lkc", ":CopyKotlinFQClassName<CR>")
		core.map_key("n", "<leader>lkC", ":CopyJVMBinaryName<CR>")
	end,
})

-- neotest
core.map_key("n", "<leader>tt", function()
	require("neotest").run.run()
end)
