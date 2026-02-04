# Neovim Configuration

A clean, modular Neovim configuration built with Lua and lazy.nvim. Focused on simplicity, performance, and easy customization.

## ✨ Features

- 🚀 **Fast Startup** - Lazy loading with lazy.nvim, optimized for performance
- 🎨 **Modern UI** - Tokyo Night theme, lualine, bufferline
- 📝 **LSP Support** - Full language server protocol integration via Mason
- 🔍 **Fuzzy Finding** - Telescope with extended keymaps
- 🌳 **File Explorer** - nvim-tree for project navigation
- ✅ **Auto-completion** - nvim-cmp with LSP and snippet support
- 🎯 **Formatting & Linting** - conform.nvim and nvim-lint
- 🔧 **Easy Customization** - Single `config.lua` file for all settings
- 📦 **Modular Design** - Organized plugin specs by category

## 📦 Installation

### Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)
- ripgrep (for Telescope live_grep)

### Install

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone <your-repo-url> ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

On first launch, lazy.nvim will automatically install all plugins. Then run `:Mason` to install LSP servers, formatters, and linters.

## 🎨 Customization

All user settings are centralized in **`lua/config.lua`** - this is the only file you need to edit for most customizations!

### Change Colorscheme

```lua
ui = {
  colorscheme = "tokyonight",  -- Change to any installed theme
  transparent_background = false,
}
```

### Configure LSP Servers

```lua
lsp = {
  servers = {
    "lua_ls",
    "pyright",
    "ruff",
    -- Add more servers here
  },
}
```

### Setup Formatters

```lua
formatting = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    -- Add more formatters
  },
}
```

### Toggle Format on Save

```lua
editor = {
  format_on_save = true,  -- Set to false to disable
}
```

Toggle at runtime: `:ToggleFormatOnSave`

### Add Custom Settings

The `config.lua` file is consumed by LSP, formatting, and plugin modules. Add your settings there and they'll be automatically picked up.

## ⌨️ Keybindings

Leader key: `<Space>`

### Core

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Close buffer |
| `jk` | Exit insert mode |
| `<C-h/j/k/l>` | Navigate windows |

### File Navigation (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (dropdown) |
| `<leader>fF` | Find files (with preview) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>f/` | Grep in current buffer |
| `<leader>fs` | File symbols (Treesitter) |
| `<leader>fS` | File symbols (LSP) |
| `<leader>fw` | Workspace symbols |
| `<leader>fcf` | Find config files |
| `<leader>fcg` | Grep in config |
| `<leader>fP` | Projects |
| `<leader>e` | Toggle file explorer |

### Buffers

| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bp` | Pick buffer |

### LSP (when in a file with LSP)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename |
| `[d` / `]d` | Previous/next diagnostic |

### Text Editing

| Key | Action |
|-----|--------|
| `gc` | Comment toggle (normal/visual) |
| `gb` | Block comment toggle |
| `<M-j>` / `<M-k>` | Move line up/down |
| `J` / `K` (visual) | Move selection up/down |

## 📁 Project Structure

```
nvim/
├── init.lua                    # Entry point (loads core & plugins)
├── lua/
│   ├── config.lua             # 🎯 USER CONFIG - edit this!
│   ├── core/
│   │   ├── init.lua           # Core module loader
│   │   ├── options.lua        # Editor options
│   │   ├── keymaps.lua        # Core keymaps (minimal)
│   │   └── autocmds.lua       # Auto commands
│   ├── lsp/
│   │   ├── init.lua           # LSP setup
│   │   ├── servers.lua        # Server configs (uses config.lua)
│   │   ├── keymaps.lua        # LSP keymaps
│   │   ├── diagnostics.lua    # Diagnostics config
│   │   ├── capabilities.lua   # LSP capabilities
│   │   ├── utils.lua          # LSP utilities
│   │   └── settings/          # Per-server settings
│   ├── plugins/
│   │   ├── lazy.lua           # lazy.nvim bootstrap
│   │   ├── specs/             # Plugin specifications (organized)
│   │   │   ├── core.lua       # Telescope, nvim-tree, Treesitter
│   │   │   ├── ui.lua         # Colorscheme, lualine, bufferline
│   │   │   ├── editor.lua     # Comment, autopairs, gitsigns
│   │   │   ├── lsp.lua        # LSP plugins (Mason, lspconfig)
│   │   │   ├── completion.lua # nvim-cmp stack
│   │   │   └── tools.lua      # Formatting & linting
│   │   └── [configs]/         # Individual plugin configs
│   └── utils/                 # Helper functions
├── README.md                   # This file
├── KEYMAPS.md                  # Keybindings reference
└── MEMORY_BANK.md              # Project knowledge base
```

## 🔌 Plugins

### Core
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - File explorer
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting

### LSP & Completion
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine

### Editor
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Commenting
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto pairs
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - Indent guides

### Tools
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Formatting
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linting

### UI
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Colorscheme
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer tabs

## 🛠️ Commands

- `:Lazy` - Manage plugins
- `:Mason` - Manage LSP servers
- `:ToggleFormatOnSave` - Toggle format on save
- `:Telescope` - Open Telescope
- `:NvimTreeToggle` - Toggle file explorer

## 📝 Tips

1. **Install LSP servers**: Run `:Mason` and install servers for your languages
2. **Install formatters/linters**: Use Mason or your system package manager
3. **Customize settings**: Edit `lua/config.lua` for most changes
4. **Add new plugins**: Add specs to files in `lua/plugins/specs/`
5. **Plugin-specific keymaps**: Defined in plugin specs for better organization
6. **Check health**: Run `:checkhealth` to diagnose issues
7. **Profile startup**: `nvim --startuptime startup.log` to check performance
8. **View keymaps**: See `KEYMAPS.md` for complete reference

## 🏗️ Architecture

### Design Principles
- **Single source of truth**: `config.lua` for all user settings
- **Modular organization**: Plugins grouped by function
- **Lazy loading**: Everything loads on-demand for fast startup
- **Convention over configuration**: Sensible defaults, easy overrides

### Module Loading Order
1. `init.lua` → Loads core and plugins
2. `core/init.lua` → Sets up options, keymaps, autocmds
3. `plugins/lazy.lua` → Bootstraps lazy.nvim
4. `plugins/specs/*.lua` → Plugin specs (lazy-loaded)
5. `lsp/init.lua` → LSP setup (on FileType)

## 🤝 Contributing

Feel free to fork and customize for your needs!

## 📄 License

MIT
