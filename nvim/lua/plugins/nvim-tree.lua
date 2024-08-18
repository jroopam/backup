return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        config = function ()
            local HEIGHT_RATIO = 0.8
            local WIDTH_RATIO = 0.4
            local nvimtree = require("nvim-tree")

            nvimtree.setup({
                git = {
                    ignore = false,
                },
                --view = {
                --    float = {
                --        enable = true,
                --        open_win_config = function()
                --            local screen_w = vim.opt.columns:get()
                --            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                --            local window_w = screen_w * WIDTH_RATIO
                --            local window_h = screen_h * HEIGHT_RATIO
                --            local window_w_int = math.floor(window_w)
                --            local window_h_int = math.floor(window_h)
                --            local center_x = (screen_w - window_w) / 2
                --            local center_y = ((vim.opt.lines:get() - window_h) / 2)
                --            - vim.opt.cmdheight:get()
                --            return {
                --                border = 'rounded',
                --                relative = 'editor',
                --                row = center_y,
                --                col = center_x,
                --                width = window_w_int,
                --                height = window_h_int,
                --            }
                --        end,
                --    },
                --    width = function()
                --        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                --    end,
                --},
            })

            --vim.api.nvim_set_keymap('n', '<C-p>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
            --vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeFocus<CR>', { noremap = true, silent = true })

            ---- Auto-open NvimTree when VimEnter
            --vim.cmd([[autocmd VimEnter * NvimTreeOpen | wincmd p]])
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
                pattern = "NvimTree_*",
                callback = function()
                    local layout = vim.api.nvim_call_function("winlayout", {})
                    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
                end
            })
        end
    },
    {

        'nvim-telescope/telescope.nvim',
        dependencies = {
            {
                'nvim-lua/plenary.nvim'
            },
        },
    },
}
