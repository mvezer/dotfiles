local function get_nestjs_pid()
	-- full process info with "or" condition
	-- ps aux | grep -e "nest start" -e "node"
	local handle = io.popen("pgrep -f 'nest start' 2>&1")

	if not handle then
		return nil, "Failed to execute pgrep command"
	end

	local result = handle:read("*a")
	handle:close()

	-- Trim whitespace
	result = result:gsub("^%s*(.-)%s*$", "%1")

	if result == "" then
		return nil, "No NestJS process found"
	end

	-- pgrep can return multiple PIDs (one per line)
	-- Get the first one
	local pid = result:match("^(%d+)")

	if pid then
		vim.notify("Attaching to NestJS process with PID: " .. pid)
		return tonumber(pid), nil
	else
		vim.notify("No NestJS process found")
		return nil, "Could not parse PID from pgrep output"
	end
end

local dap = require("dap")

dap.adapters = {
	["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "js-debug-adapter",
			args = {
				"${port}",
			},
		},
	},
}

dap.configurations["typescript"] = {
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach to process ID",
		processId = get_nestjs_pid,
		cwd = "${workspaceFolder}",
	},
}
