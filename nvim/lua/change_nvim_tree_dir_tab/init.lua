local M = {}
M.cache = {}
local tab_page = vim.api.nvim_get_current_tabpage()

function M.on_tab_enter()
	local api = require("nvim-tree.api")
	api.tree.change_root(M.cache[tab_page])
end

function M.on_dir_change()
	local tab_cwd = vim.loop.cwd()
	M.cache[tab_page] = tab_cwd
	M.on_tab_enter()
end

local group = vim.api.nvim_create_augroup("TabDirAU", {})
vim.api.nvim_create_autocmd("TabEnter", {group = group, callback = M.on_tab_enter})
vim.api.nvim_create_autocmd("DirChanged", {group = group, callback = M.on_dir_change})
