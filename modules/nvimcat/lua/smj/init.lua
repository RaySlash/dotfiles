require("smj.keybinds")
require("smj.options")

local lze = require("lze")

lze.register_handlers({
	require("smj.utils.lzUtils").for_cat,
	require("lzextras").lsp,
})

lze.load({
	{ import = "smj.plugins" },
})
