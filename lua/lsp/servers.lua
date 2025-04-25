local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  local capabilities = require("lsp.capabilities")
  local on_attach = require("lsp.utils").with_on_attach()

  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  mason_lspconfig.setup({
    ensure_installed = {
      "lua_ls",
      "pyright",
      "ruff",
      "jsonls",
      "bashls",
      "html",
      "cssls",
    },
  })

  mason_lspconfig.setup_handlers({
    function(server_name)
      local opts = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Add per-server config override if available
      local ok, server_settings = pcall(require, "lsp.settings." .. server_name)
      if ok then
        opts = vim.tbl_deep_extend("force", opts, server_settings)
      end

      lspconfig[server_name].setup(opts)
    end,
  })
end

return M
