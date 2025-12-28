-- nvim config by egnrse
-- (https://github.com/egnrse/configs)
--
-- split into multiple parts:
-- 	-./init.lua		: general configurations
-- 	-./lua/maps.lua	: key mappings and custom commands
--	-./lua/plugins/	: plugins managed by Lazy (`:Lazy`)


--if vim.fn.filereadable("~/.vimrc") == 1 then
--	vim.cmd('source ~/.vimrc')	-- import some settings from vim
--end

-- General Settings
vim.o.number = true				-- line numbers
vim.o.relativenumber = true		-- enable relative line numbers
vim.o.expandtab = false			-- use tabs
vim.o.tabstop = 4				-- number of spaces a tab represents
vim.o.shiftwidth = 4			-- number of spaces for each indentation
vim.o.mouse = a					-- allow all mouse interations
vim.o.modeline = true			-- activate modeline (eg. # vim: set ts=2 sw=2 sts=2 et:)
vim.o.modelines = 5				-- lines from start/end of file to search for modeline

vim.o.hls = true				-- search highlighting [noh]
vim.o.smartcase = true			-- make search case insensitive for only lowercase search
vim.o.ignorecase = true			-- needed by the previous setting
vim.o.smartindent = true		-- automatically indent new lines
vim.o.wrap = true				-- line wrapping

vim.o.visualbell = true
vim.o.cursorline = true			-- highlight the current line
vim.o.termguicolors = true		-- enable 24-bit RGB colors

vim.o.title = true				-- set a custom title string
vim.o.titlelen = 70				-- limit the max lenght of the title
vim.o.titlestring = "Nvim: %<%f"-- relative filepath, truncated from the left

-- when opening multiple files, open them in tabs instead (does sadly destroy syntax highlighting)
--vim.api.nvim_create_autocmd("VimEnter", {
--	once = true,
--	command = "tab all"
--})

-- Folds
-- close: zc / open: zo / zR: open all folds
vim.o.foldlevel=99 			-- start with folds open

-- to initialize a project folder: 'ctags --extras=+q -R -f .tags .'
vim.o.tags = "tags,./.tags;/"	-- search for '.tag' files (also in parent directories)

vim.env.LANG = "en_US.UTF-8"
-- use alacritty if it exists
if vim.fn.executable("alacritty") == 1 then
	vim.env.TERMINAL = "alacritty"
end

-- force tabs more aggressively
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- skip some filetypes
		if vim.bo.filetype == "yaml" then return end
		vim.opt_local.expandtab = false	-- use tabs instead of spaces
	end,
})

require("config.lazy")	--plugins
require("maps")			--keymappings

-- change colors
--vim.api.nvim_set_hl(0, "Normal", {fg = "#FFFFFF", bg = "#071020"} )
--require('lush')(require('tokyodark'))	--colorscheme

--local lspconfig = require('lspconfig')
--lspconfig.bashls.setup{}

