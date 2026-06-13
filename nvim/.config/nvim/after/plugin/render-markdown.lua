require("render-markdown").setup({
	anti_conceal = { enabled = false },
	file_types = { "markdown", "codecompanion", "opencode_output" },
})

-- Fix the codeblock background color
vim.cmd("hi RenderMarkdownCode guifg=white guibg=black")
