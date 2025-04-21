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
end

return M
