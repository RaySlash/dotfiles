return {
	{
		"lazydev",
		for_cat = "lsp",
		ft = "lua",
		after = function(_)
			require("lazydev").setup({
				library = {
					{
						words = { "uv", "vim%.uv", "vim%.loop" },
						path = (nixCats.pawsible({ "allPlugins", "start", "luvit-meta" }) or "luvit-meta")
							.. "/library",
					},
					{ words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
				},
			})
		end,
	},
	{
		"trouble",
		for_cat = "lsp",
		event = "LspAttach",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostic toggle<CR>", mode = { "n" }, desc = "Diagnostics [Trouble]" },
			{
				"<leader>xl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
				mode = { "n" },
				desc = "LSP Definitions/References [Trouble]",
			},
		},
		after = function(_)
			require("trouble").setup({})
		end,
	},
}
