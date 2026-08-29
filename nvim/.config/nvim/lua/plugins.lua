local core = require("core")
local plugins = {
	-- core deps
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },

	-- AI
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },

	-- LSP & formatting
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/towolf/vim-helm" },
	{ src = "https://github.com/adalessa/laravel.nvim" },

	-- editing
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/chrisgrieser/nvim-recorder" },
	{ src = "https://github.com/Wansmer/treesj" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/saghen/blink.indent" },

	-- utility
	{ src = "https://github.com/zk-org/zk-nvim" },
	{ src = "https://github.com/gnsfujiwara/suda.nvim" },
	{ src = "https://github.com/hedyhli/outline.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/emfussenegger/nvim-dap" },
	{ src = "https://github.com/igorlfs/nvim-dap-view" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/rmagatti/auto-session" },
	{ src = "https://github.com/roodolv/markdown-toggle.nvim" },

	-- UI
	{ src = "https://github.com/numToStr/Navigator.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/kevinhwang91/nvim-bqf" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
	{ src = "https://github.com/shatur/neovim-ayu" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/mong8se/buffish.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },

	-- own plugins
	{ src = "https://github.com/mvezer/fzf-plugin-manager.nvim" },
	-- { src = "file:///home/mat/workshop/fzf-plugin-manager.nvim" },
	{ src = "https://github.com/mvezer/mark-and-jump.nvim" },
	-- { src = "file:///home/mat/workshop/mark-and-jump.nvim" },
}
if core.is_home() then
	-- use opencode at home
	table.insert(plugins, { src = "https://github.com/sudo-tee/opencode.nvim" })
else
	-- claude code at work...
	table.insert(plugins, { src = "https://github.com/coder/claudecode.nvim" })
end

vim.pack.add(plugins)
