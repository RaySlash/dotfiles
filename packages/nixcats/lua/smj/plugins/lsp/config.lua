return {
	{
		"nvim-lspconfig",
		for_cat = "lsp",
		on_require = { "lspconfig" },
		before = function(_)
			vim.lsp.config("*", {
				on_attach = require("smj.utils.lsp").on_attach,
			})
		end,
		lsp = function(plugin)
			vim.lsp.config(plugin.name, plugin.lsp or {})
			vim.lsp.enable(plugin.name)
			-- require("lspconfig")[plugin.name].setup(vim.tbl_extend("force", {
			-- 	capabilities = require("smj.utils.lsp").get_capabilities(plugin.name),
			-- 	on_attach = require("smj.utils.lsp").on_attach,
			-- }, plugin.lsp or {}))
		end,
	},
}
