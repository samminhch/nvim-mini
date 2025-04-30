return {
    before_init = function()
        -- Setup lazydev before configuring LSPs
        ---@diagnostic disable-next-line: missing-fields
        require("lazydev").setup({
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        })
    end,
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
}
