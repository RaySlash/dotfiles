return {
	{
		"conform.nvim",
		for_cat = "formatter",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<C-f>",
				function()
					require("conform").format({ async = true })
				end,
				mode = { "n", "i" },
				desc = "Format buffer",
			},
		},
		before = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		after = function()
			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})

			---@param bufnr integer
			---@param ... string
			---@return string
			local function first(bufnr, ...)
				local conform = require("conform")
				for i = 1, select("#", ...) do
					local formatter = select(i, ...)
					if conform.get_formatter_info(formatter, bufnr).available then
						return formatter
					end
				end
				return select(1, ...)
			end

			require("conform").setup({
				formatters_by_ft = {
					c = { "clang-tools" },
					cpp = { "clang-tools" },
					elm = { "elm-format" },
					rust = { "rustfmt" },
					lua = { "stylua" },
					nix = { "alejandra" },
					python = function(bufnr)
						return { first(bufnr, "pyright", "prettierd") }
					end,
					javascript = function(bufnr)
						return { first(bufnr, "prettierd", "prettier") }
					end,
					javascriptreact = function(bufnr)
						return { first(bufnr, "prettierd", "prettier") }
					end,
					typescript = function(bufnr)
						return { first(bufnr, "prettierd", "prettier") }
					end,
					typescriptreact = function(bufnr)
						return { first(bufnr, "prettierd", "prettier") }
					end,
					sh = { "shfmt" },
					sql = { "sql-formatter" },
					toml = { "taplo" },
					markdown = function(bufnr)
						return { first(bufnr, "prettierd", "prettier") }
					end,
				},
				format_on_save = function(bufnr)
					-- Disable autoformat on certain filetypes
					-- local ignore_filetypes = { "sql" }
					-- if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					--   return
					-- end
					-- Disable autoformat for files in a certain path
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if bufname:match("/node_modules/") then
						return
					end
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_format = "fallback" }
				end,
				default_format_opts = {
					lsp_format = "fallback",
				},
			})
		end,
	},
}
