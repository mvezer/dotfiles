-- a dedicated qutebrowser instance (own profile + window, app id "qute-preview" for WM rules)
local browser = "default"
-- macOS: not on PATH, only the app bundle
local qute = vim.fn.exepath("qutebrowser")
if qute == "" and vim.fn.executable("/Applications/qutebrowser.app/Contents/MacOS/qutebrowser") == 1 then
	qute = "/Applications/qutebrowser.app/Contents/MacOS/qutebrowser"
end
if qute ~= "" then
	browser = table.concat({
		vim.fn.shellescape(qute),
		"--basedir",
		vim.fn.shellescape(vim.fn.stdpath("data") .. "/qute-preview"),
		"--config-py",
		vim.fn.shellescape(vim.fn.stdpath("config") .. "/extras/qute-preview.py"),
		"--desktop-file-name qute-preview",
		"--target window",
		-- must be last (the URL follows); on macOS it also stops AppKit from reopening the URL as a file
		"--untrusted-args",
	}, " ")
end

require("livepreview.config").set({
	-- one server per nvim: a fixed port would clash between instances
	port = 5500 + vim.fn.getpid() % 1000,
	browser = browser,
	sync_scroll = true,
})
