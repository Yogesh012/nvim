local utils = require("lsp.utils")

return {
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        diagnosticSeverityOverrides = {
          reportArgumentType = "none",
        },
      },
    },
  },
  on_attach = utils.with_on_attach(function(client)
    utils.disable_format(client)
  end),
}
