return {
    cmd = { "arduino-language-server" },
    filetypes = { "arduino", "cpp" },
    root_markers = { "sketch.yaml" },
    capabilities = {
        textDocument = {
            semanticTokens = vim.NIL,
        },
        workspace = {
            semanticTokens = vim.NIL,
        },
    },
}
