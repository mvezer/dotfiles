local utils = require("utils")

return function()
  local dap = require("dap")
  local dap_view = require("dap-view")
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      args = { "--port", "${port}" },
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp

  dap_view.setup({})
  utils.map("n", "<leader>d", dap.continue, utils.map_opts)
  utils.map("n", "<leader>D", dap.disconnect, utils.map_opts)
  utils.map("n", "<leader>b", dap.toggle_breakpoint, utils.map_opts)
  utils.map("n", "<leader>w", dap_view.add_expr, utils.map_opts)
  utils.map("n", "<C-s>", dap.step_over, utils.map_opts)
  utils.map("n", "<C-i>", dap.step_into, utils.map_opts)
end
