local core = require("core")

local function smart_dd()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		vim.api.nvim_feedkeys('"_dd', "n", false)
	else
		vim.api.nvim_feedkeys("dd", "n", false)
	end
end

-- General / non-leader keymaps
core.map_key("v", "<", "<gv")
core.map_key("v", ">", ">gv")
core.map_key({ "n", "v" }, "c", '"_c')
core.map_key({ "n", "v" }, "C", '"_C')
core.map_key("v", "p", "P")
core.map_key({ "n", "i", "t" }, "<c-down>", "<CMD>NavigatorDown<CR>")
core.map_key({ "n", "i", "t" }, "<c-up>", "<CMD>NavigatorUp<CR>")
core.map_key({ "n", "i", "t" }, "<c-right>", "<CMD>NavigatorRight<CR>")
core.map_key({ "n", "i", "t" }, "<c-left>", "<CMD>NavigatorLeft<CR>")

core.map_key("n", "<Tab>", "<Cmd>bnext<CR>")
core.map_key("n", "<S-Tab>", "<Cmd>bprevious<CR>")
core.map_key({ "n" }, "<C-x>", ":bd<CR>")

core.map_key("n", "Y", "y$", { desc = "Yank to end of line" })
core.map_key("n", "<C-u>", "<C-u>zz")
core.map_key("n", "<C-d>", "<C-d>zz")
core.map_key("n", "<Down>", "gj")
core.map_key("n", "<Up>", "gk")
core.map_key("n", "<Esc>", ":noh<CR>")
core.map_key("t", "<Esc>", "<C-\\><C-n>")
core.map_key("n", "dd", smart_dd)

core.map_key({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })

core.map_key("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
core.map_key("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
core.map_key("n", "gr", require("fzf-lua").lsp_references, { desc = "LSP references" })
core.map_key("n", "gx", ":OpenUrlInLine<CR>", { desc = "Open URL" })

core.map_key({ "n", "i" }, "<S-Down>", ":cn<CR>", { desc = "Next quickfix" })
core.map_key({ "n", "i" }, "<S-Up>", ":cp<CR>", { desc = "Prev quickfix" })

-- AI toggle (conditional on environment)
if core.is_home() then
	local opencode_api = require("opencode.api")
	core.map_key({ "n", "t" }, "<c-a>", opencode_api.toggle)
	core.map_key("v", "<c-a>", opencode_api.add_visual_selection)
else
	core.map_key({ "n", "t" }, "<c-a>", "<Cmd>ClaudeCode<CR>")
	core.map_key("v", "<c-a>", "<Cmd>ClaudeCodeSend<CR>")
end

-- Markdown filetype autocmd
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local toggle = require("markdown-toggle")
		core.map_key("n", "<CR>", toggle.checkbox)
	end,
})

-- which-key leader mappings
local wk = require("which-key")
wk.setup({})

local fzf = require("fzf-lua")

wk.add({
	-- Buffer management
	{ "<leader><leader>", ":Buffish<CR>", desc = "Buffer list" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>bo", ":%bd|e#|bd#<CR>", desc = "Close all other buffers" },
	{ "<leader>by", ":let @+ = expand('%:p')", desc = "Yank file path" },

	-- Files / Explorer
	{ "<leader>e", ":Oil<CR>", desc = "Oil explorer" },
	{
		"<leader>E",
		function()
			require("nvim-tree.api").tree.toggle({
				path = "<args>",
				find_file = false,
				update_root = false,
				focus = true,
			})
		end,
		desc = "NvimTree toggle",
	},

	-- Search (fzf)
	{ "<leader>s", group = "Search" },
	{ "<leader>sf", fzf.files, desc = "Files" },
	{ "<leader>sw", fzf.grep_cword, desc = "Word under cursor" },
	{ "<leader>sr", fzf.oldfiles, desc = "Recent files" },
	{ "<leader>st", fzf.live_grep, desc = "Live grep" },
	{ "<leader>sh", fzf.helptags, desc = "Help tags" },
	{ "<leader>sd", fzf.lsp_document_diagnostics, desc = "Diagnostics" },
	{ "<leader>sm", fzf.marks, desc = "Marks" },
	{ "<leader>sc", fzf.colorschemes, desc = "Colorschemes" },
	{ "<leader>sb", fzf.buffers, desc = "Buffers" },
	{ "<leader>sn", ":ZkNotes<CR>", desc = "Notes (Zk)" },

	-- LSP
	{ "<leader>l", group = "LSP" },
	{ "<leader>lr", vim.lsp.buf.rename, desc = "Rename symbol" },
	{ "<leader>ls", ":Neotree toggle=true source=document_symbols<CR>", desc = "Document symbols" },
	{
		"<leader>ll",
		function()
			vim.diagnostic.setqflist({ severity = { min = vim.diagnostic.severity.WARN } })
		end,
		desc = "Diagnostics to qflist",
	},
	{ "<leader>ld", vim.diagnostic.open_float, desc = "Line diagnostics" },
	{ "<leader>la", ":Laravel<CR>", desc = "Laravel" },
	{ "<leader>lk", group = "Kotlin" },
	{
		"<leader>lkc",
		function()
			require("kotlin_fqn").copy()
		end,
		desc = "Copy FQN",
	},
	{
		"<leader>lkC",
		function()
			require("kotlin_fqn").copy({ binary = true })
		end,
		desc = "Copy binary FQN",
	},

	-- Git
	{ "<leader>g", group = "Git" },
	{ "<leader>gl", ":Gitsigns setqflist<CR>", desc = "Hunks to qflist" },
	{ "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset hunk" },

	-- Debug (DAP)
	{ "<leader>d", group = "Debug" },
	{ "<leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
	{ "<leader>dd", ":DapViewToggle<CR>", desc = "DAP view toggle" },
	{ "<leader>dc", ":DapContinue<CR>", desc = "Continue" },
	{ "<leader>dD", ":DapDisconnect<CR>", desc = "Disconnect" },
	{ "<leader>do", ":DapStepOver<CR>", desc = "Step over" },
	{ "<leader>dO", ":DapStepOut<CR>", desc = "Step out" },
	{ "<leader>di", ":DapStepInto<CR>", desc = "Step into" },

	-- Notes (Zk)
	{ "<leader>n", group = "Notes" },
	{ "<leader>na", ":AddNote<CR>", desc = "Add note" },
	{ "<leader>nq", ":AddQuickNote<CR>", desc = "Quick note" },
	{ "<leader>nn", ":ZkNotes<CR>", desc = "List notes" },
	{ "<leader>nt", ":ZkTags<CR>", desc = "List tags" },
	{ "<leader>nl", ":ZkInsertLink<CR>", desc = "Insert link" },
	{ "<leader>ni", ":ZkIndex<CR>", desc = "Index notes" },
	{ "<leader>ns", ":AddNoteFromSelection<CR>", desc = "Note from selection", mode = { "n", "v" } },

	-- Tests
	{ "<leader>t", group = "Test" },
	{
		"<leader>tt",
		function()
			require("neotest").run.run()
		end,
		desc = "Run nearest test",
	},

	-- Toggles / misc
	{
		"<leader>f",
		function()
			vim.b.disable_autoformat = not vim.b.disable_autoformat
			vim.cmd("redrawstatus")
		end,
		desc = "Toggle autoformat",
	},
	{
		"<leader>c",
		function()
			if core.is_quickfix_open() then
				vim.cmd("cclose")
			else
				vim.cmd("copen")
			end
		end,
		desc = "Toggle quickfix",
	},
	{
		"<leader>a",
		function()
			require("nvim-autopairs").toggle()
		end,
		desc = "Toggle autopairs",
	},
	{ "<leader>ai", ":SupermavenToggle<CR>:redrawstatus<CR>", desc = "Toggle Supermaven" },
	{ "<leader>m", ":TSJToggle<CR>", desc = "Toggle split/join" },
	{ "<leader>M", ":MarkdownPreview<CR>", desc = "Markdown preview" },
	{ "<leader>o", ":Outline<CR>", desc = "Outline" },
	{ "<leader>S", ":AutoSession save<CR>", desc = "Save session" },
})
