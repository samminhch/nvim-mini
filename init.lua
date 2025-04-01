-- ╒═════════════════════════════╕
-- │samminhch.nvim -- mini setup │
-- ╘═════════════════════════════╛
-- A more minimal, portable, but
-- just as powerful NeoVIM setup
--
-- ! Nerd Font Symbols are **highly recommended** for best experience !
-- ! Don't use on TTY if you can avoid it                             !
----------------------------------

-- ╒═════════════════╕
-- │`mini.nvim` Setup│
-- ╘═════════════════╛
-- Clone `mini.nvim` manually in a way that it gets managed by `mini.deps`
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim",
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up `mini.deps` (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

-- ╒══════════════════════════════════╕
-- │Include nvim Settings and Bindings│
-- ╘══════════════════════════════════╛
-- Make a hyprlang filetype
vim.filetype.add({
    pattern = { [".*/hypr.*%.conf"] = "hyprlang" },
    callback = function(event) vim.bo[event.buf].commentstring = "# %s" end,
})
require("base.settings")
require("base.bindings")

-- ╒══════════════════════╕
-- │Load all Plugin Files │
-- ╘══════════════════════╛

-- Set up colorscheme first
require("plugins")
