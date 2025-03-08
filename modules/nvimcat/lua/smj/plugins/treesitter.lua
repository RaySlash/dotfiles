return {
	"treesitter",
	on_cat = "general.treesitter",
	event = "DeferredUIEnter",
	before = function()
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.g.skip_ts_context_comment_string_module = true
	end,
	after = function()
		local npairs = require("nvim-autopairs")
		local configs = require("nvim-treesitter.configs")

		---@diagnostic disable-next-line: missing-fields
		configs.setup({
			auto_install = false,
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 100 * 1024 -- 100 KiB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aC"] = "@call.outer",
						["iC"] = "@call.inner",
						["a#"] = "@comment.outer",
						["i#"] = "@comment.outer",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.outer",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["aP"] = "@parameter.outer",
						["iP"] = "@parameter.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]P"] = "@parameter.outer",
					},
					goto_next_end = {
						["]m"] = "@function.outer",
						["]P"] = "@parameter.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[P"] = "@parameter.outer",
					},
					goto_previous_end = {
						["[m"] = "@function.outer",
						["[P"] = "@parameter.outer",
					},
				},
				nsp_interop = {
					enable = true,
					peek_definition_code = {
						["df"] = "@function.outer",
						["dF"] = "@class.outer",
					},
				},
			},
		})

		require("treesitter-context").setup({
			max_lines = 3,
		})

		require("ts_context_commentstring").setup()

		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
			},
		})
	end,
}
