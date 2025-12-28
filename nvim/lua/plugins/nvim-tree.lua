-- tree filemanager
return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw       = 1
		vim.g.loaded_netrwPlugin = 1
		vim.api.nvim_create_autocmd("QuitPre", {
			callback = function()
				local tree_wins = {}
				local floating_wins = {}
				local wins = vim.api.nvim_list_wins()
				for _, w in ipairs(wins) do
					local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
					if bufname:match("NvimTree_") ~= nil then
						table.insert(tree_wins, w)
					end
					if vim.api.nvim_win_get_config(w).relative ~= '' then
						table.insert(floating_wins, w)
					end
				end
				if 1 == #wins - #floating_wins - #tree_wins then
					-- Should quit, so we close all invalid windows.
					for _, w in ipairs(tree_wins) do
						vim.api.nvim_win_close(w, true)
					end
				end
			end
		})
		require("nvim-tree").setup {
			view = {
				adaptive_size = true,
			},
			renderer = {
				add_trailing = true,
				indent_markers = {
					enable = true
				}
			},
			-- custom mappings
			on_attach = function(bufnr)
				local api = require "nvim-tree.api"

				-- default mappings
				api.config.mappings.default_on_attach(bufnr)

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, desc)
				end

				-- custom mappings
				map("n", "?", 	api.tree.toggle_help,			opts("Help"))
				map("n", "t", 	api.node.open.tab,				opts("Open: New Tab"))

			end
		}
	end,
}

--[[
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
	  "nvim-lua/plenary.nvim",
	  "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	  "MunifTanjim/nui.nvim",
	  -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	}
}
]]
