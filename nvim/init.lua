vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
]])

-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

------------------------- Lazy -------------------------------------
--- opts => When opts is provided, lazy automatically calls require("plugin").setup(opts) for you. opts will be overriding the configurations provided by the plugin.
--- config => provides more granular control over the plugin's initialization process. It allows you to execute custom Lua code when the plugin loads. This function can contain any Lua code needed for setup, including calling require("your_plugin_main_module").setup().
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
--------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })
vim.o.background = "dark" -- or "light" for light mode

-- Configuration
vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, { desc = "toggle diagnostic" })

-- Commenting
-- Ref: https://github.com/neovim/neovim/discussions/29075
vim.keymap.set({"n", "v"}, "<C-_>", "gc", {remap = true})
vim.keymap.set({"n"}, "<C-_>", "gcc", {remap = true})  -- Use with leader n to comment n lines

-- Code folding
vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
vim.o.foldcolumn = '1'
vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'

---- Better Vertical Motions -------
-- Ref: https://www.reddit.com/r/neovim/comments/1jk3r0n/found_a_comfortable_way_to_combine_jumping_and/?rdt=40859
-- When you use normal <C-d> or <C-u>, it scrolls which is the cursor remains in the same position wrt window but the line number under the cursor changes
local function special_up()
  local cursorline = vim.fn.line('.')
 local first_visible = vim.fn.line('w0')
  local travel = math.floor(vim.api.nvim_win_get_height(0) / 2)

  if (cursorline - travel) < first_visible then
   vim.cmd("execute \"normal! " .. travel .. "\\<C-y>\"")
  else
    vim.cmd("execute \"normal! " .. travel .. "\\k\"")
  end
end

local function special_down()
  local cursorline = vim.fn.line('.')
  local last_visible = vim.fn.line('w$')
  local travel = math.floor(vim.api.nvim_win_get_height(0) / 2)

  if (cursorline + travel) > last_visible and last_visible < vim.fn.line('$') then -- If the final position is outside the screen we scroll -> the cursor stays on the same line number but the screen is scrolled
    vim.cmd("execute \"normal! " .. travel .. "\\<C-e>\"")
  elseif cursorline < last_visible then -- If the final position is inside the screen we just move to it
    vim.cmd("execute \"normal! " .. travel .. "\\j\"")
  end
end

vim.keymap.set({ 'n', 'x' }, '<M-u>', function() special_up() end)
vim.keymap.set({ 'n', 'x' }, '<M-d>', function() special_down() end)
------------------------------------

-- Telescope
vim.cmd('cnoreab ss Telescope')
vim.keymap.set('c', '<tab>', '<C-z>', { silent = false }) -- to fix cmp

-- Colorscheme
vim.cmd('colorscheme vaporwave')

vim.lsp.enable({
    'lua',
})

vim.api.nvim_create_autocmd("LspAttach", {

    desc = "LSP actions",
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf
        if not client then
            return
        end

        ---[[ Format and autoimport on Save
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     buffer = args.buf,
        --     callback = function()
        --         if client:supports_method("textDocument/formatting") then
        --             vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        --         end
        --         if client:supports_method("textDocument/codeAction") then
        --             local function apply_code_action(action_type)
        --                 local ctx = { only = action_type, diagnostics = {} }
        --                 local actions = vim.lsp.buf.code_action({ context = ctx, apply = true, return_actions = true })
        --
        --                 -- only apply if code action is available
        --                 if actions and #actions > 0 then
        --                     vim.lsp.buf.code_action({ context = ctx, apply = true })
        --                 end
        --             end
        --             apply_code_action({ "source.fixAll" })
        --             apply_code_action({ "source.organizeImports" })
        --         end
        --     end,
        -- })
        ---]]

        ---[[ Lsp Keymaps
        local nmap = function(keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end
            vim.keymap.set("n", keys, func, { buffer = args.buf, noremap = true, silent = true, desc = desc })
        end

        nmap("K", vim.lsp.buf.hover, "Open hover")
        nmap("<leader>r", vim.lsp.buf.rename, "Rename")
        nmap("<leader>dr", vim.lsp.buf.references, "References")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
        nmap("<leader>df", vim.lsp.buf.definition, "Goto definition")
        nmap("<leader>ds", "<cmd>vs | lua vim.lsp.buf.definition()<cr>", "Goto definition (v-split)")
        nmap("<leader>dh", "<cmd>sp | lua vim.lsp.buf.definition()<cr>", "Goto definition (h-split)")

        local opts = {buffer = bufnr, remap = false}
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

        -- Diagnostic
        nmap("dn", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Goto next diagnostic")
        nmap("dN", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Goto prev diagnostic")
        nmap("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")
        nmap("<leader>e", vim.diagnostic.open_float, "Open diagnostic float")

        vim.keymap.set("i", "<M-t>", vim.lsp.buf.signature_help, { buffer = args.buf })

        -- inlay hints
        nmap("<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "Toggle inlay hints")

        vim.api.nvim_buf_create_user_command(args.buf, "Fmt", function(_)
            vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
        ---]]
    end,
})

-- Ref: https://www.reddit.com/r/neovim/comments/1o0uo9q/comment/nie1a7p/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.cmd"packadd nvim.undotree"
