vim.o.guifont = "JetBrainsMono Nerd Font Mono:h11" -- text below applies for VimScript
vim.g.neovide_scale_factor = 1.0

vim.api.nvim_create_user_command("NeovideIncreaseScaleFactor", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
end, {})

vim.api.nvim_create_user_command("NeovideDecreaseScaleFactor", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1 / 1.1
end, {})
