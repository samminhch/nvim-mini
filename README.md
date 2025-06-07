# samminhch.nvim

## Quick Start

### Requirements

- [ ] [NeoVIM](https://neovim.io/) (≥ v0.11.0)
- [ ] [ripgrep](https://github.com/BurntSushi/ripgrep)
- [ ] [npm](https://nodejs.org/en) (I recommend [nvm](https://github.com/nvm-sh/nvm) for installation)
- [ ] `git` (≥ v2.19.0)
- [ ] [C compiler](https://github.com/nvim-treesitter/nvim-treesitter#requirements)

### Back Up Previous Configuration

Make sure to back up these files:

| Linux / MacOS              | Windows                                 |
| -------------------------- | --------------------------------------- |
| `$HOME/.config/nvim/`      | `$Env.HomePath\AppData\Local\nvim`      |
| `$HOME/.local/share/nvim/` | `$Env.HomePath\AppData\Local\nvim-data` |
| `$HOME/.cache/nvim/`       |                                         |

...and then clone the repository into the respective folders

## Plugin List (17)

```txt
┌──(`mini.nvim` Suite)  # Used throughout config
├──(Appearance)
│  ├──[everviolet/nvim]
│  ├──[sainnhe/everforest]
│  └──[stevearc/dressing.nvim]
├──(General Text Editing)
│  ├──[mbbill/undotree]
│  ├──[nvim-treesitter/nvim-treesitter]
│  ├──[nvim-treesitter/nvim-treesitter-context]
│  └──[stevearc/conform.nvim]
├──(Mason)
│  └──[WhoIsSethDaniel/mason-tool-installer.nvim]
│     ├──(mason-org/mason.nvim)
│     └──(mason-org/mason-lspconfig.nvim)
├──(Language-Specific)
│  ├──[MeanderingProgrammer/render-markdown.nvim]
│  ├──[chomosuke/typst-preview.nvim]
│  ├──[folke/lazydev.nvim]
│  ├──[p00f/clangd_extensions.nvim]
│  └──[saecki/crates.nvim]
└──(Keymap Management)
   └──[folke/which-key.nvim]
```
