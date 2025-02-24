if vim.g.did_load_lspconfig_plugin then
	return
end
vim.g.did_load_lspconfig_plugin = true

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
