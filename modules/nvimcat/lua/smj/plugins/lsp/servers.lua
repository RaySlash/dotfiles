return {
	-- TODO: Upon adding settings to server, we get error. Fix it
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
					capabilities = require("smj.utils.lspUtils").get_capabilities("nil_ls"),
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
