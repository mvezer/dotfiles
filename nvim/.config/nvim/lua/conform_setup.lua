local utils = require("utils")

return function()
  local formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt", lsp_format = "fallback" },
  }
  for _, ft in ipairs({ "javascript ", "typescript", "typescriptreact", "javascriptreact ", "json", "jsonc ", "yaml ", "html" }) do
    formatters_by_ft[ft] = { "prettier", "eslint_d", stop_after_first = true }
  end
  require("conform").setup({
    format_on_save = function(bufnr)
      local enable_autoformat = not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat
      return enable_autoformat and { timeout_ms = 500, lsp_format = "fallback" } or nil
    end,
    formatters_by_ft = formatters_by_ft,
  })
  utils.map("n", "<leader>f", function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.cmd("redrawstatus")
  end, utils.map_opts)
end
