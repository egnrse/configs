-- nvim-treesitter
-- needs curl,tar,tree-sitter-cli
-- see :checkhealth nvim-treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },

	opts = {
		ensure_installed = {
			"bash",
			"c",
			"caddy",
			"css",
			"diff",
			"dockerfile",
			"gdscript",
			"gdshader",
			"git_config",
			"git_rebase",
			"gitcommit",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"latex",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"rust",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
	},

	config = function(_, opts)
		local ts = require("nvim-treesitter")

		-- sanity checks
		if type(opts.ensure_installed) ~= "table" then
			error("ensure_installed must be a table")
		end

		-- install parsers
		ts.install(opts.ensure_installed)

		-- activate the parsers on the right filetypes
		vim.api.nvim_create_autocmd('FileType', {
			group = vim.api.nvim_create_augroup('treesitter.setup', {}),
			callback = function(args)
				local buf = args.buf
				local filetype = args.match

				-- you need some mechanism to avoid running on buffers that do not
				-- correspond to a language (like oil.nvim buffers), this implementation
				-- checks if a parser exists for the current language
				local language = vim.treesitter.language.get_lang(filetype) or filetype
				if not vim.treesitter.language.add(language) then
					return
				end

				-- syntax highlighting
				vim.treesitter.start(buf, language)

				-- folds (only active if supported by parser)
				if vim.treesitter.query.get(language, "folds") then
					vim.wo.foldmethod = 'expr'
					vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				end

				-- indentation (only active if supported by parser)
				if vim.treesitter.query.get(language, "indents") then
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
