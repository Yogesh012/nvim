# Neovim Configuration

A clean, modular Neovim configuration built with Lua and lazy.nvim. Focused on simplicity, performance, and easy customization.

## ✨ Features

- 🚀 **Fast Startup** - Lazy loading with lazy.nvim, optimized for performance
- 🎨 **Modern UI** - Dynamic themes via chromatic.nvim, lualine, bufferline
- 📝 **LSP Support** - Full language server protocol integration (native 0.11+)
- 🔍 **Fuzzy Finding** - Telescope with extended keymaps
- 🌳 **File Explorer** - nvim-tree for project navigation
- ✅ **Auto-completion** - nvim-cmp with LSP and snippet support
- 🎯 **Formatting & Linting** - conform.nvim and nvim-lint
- ⌨️ **Keymap Help** - Press `?` for a searchable keymap reference (by key, category, or description)
- 🔧 **Easy Customization** - Single `config.lua` file for all settings
- 📦 **Modular Design** - Organized plugin specs and keymap files by category

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

### Startup Option Guard (E21 Fix)

Some options (e.g., `tabstop`, `shiftwidth`, `textwidth`, `listchars`, `conceallevel`, `fileencoding`) are **buffer-local**. On cold start, the active buffer can be unmodifiable (special UI buffers or the initial [No Name] buffer), so setting those options can raise `E21: Cannot make changes, 'modifiable' is off`. The config now applies buffer-local defaults only when `vim.bo.modifiable` is true, while keeping global defaults via `vim.opt_global`.

### Add Custom Settings

The `config.lua` file is consumed by LSP, formatting, and plugin modules. Add your settings there and they'll be automatically picked up.

## ⌨️ Keybindings

Leader key: `<Space>` — see [KEYMAPS.md](KEYMAPS.md) for the full reference.

> Press `?` in normal mode to open the **interactive keymap help picker** — search by key combo, category, or description keyword.

### Core

| Key | Action |
|-----|--------|
| `?` | Keymap help picker |
| `<leader>w` | Save file |
| `<leader>q` | Close buffer |
| `<leader><leader>` | Toggle last buffer |
| `jk` | Exit insert mode |
| `<C-h/j/k/l>` | Navigate windows |

### File Navigation (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (dropdown) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fP` | Projects |
| `<leader>fcf` / `<leader>fcg` | Find / grep config files |
| `<leader>e` | Toggle file explorer |

### Git

| Key | Action |
|-----|--------|
| `]g` / `[g` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>gs` | Git status (Telescope) |
| `<leader>gc` | Commits (Telescope) |
| `<leader>dv` | Diff view |

### LSP (buffer-local when LSP attached)

| Key | Action |
|-----|--------|
| `gd` / `gr` / `gi` / `gt` | Definition / references / impl / type |
| `K` | Hover docs |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename |
| `gj` / `gk` | Next / prev diagnostic |
| `gL` | All diagnostics (Telescope) |
| `gf` | Format buffer |

### Themes

| Key | Action |
|-----|--------|
| `<leader>Tn` | Random next theme |
| `<leader>Td` / `<leader>Tl` | Set dark / light mode |
| `<leader>Tc` | Theme picker |

### Text Editing

| Key | Action |
|-----|--------|
| `gc` / `gb` | Comment toggle (line / block) |
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
│   │   ├── keymaps.lua        # Core keymaps + '?' help trigger
│   │   └── autocmds.lua       # Auto commands
│   ├── lsp/
│   │   ├── init.lua           # LSP setup
│   │   ├── servers.lua        # Server configs (uses config.lua)
│   │   ├── keymaps.lua        # LSP keymaps (all LSP: prefixed)
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
│   │   │   ├── lsp.lua        # LSP plugins
│   │   │   ├── completion.lua # nvim-cmp stack
│   │   │   └── tools.lua      # Formatting & linting
│   │   ├── keymaps/           # Dedicated keymap modules
│   │   │   ├── telescope.lua  # All Find: keymaps
│   │   │   └── help.lua       # '?' keymap help picker
│   │   └── [configs]/         # Individual plugin configs
│   └── utils/                 # Helper functions
├── README.md                   # This file
├── KEYMAPS.md                  # Full keybindings reference
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

1. **Find any keymap**: Press `?` to open the interactive keymap help picker
2. **Install LSP servers**: Run `:Mason` and install servers for your languages
3. **Install formatters/linters**: Use Mason or your system package manager
4. **Customize settings**: Edit `lua/config.lua` for most changes
5. **Add new plugins**: Add specs to files in `lua/plugins/specs/`
6. **Add new keymaps**: Use `"Category: Description"` in `desc` so they appear in `?`
7. **Check health**: Run `:checkhealth` to diagnose issues
8. **Profile startup**: `nvim --startuptime startup.log` to check performance
9. **Full keymap reference**: See `KEYMAPS.md`

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
