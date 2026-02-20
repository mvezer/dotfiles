local core = require("core")

local function open_url_on_line()
	local line = vim.api.nvim_get_current_line()
	local url = line:match("https?://[%w-_%.%?%.:/%+=&]+")

	if not url then
		vim.notify("No URL found on current line", vim.log.levels.WARN)
		return
	end

	local open_command
	if vim.fn.has("mac") == 1 then
		open_command = "open"
	elseif vim.fn.has("unix") == 1 then
		open_command = "xdg-open"
	else
		vim.notify("Unsupported operating system", vim.log.levels.ERROR)
		return
	end

	vim.fn.jobstart({ open_command, url }, { detach = true })
	vim.notify("Opening: " .. url, vim.log.levels.INFO)
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
core.map_key({ "n", "v", "i" }, "<c-down>", ":NavigatorDown<CR>")
core.map_key({ "n", "v", "i" }, "<c-up>", ":NavigatorUp<CR>")
core.map_key({ "n", "v", "i" }, "<c-right>", ":NavigatorRight<CR>")
core.map_key({ "n", "v", "i" }, "<c-left>", ":NavigatorLeft<CR>")
core.map_key("n", "<leader>bo", ":%bd|e#|bd#<CR>") -- close all buffers but the current one
core.map_key({ "n", "v", "i" }, "<C-x>", ":bd<CR>")
core.map_key("n", "<leader>by", ":let @+ = expand('%:p')")
core.map_key("n", "Y", "y$", { desc = "Yank to end of line" })
core.map_key("n", "<C-u>", "<C-u>zz")
core.map_key("n", "<C-d>", "<C-d>zz")
core.map_key("n", "<Down>", "gj")
core.map_key("n", "<Up>", "gk")
core.map_key("n", "<Esc>", ":noh<CR>")
core.map_key("t", "<Esc>", "<C-\\><C-n>")
core.map_key("n", "<Tab>", ":bNext<CR>")
core.map_key("n", "<S-Tab>", ":bPrevious<CR>")
core.map_key("n", "<leader>E", ":Dired<CR>") -- because of the vim-rooter the current buffer is the .git root
core.map_key("n", "<leader>e", ":Dired %:p:h<CR>") -- open dired in the directory of the current buffer
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

core.map_key("n", "<leader>sf", require("fzf-lua").files)
core.map_key("n", "<leader>sw", require("fzf-lua").grep_cword)
core.map_key("n", "<leader>sr", require("fzf-lua").oldfiles)
core.map_key("n", "<leader>st", require("fzf-lua").live_grep)
core.map_key("n", "<leader>sh", require("fzf-lua").helptags)
core.map_key("n", "<leader>sd", require("fzf-lua").lsp_document_diagnostics)
core.map_key("n", "<leader>sm", require("fzf-lua").marks)
core.map_key("n", "<leader>sc", require("fzf-lua").colorschemes)
core.map_key("n", "<leader>sa", require("aerial").fzf_lua_picker)
core.map_key("n", "<leader>sn", ":ZkNotes<CR>")
core.map_key("n", "<leader><leader>", require("fzf-lua").buffers)

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

-- AI stuff
core.map_key({ "n", "v" }, "<leader>aa", ":GpRewrite<CR>")
core.map_key({ "n", "v" }, "<leader>aA", ":GpAppend<CR>")
core.map_key({ "n", "v" }, "<leader>ac", ":GpChatToggle<CR>")
core.map_key({ "n", "v" }, "<leader>an", ":GpChatNew<CR>")
core.map_key({ "n", "v" }, "<leader>ad", ":GpChatDelete<CR>")
core.map_key({ "n", "v" }, "<leader>af", ":GpChatFinder<CR>")

-- debug stuff
core.map_key("n", "<leader>db", ":DapToggleBreakpoint<CR>")
core.map_key("n", "<leader>dd", ":DapViewToggle<CR>")
core.map_key("n", "<leader>dc", ":DapContinue<CR>")
core.map_key("n", "<leader>dD", ":DapDisconnect<CR>")
core.map_key("n", "<leader>do", ":DapStepOver<CR>")
core.map_key("n", "<leader>dO", ":DapStepOut<CR>")
core.map_key("n", "<leader>di", ":DapStepInto<CR>")
core.map_key("n", "gx", ":OpenUrlInLine<CR>")

-- vim.keymap.set("n", "gx", open_url_on_line, { desc = "Open URL under cursor" })

-- treesitter textobjects
core.map_key({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
core.map_key({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
core.map_key({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
core.map_key({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
core.map_key({ "x", "o" }, "as", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)
