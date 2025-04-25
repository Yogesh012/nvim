local utils = require("lsp.utils")

return {
  cmd = { "ruff", "server", "--preview" }, -- Enable LSP mode
  -- filetypes = { "python" },
  root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),

  init_options = {
    settings = {
      args = {
        -- You can pass custom ruff rules here
        "--config=ruff.toml", -- or ".ruff.toml", if that's what you use
      },
    },
  },
  on_attach = utils.with_on_attach(function(client)
    utils.disable_format(client)
  end),
}
