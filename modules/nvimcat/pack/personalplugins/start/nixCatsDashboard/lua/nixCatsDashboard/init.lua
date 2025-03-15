-- Dashboard plugin to show a floating buffer with info from
-- <cmd>NixCats pawsible<CR>
-- <cmd>NixCats cats<CR>

local M = {}

local nixcats = require("nixCats")

local newbuf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_option_value("filetype", "nixcatdashboard", { buf = newbuf })

return M
