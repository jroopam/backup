local packer = require('packer')

packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons',
		},
	}
	use("tiagovla/scope.nvim")
	vim.api.nvim_create_autocmd("BufEnter", {
	  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
	  pattern = "NvimTree_*",
	  callback = function()
	    local layout = vim.api.nvim_call_function("winlayout", {})
	    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
	  end
	})
	use {'neoclide/coc.nvim', branch = 'release'}
	use {'lewis6991/gitsigns.nvim'}
	--use {"catppuccin/nvim", as = "catppuccin"}
	--use {'folke/tokyonight.nvim'}
	use {'morhetz/gruvbox', config = function() vim.cmd.colorscheme("gruvbox") end }
	--use {'navarasu/onedark.nvim'}
	use {'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true }}
end)
