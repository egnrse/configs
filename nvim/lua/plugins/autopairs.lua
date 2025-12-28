-- autopairing
return {
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		-- autoclose html tags
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	}
}
