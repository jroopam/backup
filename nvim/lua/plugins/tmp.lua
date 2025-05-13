-- lazy.nvim
return {
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            max_time = 1200,
            max_count = 1;
        }
    },
    {
        'rmagatti/auto-session',
        lazy = false,

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = {'~/Projects', '~/Downloads', '/' },
            -- log_level = 'debug',
        }
    }
}
