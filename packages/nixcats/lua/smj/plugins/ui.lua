return {
	{
		"lualine.nvim",
		for_cat = "ui.core",
		event = "DeferredUIEnter",
		after = function()
			require("lualine").setup({
				globalstatus = true,
				options = {
					theme = "auto",
					icons_enabled = true,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
				extensions = { "fugitive", "fzf", "toggleterm", "quickfix" },
			})
		end,
	},
	{
		"statuscol.nvim",
		for_cat = "ui.core",
		event = "DeferredUIEnter",
		on_require = { "statuscol" },
		after = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				setopt = true,
				relculright = true,
				segments = {
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
				},
			})
		end,
	},
	{
		"dashboard-nvim",
		for_cat = "ui.core",
		event = "DeferredUIEnter",
		after = function()
			require("dashboard").setup({
				theme = "hyper",
				shortcut_type = "number",
				config = {
					shortcut = {},
					week_header = { enable = true },
					packages = { enable = false },
				},
			})
		end,
	},
	{
		"vim-startuptime",
		for_cat = "ui.core",
		before = function(_)
			vim.g.startuptime_event_width = 0
			vim.g.startuptime_tries = 10
			vim.g.startuptime_exe_path = require("nixCats").packageBinPath
		end,
	},
	{
		"nvim-highlight-colors",
		for_cat = "ui.addons",
		event = "DeferredUIEnter",
		-- ft = "",
		after = function(_)
			require("nvim-highlight-colors").setup({
				render = "virtual",
				virtual_symbol = "■",
				enable_named_colors = true,
				enable_tailwind = true,
			})
		end,
	},
}
