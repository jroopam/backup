return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc" },
    settings = {
        Lua = {
            hint = { enable = true },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" }, disable = {"missing-fields"} },
            workspace = { checkThirdParty = false },
            format = {enable = false}
        },
    },
}
