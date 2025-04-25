local M = {}

local default_on_attach = require("lsp.keymaps").on_attach

M._virtual_text_enabled = true

-- Wrap user-defined `on_attach` with global one
function M.with_on_attach(extra)
  return function(client, bufnr)
    default_on_attach(client, bufnr)
    if extra then
      extra(client, bufnr)
    end
  end
end

-- Optional: disable formatting for a client
function M.disable_format(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

function M.toggle_virtual_text()
  M._virtual_text_enabled = not M._virtual_text_enabled
  vim.diagnostic.config({
    virtual_text = M._virtual_text_enabled and {
      prefix = "●",
      spacing = 2,
    } or false,
  })
  vim.notify("Virtual text: " .. (M._virtual_text_enabled and "ON" or "OFF"))
end

return M
