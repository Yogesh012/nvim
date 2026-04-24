# Keybindings Reference

Leader key: `<Space>`

> **Tip:** Press `?` in normal mode to open the interactive **Keymap Help picker** — search keymaps by key combo, category, or description.

---

## Core Editor

| Key | Mode | Action |
|-----|------|--------|
| `?` | Normal | Open Keymap Help picker |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Close buffer (focus left neighbour or tree) |
| `<leader><leader>` | Normal | Toggle between current and last buffer |
| `jk` | Insert | Exit to normal mode |
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to window below |
| `<C-k>` | Normal | Move to window above |
| `<C-l>` | Normal | Move to right window |
| `<M-j>` | Normal/Visual | Move line/selection down |
| `<M-k>` | Normal/Visual | Move line/selection up |
| `J` | Visual/Select | Move selection down |
| `K` | Visual/Select | Move selection up |
| `p` | Visual | Paste without yanking selection |

---

## Keymap Help Picker

| Key | Context | Action |
|-----|---------|--------|
| `?` | Normal | Open picker |
| `<Tab>` / `<S-Tab>` | Insert (in picker) | Navigate list |
| `<Esc>` | Insert (in picker) | Enter normal mode |
| `j` / `k` | Normal (in picker) | Navigate list |
| `<Esc>` | Normal (in picker) | Close picker |

Search by typing any part of the key combo, category name, or description. Multiple words are ANDed (e.g. `git stage` shows only entries containing both).

---

## File Navigation (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (dropdown, no preview) |
| `<leader>fF` | Find files (with preview) |
| `<leader>fg` | Live grep |
| `<leader>fb` | List open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fc` | Commands |
| `<leader>fk` | Raw keymaps picker |
| `<leader>f/` | Grep in current buffer |
| `<leader>fl` | Lua help tags |
| `<leader>fp` | Python help tags |
| `<leader>fs` | File symbols (Treesitter) |
| `<leader>fS` | File symbols (LSP) |
| `<leader>fw` | Workspace symbols (LSP) |
| `<leader>fcf` | Find Neovim config files |
| `<leader>fcg` | Grep in Neovim config |
| `<leader>fe` | Symbol/glyph picker |
| `<leader>fP` | Projects |

---

## File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle nvim-tree |

---

## Buffers

| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>bp` | Pick buffer (interactive) |

---

## Git (gitsigns)

> These keymaps are **buffer-local** — available in any file tracked by git.

### Hunk Navigation

| Key | Action |
|-----|--------|
| `]g` | Next hunk |
| `[g` | Previous hunk |

### Hunk Operations

| Key | Mode | Action |
|-----|------|--------|
| `<leader>hs` | Normal | Stage hunk |
| `<leader>hs` | Visual | Stage selected lines |
| `<leader>hr` | Normal | Reset hunk |
| `<leader>hr` | Visual | Reset selected lines |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hp` | Normal | Preview hunk |

### Buffer Operations

| Key | Action |
|-----|--------|
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |

### Git Views

| Key | Action |
|-----|--------|
| `<leader>gb` | Toggle current-line blame |
| `<leader>gd` | Diff this file |
| `<leader>gc` | Commits (Telescope) |
| `<leader>gB` | Branches (Telescope) |
| `<leader>gs` | Status (Telescope) |
| `<leader>gS` | Stash (Telescope) |

### Diffview

| Key | Action |
|-----|--------|
| `<leader>dv` | Open diff view |
| `<leader>dh` | File history (all) |
| `<leader>df` | File history (current file) |

---

## Git Conflicts

| Key | Action |
|-----|--------|
| `]x` | Next conflict |
| `[x` | Previous conflict |
| `<leader>co` | Choose ours |
| `<leader>ct` | Choose theirs |
| `<leader>cb` | Choose both |
| `<leader>cn` | Choose none |
| `<leader>cx` | List all conflicts (Telescope) |
| `<leader>gm` | 2-way merge view (DiffviewOpen) |
| `<leader>gm3` | 3-way merge view |
| `<leader>gmc` | Close merge view |

---

## LSP

> Buffer-local — available when an LSP server is attached.

### Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `gs` | Signature help |

### Code Actions

| Key | Action |
|-----|--------|
| `<leader>ca` | Code actions (normal + visual) |
| `<leader>rn` | Rename symbol |
| `gf` | Format buffer |

### Diagnostics

| Key | Action |
|-----|--------|
| `gj` | Next diagnostic (float) |
| `gk` | Previous diagnostic (float) |
| `gl` | Show line diagnostic (float) |
| `gL` | All diagnostics (Telescope) |
| `<leader>dq` | Diagnostics → quickfix list |
| `<leader>dl` | Diagnostics → loclist |

### Toggles

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle virtual text |
| `<leader>th` | Toggle inlay hints |

### Workspace

| Key | Action |
|-----|--------|
| `gwa` | Add workspace folder |
| `gwr` | Remove workspace folder |
| `gwl` | List workspace folders |

---

## Treesitter

### Incremental Selection

| Key | Mode | Action |
|-----|------|--------|
| `vv` | Normal | Init selection |
| `<S-l>` | Visual | Expand to parent node |
| `<S-s>` | Visual | Expand to scope |
| `<S-h>` | Visual | Shrink to child node |

### Text Objects

| Key | Mode | Action |
|-----|------|--------|
| `af` | Visual/Operator | Outer function |
| `if` | Visual/Operator | Inner function |
| `ac` | Visual/Operator | Outer class |
| `ic` | Visual/Operator | Inner class |

---

## Commenting

| Key | Mode | Action |
|-----|------|--------|
| `gc` | Normal/Visual | Toggle line comment |
| `gb` | Normal/Visual | Toggle block comment |

---

## Themes (chromatic.nvim)

| Key | Action |
|-----|--------|
| `<leader>Tn` | Random next theme |
| `<leader>Tc` | Theme settings picker |
| `<leader>Td` | Set dark mode (persisted) |
| `<leader>Tl` | Set light mode (persisted) |
| `<leader>Ta` | Set any mode (persisted) |
| `<leader>Ti` | Theme info |

---

## Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Manage plugins |
| `:Mason` | Manage LSP servers, formatters, linters |
| `:ToggleFormatOnSave` | Toggle auto-format on save |
| `:Format` | Format buffer |
| `:DiagnosticsShowAll` / `:DSA` | Show all diagnostics |
| `:DiagnosticsShowErrors` / `:DSE` | Show errors only |
| `:DiagnosticsShowWarnings` / `:DSW` | Show errors and warnings |
| `:DiagnosticsHide` / `:DSH` | Hide diagnostics |
| `:Telescope` | Open Telescope picker |
| `:NvimTreeToggle` | Toggle file explorer |
| `:checkhealth` | Check Neovim health |
| `:TSUpdate` | Update Treesitter parsers |

---

## Telescope Navigation (Inside any Telescope picker)

| Key | Action |
|-----|--------|
| `<C-n>` / `<Down>` | Next item |
| `<C-p>` / `<Up>` | Previous item |
| `<Tab>` / `<S-Tab>` | Next / previous item |
| `<M-p>` | Toggle preview |
| `<CR>` | Select item |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-u>` | Scroll preview up |
| `<C-d>` | Scroll preview down |
| `<C-q>` | Send all to quickfix |
| `<M-q>` | Send selected to quickfix |
| `<Esc>` | Close Telescope |
