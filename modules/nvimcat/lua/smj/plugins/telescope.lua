return {
	{
		"telescope.nvim",
		for_cat = "general.telescope",
		event = "DeferredUIEnter",
		on_require = { "telescope" },
		keys = {
			{
				"<leader>ff",
				function()
					return require("telescope.builtin").find_files()
				end,
				mode = { "n" },
				desc = "Find files [Telescope]",
				noremap = true,
			},
			{
				"<leader>fg",
				function()
					return require("telescope.builtin").live_grep()
				end,
				mode = { "n" },
				desc = "Find string [Telescope]",
				noremap = true,
			},
			{
				"<leader>fb",
				function()
					return require("telescope.builtin").buffers()
				end,
				mode = { "n" },
				desc = "Find buffers [Telescope]",
				noremap = true,
			},
		},
		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("telescope-fzy-native.nvim")
			vim.cmd.packadd("telescope-frecency.nvim")
		end,
		after = function(_)
			local telescope = require("telescope")
			local extension = telescope.load_extension

			telescope.setup({
				defaults = {
					preview = {
						treesitter = true,
					},
					color_devicons = true,
					prompt_prefix = "   ",
					initial_mode = "insert",
					vimgrep_arguments = {
						"rg",
						"-L",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!**/.git/**",
					},
				},
				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					},
				},
			})
			pcall(extension, "fzy_native")
			pcall(extension, "noice")
			pcall(extension, "frecency")
			pcall(extension, "undo")
		end,
	},
}
