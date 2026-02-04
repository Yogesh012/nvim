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


  -- Comment color for virtual text
  -- vim.cmd([[highlight! link DiagnosticVirtualTextHint Comment]])
  -- vim.cmd([[highlight! link DiagnosticVirtualTextWarn Comment]])
  -- vim.cmd([[highlight! link DiagnosticVirtualTextError Comment]]


  -- Custom colors for virtual text by severity (subtle but distinct) - a little more brighter
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#c9707a", italic = true })
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#c9936a", italic = true })
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#7090c9", italic = true })
  -- vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#76b5a8", italic = true })

  -- Custom colors for virtual text by severity (subtle but distinct) - a little more dim
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#9d5f68", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#9d7a58", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#5a729d", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#5a8d82", italic = true })

  -- Subtle inlay hints styling
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#565f89", italic = true })
end

return M
