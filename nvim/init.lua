-- nvim config by egnrse
-- (https://github.com/egnrse/configs)
--
-- split into multiple parts:
-- 	-./init.lua		: general configurations
-- 	-./lua/maps.lua	: key mappings and custom commands
--	-./lua/plugins/	: plugins managed by Lazy (`:Lazy`)


if vim.fn.filereadable("~/.vimrc") == 1 then
	vim.cmd('source ~/.vimrc')	-- import some settings from vim
end

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

vim.env.LANG = "en_US.UTF-8"
-- use alacritty if it exists
if vim.fn.executable("alacritty") == 1 then
	vim.env.TERMINAL = "alacritty"
end

require("config.lazy")	--plugins
require("maps")			--keymappings

-- change colors
--vim.api.nvim_set_hl(0, "Normal", {fg = "#FFFFFF", bg = "#071020"} )
--require('lush')(require('tokyodark'))	--colorscheme

local lspconfig = require('lspconfig')
lspconfig.bashls.setup{}

