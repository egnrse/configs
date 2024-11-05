-- bufferline
return {
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = {
		'nvim-tree/nvim-web-devicons',
--		'nvim-tree/nvim-tree.lua',
	},
	config = function()
		require("bufferline").setup {
			options = {
				offsets = {
					{
						filetype = "NvimTree",
						text = "",
						text_align = "right", -- or "left","center"
						separator = true
					}
				}

			}
		}
	end,
}

