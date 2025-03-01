if require("nixCats").cats.general.core ~= true or vim.g.did_load_general_plugin then
	return
end
vim.g.did_load_general_plugin = true

local add_ftype = function(pattern)
	vim.filetype.add({
		pattern = pattern,
	})
end

add_ftype({ [".*/*/hypr.*%.conf"] = "hyprlang" })
add_ftype({ [".*/*/.*%.yuck"] = "yuck" })
add_ftype({ [".*%.purs"] = "purescript" })

require("nvim-autopairs").setup()
require("mini.surround").setup()
require("which-key").setup({
	preset = "helix",
})

if require("nixCats").cats.general.addons == true then
	require("nvim-highlight-colors").setup({
		enable_tailwind = true,
	})
end

if require("nixCats").cats.general.git == true then
	local neogit = require("neogit")

	neogit.setup({
		disable_builtin_notifications = true,
		disable_insert_on_commit = "auto",
		integrations = {
			diffview = true,
			telescope = true,
			fzf_lua = true,
		},
		sections = {
			---@diagnostic disable-next-line: missing-fields
			recent = {
				folded = false,
			},
		},
	})

	local keymap = vim.keymap

	keymap.set("n", "<leader>gg", neogit.open, { noremap = true, silent = true, desc = "neo[g]it open" })
	keymap.set("n", "<leader>gs", function()
		neogit.open({ kind = "auto" })
	end, { noremap = true, silent = true, desc = "neo[g]it open [s]plit" })
	keymap.set("n", "<leader>gc", function()
		neogit.open({ "commit" })
	end, { noremap = true, silent = true, desc = "neo[g]it [c]ommit" })
end
