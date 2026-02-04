# Keybindings Reference

Leader key: `<Space>`

## Core Editor

| Key | Mode | Action |
|-----|------|--------|
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Close buffer |
| `jk` | Insert | Exit to normal mode |
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to window below |
| `<C-k>` | Normal | Move to window above |
| `<C-l>` | Normal | Move to right window |
| `<M-j>` | Normal/Visual | Move line/selection down |
| `<M-k>` | Normal/Visual | Move line/selection up |
| `J` | Visual | Move selection down |
| `K` | Visual | Move selection up |
| `p` | Visual | Paste without yanking |

## File Navigation (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (dropdown, no preview) |
| `<leader>fF` | Find files (with preview) |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | List open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>f/` | Grep in current buffer |
| `<leader>fl` | Lua help tags |
| `<leader>fp` | Python help tags |
| `<leader>fs` | File symbols (Treesitter) |
| `<leader>fS` | File symbols (LSP) |
| `<leader>fw` | Workspace symbols (LSP) |
| `<leader>fcf` | Find config files |
| `<leader>fcg` | Grep in config |
| `<leader>fe` | Symbol picker |
| `<leader>fP` | Projects |

## File Explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle nvim-tree |

## Buffers

| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bp` | Pick buffer (interactive) |

## LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Show references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>d` | Show line diagnostics |

## Commenting

| Key | Mode | Action |
|-----|------|--------|
| `gc` | Normal/Visual | Toggle line comment |
| `gb` | Normal/Visual | Toggle block comment |

## Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Manage plugins |
| `:Mason` | Manage LSP servers, formatters, linters |
| `:ToggleFormatOnSave` | Toggle auto-format on save |
| `:Telescope` | Open Telescope picker |
| `:NvimTreeToggle` | Toggle file explorer |
| `:checkhealth` | Check Neovim health |

## Telescope Navigation (Inside Telescope)

| Key | Action |
|-----|--------|
| `<C-n>` / `<Down>` | Next item |
| `<C-p>` / `<Up>` | Previous item |
| `<CR>` | Select item |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-u>` | Scroll preview up |
| `<C-d>` | Scroll preview down |
| `<Esc>` | Close Telescope |
