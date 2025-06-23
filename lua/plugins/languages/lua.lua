MiniDeps.now(function() MiniDeps.add({ source = "folke/lazydev.nvim" }) end)
MiniDeps.later(function() require("lazydev").setup() end)
