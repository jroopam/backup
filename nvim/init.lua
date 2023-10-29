vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

-- Code indentation lines
--vim.opt.expandtab = false
--vim.opt.listchars = { tab = "| " }
--vim.opt.list = true

require("plugins")

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Scope.nvim for seperate buffers in each tab
require("scope").setup({})

-- Gitsigns.nvim
require('gitsigns').setup {
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
    ignore_whitespace = false,
  },
}

-- Colorscheme
-- Set Gruvbox specific options
vim.g.gruvbox_italic = 1
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_italicize_strings = 1
vim.g.gruvbox_italicize_comments = 1
vim.g.gruvbox_transparent_bg = 1

-- Load the Gruvbox color scheme
vim.cmd('colorscheme gruvbox')

-- Explorer
-- NvimTree
require("nvim-tree").setup()
require("change_nvim_tree_dir_tab")

-- OR setup with some options
--require("nvim-tree").setup({
--    sort_by = "case_sensitive",
--    view = {
--        mappings = {
--            list = {
--                { key = "u", action = "dir_up" },
--            },
--        },
--    },
--    renderer = {
--        group_empty = true,
--    },
--    filters = {
--        dotfiles = true,
--    },
--})

vim.api.nvim_set_keymap('n', '<C-p>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

---- Auto-open NvimTree when VimEnter
vim.cmd([[autocmd VimEnter * NvimTreeOpen | wincmd p]])


vim.o.background = "dark" -- or "light" for light mode
--require('onedark').load()
