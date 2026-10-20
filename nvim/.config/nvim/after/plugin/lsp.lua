require("mason").setup()

-- vue_ls runs in "hybrid mode": it only handles template/CSS and forwards
-- TypeScript requests to a ts_ls client attached to the same buffer. ts_ls
-- doesn't open .vue files by default, so we extend its filetypes and load
-- the @vue/typescript-plugin that vue-language-server ships.
-- https://github.com/vuejs/language-tools/wiki/Neovim
local vue_language_server_path = vim.fn.stdpath("data")
	.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("ts_ls", {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
			},
		},
	},
})

require("mason-lspconfig").setup()
require("mason-nvim-dap").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"eslint_d",
		"ts_ls",
		"vue_ls",
		"prettier",
		"prettierd",
		"eslint",
		"bash-language-server",
		"clangd",
		"bashls",
		"jsonls",
		"yamlls",
		"js-debug-adapter",
	},
})
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "accept", "fallback" },
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	enabled = function()
		return not vim.tbl_contains({ "markdown", "log", "txt" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
	end,
})
