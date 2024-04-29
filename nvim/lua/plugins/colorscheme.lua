return {
    {
        'catppuccin/nvim',
        lazy = true,
    },
    {
        'folke/tokyonight.nvim',
        --config = function() vim.cmd.colorscheme("tokyonight") end 
    },
    {
        'ellisonleao/gruvbox.nvim', 
        --lazy = true,
        config = function()
            -- Default options:
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = true,
                bold = true,
                italic = {
                    strings = true,
                    emphasis = true,
                    comments = true,
                    operators = false,
                    folds = true,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                dim_inactive = false,
                overrides = {
                    SignColumn = {bg = "#282828"}
                },
            })
            --vim.cmd("colorscheme gruvbox")
        end
    },
    {
        'navarasu/onedark.nvim',
        lazy = true,
    },
    {
        'rebelot/kanagawa.nvim',
        config = function ()
            -- Default options:
            require('kanagawa').setup({
                compile = false,             -- enable compiling the colorscheme
                undercurl = true,            -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true},
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,         -- do not set background color
                dimInactive = true,         -- dim inactive window `:h hl-NormalNC`
                terminalColors = true,       -- define vim.g.terminal_color_{0,17}
                colors = {                   -- add/modify theme and palette colors
                palette = {},
                theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
            },
            overrides = function(colors) -- add/modify highlights
                return {}
            end,
            theme = "wave",              -- Load "wave" theme when 'background' option is not set
            background = {               -- map the value of 'background' option to a theme
                dark = "wave",           -- try "dragon" !
                light = "lotus"
            },
        })

        --vim.cmd("colorscheme kanagawa")
        vim.cmd("colorscheme kanagawa-wave")
        --vim.cmd("colorscheme kanagawa-dragon")
        --vim.cmd("colorscheme kanagawa-lotus")
        end
    }
}
