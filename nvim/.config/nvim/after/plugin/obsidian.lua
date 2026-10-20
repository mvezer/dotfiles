return

-- local workspaces = {}
--
-- if vim.env.NOTES_DIR then
-- 	table.insert(workspaces, { name = "notes", path = vim.env.NOTES_DIR })
-- end
--
-- if vim.env.WORK_NOTES_DIR then
-- 	table.insert(workspaces, { name = "work_notes", path = vim.env.WORK_NOTES_DIR })
-- end
--
-- print(vim.inspect(workspaces))
--
-- require("obsidian").setup({
-- 	workspaces = workspaces,
-- 	picker = {
-- 		name = "fzf-lua",
-- 	},
-- })
