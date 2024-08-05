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
    --[[ {
        'numToStr/Comment.nvim',
        event = {'BufReadPre', 'BufNewFile'},
        config = function()
            require('Comment').setup({
                toggler = {
                    line = '<C-_>',
                }
            })
        end
    }, ]]
    {
        'aluriak/nerdcommenter'
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
}


