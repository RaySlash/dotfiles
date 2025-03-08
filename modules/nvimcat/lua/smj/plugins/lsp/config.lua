return {
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
			})
		end,
	},
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		on_require = { "lspconfig" },
		lsp = function(plugin)
			require("lspconfig")[plugin.name].setup(vim.tbl_extend("force", {
				capabilities = require("smj.utils.lsp").get_capabilities(plugin.name),
				on_attach = require("smj.utils.lsp").on_attach,
			}, plugin.lsp or {}))
		end,
	},
}
