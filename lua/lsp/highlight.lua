local M = {}

function M.setup(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  vim.cmd([[highlight! link DiagnosticVirtualTextHint Comment]])
  vim.cmd([[highlight! link DiagnosticVirtualTextWarn Comment]])
  vim.cmd([[highlight! link DiagnosticVirtualTextError Comment]])

  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff5f5f" })
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#fabd2f" })
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#83a598" })
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#7c6f64" })
end

return M
