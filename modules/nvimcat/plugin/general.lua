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
