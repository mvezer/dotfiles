vim.cmd([[
function OpenMarkdownPreview (url)
  call system('open -n -a "Firefox" --args --no-remote -P mdpreview --new-window ' . shellescape(a:url))
endfunction
]])
vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
