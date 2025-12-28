return {
	{
		-- make color strings colorfull
		'norcalli/nvim-colorizer.lua',
		lazy = true,
		init = function()
			require'colorizer'.setup({
				'*',	-- HIghlight all files
				css = {css = true},
			})
		end,
	},
	--show a tip on startup
	'michaelb/vim-tips',
}
