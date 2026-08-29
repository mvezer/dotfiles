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

-----------------------------------------------------

-- Resolve + copy the fully qualified name of the Kotlin type under the cursor.
--
-- Resolution order:
--   1. an `import a.b.C` (or `import a.b.C as D`) matching the word under cursor
--   2. package + enclosing class/object chain from treesitter
--   3. package + word, for same-package references that need no import
--
-- Requires the kotlin treesitter parser: :TSInstall kotlin

local M = {}

local TYPE_NODES = {
	class_declaration = true,
	object_declaration = true,
	companion_object = true,
}

local function package_of(bufnr)
	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
		local pkg = line:match("^%s*package%s+([%w_%.`]+)")
		if pkg then
			return (pkg:gsub("`", ""))
		end
	end
	return nil
end

local function import_of(bufnr, name)
	for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 500, false)) do
		local aliased, alias = line:match("^%s*import%s+([%w_%.`]+)%s+as%s+([%w_`]+)")
		if aliased and alias:gsub("`", "") == name then
			return (aliased:gsub("`", ""))
		end
		local plain = line:match("^%s*import%s+([%w_%.`]+)%s*$")
		if plain then
			plain = plain:gsub("`", "")
			if plain:match("([^%.]+)$") == name then
				return plain
			end
		end
	end
	return nil
end

local function type_name(node, bufnr)
	for child in node:iter_children() do
		local t = child:type()
		-- grammars differ: fwcd uses simple_identifier, others type_identifier
		if t == "type_identifier" or t == "simple_identifier" then
			return vim.treesitter.get_node_text(child, bufnr)
		end
	end
	if node:type() == "companion_object" then
		return "Companion"
	end
	return nil
end

-- Outermost-first list of the type declarations enclosing the cursor.
local function enclosing_types(bufnr)
	local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
	if not ok or not node then
		return {}
	end
	local names = {}
	while node do
		if TYPE_NODES[node:type()] then
			local name = type_name(node, bufnr)
			if name then
				table.insert(names, 1, name)
			end
		end
		node = node:parent()
	end
	return names
end

--- @param opts table|nil  { binary = true } to use `$` between nested types
--- @return string|nil
function M.resolve(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local word = vim.fn.expand("<cword>")
	local pkg = package_of(bufnr)

	local imported = import_of(bufnr, word)
	if imported then
		return imported
	end

	local chain = enclosing_types(bufnr)

	-- cursor sits on one of the enclosing names -> stop the chain there
	for i, name in ipairs(chain) do
		if name == word then
			chain = vim.list_slice(chain, 1, i)
			break
		end
	end

	if #chain > 0 then
		local sep = opts.binary and "$" or "."
		return (pkg and pkg .. "." or "") .. table.concat(chain, sep)
	end

	-- same-package type, no import required
	if pkg and word:match("^%u") then
		return pkg .. "." .. word
	end

	return nil
end

function M.copy(opts)
	local fqn = M.resolve(opts)
	if not fqn then
		vim.notify("No Kotlin type found under cursor", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", fqn)
	vim.fn.setreg('"', fqn)
	vim.notify(fqn, vim.log.levels.INFO, { title = "Copied" })
end

vim.api.nvim_create_user_command("CopyKotlinFQClassName", function()
	M.copy()
end, {})

vim.api.nvim_create_user_command("CopyJVMBinaryName", function()
	M.copy({ binary = true })
end, {})

return M
