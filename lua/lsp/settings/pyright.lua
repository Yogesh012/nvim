local utils = require("lsp.utils")

return {
  settings = {
    python = {
      analysis = {
        -- Type checking
        typeCheckingMode = "basic",
        
        -- Auto-imports
        autoImportCompletions = true,
        autoSearchPaths = true,
        
        -- Performance
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        
        -- Disable annoying warnings, keep helpful ones
        diagnosticSeverityOverrides = {
          -- Disable: Too noisy
          reportMissingTypeStubs = "none",
          reportUnknownMemberType = "none",
          reportUnknownVariableType = "none",
          reportUnknownArgumentType = "none",
          reportGeneralTypeIssues = "none",
          reportPrivateUsage = "none",
          reportUnusedImport = "none",  -- Let ruff handle this
          reportUnusedVariable = "none",  -- Let ruff handle this
          
          -- Keep: Actually helpful
          reportOptionalMemberAccess = "warning",
          reportOptionalSubscript = "warning",
          reportUndefinedVariable = "error",
        },
      },
    },
  },
  on_attach = utils.with_on_attach(function(client)
    utils.disable_format(client)
  end),
}
