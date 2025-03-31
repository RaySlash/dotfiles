local M = {}

M.curWinWidth = vim.api.nvim_win_set_width(0)
M.curWinHeight = vim.api.nvim_win_set_height(0)

M.add = function(axis)
	if axis == "width" then
		vim.api.nvim_win_set_width(0, math.ceil(M.curWinWidth * 3 / 2))
	elseif axis == "height" then
		vim.api.nvim_win_set_height(0, math.ceil(M.curWinHeight * 3 / 2))
	end
end

M.sub = function(axis)
	if axis == "width" then
		vim.api.nvim_win_set_width(0, math.ceil(M.curWinWidth * 2 / 3))
	elseif axis == "height" then
		vim.api.nvim_win_set_height(0, math.ceil(M.curWinHeight * 2 / 3))
	end
end
return M
