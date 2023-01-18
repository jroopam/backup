local packer = require("packer")

packer.startup(function(use)
	use({ "wbthomason/packer.nvim" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
	})

    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })
end)
