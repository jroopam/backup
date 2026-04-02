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
-- vim.keymap.set('c', '<tab>', '<C-z>', { silent = false }) -- to fix cmp

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
-- Ref: https://github.com/nvim-mini/mini.deps/blob/8f6f74a8b68dbad02f1813dff4ddae5afeee92df/lua/mini/deps.lua#L1564
-- plugin_callback_queue should contain in this format: function() require('mini.pick').setup() end
local plugin_callback_queue = {
    function () vim.cmd"packadd nvim.undotree" end,
}
local finish_is_scheduled = false

schedule_finish = function()
  if finish_is_scheduled then return end
  vim.schedule(finish)
  finish_is_scheduled = true
end

finish = function()
  local timer, step_delay = vim.loop.new_timer(), 1
  local f = nil
  f = vim.schedule_wrap(function()
    print("Loading plugin...")
    local callback = plugin_callback_queue[1]
    if callback == nil then
      finish_is_scheduled, plugin_callback_queue = false, {}
      return
    end

    table.remove(plugin_callback_queue, 1)
    pcall(callback)
    timer:start(step_delay, 0, f)
  end)
  timer:start(step_delay, 0, f)
end

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function ()
        schedule_finish()
    end
})

-- Prevent Press Enter to Continue Block Start ---
-- Ref: https://www.reddit.com/r/neovim/comments/1sa95g4/no_more_press_enter_with_ui2_with_example/
-- Ref: https://github.com/ThorstenRhau/neovim/blob/c5d8652edeedcd64a0e51c236986f379b8ac0724/lua/config/options.lua#L86-L133
local opt = vim.opt
local o = vim.o

o.completeopt = 'menu,menuone,noselect'
o.cursorline = true
o.expandtab = true
o.ignorecase = true
o.linebreak = true
o.mouse = 'nv'
o.number = true
o.numberwidth = 2
o.pumborder = 'single'
o.pumheight = 10
o.showmode = false
o.smartcase = true
o.smartindent = true
o.smoothscroll = true
o.softtabstop = 4
o.splitbelow = true
o.splitright = true
o.statuscolumn = '%s%=%{v:relnum?v:relnum:v:lnum} '
o.tabstop = 4
o.timeoutlen = 300
o.undofile = true
o.undolevels = 1000
o.winborder = 'single'

-- Cursor appearance and blinking
o.guicursor = table.concat({
  'n-v-c-sm:block-Cursor', -- Normal, Visual, Command, Showmatch: block cursor
  'i-ci-ve:ver25-Cursor', -- Insert, Command-insert, Visual-exclusive: vertical bar (25% width)
  'r-cr-o:hor20-Cursor', -- Replace, Command-replace, Operator-pending: horizontal bar (20% height)
  'a:blinkwait500-blinkoff500-blinkon500',
}, ',')

-- Whitespace characters    
o.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Folding (treesitter-based, configured per filetype)
o.foldlevel = 99
o.foldlevelstart = 99

-- Spelling
o.spelllang = 'en_us'
o.spellsuggest = 'best,20' -- Limits to 20 suggestions

-- Experimental UI2: floating cmdline and messages
o.cmdheight = 0
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})
--- Block End ---

--- Dynamically placed Relative Numbers block start ---
local ns = vim.api.nvim_create_namespace("relative_eol_numbers")
local num_enabled = false

local function update_relative_numbers()
    if not num_enabled then return end

    local buf = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_loaded(buf) then return end

    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    local cursor = vim.api.nvim_win_get_cursor(0)[1] - 1
    local cursorCol = vim.api.nvim_win_get_cursor(0)[2] - 1
    local topline = vim.fn.line("w0") - 1
    local botline = vim.fn.line("w$") - 1

    -- for lnum = topline, botline do
    --     local rel = math.abs(lnum - cursor)
    --
    --     vim.api.nvim_buf_set_extmark(buf, ns, lnum, -1, {
    --         virt_text = { { string.format("|%3d", rel), "LineNr" } },
    --         virt_text_pos = "eol",
    --         hl_mode = "combine",
    --     })
    -- end

    -- local maxLen = 0
    -- for lnum = topline, botline do
    --     local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1]
    --     if line then
    --         local width = vim.fn.strdisplaywidth(line)
    --         if width > maxLen then
    --             maxLen = width
    --         end
    --     end
    -- end
    -- maxLen = maxLen + 2
    -- for lnum = topline, botline do
    --     local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1]
    --     local width = 0
    --     if line then
    --         width = vim.fn.strdisplaywidth(line)
    --     end
    --     local rel = math.abs(lnum - cursor)
    --
    --     rel = string.rep(" ", (maxLen-width)) .. rel
    --     local formatString = string.format("%%%dd", (maxLen-width))
    --     vim.api.nvim_buf_set_extmark(buf, ns, lnum, -1, {
    --         -- virt_text = { { string.format(formatString, rel), "LineNr" } },
    --         virt_text = { { rel, "LineNr" } },
    --         virt_text_pos = "eol",
    --         hl_mode = "combine",
    --     })
    --     ::continue::
    -- end

    for lnum = topline, botline do
        if lnum % 2 == 0 then
            goto continue
        end
        local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1]
        local width = 0
        local rel = math.abs(lnum - cursor)

        -- if rel % 2 ~= 0 then
        --     goto continue
        -- end
        --
        local modifier = ""
        if line then
            width = vim.fn.strdisplaywidth(line)
            if lnum < cursor then
                modifier = "↑"
                -- modifier = "k"
            else
                modifier = "↓"
                -- modifier = "j"
            end
            if cursorCol > width then
                rel = string.rep(" ", (cursorCol-width+1)) .. rel .. modifier
            else
                rel = rel .. modifier
            end
        end

        vim.api.nvim_buf_set_extmark(buf, ns, lnum, -1, {
            virt_text = { { rel, "LineNr" } },
            virt_text_pos = "eol",
            hl_mode = "combine",
        })
        ::continue::
    end

end


vim.api.nvim_create_autocmd(
  { "CursorMoved", "CursorMovedI", "WinScrolled", "BufEnter" },
  {
    callback = update_relative_numbers,
  }
)

local function toggle_relative_numbers()
  num_enabled = not num_enabled

  if not num_enabled then
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  else
    update_relative_numbers()
  end
end

vim.api.nvim_create_user_command(
  "ToggleRelVirt",
  toggle_relative_numbers,
  {}
)

vim.keymap.set(
  "n",
  "<leader>rn",
  toggle_relative_numbers,
  { desc = "Toggle virtual relative line numbers" }
)
--- Block End ---

require("custom")
