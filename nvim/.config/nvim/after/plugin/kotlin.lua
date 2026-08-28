local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

if not configs.kmp_lsp then
	configs.kmp_lsp = {
		default_config = {
			cmd = { "kmp-lsp" },
			filetypes = { "kotlin", "java", "swift" },
			root_dir = lspconfig.util.root_pattern(
				"build.gradle",
				"build.gradle.kts",
				"pom.xml",
				"settings.gradle",
				"Package.swift",
				".git"
			),
			settings = {},
		},
	}
end

lspconfig.kmp_lsp.setup({})
