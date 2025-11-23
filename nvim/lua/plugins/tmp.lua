-- lazy.nvim
return {
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        event = "VimEnter",
        opts = {
            max_time = 1200,
            max_count = 2;
        }
    },
}
