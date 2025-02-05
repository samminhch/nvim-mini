local now, add = MiniDeps.now, MiniDeps.add

now(
    function()
        add({
            source = "nvim-java/nvim-java",
            depends = {
                "nvim-java/lua-async-await",
                "nvim-java/nvim-java-refactor",
                "nvim-java/nvim-java-core",
                "nvim-java/nvim-java-test",
                "nvim-java/nvim-java-dap",
                "MunifTanjim/nui.nvim",
                "mfussenegger/nvim-dap",
                "JavaHello/spring-boot.nvim",
                "neovim/nvim-lspconfig",
            },
        })
    end
)
