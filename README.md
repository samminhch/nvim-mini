# samminhch.nvim

## Quick Start

### Requirements

- [ ] [NeoVIM](https://neovim.io/) (≥ v0.10.0)
- [ ] [ripgrep](https://github.com/BurntSushi/ripgrep)
- [ ] [npm](https://nodejs.org/en) (I recommend [nvm](https://github.com/nvm-sh/nvm) for installation)
- [ ] `git` (≥ v2.19.0)
- [ ] [C compiler](https://github.com/nvim-treesitter/nvim-treesitter#requirements)

### Back Up Previous Configuration

Make sure to back up these files:

| Linux                      | Windows                                       |
| -------------------------- | --------------------------------------------- |
| `$HOME/.config/nvim/`      | `C:\Users\<username>\AppData\Local\nvim`      |
| `$HOME/.local/share/nvim/` | `C:\Users\<username>\AppData\Local\nvim-data` |
| `$HOME/.cache/nvim/`       |                                               |

...and then clone the repository into the respective folders

## Plugin List (30)

```txt
┌──(`mini.nvim` Suite)  # Used throughout config
├──(Appearance)
│  ├──[sainnhe/everforest]
│  └──[MunifTanjim/nui.nvim]
├──(General Text Editing)
│  ├──[nvim-treesitter/nvim-treesitter]
│  ├──[saghen/blink.cmp]  # I prefer over `mini.completion` atm
│  ├──[mbbill/undotree]
│  └──[stevearc/conform.nvim]
├──(Coding)
│  ├──[neovim/nvim-lspconfig]
│  │  ├──(folke/lazydev.nvim)
│  │  ├──(williamboman/mason.nvim)
│  │  ├──(jay-babu/mason-nvim-dap.nvim)
│  │  ├──(williamboman/mason-lspconfig.nvim)
│  │  └──(WhoIsSethDaniel/mason-tool-installer.nvim)
│  └──[mfussenegger/nvim-dap]
│     ├──(rcarriga/nvim-dap-ui)
│     ├──(nvim-neotest/nvim-nio)
│     └──(jay-babu/mason-nvim-dap.nvim)
├──(Language-Specific)
│  ├──[p00f/clangd_extensions.nvim]
│  ├──[MeanderingProgrammer/render-markdown.nvim]
│  ├──[saecki/crates.nvim]
│  ├──[chomosuke/typst-preview.nvim]
│  └──[nvim-java/nvim-java]
│     ├──(nvim-java/lua-async-await)
│     ├──(nvim-java/nvim-java-refactor)
│     ├──(nvim-java/nvim-java-core)
│     ├──(nvim-java/nvim-java-test)
│     ├──(nvim-java/nvim-java-dap)
│     ├──(MunifTanjim/nui.nvim)
│     ├──(mfussenegger/nvim-dap)
│     └──(JavaHello/spring-boot.nvim)
└──(Keymap Management)
   └──[folke/which-key.nvim]
```
