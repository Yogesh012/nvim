local M = {}

local config = require("config")

local default_on_attach = require("lsp.keymaps").on_attach

M._virtual_text_enabled = config.lsp.virtual_text ~= false

-- Wrap user-defined `on_attach` with global one
function M.with_on_attach(extra)
  return function(client, bufnr)
    default_on_attach(client, bufnr)

    vim.diagnostic.config({
      virtual_text = M._virtual_text_enabled and {
        prefix = "●",
        spacing = 2,
      } or false,
    }, bufnr)

    if config.lsp.inlay_hints ~= false then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end

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

function M.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  vim.notify("Inlay hints: " .. (not enabled and "ON" or "OFF"))
end

return M
