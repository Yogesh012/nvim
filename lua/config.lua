-- User Configuration
-- Edit this file to customize your Neovim setup

local M = {
	-- UI Settings
	ui = {
		-- transparent_background is referenced by plugins/specs/ui.lua (tokyonight opts)
		-- Theming is handled by chromatic.nvim — configure it in plugins/specs/ui.lua
		colorscheme = "tokyonight",
		transparent_background = false,
	},

	-- Editor Settings
	editor = {
		format_on_save = true,
		relative_number = true,
		tab_width = 2,
	},

	-- LSP Settings
	lsp = {
		servers = {
			"lua_ls",
			"pyright",
			"ruff",
			"jsonls",
			"bashls",
			"html",
			"cssls",
		},
		virtual_text = true,
		inlay_hints = true,
	},

	-- Formatting (conform.nvim)
	formatting = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
	},

	-- Linting (nvim-lint)
	-- NOTE: Python is intentionally omitted here — the Ruff LSP server handles
	-- all linting diagnostics for .py files. Adding ruff here would cause
	-- duplicate diagnostics from both "ruff:" (nvim-lint) and "Ruff:" (LSP).
	linting = {
		linters_by_ft = {
			-- python = { "ruff" },
			javascript = { "eslint" },
			typescript = { "eslint" },
		},
	},
}

return M
