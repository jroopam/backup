local M = {}

------------------------------------------------------------
-- Constants & Config
------------------------------------------------------------

local STATE = {
    IDLE = "IDLE",
    SEARCHING = "SEARCHING",
    LABELING = "LABELING",
    JUMPING = "JUMPING",
}

local LABEL_CHARS = {}
do
    -- home row first, then rest
    local order = "asdfghjklqwertyuiopzxcvbnm"
    for c in order:gmatch(".") do
        table.insert(LABEL_CHARS, c)
    end
end

vim.api.nvim_set_hl(0, 'MyFlashLabel', {
  fg = 'White',
  bg = 'Red',
  bold = true,
})

local MIN_PATTERN_LEN = 1
local NS = vim.api.nvim_create_namespace("searchlabels")

------------------------------------------------------------
-- State
------------------------------------------------------------

local state = {
    mode = STATE.IDLE,
    pattern = "",
    matches = {},
    labels = {},
    forbidden = {},
    label_input = "",
    winid = nil,
    bufnr = nil,
}

------------------------------------------------------------
-- Utilities
------------------------------------------------------------

local function exit_cmdline()

    -- vim.api.nvim_feedkeys(
    --     vim.api.nvim_replace_termcodes('<CR>', true, false, true),
    --     'n',
    --     true
    -- )

    if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
        local pattern = vim.fn.getcmdline()
        -- vim.fn.setreg('/', pattern ~= '' and pattern or '\n')
        vim.fn.setreg('/', '\n')
        -- vim.fn.setreg('/', [[\%#]])
        vim.cmd('nohlsearch')
    end

    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<C-c>", true, false, true),
        "n",
        false
    )
    vim.cmd('nohlsearch')
end

local function reset_state()
    print("reset_state")
    print(debug.traceback())
        vim.api.nvim_buf_clear_namespace(0, NS, 0, -1)
        state = {
            mode = STATE.IDLE,
            pattern = "",
            matches = {},
            labels = {},
            forbidden = {},
            label_input = "",
            winid = nil,
            bufnr = nil,
        }
        vim.opt.incsearch = true
end

local function visible_range(winid)
    return vim.fn.line("w0", winid), vim.fn.line("w$", winid)
end

local function get_regex(pattern)
    local ok, rx = pcall(vim.regex, pattern)
    if not ok then
        return nil
    end
    return rx
end

------------------------------------------------------------
-- Match Collection
------------------------------------------------------------

local function collect_matches(pattern)
    local winid = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_get_current_buf()

    local top, bot = visible_range(winid)
    local rx = get_regex(pattern)
    if not rx then
        return {}
    end

    local matches = {}

    for lnum = top, bot do
        local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
        if line then
            local start = 0
            while true do
                local s, e = rx:match_str(line:sub(start + 1))
                if not s then
                    break
                end
                local col_start = start + s
                local col_end = start + e

                local next_char = line:sub(col_end + 1, col_end + 1)
                if next_char == "" then
                    next_char = nil
                end

                table.insert(matches, {
                    lnum = lnum,
                    col_start = col_start,
                    col_end = col_end,
                    next_char = next_char,
                })

                start = col_end
            end
        end
    end

    table.sort(matches, function(a, b)
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        return a.col_start < b.col_start
    end)

    return matches
end

------------------------------------------------------------
-- Forbidden Characters
------------------------------------------------------------

local function compute_forbidden(matches)
    local forbidden = {}
    for _, m in ipairs(matches) do
        if m.next_char then
            forbidden[m.next_char] = true
        end
    end
    return forbidden
end

------------------------------------------------------------
-- Label Assignment
------------------------------------------------------------

local function available_label_chars(forbidden)
    local chars = {}
    for _, c in ipairs(LABEL_CHARS) do
        if not forbidden[c] then
            table.insert(chars, c)
        end
    end
    return chars
end

local function assign_labels(matches, forbidden)
    local chars = available_label_chars(forbidden)
    local labels = {}

    if #chars == 0 then
        return {}
    end

    if #matches <= #chars then
        for i, m in ipairs(matches) do
            labels[i] = {
                text = chars[i],
                match = m,
            }
        end
        return labels
    end

    -- multi-char labels
    local base = #chars
    for i, m in ipairs(matches) do
        local n = i - 1
        local label = ""
        repeat
            label = chars[(n % base) + 1] .. label
            n = math.floor(n / base) - 1
        until n < 0

        labels[i] = {
            text = label,
            match = m,
        }
    end

    return labels
end

------------------------------------------------------------
-- Rendering
------------------------------------------------------------

local function render_labels(labels, active_prefix)
    -- print(debug.traceback())
    vim.api.nvim_buf_clear_namespace(0, NS, 0, -1)

    for _, l in ipairs(labels) do
        local virt = l.text
        if active_prefix ~= "" and l.text:sub(1, #active_prefix) == active_prefix then
            virt = l.text
        end


        vim.api.nvim_buf_set_extmark(
            state.bufnr,
            NS,
            l.match.lnum - 1,
            l.match.col_end,
            {
                virt_text = { { virt, "MyFlashLabel" } },
                virt_text_pos = "overlay",
                -- hl_mode = "combine",
                hl_mode = "replace",
            }
        )
    end
end

------------------------------------------------------------
-- Label Filtering
------------------------------------------------------------

local function filter_labels_by_prefix(labels, prefix)
    -- print("filter_labels " .. vim.json.encode(labels))
    local out = {}
    for _, l in ipairs(labels) do
        if l.text == prefix then
            table.insert(out, 1, l)
        elseif l.text:sub(1, #prefix) == prefix then
            table.insert(out, l)
        end
    end
    -- for _, l in ipairs(labels) do
    --     -- print("filter_labels " .. l.text .. " " .. prefix)
    --     if l.text == prefix then
    --         table.insert(out, l)
    --     end
    -- end
    -- print("filter_labels " .. vim.json.encode(out))
    return out
end

------------------------------------------------------------
-- State Transitions
------------------------------------------------------------

local function enter_searching()
    state.mode = STATE.SEARCHING
end


local function enter_labeling()
    state.mode = STATE.LABELING
    state.label_input = ""
end

local function enter_jumping(label, change_state)
    if change_state then
        state.mode = STATE.JUMPING
    end

    vim.api.nvim_win_set_cursor(0, { label.match.lnum, label.match.col_end })
    -- reset_state()
end

------------------------------------------------------------
-- Cmdline Handling
------------------------------------------------------------

local function on_cmdline_changed()
    if vim.fn.getcmdtype() ~= "/" then
        return
    end


    print("on_cmdline_changed" .. state.mode)
    -- print("on_cmdline_changed " .. vim.f.getcmdline())

    local pattern = vim.fn.getcmdline()
    state.pattern = pattern

    if state.mode == STATE.SEARCHING then
        -- if #pattern < MIN_PATTERN_LEN then
        --     return
        -- end
        --
        -- local matches = collect_matches(pattern)
        -- if #matches <= 1 then
        --     return
        -- end
        --
        -- state.matches = matches
        -- state.forbidden = compute_forbidden(matches)
        -- state.labels = assign_labels(matches, state.forbidden)
        -- print("on_cmdline_changed " .. vim.json.encode(state.labels))
        --
        -- print(#state.labels)
        -- if #state.labels > 0 then
        --     -- enter_labeling()
        --     render_labels(state.labels, "")
        -- end
        --
    elseif state.mode == STATE.LABELING then

    end
end

------------------------------------------------------------
-- Input Interception (Label Typing)
------------------------------------------------------------

local function on_char_pre(c)
    -- Need to keep the below code here and not in on_cmdline_changed,
    -- as the cmdline text(vim.fn.getcmdline()) is not updated till 
    -- on_cmdline_changed is executed
    if state.mode == STATE.IDLE then
        return
    end
    local byte = c:byte()

    if byte == 3  -- <C-c>
        or byte == 27 -- <Esc>
    then
        -- scheduling since we need to jump first
        vim.schedule(function ()
            -- reset_state()
        end)
        return
    end

    local pattern = vim.fn.getcmdline() .. c
    state.pattern = pattern
    print("on_char_pre " .. state.mode)
    if state.mode == STATE.SEARCHING then

        -------------------old------------
        local labels_filtered = filter_labels_by_prefix(state.labels, c)
        if #labels_filtered > 0 then
            enter_labeling()
            ---new----
        else

            if #pattern < MIN_PATTERN_LEN then
                return
            end

            local matches = collect_matches(pattern)
            if #matches <= 1 then
                return
            end

            state.matches = matches
            state.frbidden = compute_forbidden(matches)
            state.labels = assign_labels(matches, state.forbidden)

            if #state.labels > 0 then
                -- enter_labeling()
                render_labels(state.labels, "")
            end
        end
    end

    print("on_char_pre after " .. state.mode)

    if state.mode == STATE.LABELING then
        state.label_input = state.label_input .. c
        vim.opt.incsearch = false

        print("on_char_pre here")
        local filtered = filter_labels_by_prefix(state.labels, state.label_input)
        print("on_char_pre " .. vim.json.encode(filtered))
        if #filtered >= 1 then
            exit_cmdline()
        end
        -- scheduling to allow it to exit cmdline, else the cmdline input pollutes it and 
        -- cursor is put back to the starting position
        -- moved here from on_cmdline_changed, as we exit the cmdline mode even for multi char labels and after doing that on_cmdline_changed is not fired
        vim.schedule(function ()

            if#filtered == 0 then
                -- ambiguity resolved in favor of search
                -- state.mode = STATE.SEARCHING
                -- vim.api.nvim_buf_clear_namespace(0, NS, 0, -1)
                return
            end

            if #filtered >= 1 then
                enter_jumping(filtered[1], false)
            elseif #filtered == 1 then
                enter_jumping(filtered[1], true)
                return
            end

            render_labels(filtered, state.label_input)
        end)
    end

end

------------------------------------------------------------
-- Autocommands
------------------------------------------------------------

function M.setup()
    local group = vim.api.nvim_create_augroup("SearchLabels", { clear = true })

    vim.api.nvim_create_autocmd("CmdlineEnter", {
        group = group,
        callback = function()
            if vim.fn.getcmdtype() == "/" then
                reset_state()
                state.winid = vim.api.nvim_get_current_win()
                state.bufnr = vim.api.nvim_get_current_buf()
                print("entering cmdline")
                enter_searching()
            end
        end,
    })

    vim.api.nvim_create_autocmd("CmdlineChanged", {
        group = group,
        callback = on_cmdline_changed,
    })

    -- vim.api.nvim_create_autocmd("CmdlineLeave", {
    --     group = group,
    --     callback = reset_state,
    -- })

    vim.on_key(on_char_pre, NS)
end

M.setup()









local LOG_BUF_NAME = "*searchlabels-log*"
local log_bufnr = nil

local function get_log_buffer()
    -- Reuse cached buffer if still valid
    if log_bufnr and vim.api.nvim_buf_is_valid(log_bufnr) then
        return log_bufnr
    end

    -- Search for existing buffer by name
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match(LOG_BUF_NAME) then
            log_bufnr = buf
            return buf
        end
    end

    -- Create new scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, LOG_BUF_NAME)

    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
    vim.api.nvim_buf_set_option(buf, "swapfile", false)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)

    log_bufnr = buf
    return buf
end
local function log_to_buffer(msg)
    local buf = get_log_buffer()

    local lines = vim.split(tostring(msg), "\n")
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
end
-- local function log_to_buffer(msg)
--   local buf = get_log_buffer()
--   local win = vim.fn.bufwinid(buf)
--   local cursor
--
--   if win ~= -1 then
--     cursor = vim.api.nvim_win_get_cursor(win)
--   end
--
--   local lines = vim.split(tostring(msg), "\n")
--   vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
--
--   if win ~= -1 and cursor then
--     vim.api.nvim_win_set_cursor(win, { cursor[1] + #lines, cursor[2] })
--   end
-- end
print = function(msg) 
    log_to_buffer(msg)
end






--vim.cmd("vsp *searchlabels-log*")
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*searchlabels-log*",
  command = "normal! G",
})


