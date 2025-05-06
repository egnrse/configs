" vim config by egnrse
" (https://github.com/egnrse/configs)
" 
" overview:
" - general settings
" - custom commands
" - key mappings
" - plugins (vim-plug)
"
"(use :set ff=unix for ^M errors)


"====== GENERAL ======
set number			"line numbers [nonumber]
set relativenumber	"relative line numbers [nonumber]
set tabstop=4		"tabs are shorter
set shiftwidth=4
set mouse=a			"mouse interaction (all)

set hls				"search highlight [noh]
set smartcase		"make search case insensitive for only lowercase search
set smartindent		"automatically indent new lines

set showcmd			"show keys pressed in the bottom right corner
set visualbell
"set cursorline		"highlight the current line
syntax on			"syntax highlighting
autocmd FileType * if &ft !=# 'c' | set smartindent | endif
autocmd FileType c,cpp set cindent

autocmd VimEnter * ++once tab all	"when opening multiple files, open them in tabs instead

"Folds
"close: zc / open: zo / zR: open all folds
set foldmethod=syntax
set foldlevel=99	"start with open folds
highlight Folded ctermbg=Black ctermfg=Grey guibg=Black guifg=Grey	"fold color

"ctags
set tags+=./.tags;/	"search for '.tag' files also in parent directories

" show preview in a popup not in a special window buffer
"set previewpopup=height:10,width:60

"====== COMMANDS ======
command W w
command Wq wq
command Wqa wqa
command WQ wqa
command Q qa
command Qa qa


"====== KEYMAPPINGS ======
let mapleader = " "

"General
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
vnoremap <C-s> <Esc>:w<CR>gv
"clipbard might be disabled (vim --version | grep clipboard)
"vnoremap <C-c> "+y

"Window Tabs
nnoremap <leader>tn :tab split<CR>
nnoremap <leader><Tab> :tabnext<CR>
nnoremap <leader><S-Tab> :tabprevious<CR>
nnoremap <leader>tp :tabprevious<CR>
nnoremap <leader>td :tabclose<CR>
nnoremap <leader>tD :tabclose!<CR>
nnoremap <leader>tc :tabclose<CR>
"Window Buffer
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>q :bdelete<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bD :bdelete!<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

"Window Size Managing
nnoremap <leader>\| :vsplit<CR>
nnoremap <leader>h :vsplit<CR>
nnoremap <leader>- :split<CR>
nnoremap <leader>wm :only<CR>

nnoremap <C-Left> <C-w><
nnoremap <C-Right> <C-w>>
nnoremap <C-Up> <C-w>+
nnoremap <C-Down> <C-w>-

"Terminal
nnoremap <leader>th :horizontal terminal<CR>
nnoremap <leader>tv :vertical terminal<CR>
tnoremap <Esc><Esc> <C-\><C-n>

"Preview Buffer
nnoremap <leader>} :ptag <C-r><C-w><CR>
map <Esc><Esc> :pclose<CR>

"more keymaps under plugins (eg. FileManager)


" ---------- vim only section (ignore in nvim) --------------
if !has('nvim')


"====== PLUGINS (vim-plug) ======
" should autoinstall on first launch
" :PlugInstall, :PlugClean
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()
	Plug 'itchyny/lightline.vim'	"status line
	Plug 'godlygeek/tabular'		"markdown dependency
	Plug 'preservim/vim-markdown'	"folding around titles
	Plug 'preservim/nerdtree'		"file explorer
	Plug 'craigemery/vim-autotag'	"update ctags on save
	Plug 'Raimondi/delimitMate'		"auto pairs
	Plug 'michaelb/vim-tips'		"show a tip on startup
call plug#end()
"otherPlugins:
"Plug 'dense-analysis/ale'

"lightline plugin
set laststatus=2

"vim-markdown
"let g:vim_markdown_folding_level = 0
"let g:vim_markdown_override_foldtext = 0
"autocmd FileType markdown normal! zR	"open all folds on open

"NERDTree
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

nnoremap <leader>e :NERDTreeToggle<CR>	"toggle filetree
nnoremap <leader>r :NERDTreeFocus<CR>	"focus filetree

"vim-autotag
let g:autotagTagsFile=".tags"
"let g:autotagDisabled=""



endif
" end of vim only section
