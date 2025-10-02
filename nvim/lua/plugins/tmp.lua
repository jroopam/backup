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
    {
        'rmagatti/auto-session',
        event = "VeryLazy",

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = {'~/Projects', '~/Downloads', '/' },
            auto_save = true,
            cwd_change_handling = true,
            -- log_level = 'debug',
        }
    }
}
