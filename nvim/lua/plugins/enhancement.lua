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
        config = function()
            require('tint').setup({
                tint = -50
            })
        end
    },
    {
        'aluriak/nerdcommenter'
    },
}


