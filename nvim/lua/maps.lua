-- ----------- --
-- Keymappings --
-- ----------- --
-- for nvim by egnrse
-- (https://github.com/egnrse/configs)
--
-- sorted into:
-- 	- General		(save, clipboard, ..)
-- 	- Windows:		(Buffer management)
-- 		Buffers (Navigation), Size Managing, Terminal, FileManager
-- 	- Custom Commands / Other
--
--
-- TODO: <leader>
-- relative Number toggle
-- understand fix cmp
-- add better linting

vim.g.mapleader = ' '		-- Space as the leader key

-- function for easier/faster remapping of keys
-- (vim-mode, KeyMap, function [, options])
local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
end

-- General
--map("n", "<leader>w", "<CMD>update<CR>")	--save (n)
map("n", "<C-s>", "<CMD>update<CR>")		--save (n)
map("i", "<C-s>", "<CMD>update<CR>")		--save (i)
map("v", "<C-c>", '"+y')					--copy clipboard (v)
map("n", "<C-c>", '"+yy')					--copy line (n)
map("i", "<C-v>", '<C-r>+')					--insert clipboard (i)
map("n", "<C-v>", "<C-q>")					--visual block mode (n)

map("c", "<Tab>", "<C-z>")					--tab-autocompletation in commands (c)

--vim.api.nvim_del_keymap('n', '<C-v>')		--delete a mapping


-- WINDOWS --
-- Buffer (Navigation)
map("n", "<leader><Tab>", "<CMD>bnext<CR>") --next (n)
map("n", "<leader>bn", "<CMD>bnext<CR>")	--next (n)
map("n", "<leader><S-Tab>", "<CMD>bp<CR>")	--previous (n)
map("n", "<leader>bp", "<CMD>bprevious<CR>")--previous (n)
map("n", "<leader>q", "<CMD>bd<CR>")		--close (n)
map("n", "<leader>bd", "<CMD>bd<CR>")		--close (n)
map("n", "<leader>bD", "<CMD>bd!<CR>")		--close (n)

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Size Managing
map("n", "<leader>|", ":vsplit<CR>")		--vertical split
map("n", "<leader>-", ":split<CR>")			--horizontal split
map("n", "<leader>wm", ":only<CR>")			--maximize current

map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

--Terminal
local term = ""
if vim.fn.has('win64') == 1 then
	term = "powershell.exe"
end
map("n", "<leader>th", ":belowright split | terminal " .. term .."<CR>")	--open terminal horizontal
map("n", "<leader>tv", ":belowright vsplit | terminal " .. term .."<CR>")	--open terminal vertical
map("t", "<Esc><Esc>", "<C-\\><C-n>")			-- switch from terminal-mode to normal-mode

-- FileManager
map("n", "<leader>e", "<CMD>NvimTreeToggle<CR>")
map("n", "<leader>r", "<CMD>NvimTreeFocus<CR>")
vim.cmd([[autocmd FileType NvimTree nmap <buffer> <space> <CR>]])	-- in nvim-tree map space to enter ('<CR>')
vim.api.nvim_create_user_command('E', ':NvimTreeToggle', {})


-- Custom Commands
vim.api.nvim_create_user_command('W', ':w', {})			--save
vim.api.nvim_create_user_command('Wq', ':wq', {})		--save+close
vim.api.nvim_create_user_command('WA', ':wq', {})		--save+close
vim.api.nvim_create_user_command('Q', ':qa', {})		--close all
