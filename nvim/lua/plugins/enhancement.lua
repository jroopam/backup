return {
    {
        'tiagovla/scope.nvim',
        config = function()
            require("scope").setup({})
        end
    },
    {
        'Pocco81/auto-save.nvim',
        config = function()
            require('auto-save').setup({})
        end
    },
    {
        'levouh/tint.nvim',
        event = "WinNew",
        config = function()
            require('tint').setup({
                tint = -50
            })
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        "lukas-reineke/indent-blankline.nvim", main = "ibl",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { show_start = false, show_end = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        }
    },
    -- {
    --     'echasnovski/mini.animate',
    --     config = true,
    --     version = false
    -- }
    -- Ref1: https://www.reddit.com/r/neovim/comments/1gydpht/smooth_cursor_in_standard_terminal/
    -- Ref2: https://www.reddit.com/r/neovim/comments/1gyt2ea/karb94neoscrollnvim_sphambasmearcursornvim_make/
    -- 1. Using kitty: Use cursor_trail
    -- 2. Use plugins: smear-cursor and neoscroll
}
