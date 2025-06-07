MiniDeps.now(function() MiniDeps.add({ source = "saecki/crates.nvim" }) end)

MiniDeps.later(function()
    require("crates").setup({
        popup = {
            border = "rounded",
        },
        lsp = {
            enabled = true,
            on_attach = function(client, bufnr)
                -- The same on_attach function as for your other LSPs
            end,
            actions = true,
            completion = true,
            hover = true,
        },
        completion = {
            cmp = {
                enabled = true,
            },
            crates = {
                enabled = true,
            },
        },
    })
end)
