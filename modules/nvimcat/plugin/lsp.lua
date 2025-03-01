if require("nixCats").cats.lsp ~= true or vim.g.did_load_lspconfig_plugin then
	return
end
vim.g.did_load_lspconfig_plugin = true

require("lazydev").setup({
	enabled = function(root_dir)
		return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
	end,
	-- Only load luvit types when the `vim.uv` word is found
	{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
})

require("trouble").setup({})
local keymap = vim.keymap
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", {
	desc = "Diagnostics (Trouble)",
	noremap = true,
	silent = true,
})
keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", {
	desc = "Buffer Diagnostics (Trouble)",
	noremap = true,
	silent = true,
})
keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", {
	desc = "Symbols (Trouble)",
	noremap = true,
	silent = true,
})
keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", {
	desc = "LSP Definitions / References (Trouble)",
	noremap = true,
	silent = true,
})
keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", {
	desc = "Location List (Trouble)",
	noremap = true,
	silent = true,
})
keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", {
	desc = "Quickfix List (Trouble)",
	noremap = true,
	silent = true,
})

local lspconfig = require("lspconfig")
lspconfig.ccls.setup({})
lspconfig.cssls.setup({
	less = { validate = true },
	css = { validate = true },
	scss = { validate = true },
})
lspconfig.dartls.setup({})
lspconfig.elmls.setup({})
lspconfig.html.setup({})
lspconfig.hls.setup({})
lspconfig.marksman.setup({})
lspconfig.ts_ls.setup({})
lspconfig.tailwindcss.setup({})
lspconfig.nil_ls.setup({})
lspconfig.nixd.setup({})
lspconfig.purescriptls.setup({})
lspconfig.jdtls.setup({})
lspconfig.zls.setup({})
lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			lens = { enable = true, implementations = true },
			diagnostics = { enable = true },
			procMacro = {
				enable = true,
				ignored = {
					leptos_macro = {
						"server",
					},
				},
			},
		},
	},
})
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				disable = {
					"duplicate-set-field",
				},
			},
			workspace = {
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
			},
		},
	},
})
