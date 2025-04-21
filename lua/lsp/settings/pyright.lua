return {
  settings = {
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportImportCycles = "warning",
          reportUnusedImport = "information",
          reportUnusedClass = "information",
          reportUnusedFunction = "information",
          reportUnusedVariable = "information",
          reportDuplicateImport = "warning",
          reportTypeCommentUsage = "information",
          reportMissingSuperCall = "warning",
          reportUninitializedInstanceVariable = "warning",
          reportUnnecessaryIsInstance = "warning",
          reportUnnecessaryCast = "warning",
          reportConstantRedefinition = "warning",
          reportUnnecessaryComparison = "warning",
          reportUnnecessaryContains = "warning",
          reportAssertAlwaysTrue = "warning",
          reportSelfClsParameterName = "warning",
          reportImplicitStringConcatenation = "warning",
          reportUnusedCallResult = "warning",
          reportUnusedCoroutine = "warning",
          reportMatchNotExhaustive = "information",
          reportUnusedExpression = "warning",
        },
        typeCheckingMode = "off"
      },

      linting = {
        pylintEnabled = true,
        flake8Enabled = true,
        pydocstyleEnabled = true,
      },

      formatting = {
        provider = "autopep8", -- autopep8 | darker | black | blackd | yapf | none
      },

    }
  },
}
