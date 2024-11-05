vim.cmd('source ~/.vimrc')		-- import some settings from vim

-- General Settings
vim.o.number = true				-- line numbers
vim.o.relativenumber = true		-- Enable relative line numbers
vim.o.tabstop = 4				-- Number of spaces a tab represents
vim.o.shiftwidth = 4			-- Number of spaces for each indentation
vim.o.smartindent = true		-- Automatically indent new lines
vim.o.wrap = false				-- Disable line wrapping
vim.o.cursorline = true			-- Highlight the current line
vim.o.termguicolors = true		-- Enable 24-bit RGB colors

vim.api.nvim_exec ('language en_US', true)

require("config.lazy")	--plugins
require("maps")			--keymappings
