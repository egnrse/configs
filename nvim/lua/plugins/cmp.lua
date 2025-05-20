-- autocompletion
return {
	{
		"hrsh7th/nvim-cmp",
		event = {"InsertEnter", "CmdlineEnter"},
		dependencies = {
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- source for file system paths
			"hrsh7th/cmp-cmdline",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
			},
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",		-- vs-code like pictograms
			-- sources
			"max397574/cmp-greek",		-- accessed with eg :alpha:
			"SergioRibera/cmp-dotenv",	-- environmet variables
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local luasnip = require("luasnip")


			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = {
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, {"i","s","c"}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {"i","s","c"}),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({
								behavior = cmp.ConfirmBehavior.Replace,
								select = true,
							})
						else
							fallback()
						end
					end, {"i", "s"}),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "greek" },		-- greek letters
					{
						name = "dotenv",	-- env variables
						option = {
							path = ".",
							load_shell = true,
							item_kind = cmp.lsp.CompletionItemKind.Variable,
							eval_on_confirm = false,
							show_documentation = true,
							show_content_on_docs = true,
							documentation_kind = 'markdown',
							dotenv_environment = '.*',	-- which var to load
						}
					},
				}),
			})

			vim.cmd([[
			set completeopt=menuone,noinsert,noselect
			highlight! default link CmpItemKind CmpItemMenuDefault
			]])
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Configure LSP here after loading
			local lspconfig = require('lspconfig')
			--lspconfig.bashls.setup{}
		end 
	},

}
