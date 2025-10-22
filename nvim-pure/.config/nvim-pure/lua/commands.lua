local utils = require("utils")

-- Highlight on yank
utils.autocmd("TextYankPost", {
  group = utils.augroup,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Grep
if vim.fn.executable("rg") == 1 then
  function _G.RgFindFiles(cmdarg, _cmdcomplete)
    local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
    if #cmdarg == 0 then
      return fnames
    else
      return vim.fn.matchfuzzy(fnames, cmdarg)
    end
  end

  vim.o.findfunc = "v:lua.RgFindFiles"
end

local function is_cmdline_type_find()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]

  return cmdline_cmd == "find" or cmdline_cmd == "fin"
end

utils.autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
  pattern = { "*" },
  group = utils.augroup,
  callback = function(ev)
    local function should_enable_autocomplete()
      local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]

      return is_cmdline_type_find() or cmdline_cmd == "help" or cmdline_cmd == "h"
    end

    if ev.event == "CmdlineChanged" and should_enable_autocomplete() then
      vim.opt.wildmode = "noselect:lastused,full"
      vim.fn.wildtrigger()
    end

    if ev.event == "CmdlineLeave" then
      vim.opt.wildmode = "full"
    end
  end,
})
