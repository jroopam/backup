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
            vim.cmd("colorscheme gruvbox")
        end
    },
    {
        'navarasu/onedark.nvim',
        lazy = true,
    }
}
