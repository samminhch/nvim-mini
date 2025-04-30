require("mini.deps").now(function()
    -- ╒══════════╕
    -- │Appearance│
    -- ╘══════════╛
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    vim.opt.cursorline = true
    vim.opt.termguicolors = vim.fn.has("termguicolors") == 1 -- Conditional termguicolors support
    vim.opt.wrap = true
    vim.opt.breakindent = true
    vim.opt.pumblend = 10 -- Popup menu transparency
    vim.opt.pumheight = 10 -- Limit popup menu height
    vim.opt.conceallevel = 2 -- Hide special characters like bold/italic markup
    vim.opt.splitkeep = "screen" -- Preserve layout during splits
    vim.opt.winborder = "rounded"

    -- ╒══════════════════════════╕
    -- │Indentations / Formatting │
    -- ╘══════════════════════════╛
    vim.opt.expandtab = true -- Use spaces instead of tabs
    vim.opt.smarttab = true -- Insert appropriate number of spaces for a tab
    vim.opt.smartindent = true -- Enable C-style indentation
    vim.opt.shiftwidth = 4 -- Number of spaces for indentation
    vim.opt.softtabstop = 4 -- Spaces for a tab while editing
    vim.opt.formatoptions = "jcroqnt" -- Adjust format options for better text formatting

    -- ╒═════════════╕
    -- │Key Behavior │
    -- ╘═════════════╛
    vim.opt.clipboard = "unnamedplus" -- Use system clipboard
    vim.opt.mouse = "a" -- Enable mouse in all modes
    vim.opt.scrolloff = 4 -- Keep 4 lines visible when scrolling
    vim.opt.timeoutlen = 300 -- Shorter timeout for key sequences
    vim.opt.updatetime = 100 -- Faster updates for better responsiveness
    vim.opt.completeopt = "menuone,noselect" -- Configure completion menu behavior
    vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
    vim.opt.history = 50 -- Keep a history of 50 commands

    -- ╒════════════════╕
    -- │Search Behavior │
    -- ╘════════════════╛
    vim.opt.ignorecase = true -- Case-insensitive search
    vim.opt.smartcase = true -- Override case-insensitivity when uppercase present
    vim.opt.hlsearch = true -- Highlight search matches

    -- ╒══════════════════════════════════╕
    -- │ Backup, Swap, Undo, and Autosave │
    -- ╘══════════════════════════════════╛
    vim.opt.autowrite = true -- Automatically save before certain actions
    vim.opt.confirm = true -- Ask for confirmation when quitting unsaved
    vim.opt.backup = false -- Disable backups
    vim.opt.writebackup = true -- Enable write-backups
    vim.opt.undofile = true -- Enable persistent undo
    vim.opt.swapfile = true -- Enable swap files

    -- ╒════════════════╕
    -- │ Spell Checking │
    -- ╘════════════════╛
    -- vim.opt.spell = true -- Enable spell checking
    -- vim.opt.spelllang = "en_us" -- Set spell-checking language

    -- ╒═══════╕
    -- │ Folds │
    -- ╘═══════╛
    vim.opt.foldcolumn = "auto" -- Dynamic fold column width
    vim.opt.foldlevel = 20 -- Open folds up to level 20 by default
    vim.opt.foldmethod = "expr" -- Use expression-based folding
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Treesitter for folding
    vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()" -- Customize fold text display
end)
