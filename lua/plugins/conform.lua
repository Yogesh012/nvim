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
      python = { "isort", "ruff_format" },
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
  })
end

return M
