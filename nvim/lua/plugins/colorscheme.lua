return {
    {
        'catppuccin/nvim',
        lazy = true,
    },
    {
        'folke/tokyonight.nvim',
        config = function() vim.cmd.colorscheme("tokyonight") end 
    },
    {
        'ellisonleao/gruvbox.nvim', 
        lazy = true,
        config = function()
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_contrast_dark = 'hard'
            vim.g.gruvbox_italicize_strings = 1
            vim.g.gruvbox_italicize_comments = 1
            vim.g.gruvbox_transparent_bg = 1
        end
    },
    {
        'navarasu/onedark.nvim',
        lazy = true,
    }
}
