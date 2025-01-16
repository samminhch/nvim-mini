local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

now(
    function()
        add({
            source = "MeanderingProgrammer/render-markdown.nvim",
            depends = {
                "nvim-treesitter/nvim-treesitter",
                "echasnovski/mini.nvim",
            },
        })
    end
)

later(function() require("render-markdown").setup() end)
