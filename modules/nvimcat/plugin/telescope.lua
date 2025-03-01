if require("nixCats").cats.general.telescope ~= true or vim.g.did_load_telescope_plugin then
	return
end
vim.g.did_load_telescope_plugin = true

local telescope = require("telescope")
local actions = require("telescope.actions")

local builtin = require("telescope.builtin")
local keymap = vim.keymap

local layout_config = {
	horizontal = {
		width = function(_, max_columns)
			return math.floor(max_columns * 0.80)
		end,
		height = function(_, _, max_lines)
			return math.floor(max_lines * 0.80)
		end,
		prompt_position = "bottom",
		preview_cutoff = 0,
	},
}

-- Fall back to find_files if not in a git repo
local project_files = function()
	local opts = {} -- define here if you want to define something
	local ok = pcall(builtin.git_files, opts)
	if not ok then
		builtin.find_files(opts)
	end
end

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
	local current_file_ext = vim.fn.expand("%:e")
	local additional_vimgrep_arguments = {}
	if current_file_ext ~= "" then
		additional_vimgrep_arguments = {
			"--type",
			current_file_ext,
		}
	end
	local conf = require("telescope.config").values
	picker({
		vimgrep_arguments = vim.tbl_flatten({
			conf.vimgrep_arguments,
			additional_vimgrep_arguments,
		}),
	})
end

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
	grep_current_file_type(builtin.grep_string)
end

keymap.set("n", "<leader>ff", function()
	builtin.find_files()
end, { desc = "[t]elescope find files - ctrl[p] style" })
keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[telescope] old files" })
keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[telescope] live grep" })
keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>")
keymap.set(
	"n",
	"<leader>t*",
	grep_string_current_file_type,
	{ desc = "[t]elescope grep current string [*] in current filetype" }
)
keymap.set("n", "<leader>*", builtin.grep_string, { desc = "[telescope] grep current string [*]" })
keymap.set("n", "<leader>tg", project_files, { desc = "[t]elescope project files [g]" })
keymap.set("n", "<leader>tc", builtin.quickfix, { desc = "[t]elescope quickfix list [c]" })
keymap.set("n", "<leader>tq", builtin.command_history, { desc = "[t]elescope command history [q]" })
keymap.set("n", "<leader>tl", builtin.loclist, { desc = "[t]elescope [l]oclist" })
keymap.set("n", "<leader>tr", builtin.registers, { desc = "[t]elescope [r]egisters" })
keymap.set("n", "<leader>tbb", builtin.buffers, { desc = "[t]elescope [b]uffers [b]" })
keymap.set(
	"n",
	"<leader>tbf",
	builtin.current_buffer_fuzzy_find,
	{ desc = "[t]elescope current [b]uffer [f]uzzy find" }
)
keymap.set("n", "<leader>td", builtin.lsp_document_symbols, { desc = "[t]elescope lsp [d]ocument symbols" })
keymap.set(
	"n",
	"<leader>to",
	builtin.lsp_dynamic_workspace_symbols,
	{ desc = "[t]elescope lsp dynamic w[o]rkspace symbols" }
)

telescope.setup({
	defaults = {
		path_display = {
			"truncate",
		},
		layout_strategy = "horizontal",
		layout_config = layout_config,
		mappings = {
			i = {
				["<C-q>"] = actions.send_to_qflist,
				["<C-l>"] = actions.send_to_loclist,
				-- ['<esc>'] = actions.close,
				["<C-s>"] = actions.cycle_previewers_next,
				["<C-a>"] = actions.cycle_previewers_prev,
			},
			n = {
				q = actions.close,
			},
		},
		preview = {
			treesitter = true,
		},
		history = {
			path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
			limit = 1000,
		},
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" },
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob",
			"!**/.git/**",
		},
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
})

telescope.load_extension("fzy_native")
telescope.load_extension("noice")
telescope.load_extension("frecency")
telescope.load_extension("undo")
