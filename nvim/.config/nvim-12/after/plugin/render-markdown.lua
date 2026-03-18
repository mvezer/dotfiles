require("render-markdown").setup({
	file_types = { "markdown", "codecompanion" },
})

-- Fix the codeblock background color
vim.cmd("hi RenderMarkdownCode guifg=white guibg=black")
