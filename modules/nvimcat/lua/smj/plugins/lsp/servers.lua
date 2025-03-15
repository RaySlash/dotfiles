return {
	{
		"ccls",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "c", "cpp" },
		},
	},
	{
		"pyright",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "python" },
		},
	},
	{
		"cssls",
		enabled = nixCats("lsp"),
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
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "elm" },
		},
	},
	{
		"html",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "html" },
		},
	},
	{
		"hls",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "haskell" },
		},
	},
	{
		"marksman",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "markdown" },
		},
	},
	{
		"ts_ls",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		},
	},
	{
		"tailwindcss",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "typescriptreact", "javascriptreact" },
		},
	},
	{
		"puresciptls",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "purescipt", "purs" },
		},
	},
	{
		"jdtls",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = { "java" },
		},
	},
	{
		"zls",
		enabled = nixCats("lsp"),
		lsp = {
			filetypes = {
				"zig",
			},
		},
	},
	{
		"rust_analyzer",
		enabled = nixCats("lsp"),
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
		enabled = nixCats("lsp"),
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
		enabled = nixCats("lsp"),
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
