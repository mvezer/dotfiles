local plugin_spec = {
  { "nvim-treesitter/nvim-treesitter" },
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "neovim/nvim-lspconfig" },
  { "folke/lazydev.nvim", opts = {} },
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        transparent = true,
        style = "darker",
      })

      vim.cmd.colorscheme("onedark")
    end,
  },
  { "https://github.com/numToStr/Navigator.nvim", opts = {} },
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = { accept_suggestion = "<S-Tab>" },
      color = { suggestion_color = "#005f5f", cterm = 23 },
    },
  },
  {
    "Robitx/gp.nvim",
    opts = {
      providers = {
        anthropic = {
          endpoint = "https://api.anthropic.com/v1/messages",
          secret = os.getenv("ANTHROPIC_API_KEY"),
        },
      },
      agents = {
        {
          provider = "anthropic",
          name = "ChatClaude-4.5-Sonnet",
          chat = true,
          command = true,
          model = { model = "claude-sonnet-4-5-20250929" },
          system_prompt = [[
You are a general AI assistant.

The user provided the additional info about how they would like you to respond:

- If you're unsure don't guess and say you don't know instead.
- Ask question if you need clarification to provide better answer.
- Think deeply and carefully from first principles step by step.
- Zoom out first to see the big picture and then zoom in to details.
- Use Socratic method to improve your thinking and coding skills.
- Don't elide any code from your output if the answer requires coding.
- Take a deep breath; You've got this!
]],
        },
      },
      default_command_agent = "ChatClaude-4.5-Sonnet",
      default_chat_agent = "ChatClaude-4.5-Sonnet",
    },
  },
  {
    "stevearc/conform.nvim",
    config = function()
      local formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        toml = { "taplo" },
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
          local enable_autoformat = not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat
          return enable_autoformat and { timeout_ms = 500, lsp_format = "fallback" } or nil
        end,
        formatters_by_ft = formatters_by_ft,
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      filesystem = { filtered_items = { hide_dotfiles = false } },
      window = { position = "float" },
    },
  },
  {
    "folke/flash.nvim",
    opts = { labels = "neioarst" },
  },
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({ picker = "fzf_lua" })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "codecompanion" },
    },
  },
  -- {
  --   "kevinhwang91/nvim-bqf",
  --   opts = {},
  -- },
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      "max-perf",
      winopts = { height = 1, width = 1 },
      keymap = { fzf = { ["ctrl-q"] = "select-all+accept" } },
      buffes = {
        sort_lastused = false,
      },
    },
  },
  {
    "Wansmer/treesj",
    opts = {},
  },
  {
    "chrisgrieser/nvim-recorder",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "chentoast/marks.nvim",
    opts = {
      mappings = {
        set_next = "mm",
        delete_line = "M",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local function filename_plus_project()
        local dir = vim.fn.getcwd() or ""
        local buffer_dir = vim.fn.expand("%")
        local project = "[" .. string.match(dir, ".+/(.+)$") .. "]"
        local relative_path = buffer_dir:gsub(dir, "")
        local modified_suffix = ""
        if vim.bo.modified then
          modified_suffix = "[+]"
        end
        return project .. " " .. relative_path .. " " .. modified_suffix
      end

      local function autoformat()
        if vim.g.disable_autoformat == true or vim.b.disable_autoformat == true then
          return "-"
        end

        return "󰦪"
      end
      local function autopairs()
        if require("nvim-autopairs").state.disabled == true then
          return "-"
        end

        return "󰅩"
      end

      local function supermaven()
        if require("supermaven-nvim.api").is_running() then
          return "󰬀"
        else
          return "-"
        end
      end
      require("lualine").setup({
        options = {
          always_show_tabline = true,
          icons_enabled = true,
          theme = "auto",
          component_separators = "",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { filename_plus_project },
          lualine_x = { autopairs, autoformat, supermaven },
          lualine_y = { { "filetype", icon_only = true }, { "lsp_status", icon = "󰬓" } },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      background_colour = "#000000",
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      { "rcarriga/nvim-notify", opts = { background_colour = "#000000" } },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {},
  },
  {
    "stevearc/overseer.nvim",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugin_spec)
