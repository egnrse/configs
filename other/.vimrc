"(use :set ff=unix for ^M errors)
set tabstop=4		"tabs are shorter
set shiftwidth=4

set number			"line numbers [nonumber]
set hls				"search highlight [noh]
set smartcase		"make search case insensitive for only lowercase search
syntax on			"syntax highlighting
set mouse=a			"mouse interaction (all)
set visualbell
autocmd FileType * if &ft !=# 'c' | set smartindent | endif
autocmd FileType c,cpp set cindent

"Folds
"close: zc / open: zo / zR: open all folds
set foldmethod=syntax
set foldlevel=99	"start with open folds
highlight Folded ctermbg=Black ctermfg=Grey guibg=Black guifg=Grey	"fold color


" ---------- vim only section (ignore in nvim) --------------
if !has('nvim')

"vim-plug :PlugInstall, :PlugClean
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
	Plug 'itchyny/lightline.vim'	"status line
	Plug 'godlygeek/tabular'		"markdown dependency
	Plug 'preservim/vim-markdown'	"folding around titles
call plug#end()
"otherPlugins:
"Plug 'dense-analysis/ale'

"lightline plugin
set laststatus=2

"vim-markdown
"let g:vim_markdown_folding_level = 0
"let g:vim_markdown_override_foldtext = 0
"autocmd FileType markdown normal! zR	"open all folds on open

endif
" end of vim only section
