-- lazy.nvim
return {
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        event = "VeryLazy",
        opts = {
            max_time = 1200,
            max_count = 2;
        }
    },
}
