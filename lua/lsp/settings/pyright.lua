return {
	root_dir = function(fname)
		return vim.fs.root(fname, {
			"pyrightconfig.json",
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			".git",
		})
	end,
	settings = {
		python = {
			analysis = {
				-- Type checking
				typeCheckingMode = "basic",
				extraPaths = { "." },

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
					reportUnusedImport = "none", -- Let ruff handle this
					reportUnusedVariable = "none", -- Let ruff handle this

					-- Keep: Actually helpful
					reportOptionalMemberAccess = "warning",
					reportOptionalSubscript = "warning",
					reportUndefinedVariable = "error",
				},
			},
		},
	},
}
