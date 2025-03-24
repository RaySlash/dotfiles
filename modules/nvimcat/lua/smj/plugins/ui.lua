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
		"noice.nvim",
		for_cat = "ui.core",
		event = "UIEnter",
		load = function(name)
			vim.cmd.packadd("nui.nvim")
			vim.cmd.packadd(name)
		end,
		after = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
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
		"kanagawa.nvim",
		for_cat = "ui.core",
		event = "UIEnter",
		before = function()
			vim.o.background = "dark"
		end,
		after = function()
			---@diagnostic disable: missing-fields
			require("kanagawa").setup({
				transparent = true,
				background = {
					dark = "dragon",
					light = "lotus",
				},
				overrides = function(colors)
					local theme = colors.theme
					local makeDiagnosticColor = function(color)
						local c = require("kanagawa.lib.color")
						return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
					end
					return {
						-- This immitates a style of diagnostic messages seen OR Tint background of diagnostic messages with their foreground color
						DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
						DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
						DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
						DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
						-- Use Telescope Block UI
						TelescopeTitle = { fg = theme.ui.special, bold = true },
						TelescopePromptNormal = { bg = theme.ui.bg_p1 },
						TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
						TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
						TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
						TelescopePreviewNormal = { bg = theme.ui.bg_dim },
						TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
						-- More uniform colors for the popup menu.
						Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
						PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
						PmenuSbar = { bg = theme.ui.bg_m1 },
						PmenuThumb = { bg = theme.ui.bg_p2 },
					}
				end,
				-- Remove the background of LineNr, {Sign,Fold}Column and friends
				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none",
							},
						},
					},
				},
			})
			vim.cmd.colorscheme("kanagawa")
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
	{
		"colorful-menu.nvim",
		for_cat = "ui.core",
		after = function()
			require("colorful-menu").setup({})
		end,
	},
	{
		"blink.cmp",
		for_cat = "ui.core",
		after = function()
			require("blink.cmp").setup({
				sources = { default = { "lsp", "buffer", "snippets", "path" } },
				keymap = {
					preset = "enter",
				},
				appearance = { nerd_font_variant = "normal" },
				completion = {
					menu = {
						draw = {
							treesitter = { "lsp" },
							-- We don't need label_description now because label and label_description are already
							-- combined together in label by colorful-menu.nvim.
							columns = { { "kind_icon" }, { "label", gap = 1 } },
							components = {
								label = {
									text = function(ctx)
										return require("colorful-menu").blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require("colorful-menu").blink_components_highlight(ctx)
									end,
								},
							},
						},
					},
				},
			})
		end,
	},
}
