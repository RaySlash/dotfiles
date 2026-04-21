-- Movement
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", {
  noremap = true,
  expr = true,
  desc = 'Move Cursor Down',
})

vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", {
  noremap = true,
  expr = true,
  desc = 'Move Cursor Up',
})

-- Basic operations
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<CR>', {
  noremap = true,
  desc = 'Lazy manager UI dashboard',
})

vim.keymap.set('n', '<C-q>', '<cmd>q!<CR>', {
  noremap = true,
  desc = 'Quit session',
})

vim.keymap.set('n', '<C-x><C-s>', '<cmd>w!<CR>', {
  noremap = true,
  desc = 'Save File',
})

vim.keymap.set('n', '<Esc>', '<cmd>noh<CR><Esc>', {
  noremap = true,
  desc = 'Escape and Clear hlsearch',
})

vim.keymap.set('n', 'Y', 'y$', {
  noremap = true,
  desc = 'Yank till end of line',
})

-- Buffer navigation
vim.keymap.set('n', '[b', vim.cmd.bprevious, {
  silent = true,
  desc = 'Switch to prev buffer',
})

vim.keymap.set('n', ']b', vim.cmd.bnext, {
  silent = true,
  desc = 'Switch to next buffer',
})

vim.keymap.set('n', '[B', vim.cmd.bfirst, {
  silent = true,
  desc = 'Switch to first buffer',
})

vim.keymap.set('n', ']B', vim.cmd.blast, {
  silent = true,
  desc = 'Switch to last buffer',
})

-- Window management
vim.keymap.set('n', '<leader>fq', '<cmd>close!<CR>', {
  silent = true,
  desc = 'Close Floating window',
})

-- TODO: fix import utils.window
-- vim.keymap.set("n", "<leader>w+", function()
--   require("smj.utils.window").add("width")
-- end, {
--   silent = true,
--   desc = "Increase window width",
-- })
--
-- vim.keymap.set("n", "<leader>w-", function()
--   require("smj.utils.window").sub("width")
-- end, {
--   silent = true,
--   desc = "Decrease window width",
-- })
--
-- vim.keymap.set("n", "<leader>h+", function()
--   require("smj.utils.window").add("height")
-- end, {
--   silent = true,
--   desc = "Increase window height",
-- })
--
-- vim.keymap.set("n", "<leader>h-", function()
--   require("smj.utils.window").sub("height")
-- end, {
--   silent = true,
--   desc = "Decrease window height",
-- })

-- Tab management
vim.keymap.set('n', '<leader>tn', vim.cmd.tabnew, {
  noremap = true,
  desc = 'Open new tab',
})

vim.keymap.set('n', '<leader>tq', vim.cmd.tabclose, {
  noremap = true,
  desc = 'Close current tab',
})

-- Terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {
  desc = 'Switch to normal mode',
})

vim.keymap.set('t', '<C-Esc>', '<Esc>', {
  desc = 'Send ESC to terminal',
})

-- Misc
vim.keymap.set('n', '<leader>S', function()
  vim.opt.spell = not vim.opt.spell:get()
end, {
  noremap = true,
  desc = 'Toggle spell-check',
})
