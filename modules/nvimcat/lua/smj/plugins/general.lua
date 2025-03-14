return {
	{
		"undotree",
		for_cat = "general.core",
		event = "DeferredUIEnter",
		keys = { { "<leader>ut", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree", noremap = true } },
		before = function(_)
			vim.g.undotree_WindowLayout = 1
			vim.g.undotree_SplitWidth = 40
		end,
	},
	{
		"nvim-autopairs",
		on_cat = "general.core",
		event = "InsertEnter",
		on_require = { "nvim-autopairs" },
		after = function(_)
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"nvim-surround",
		on_cat = "general.core",
		event = "DeferredUIEnter",
		after = function(_)
			require("nvim-surround").setup({})
		end,
	},
	{
		"which-key.nvim",
		on_cat = "general.core",
		event = "DeferredUIEnter",
		after = function(_)
			require("which-key").setup({
				preset = "helix",
			})
		end,
	},
	{
		"leap.nvim",
		on_cat = "general.core",
		event = "DeferredUIEnter",
		keys = {
			{ "s", "<Plug>(leap-forward)", mode = { "n", "x" }, desc = "Find Forward [Leap]", noremap = true },
			{ "S", "<Plug>(leap-backward)", mode = { "n", "x" }, desc = "Find Backwards [Leap]", noremap = true },
		},
	},
	{
		"auto-session",
		on_cat = "general.core",
		before = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
		after = function()
			require("auto-session").setup({
				suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
				bypass_save_filetypes = { "dashboard", "netrw", "oil" },
			})
		end,
	},
	{
		"neogit",
		on_cat = "general.git",
		event = "DeferredUIEnter",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<CR>", mode = { "n" }, desc = "Git Console [Neogit]", noremap = true },
		},
		after = function()
			require("neogit").setup({
				commit_date_format = "strftime",
			})
		end,
	},
}
