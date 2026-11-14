function _G.OpenMarkdownPreview(url)
	local cmd
	if vim.fn.has("mac") == 1 then
		cmd = { "open", "-n", "-a", "Firefox", "--args", "--no-remote", "-P", "mdpreview", "--new-window", url }
	else
		cmd = { "firefox", "--no-remote", "-P", "mdpreview", "--new-window", url }
	end
	vim.fn.jobstart(cmd, { detach = true })
end

vim.cmd([[
function OpenMarkdownPreview(url)
  call v:lua.OpenMarkdownPreview(a:url)
endfunction
]])
vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
