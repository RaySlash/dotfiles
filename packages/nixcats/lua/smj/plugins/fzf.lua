return {
	{
		"fzf-lua",
		for_cat = "general.fzf",
		after = function()
			require("fzf-lua").setup({
				"telescope",
				files = {
					git_icons = true,
				},
				hls = {
					border = "FloatBorder",
					preview_border = "FloatBorder",
					help_border = "FloatBorder",
				},
				fzf_colors = true,
			})
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
					return require("fzf-lua").live_grep_native()
				end,
				mode = { "n" },
				desc = "Find string [fzf]",
				noremap = true,
			},
			{
				"<leader>fv",
				function()
					return require("fzf-lua").git_blame()
				end,
				mode = { "n" },
				desc = "Find in Git Blame [fzf]",
				noremap = true,
			},
			{
				"<leader>fc",
				function()
					return require("fzf-lua").git_commits()
				end,
				mode = { "n" },
				desc = "Find in Git Commits [fzf]",
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
