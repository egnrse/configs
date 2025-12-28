-- lsp configurations
return {
	"neovim/nvim-lspconfig",
	config = function()
		-- Configure LSP here after loading
		local lspconfig = require('lspconfig')
		--lspconfig.bashls.setup{}
	end 
}
