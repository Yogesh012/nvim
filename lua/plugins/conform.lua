local util = require("conform.util")
local M = {}

function M.setup()
  require("conform").setup({
    -- Automatically format on save
    format_on_save = function(bufnr)
      -- Disable for certain filetypes or large files
      local ignore_ft = { "markdown" }
      local max_lines = 5000

      if vim.g.format_on_save then
        if vim.tbl_contains(ignore_ft, vim.bo[bufnr].filetype) then
          return
        end
        if vim.api.nvim_buf_line_count(bufnr) > max_lines then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end
    end,

    formatters_by_ft = {
      lua = { "stylua" },
      python = {"isort", "ruff_format" },
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      sh = { "shfmt" },
      yaml = { "prettier" },
      -- rust = { "rustfmt" },
      -- Add more as needed
    },

    formatters = {
      ruff_format = {
        command = "ruff",
        args = function(ctx)
          -- Find ruff.toml in project root or fallback
          local root = util.root_file({
            "pyproject.toml",
            "ruff.toml",
            ".ruff.toml",
            ".git",
          }) or vim.fn.expand("~")

          local config_path = vim.fn.findfile("ruff.toml", root .. "/")
          or vim.fn.findfile(".ruff.toml", root .. "/")

          if config_path then
            return { "format", "--config", config_path, "-" }
          else
            return { "format", "-" }
          end
        end,
        stdin = true,
      },

      isort = {
        command = "isort",
        args = {
          "--profile", "black", -- or "default"
          "--stdout",
          "--filename", "$FILENAME",
          "-"
        },
        stdin = true,
      },
    },
  })
end

return M
