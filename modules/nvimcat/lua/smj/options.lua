return {
	{
		"options",
		load = function()
			vim.cmd.filetype("plugin", "indent", "on")
			vim.cmd.packadd("cfilter")
		end,
		before = function()
			local opt = vim.o
			opt.termguicolors = true
			opt.path = vim.o.path .. "**"
			opt.number = true
			opt.clipboard = "unnamedplus"
			opt.relativenumber = true
			opt.cursorline = true
			opt.showmatch = true
			opt.incsearch = true
			opt.hlsearch = true
			opt.spell = false
			opt.spelllang = "en"
			opt.autoread = true
			opt.expandtab = true
			opt.tabstop = 2
			opt.softtabstop = 2
			opt.shiftwidth = 2
			opt.foldenable = true
			opt.history = 2000
			opt.nrformats = "bin,hex" -- 'octal'
			opt.undofile = true
			opt.splitright = true
			opt.splitbelow = true
			opt.cmdheight = 0
			opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
			opt.colorcolumn = "100"
			local function prefix_diagnostic(prefix, diagnostic)
				return string.format(prefix .. " %s", diagnostic.message)
			end

			vim.diagnostic.config({
				virtual_text = {
					prefix = "",
					format = function(diagnostic)
						local severity = diagnostic.severity
						if severity == vim.diagnostic.severity.ERROR then
							return prefix_diagnostic("󰅚", diagnostic)
						end
						if severity == vim.diagnostic.severity.WARN then
							return prefix_diagnostic("⚠", diagnostic)
						end
						if severity == vim.diagnostic.severity.INFO then
							return prefix_diagnostic("ⓘ", diagnostic)
						end
						if severity == vim.diagnostic.severity.HINT then
							return prefix_diagnostic("󰌶", diagnostic)
						end
						return prefix_diagnostic("■", diagnostic)
					end,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN] = "⚠",
						[vim.diagnostic.severity.INFO] = "ⓘ",
						[vim.diagnostic.severity.HINT] = "󰌶",
					},
				},
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "if_many",
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
