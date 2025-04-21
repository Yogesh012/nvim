local M = {}

function M.setup()
  require("lsp.diagnostics").setup()
  require("lsp.servers").setup()

end

return M
