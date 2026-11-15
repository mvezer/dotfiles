-- a dedicated qutebrowser instance (own profile + window, app id "qute-preview" for WM rules)
local browser = "default"
if vim.fn.executable("qutebrowser") == 1 then
	browser = table.concat({
		"qutebrowser",
		"--basedir",
		vim.fn.shellescape(vim.fn.stdpath("data") .. "/qute-preview"),
		"--config-py",
		vim.fn.shellescape(vim.fn.stdpath("config") .. "/extras/qute-preview.py"),
		"--desktop-file-name qute-preview",
		"--target window",
	}, " ")
end

require("livepreview.config").set({
	-- one server per nvim: a fixed port would clash between instances
	port = 5500 + vim.fn.getpid() % 1000,
	browser = browser,
	sync_scroll = true,
})
