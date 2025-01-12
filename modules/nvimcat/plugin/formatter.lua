if vim.g.did_load_formatter_plugin then
	return
end
vim.g.did_load_formatter_plugin = true

local formatter = require("formatter")
local util = require("formatter.util")

local settings = {
	c = {
		require("formatter.filetypes.c").clangformat,
	},
	dart = {
		require("formatter.filetypes.dart").dartformat,
	},
	cpp = {
		require("formatter.filetypes.cpp").clangformat,
	},
	css = {
		require("formatter.filetypes.css").prettierd,
	},
	less = {
		require("formatter.filetypes.css").prettierd,
	},
	scss = {
		require("formatter.filetypes.css").prettierd,
	},
	elm = {
		function()
			return {
				exe = "elm-format",
				args = {
					util.escape_path(util.get_current_buffer_file_path()),
					"--yes",
				},
				stdin = false,
				cwd = vim.fn.getcwd(),
				async = true,
			}
		end,
	},
	javascript = {
		require("formatter.filetypes.javascript").prettierd,
	},
	javascriptreact = {
		require("formatter.filetypes.javascriptreact").prettierd,
	},
	typescript = {
		require("formatter.filetypes.typescript").prettierd,
	},
	typescriptreact = {
		require("formatter.filetypes.typescriptreact").prettierd,
	},
	json = {
		require("formatter.filetypes.json").prettierd,
	},
	markdown = {
		require("formatter.filetypes.markdown").prettierd,
	},
	nix = {
		require("formatter.filetypes.nix").alejandra,
	},
	rust = {
		require("formatter.filetypes.rust").rustfmt,
		function()
			local project_root = vim.fn.getcwd()
			local leptosfmt_config = project_root .. "/leptosfmt.toml"

			if vim.fn.filereadable(leptosfmt_config) == 1 then
				return {
					exe = "leptosfmt",
					args = { "--stdin" },
					stdin = true,
					cwd = project_root,
				}
			end
		end,
	},
	sh = {
		require("formatter.filetypes.sh").shfmt,
	},
	sql = {
		require("formatter.filetypes.sql").sql_formatter,
	},
	toml = {
		require("formatter.filetypes.toml").taplo,
	},
	html = {
		require("formatter.filetypes.html").prettierd,
	},
	zig = {
		require("formatter.filetypes.zig").zigfmt,
	},
	yaml = {
		require("formatter.filetypes.yaml").prettierd,
	},
	lua = {
		require("formatter.filetypes.lua").stylua,
	},

	["*"] = {
		-- "formatter.filetypes.any" defines default configurations for any
		-- filetype
		require("formatter.filetypes.any").remove_trailing_whitespace,
		-- Format using lsp if not preconfigured
		function()
			-- Ignore already configured types.
			local defined_types = require("formatter.config").values.filetype
			if defined_types[vim.bo.filetype] ~= nil then
				return nil
			end
			vim.lsp.buf.format({ async = true })
		end,
		-- Remove trailing whitespace without 'sed'
		-- require("formatter.filetypes.any").substitute_trailing_whitespace,
	},
}

formatter.setup({
	logging = false,
	log_level = vim.log.levels.WARN,
	filetype = settings,
})
