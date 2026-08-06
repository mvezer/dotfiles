vim.cmd([[
function OpenMarkdownPreview (url)
  call system('open -n -a "Brave Browser" --args --new-window ' . shellescape(a:url))
endfunction
]])
vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
