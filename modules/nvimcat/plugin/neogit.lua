if require("nixCats").cats.general.git ~= true or vim.g.did_load_neogit_plugin then
	return
end
vim.g.did_load_neogit_plugin = true

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
