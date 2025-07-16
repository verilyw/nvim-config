vim.cmd([[
  set mouse=a
  set nu nornu ru ls=2 " 显示相关
  set et sts=0 ts=4 sw=4
  set signcolumn=number
  set nohls
  set list
  set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
  set cinoptions=j1,(0,ws,Ws,g0,:0,=0,l1
  set cinwords=if,else,switch,case,for,while,do
  set showbreak=↪
  set bri wrap
  set switchbuf=useopen
  set clipboard+=unnamedplus
  set exrc
  set foldtext='+--'
  set termguicolors
  " set cc=80
  " set scrolloff=4
  " set sidescrolloff=4
]])

vim.cmd([[
    augroup disable_formatoptions_cro
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=cro
    augroup end
]]
)
