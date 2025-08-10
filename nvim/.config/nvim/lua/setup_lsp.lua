local utils = require("utils")

return function()
  utils.map("n", "<leader>ld", vim.diagnostic.open_float, utils.map_opts)
  vim.lsp.enable("ts_ls")
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = vim.fs.dirname(vim.fs.find({ "tsconfig.json", "package.json" }, { upward = true })[1]),
    filetypes = { "typescript", "typescriptreact" },
  })

  vim.lsp.enable("lua_ls")
  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
    settings = {
      Lua = {
        diagnostics = {
          globals = {
            "vim",
            "vim.loop",
            "vim.loop.os_uname",
            "vim.uv",
            "kong",
            "ngx",
            "awesome",
            "root",
            "client",
            "screen",
          },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            ["/usr/share/awesome/lib"] = true,
          },
        },
      },
    },
  })

  vim.lsp.enable("clangd")
  vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index" },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    root_dir = vim.fn.getcwd(),
    filetypes = { "c", "cpp" },
  })

  vim.lsp.enable("bashls")
  vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh, zsh" },
    root_dir = vim.fn.getcwd(),
  })

  vim.lsp.enable("yamlls")
  vim.lsp.config("yamlls", {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_dir = vim.fn.getcwd(),
  })

  vim.lsp.enable("jsonls")
  vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json" },
    root_dir = vim.fn.getcwd(),
  })
  local chars = {}
  for i = 32, 126 do
    table.insert(chars, string.char(i))
  end
  local pumMap = function(insertKmap, pumKmap)
    utils.map("i", insertKmap, function()
      if vim.fn.pumvisible() == 0 then
        return insertKmap
      else
        return pumKmap
      end
    end, { expr = true })
  end
  utils.autocmd("LspAttach", {
    group = utils.augroup,
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client:supports_method("textDocument/implementation") then
        local bufopts = { noremap = true, silent = true, buffer = args.buf }
        utils.map("n", "gd", utils.fzf.lsp_definitions, bufopts)
        utils.map("n", "gD", utils.fzf.lsp_typedefs, bufopts)
        utils.map("n", "K", vim.lsp.buf.hover, bufopts)
        utils.map("n", "gr", utils.fzf.lsp_references, bufopts)
        utils.map("n", "<leader>lr", vim.lsp.buf.rename, bufopts)
        utils.map("n", "<leader>o", utils.fzf.lsp_document_symbols, bufopts)
        utils.map({ "n", "i" }, "<S-Down>", vim.diagnostic.goto_next, bufopts)
        utils.map({ "n", "i" }, "<S-Up>", vim.diagnostic.goto_prev, bufopts)
        pumMap("<Down>", "<C-n>")
        pumMap("<Up>", "<C-p>")
        pumMap("<CR>", "<C-y>")
      end
      if client:supports_method("textDocument/completion") then
        client.server_capabilities.completionProvider.triggerCharacters = chars
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end
    end,
  })
end
