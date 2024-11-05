-- Keymappings

-- (mode, KeyMap, function [, options])
local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- general
map("n", "<leader>w", "<CMD>update<CR>")	--save

-- FileManager
map("n", "<leader>e", "<CMD>NvimTreeToggle<CR>")
map("n", "<leader>r", "<CMD>NvimTreeFocus<CR>")
vim.cmd([[autocmd FileType NvimTree nmap <buffer> <space> <CR>]])	-- in nvim-tree map space to enter ('<CR>')

-- Windows
-- Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resizing
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")


-- Custom Commands
vim.api.nvim_create_user_command('W', ':w', {})			--save
vim.api.nvim_create_user_command('Q', ':qa', {})		--close
vim.api.nvim_create_user_command('E', ':NvimTreeToggle', {})
