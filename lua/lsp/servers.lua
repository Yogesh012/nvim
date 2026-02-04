local M = {}

function M.setup()
  local config = require("config")
  
  -- Check if mason is available
  local mason_ok, mason = pcall(require, "mason")
  if not mason_ok then
    vim.notify("Mason not loaded yet", vim.log.levels.WARN)
    return
  end

  local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_lspconfig_ok then
    vim.notify("Mason-lspconfig not loaded yet", vim.log.levels.WARN)
    return
  end

  local capabilities = require("lsp.capabilities")
  local on_attach = require("lsp.utils").with_on_attach()

  -- Setup mason
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  -- Setup mason-lspconfig to ensure servers are installed
  mason_lspconfig.setup({
    ensure_installed = config.lsp.servers,
    automatic_installation = true,
  })

  -- Setup each server using new vim.lsp.config API (Neovim 0.11+)
  for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
    local opts = {
      capabilities = capabilities,
      on_attach = on_attach,
    }

    -- Add per-server config override if available
    local ok, server_settings = pcall(require, "lsp.settings." .. server_name)
    if ok then
      opts = vim.tbl_deep_extend("force", opts, server_settings)
    end

    -- Configure and enable the server
    vim.lsp.config(server_name, opts)
    vim.lsp.enable(server_name)
  end
end

return M
