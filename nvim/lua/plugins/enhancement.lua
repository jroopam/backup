return {
    {
        'tiagovla/scope.nvim',
        config = function()
            vim.opt.sessionoptions = {
                "buffers",
                "tabpages",
                "globals",
            }
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
    {
        "OXY2DEV/markview.nvim",
        lazy = false,      -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("markview").setup({
                ignore_modes = nil,
                preview = {
                    modes = {"n", "i"},
                    hybrid_modes = { "n", "i" },
                },
                code_blocks = {
                    enable = true,

                    --- Icon provider for the block icons & signs.
                    ---
                    --- Possible values are,
                    ---   • "devicons", Uses `nvim-web-devicons`.
                    ---   • "mini", Uses `mini.icons`.
                    ---   • "internal", Uses the internal icon provider.
                    ---   • "", Disables icons
                    ---
                    ---@type "devicons" | "mini" | "internal" | ""
                    icons = "internal",

                    --- Render style for the code block.
                    ---
                    --- Possible values are,
                    ---   • "simple", Simple line highlighting.
                    ---   • "minimal", Box surrounding the code block.
                    ---   • "language", Signs, icons & much more.
                    ---
                    ---@type "simple" | "minimal" | "language"
                    style = "language",

                    --- Primary highlight group.
                    --- Used by other options that end with "_hl" when
                    --- their values are nil.
                    ---@type string
                    border_hl = "MarkviewCode",

                    --- Highlight group for the info string
                    ---@type string
                    info_hl = "MarkviewCodeInfo",

                    --- Minimum width of a code block.
                    ---@type integer
                    min_width = 40,

                    --- Left & right padding amount
                    ---@type integer
                    pad_amount = 0,

                    --- Character to use as whitespace
                    ---@type string?
                    pad_char = " ",

                    --- Table containing various code block language names
                    --- and the text to show.
                    --- e.g. { cpp = "C++" }
                    ---@type { [string]: string }
                    language_names = nil,

                    --- Direction of the language preview
                    ---@type "left" | "right"
                    language_direction = "left",

                    --- Enables signs
                    ---@type boolean
                    sign = true,

                    --- Highlight group for the sign
                    ---@type string?
                    sign_hl = nil
                },
                inline_codes = {
                    enable = true,
                    hl = "MarkviewHeading3",

                    --- Left corner, Added before the left padding.
                    ---@type string?
                    corner_left = nil,

                    --- Left padding, Added before the text.
                    ---@type string?
                    padding_left = nil,

                    --- Right padding, Added after the text.
                    ---@type string?
                    padding_right = nil,

                    --- Right corner, Added after the right padding.
                    ---@type string?
                    corner_right = nil,

                    ---@type string?
                    corner_left_hl = nil,
                    ---@type string?
                    padding_left_hl = nil,

                    ---@type string?
                    padding_right_hl = nil,
                    ---@type string?
                    corner_right_hl = nil,
                },
                markdown = {
                    list_items = {
                        enable = true,

                        --- Amount of spaces that defines an indent
                        --- level of the list item.
                        ---@type integer
                        indent_size = 2,

                        --- Amount of spaces to add per indent level
                        --- of the list item.
                        ---@type integer
                        shift_width = 2,

                        marker_minus = {
                            add_padding = false,

                            text = "",
                            hl = "MarkviewListItemMinus"
                        },
                        marker_plus = {
                            add_padding = false,

                            text = "",
                            hl = "MarkviewListItemPlus"
                        },
                        marker_star = {
                            add_padding = false,

                            text = "",
                            hl = "MarkviewListItemStar"
                        },

                        --- These items do NOT have a text or
                        --- a hl property!

                        --- n. Items
                        marker_dot = {
                            add_padding = true
                        },

                        --- n) Items
                        marker_parenthesis = {
                            add_padding = true
                        }
                    }
                },
            });
        end
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
