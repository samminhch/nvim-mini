---@type vim.lsp.Config
return {
    cmd = { "arduino-language-server" },
    filetypes = { "arduino", "cpp" },
    root_markers = { "sketch.yaml" },
    capabilities = {
        textDocument = {
            semanticTokens = nil,
        },
        workspace = {
            semanticTokens = nil,
        },
    },
}
