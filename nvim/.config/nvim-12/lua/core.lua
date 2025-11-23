local default_map_opts = { silent = true }
local map_key = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or default_map_opts)
end

local augroup = vim.api.nvim_create_augroup("mat.cfg", {})

local plugins = {}

---------------------------------------------------------------------------------
--- Plugin management functions and commands
---------------------------------------------------------------------------------
---
---Gets all the names of the installed plugins
---@return string[] Plugin names
plugins.get_all = function()
  local plugin_info = vim.pack.get()
  local plugin_names = {}
  for _, plugin in ipairs(plugin_info) do
    table.insert(plugin_names, plugin.spec.name)
  end
  return plugin_names
end

---Invokes the plugins fzf picker
plugins.fzf = function()
  require("fzf-lua").fzf_exec(plugins.get_all(), {
    prompt = "Update plugins>",
    actions = {
      ["default"] = function(selected_plugin)
        vim.pack.update(selected_plugin)
      end,
    },
  })
end

---Defines a plugin (wrapper for vim.pack.add)
---@param spec string|table - The github url of the plugin or the full spec as table (required by vim.pack.add)
---@param name string|nil - Name of the plugin (the name that's used for "require", for example "zk-nvim" or "fzf-lua")
---@param opts table|nil - plugin-specific options that's passed to the "setup" function
plugins.add = function(spec, name, opts)
  local normalized_spec = {}
  if type(spec) == "table" then
    normalized_spec = spec
  else
    table.insert(normalized_spec, spec)
  end
  vim.pack.add(normalized_spec)
  if not name then
    return
  end
  local ok, plugin_instance = pcall(require, name)
  if ok and plugin_instance and type(plugin_instance.setup) == "function" then
    plugin_instance.setup(opts or {})
  end
end

local function is_quickfix_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "quickfix" then
      return true
    end
  end
  return false
end

return {
  is_quickfix_open = is_quickfix_open,
  plugins = plugins,
  map_key = map_key,
  augroup = augroup,
}
