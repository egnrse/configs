return {
	"tiagovla/tokyodark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme tokyodark")

		-- custom colors for folds
		vim.api.nvim_set_hl(0, "Folded", {
			ctermbg = "Black",
			ctermfg = "Grey",
			bg = "Black",
			fg = "Grey",
		})
	end,
}
