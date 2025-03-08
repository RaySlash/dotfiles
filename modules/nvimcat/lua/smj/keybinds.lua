local api = vim.api
local fn = vim.fn
local keymap = vim.keymap

-- Better navigation
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- General
keymap.set("n", "<C-q>", "<cmd>q!<cr>", { desc = "Quit" })
keymap.set("n", "<C-s>", "<cmd>w!<cr>", { desc = "Save" })
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
keymap.set(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Yank from current position till end of current line
keymap.set("n", "Y", "y$", { silent = true, desc = "[Y]ank to end of line" })

-- Buffer list navigation
keymap.set("n", "[b", vim.cmd.bprevious, { silent = true, desc = "previous [b]uffer" })
keymap.set("n", "]b", vim.cmd.bnext, { silent = true, desc = "next [b]uffer" })
keymap.set("n", "[B", vim.cmd.bfirst, { silent = true, desc = "first [B]uffer" })
keymap.set("n", "]B", vim.cmd.blast, { silent = true, desc = "last [B]uffer" })

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
	local qf_exists = false
	for _, win in pairs(fn.getwininfo() or {}) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		vim.cmd.cclose()
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd.copen()
	end
end

keymap.set("n", "<C-c>", toggle_qf_list, { desc = "toggle quickfix list" })

local function try_fallback_notify(opts)
	local success, _ = pcall(opts.try)
	if success then
		return
	end
	success, _ = pcall(opts.fallback)
	if success then
		return
	end
	vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
	try_fallback_notify({
		try = vim.cmd.cprev,
		fallback = vim.cmd.clast,
		notify = "Quickfix list is empty!",
	})
end

local function cright()
	try_fallback_notify({
		try = vim.cmd.cnext,
		fallback = vim.cmd.cfirst,
		notify = "Quickfix list is empty!",
	})
end

keymap.set("n", "[c", cleft, { silent = true, desc = "[c]ycle quickfix left" })
keymap.set("n", "]c", cright, { silent = true, desc = "[c]ycle quickfix right" })
keymap.set("n", "[C", vim.cmd.cfirst, { silent = true, desc = "first quickfix entry" })
keymap.set("n", "]C", vim.cmd.clast, { silent = true, desc = "last quickfix entry" })

local function lleft()
	try_fallback_notify({
		try = vim.cmd.lprev,
		fallback = vim.cmd.llast,
		notify = "Location list is empty!",
	})
end

local function lright()
	try_fallback_notify({
		try = vim.cmd.lnext,
		fallback = vim.cmd.lfirst,
		notify = "Location list is empty!",
	})
end

keymap.set("n", "[l", lleft, { silent = true, desc = "cycle [l]oclist left" })
keymap.set("n", "]l", lright, { silent = true, desc = "cycle [l]oclist right" })
keymap.set("n", "[L", vim.cmd.lfirst, { silent = true, desc = "first [L]oclist entry" })
keymap.set("n", "]L", vim.cmd.llast, { silent = true, desc = "last [L]oclist entry" })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set("n", "<leader>w+", function()
	local curWinWidth = api.nvim_win_get_width(0)
	api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = "inc window [w]idth" })
keymap.set("n", "<leader>w-", function()
	local curWinWidth = api.nvim_win_get_width(0)
	api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = "dec window [w]idth" })
keymap.set("n", "<leader>h+", function()
	local curWinHeight = api.nvim_win_get_height(0)
	api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = "inc window [h]eight" })
keymap.set("n", "<leader>h-", function()
	local curWinHeight = api.nvim_win_get_height(0)
	api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = "dec window [h]eight" })

-- Close floating windows [Neovim 0.10 and above]
keymap.set("n", "<leader>fq", function()
	vim.cmd("fclose!")
end, { silent = true, desc = "[f]loating windows: [q]uit/close all" })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "switch to normal mode" })
keymap.set("t", "<C-Esc>", "<Esc>", { desc = "send Esc to terminal" })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set("c", "%%", function()
	if fn.getcmdtype() == ":" then
		return fn.expand("%:h") .. "/"
	else
		return "%%"
	end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set("n", "<leader>tn", vim.cmd.tabnew, { desc = "[t]ab: [n]ew" })
keymap.set("n", "<leader>tq", vim.cmd.tabclose, { desc = "[t]ab: [q]uit/close" })

local function toggle_spell_check()
	---@diagnostic disable-next-line: param-type-mismatch
	vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set("n", "<leader>S", toggle_spell_check, { noremap = true, silent = true, desc = "toggle [S]pell" })
