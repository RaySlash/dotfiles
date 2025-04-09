return {
	{
		"fzf-lua",
		for_cat = "general.fzf",
		after = function()
			require("fzf-lua").setup({ "fzf-native" })
		end,
		keys = {
			{
				"<leader>ff",
				function()
					return require("fzf-lua").files()
				end,
				mode = { "n" },
				desc = "Find files [fzf]",
				noremap = true,
			},
			{
				"<leader>fg",
				function()
					return require("fzf-lua").grep()
				end,
				mode = { "n" },
				desc = "Find string [fzf]",
				noremap = true,
			},
			{
				"<leader>fb",
				function()
					return require("fzf-lua").buffers()
				end,
				mode = { "n" },
				desc = "Find buffers [fzf]",
				noremap = true,
			},
		},
	},
}
