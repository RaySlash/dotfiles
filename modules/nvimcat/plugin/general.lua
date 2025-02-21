if vim.g.did_load_general_plugin then
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

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs
require("nvim-highlight-colors").setup({
	enable_tailwind = true,
})
require("nvim-autopairs").setup()
require("mini.surround").setup()
require("which-key").setup({
	preset = "helix",
})
