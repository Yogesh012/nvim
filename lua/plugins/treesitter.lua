local M = {}

function M.setup()
  require("rainbow-delimiters.setup").setup({})
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "lua",
      "vim",
      "bash",
      "python",
      "javascript",
      "typescript",
      "html",
      "css",
      "json",
      "markdown",
      "markdown_inline",
      "yaml",
      "toml",
      "tsx",
      "rust",
      "c",
    },

    sync_install = false, -- install in background
    auto_install = true, -- install missing parsers when opening file

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
      -- disable = {"python"}
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "vv",
        node_incremental = "<S-l>",
        scope_incremental = "<S-s>",
        node_decremental = "<S-h>",
      },
    },

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },

    autopairs = {
      enable = true,
    },

    context_commentstring = {
      enable = true,
      enable_autcmd = false, -- let comment.nvim handle it.
    },
  })
end

return M
