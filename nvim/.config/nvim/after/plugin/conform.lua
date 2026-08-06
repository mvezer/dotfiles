local disabled_ft = {
	"help",
	"man",
	"markdown",
	"kotlin",
}

local formatters_by_ft = {
	lua = { "stylua" },
	rust = { "rustfmt", lsp_format = "fallback" },
	toml = { "taplo" },
	gdscript = { "gdscript-formatter" },
}
for _, ft in ipairs({
	"javascript ",
	"typescript",
	"typescriptreact",
	"javascriptreact",
	"json",
	"jsonc",
	"yaml",
	"html",
}) do
	formatters_by_ft[ft] = { "prettier", "eslint_d", stop_after_first = true }
end
require("conform").setup({
	format_on_save = function(bufnr)
		local ft = vim.bo[bufnr].filetype
		if vim.tbl_contains(disabled_ft, ft) then
			return
		end
		local enable_autoformat = not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat
		return enable_autoformat and { timeout_ms = 500, lsp_format = "fallback" } or nil
	end,
	formatters_by_ft = formatters_by_ft,
})
