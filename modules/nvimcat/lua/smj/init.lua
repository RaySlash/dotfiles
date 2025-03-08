local g = vim.g
g.mapleader = " "
g.maplocalleader = " "
g.editorconfig = true

local lze = require("lze")

lze.register_handlers({
	require("smj.utils.lze").for_cat,
	require("lzextras").lsp,
})

lze.load({
	{ import = "smj.options" },
	{ import = "smj.keybinds" },
	{ import = "smj.plugins" },
})
