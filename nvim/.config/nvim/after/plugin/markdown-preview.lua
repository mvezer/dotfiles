vim.cmd([[
function OpenMarkdownPreview (url)
  execute "silent ! vivaldi-stable --new-window " . a:url
endfunction
]])
vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
