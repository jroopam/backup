return {
    {

        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        dependencies = {
            {
                'nvim-lua/plenary.nvim'
            },
        },
        config = function ()
            local builtin = require("telescope.builtin")
            local map = vim.keymap.set
            map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope live grep" })
            map({ "n" }, "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
            map({ "n" }, "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
            map({ "n" }, "<leader>so", builtin.oldfiles, { desc = "Telescope buffers" })
            map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
            map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
            map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "Telescope tags" })
            map({ "n" }, "<leader>st", builtin.builtin, { desc = "Telescope tags" })
            map({ "n" }, "<leader>sd", builtin.registers, { desc = "Telescope tags" })
            map({ "n" }, "<leader>sc", builtin.colorscheme, { desc = "Telescope tags" })
            map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>", { desc = "Telescope tags" })
            require("telescope").setup({
                defaults = {
                    -- Refs
                    -- https://github.com/nvim-telescope/telescope.nvim/issues/2014
                    -- https://github.com/nvim-telescope/telescope.nvim/pull/3010
                    path_display = {
                        "smart",
                        filename_first = {
                            reverse_directories = true,
                        },
                    },
                }
            })
        end,
    },
}

-- https://github.com/towry/nvim/blob/06ceed761f37fd1e54b6462de87e0bdaa3737bb4/lua/userlib/fzflua/init.lua#L101
-- Using fd with telescope
