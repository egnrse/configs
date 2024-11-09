vim.cmd('source ~/.vimrc')		-- import some settings from vim

-- General Settings
vim.o.number = true				-- line numbers
vim.o.relativenumber = true		-- enable relative line numbers
vim.o.tabstop = 4				-- number of spaces a tab represents
vim.o.shiftwidth = 4			-- number of spaces for each indentation
vim.o.mouse = a					-- allow all mouse interations

vim.o.hls = true				-- search hilghlighting [noh]
vim.o.smartcase = true			-- make search case insensitive for only lowercase search
vim.o.smartindent = true		-- automatically indent new lines
vim.o.wrap = true				-- line wrapping

vim.o.visualbell = true
vim.o.cursorline = true			-- highlight the current line
vim.o.termguicolors = true		-- enable 24-bit RGB colors

vim.api.nvim_exec ('language en_US', true)

require("config.lazy")	--plugins
require("maps")			--keymappings
