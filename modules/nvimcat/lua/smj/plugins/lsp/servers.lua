return {
	{
		"ccls",
		lsp = {
			filetypes = { "c", "cpp" },
		},
	},
	{
		"cssls",
		lsp = {
			filetypes = { "css", "less", "scss" },
			settings = {
				less = { validate = true },
				css = { validate = true },
				scss = { validate = true },
			},
		},
	},
	{
		"elmls",
		lsp = {
			filetypes = { "elm" },
		},
	},
	{
		"html",
		lsp = {
			filetypes = { "html" },
		},
	},
	{
		"hls",
		lsp = {
			filetypes = { "haskell" },
		},
	},
	{
		"marksman",
		lsp = {
			filetypes = { "markdown" },
		},
	},
	{
		"ts_ls",
		lsp = {
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		},
	},
	{
		"tailwindcss",
		lsp = {
			filetypes = { "typescriptreact", "javascriptreact" },
		},
	},
	{
		"puresciptls",
		lsp = {
			filetypes = { "purescipt", "purs" },
		},
	},
	{
		"jdtls",
		lsp = {
			filetypes = { "java" },
		},
	},
	{
		"zls",
		lsp = {
			filetypes = {
				"zig",
			},
		},
	},
	{
		"rust_analyzer",
		lsp = {
			filetypes = { "rust" },
			settings = {
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
			},
		},
	},
	{
		"lua_ls",
		lsp = {
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "nixCats", "vim", "make_test" },
						disable = {
							"missing-fields",
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
		},
	},
	{
		"nixd",
		after = function()
			vim.api.nvim_create_user_command("StartNilLSP", function()
				require("lspconfig").nil_ls.setup({
					capabilities = require("smj.utils.lsp").get_capabilities("nil_ls"),
				})
			end, { desc = "Run nil-ls (when you really need docs for the builtins and nixd refuse)" })
		end,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					nixpkgs = {
						expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
					},
					formatting = {
						command = { "nixfmt" },
					},
					options = {
						-- (builtins.getFlake "<path_to_system_flake>").legacyPackages.<system>.nixosConfigurations."<user@host>".options
						nixos = {
							expr = nixCats.extra("nixdExtras.nixos_options"),
						},
						-- (builtins.getFlake "<path_to_system_flake>").legacyPackages.<system>.homeConfigurations."<user@host>".options
						["home-manager"] = {
							expr = nixCats.extra("nixdExtras.home_manager_options"),
						},
					},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
}
