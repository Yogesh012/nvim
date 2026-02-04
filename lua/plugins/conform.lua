local M = {}

function M.setup()
  local config = require("config")

  require("conform").setup({
    format_on_save = function(bufnr)
      if not config.editor.format_on_save or not vim.g.format_on_save then
        return
      end

      local ignore_ft = { "markdown" }
      local max_lines = 5000

      if vim.tbl_contains(ignore_ft, vim.bo[bufnr].filetype) then
        return
      end
      if vim.api.nvim_buf_line_count(bufnr) > max_lines then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,

    formatters_by_ft = config.formatting.formatters_by_ft,
  })
end

return M
