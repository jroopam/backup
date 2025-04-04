vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

--LazyVim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })
vim.o.background = "dark" -- or "light" for light mode

-- Configuration
vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, { desc = "toggle diagnostic" })

-- Commenting
-- Ref: https://github.com/neovim/neovim/discussions/29075
vim.keymap.set({"n", "v"}, "<C-_>", "gc", {remap = true})
vim.keymap.set({"n"}, "<C-_>", "gcc", {remap = true})  -- Use with leader n to comment n lines

---- Better Vertical Motions -------
-- Ref: https://www.reddit.com/r/neovim/comments/1jk3r0n/found_a_comfortable_way_to_combine_jumping_and/?rdt=40859
-- When you use normal <C-d> or <C-u>, it scrolls which is the cursor remains in the same position wrt window but the line number under the cursor changes
local function special_up()
  local cursorline = vim.fn.line('.')
 local first_visible = vim.fn.line('w0')
  local travel = math.floor(vim.api.nvim_win_get_height(0) / 2)

  if (cursorline - travel) < first_visible then
   vim.cmd("execute \"normal! " .. travel .. "\\<C-y>\"")
  else
    vim.cmd("execute \"normal! " .. travel .. "\\k\"")
  end
end

local function special_down()
  local cursorline = vim.fn.line('.')
  local last_visible = vim.fn.line('w$')
  local travel = math.floor(vim.api.nvim_win_get_height(0) / 2)

  if (cursorline + travel) > last_visible and last_visible < vim.fn.line('$') then -- If the final position is outside the screen we scroll -> the cursor stays on the same line number but the screen is scrolled
    vim.cmd("execute \"normal! " .. travel .. "\\<C-e>\"")
  elseif cursorline < last_visible then -- If the final position is inside the screen we just move to it
    vim.cmd("execute \"normal! " .. travel .. "\\j\"")
  end
end

vim.keymap.set({ 'n', 'x' }, '<M-u>', function() special_up() end)
vim.keymap.set({ 'n', 'x' }, '<M-d>', function() special_down() end)
------------------------------------

-- Colorscheme
vim.cmd('colorscheme onedark')
