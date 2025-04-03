MiniDeps.now(
    function()
        MiniDeps.add({
            source = "MeanderingProgrammer/render-markdown.nvim",
            depends = {
                "nvim-treesitter/nvim-treesitter",
                "echasnovski/mini.nvim",
            },
        })
    end
)

MiniDeps.later(function() require("render-markdown").setup() end)
