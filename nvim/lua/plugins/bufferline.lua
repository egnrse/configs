-- bufferline
return {
	--'akinsho/bufferline.nvim',
	'egnrse/bufferline.nvim',
	version = "*",
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup {
			options = {
				offsets = {
					{
						filetype = "NvimTree",
						text = "",
						text_align = "right", -- or "left","center"
						separator = true
					}
				},
				mode = 'tabs'
			}
		}
	end,
}

