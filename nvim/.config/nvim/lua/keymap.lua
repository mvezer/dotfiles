local core = require("core")

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
core.map_key({ "n", "t" }, "<c-down>", "<CMD>NavigatorDown<CR>")
core.map_key({ "n", "t" }, "<c-up>", "<CMD>NavigatorUp<CR>")
core.map_key({ "n", "t" }, "<c-right>", "<CMD>NavigatorRight<CR>")
core.map_key({ "n", "t" }, "<c-left>", "<CMD>NavigatorLeft<CR>")

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

core.map_key("n", "<Tab>", "<Cmd>bNext<CR>") -- next buffer
core.map_key("n", "<S-Tab>", "<Cmd>bPrev<CR>") -- prev buffer
core.map_key({ "n" }, "<C-x>", ":bd<CR>") --- delete buffer

core.map_key("n", "<leader>by", ":let @+ = expand('%:p')")
core.map_key("n", "Y", "y$", { desc = "Yank to end of line" })
core.map_key("n", "<C-u>", "<C-u>zz")
core.map_key("n", "<C-d>", "<C-d>zz")
core.map_key("n", "<Down>", "gj")
core.map_key("n", "<Up>", "gk")
core.map_key("n", "<Esc>", ":noh<CR>")
core.map_key("t", "<Esc>", "<C-\\><C-n>")
core.map_key("n", "<leader>E", ":Oil<CR>")
core.map_key("n", "<leader>e", function()
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
core.map_key("n", "<leader>sa", ":GpChatFinder<CR>")
core.map_key("n", "<leader>sn", ":ZkNotes<CR>")

core.map_key("n", "gd", vim.lsp.buf.definition)
core.map_key("n", "K", vim.lsp.buf.hover)
core.map_key("n", "gr", vim.lsp.buf.references)
core.map_key("n", "<leader>lr", vim.lsp.buf.rename)
core.map_key("n", "<leader>ls", ":Neotree toggle=true source=document_symbols<CR>")
core.map_key("n", "<leader>ll", function()
	vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } })
end)
core.map_key("n", "<leader>ld", vim.diagnostic.open_float)
core.map_key("n", "<leader>gl", ":Gitsigns setqflist<CR>")
core.map_key("n", "<leader>gr", ":Gitsigns reset_hunk<CR>")
core.map_key({ "n", "i" }, "<S-Down>", ":cn<CR>")
core.map_key({ "n", "i" }, "<S-Up>", ":cp<CR>")

core.map_key("n", "<leader>m", ":TSJToggle<CR>")
core.map_key("n", "<leader>M", ":MarkdownPreview<CR>")

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

-- Claude code
core.map_key({ "n", "t" }, "<c-a>", "<Cmd>ClaudeCode<CR>") -- next buffer
core.map_key("v", "<c-a>", "<Cmd>ClaudeCodeSend<CR>") -- next buffer

-- laravel.nvim
core.map_key("n", "<leader>la", ":Laravel<CR>")
