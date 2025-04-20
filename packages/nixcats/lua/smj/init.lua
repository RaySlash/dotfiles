local g = vim.g
g.mapleader = " "
g.maplocalleader = " "
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.editorconfig = true

local lze = require("lze")
require("smj.color")

lze.register_handlers({
	require("smj.utils.lze").for_cat,
	require("lzextras").lsp,
})

lze.load({
	{ import = "smj.options" },
	{ import = "smj.keybinds" },
	{ import = "smj.plugins" },
})
