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
	vim.api.nvim_create_autocmd("BufEnter", {
	  group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
	  pattern = "NvimTree_*",
	  callback = function()
	    local layout = vim.api.nvim_call_function("winlayout", {})
	    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
	  end
	})
	use {
		"catppuccin/nvim", as = "catppuccin"
	}
	use { "ellisonleao/gruvbox.nvim" }
	-- setup must be called before loading the colorscheme
	-- Default options:
	require("gruvbox").setup({
	  undercurl = true,
	  underline = true,
	  bold = true,
	  italic = true,
	  strikethrough = true,
	  invert_selection = false,
	  invert_signs = false,
	  invert_tabline = false,
	  invert_intend_guides = false,
	  inverse = true, -- invert background for search, diffs, statuslines and errors
	  contrast = "", -- can be "hard", "soft" or empty string
	  palette_overrides = {},
	  overrides = {},
	  dim_inactive = false,
	  transparent_mode = false,
	})
	vim.cmd("colorscheme gruvbox")
end)
