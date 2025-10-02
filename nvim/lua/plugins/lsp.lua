-- The need for completion plugins
-- Language servers provide different completion results depending on the capabilities of the client. Neovim's default omnifunc has basic support for serving completion candidates. nvim-cmp supports more types of completion candidates, so users must override the capabilities sent to the server such that it can provide these candidates during a completion request.
-- Good Ref: https://www.reddit.com/r/neovim/comments/1khidkg/mind_sharing_your_new_lsp_setup_for_nvim_011/
return {
    {
        'saghen/blink.cmp', -- Ref: https://cmp.saghen.dev/installation#lazy-nvim
        dependencies = { 'rafamadriz/friendly-snippets' },

        version = '1.*',
        event = "VeryLazy",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                ['<C-f>'] = { 'snippet_forward', 'fallback' },
                ['<C-b>'] = { 'snippet_backward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback_to_mappings' },
                ['<Tab>'] = { 'select_next', 'fallback_to_mappings' },
                ['<CR>'] = { 'accept', 'fallback' },
            },

            appearance = {
                nerd_font_variant = 'mono'
            },

            completion = {
                documentation = { auto_show = false },
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            cmdline = {
                enabled = false, -- the native autcomplete menu, has better UX for me(after pressing :)
            },

            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim', -- Installed this so that I don't have to configure lsp server manually
        },
        event = "VeryLazy",
        config = function()
            local servers = {
                'dockerls',
            }

            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = servers,
                automatic_enable = {
                    exclude = { -- It was enabling lua_ls I installed using Maosn while I just wanted the one I had configured
                        "lua_ls"
                    }
                }
            })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
            vim.lsp.config('*', {
                capabilities = capabilities,
            })
        end,
    },
}
