return {
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
