local M = {}

function M.setup()
  local ok, configs = pcall(require, "nvim-treesitter")
  if not ok then
    vim.notify("nvim-treesitter not loaded.", vim.log.levels.WARN)
    return
  end

  require("rainbow-delimiters.setup").setup({})
  
  configs.setup({
    install = {
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

    sync_install = false,
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
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
      enable_autocmd = false,
    },
  })
end

return M
