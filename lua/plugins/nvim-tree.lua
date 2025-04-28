local M = {}

function M.setup()
  local function on_attach(bufnr)
    local api = require("nvim-tree.api")

    -- Set default keymaps (important!)
    api.config.mappings.default_on_attach(bufnr)

    local opts = function(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
  end

  require("nvim-tree").setup({
    on_attach = on_attach,

    view = {
      width = 30,
      side = "left",
      preserve_window_proportions = true,
    },

    diagnostics = {
      enable = true,
      show_on_dirs = false,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      },
    },

    renderer = {
      highlight_git = true,
      root_folder_label = false, --  hide root folder
      highlight_opened_files = "all", -- "none" | "icon" | "name" | "all"

      indent_markers = {
        enable = true,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          bottom = "─",
          none = " ",
        },
      },

      icons = {
        webdev_colors = true,
        git_placement = "before", -- "before" | "after" (after the file/folders icons)| "signcolumn"
        padding = " ",
        symlink_arrow = " ➛ ",
        show = {
          git = true,
          folder = true,
          file = true,
          folder_arrow = true,
        },

        glyphs = {
          default = "",
          symlink = "",
          bookmark = "",

          git = {
            unstaged = "",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            deleted = "",
            untracked = "U",
            ignored = "◌",
          },

          folder = {
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            arrow_closed = "",
            arrow_open = "",
            symlink_open = "",
          },
        },
      },
    },

    update_focused_file = {
      enable = true,
      update_root = true,
    },

    filters = {
      dotfiles = false,
      -- custom = {".git"},
      exclude = {},
    },

    git = {
      enable = true,
      ignore = false,
    },
  })
end

return M
