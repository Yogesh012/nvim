local M = {}

local base = vim.lsp.protocol.make_client_capabilities()

local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
  M = cmp.default_capabilities(base)
else
  base.textDocument.completion.completionItem.snippetSupport = true
  M = base
end

return M
