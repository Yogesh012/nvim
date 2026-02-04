local utils = require("lsp.utils")

return {
  cmd = { "ruff", "server", "--preview" },
  root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),
  
  init_options = {
    settings = {
      -- Linting configuration
      lint = {
        enable = true,
        select = { "F", "E", "W", "I", "UP", "B", "SIM", "C90" },
        ignore = { "E501", "E203", "W503" },
      },
      
      -- Code actions
      codeAction = {
        fixViolation = { enable = true },
        disableRuleComment = { enable = true },
        organizeImports = { enable = true },
      },
      
      -- Format settings (even though LSP formatting is disabled)
      format = {
        preview = true,
      },
    },
  },
  
  on_attach = utils.with_on_attach(function(client)
    -- Disable LSP formatting (using conform.nvim instead)
    utils.disable_format(client)
  end),
}
