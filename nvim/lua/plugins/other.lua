return {
	{
		-- markdown
		-- follow md links with <CR>
		'jghauser/follow-md-links.nvim',
		lazy = true,
	},
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
	}
}
