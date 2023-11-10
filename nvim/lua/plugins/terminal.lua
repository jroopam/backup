return {
    {
        'akinsho/toggleterm.nvim', version = "*", 
        opts = {
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            autochdir = false,
            direction = 'float',
            float_opts = {
                -- The border key is *almost* the same as 'nvim_open_win'
                -- see :h nvim_open_win for details on borders however
                -- the 'curved' border is a custom border type
                -- not natively supported but implemented in this plugin.
                border = 'curved',
               --width = 3,
                --height = 80,
                winblend = 3,
                zindex = 10,
            },
            winbar = {
                enabled = false,
                name_formatter = function(term) --  term: Terminal
                    return term.name
                end
            },
        }
    }
    --'folke/noice.nvim',
    --dependencies = {
    --    "MunifTanjim/nui.nvim",
    --    "rcarriga/nvim-notify",
    --},
    --config = function ()

    --    require("noice").setup({
    --        lsp = {
    --            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    --            override = {
    --                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --                ["vim.lsp.util.stylize_markdown"] = true,
    --                ["cmp.entry.get_documentation"] = true,
    --            },
    --        },
    --        -- you can enable a preset for easier configuration
    --        presets = {
    --            bottom_search = true, -- use a classic bottom cmdline for search
    --            command_palette = true, -- position the cmdline and popupmenu together
    --            long_message_to_split = true, -- long messages will be sent to a split
    --            inc_rename = false, -- enables an input dialog for inc-rename.nvim
    --            lsp_doc_border = false, -- add a border to hover docs and signature help
    --        },
    --    })
    --end
}
