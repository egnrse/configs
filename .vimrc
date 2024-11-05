"(use :set ff=unix for ^M errors)
set tabstop=4       "tabs are shorter
set shiftwidth=4

set number          "line numbers [nonumber]
set hls             "search highlight [noh]
set smartcase       "make search case insensitive for only lowercase search
syntax on           "syntax highlighting
set mouse=a         "mouse interaction (all)
set visualbell
autocmd FileType * if &ft !=# 'c' | set smartindent | endif
autocmd FileType c,cpp set cindent


"close: zc / open: zo
"zR: open all folds
set foldmethod=syntax
set foldlevel=99

"color for the folds:
highlight Folded ctermbg=Black ctermfg=Grey guibg=Black guifg=Grey


" ---------- vim only section (ignore in nvim) --------------
if !has('nvim')

"vim-plug :PlugInstall, :PlugClean
call plug#begin()
    Plug 'itchyny/lightline.vim'    "status line
call plug#end()
"otherPlugins:
"Plug 'dense-analysis/ale'

"lightline plugin
set laststatus=2

endif
" end of vim only section
