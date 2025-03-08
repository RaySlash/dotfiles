return {
	{
		"keybinds",
		load = function() end,
    event = "DeferredUIEnter",
		keys = {
			{
				"j",
				"v:count == 0 ? 'gj' : 'j'",
				mode = { "n", "x" },
				noremap = true,
				expr = true,
				desc = "Move Cursor Down",
			},
			{
				"k",
				"v:count == 0 ? 'gk' : 'k'",
				mode = { "n", "x" },
				noremap = true,
				expr = true,
				desc = "Move Cursor Up",
			},
			{ "<C-q>", "<cmd>q!<CR>", mode = { "n" }, noremap = true, desc = "Quit session" },
			{ "<C-s>", "<cmd>w!<CR>", mode = { "n" }, noremap = true, desc = "Save File" },
			{ "<Esc>", "<cmd>noh<CR><Esc>", mode = { "n" }, noremap = true, desc = "Escape and Clear hlsearch" },
			{ "Y", "y$", mode = { "n" }, noremap = true, desc = "Yank till end of line" },
			-- Buffer
			{ "[b", vim.cmd.bprevious, mode = { "n" }, silent = true, desc = "Switch to prev buffer" },
			{ "]b", vim.cmd.bnext, mode = { "n" }, silent = true, desc = "Switch to prev buffer" },
			{ "[B", vim.cmd.bfirst, mode = { "n" }, silent = true, desc = "Switch to prev buffer" },
			{ "]B", vim.cmd.blast, mode = { "n" }, silent = true, desc = "Switch to prev buffer" },
      -- Window
			{ "<leader>fq", vim.cmd("fclose!"), mode = { "n" }, silent = true, desc = "Close Floating window" },
			-- TODO: fix import utils.window 
			-- {
			-- 	"<leader>w+",
			-- 	function()
			-- 		require("smj.utils.window").add("width")
			-- 	end,
			-- 	mode = { "n" },
			-- 	silent = true,
			-- 	desc = "Increase window width",
			-- },
			-- {
			-- 	"<leader>w-",
			-- 	function()
			-- 		require("smj.utils.window").sub("width")
			-- 	end,
			-- 	mode = { "n" },
			-- 	silent = true,
			-- 	desc = "Decrease window width",
			-- },
			-- {
			-- 	"<leader>h+",
			-- 	function()
			-- 		require("smj.utils.window").add("height")
			-- 	end,
			-- 	mode = { "n" },
			-- 	silent = true,
			-- 	desc = "Increase window height",
			-- },
			-- {
			-- 	"<leader>h-",
			-- 	function()
			-- 		require("smj.utils.window").sub("height")
			-- 	end,
			-- 	mode = { "n" },
			-- 	silent = true,
			-- 	desc = "Decrease window height",
			-- },
			-- Tabs
			{ "<leader>tn", vim.cmd.tabnew, noremap = true, desc = "Open new tab" },
			{ "<leader>tq", vim.cmd.tabclose, noremap = true, desc = "Close current tab" },
			-- Misc
			{ "<Esc>", "<C-\\><C-n>", mode = { "t" }, desc = "Switch to normal mode" },
			{ "<C-Esc>", "<Esc>", mode = { "t" }, desc = "Send ESC to terminal" },
			{
				"<leader>S",
				function()
					vim.opt.spell = not (vim.opt.spell:get())
				end,
				mode = { "n" },
				noremap = true,
				desc = "Toggle spell-check",
			},
		},
	},
}
