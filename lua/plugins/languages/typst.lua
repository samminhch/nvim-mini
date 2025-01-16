local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

now(function()
    add({
        source = "chomosuke/typst-preview.nvim",
        version = "v1.2.2",
        hooks = {
            post_checkout = function() require("typst-preview").update() end,
        },
    })
end)

later(
    function()
        require("typst-preview").setup({
            dependencies_bin = {
                tinymist = "tinymist",
            },
        })
    end
)
