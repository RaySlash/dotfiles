return {
	{
		"colorful-menu.nvim",
		for_cat = "lsp",
		after = function()
			require("colorful-menu").setup({})
		end,
	},
	{
		"blink.cmp",
		for_cat = "lsp",
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
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		on_requie = { "lspconfig" },
		lsp = function(plugin)
			require("lspconfig")[plugin.name].setup(vim.tbl_extend("force", {
				capabilities = require("smj.utils.lsp").get_capabilities(plugin.name),
				on_attach = require("smj.utils.lsp").on_attach,
			}, plugin.lsp or {}))
		end,
	},
}
