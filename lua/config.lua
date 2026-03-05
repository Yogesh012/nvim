-- User Configuration
-- Edit this file to customize your Neovim setup

local M = {
	-- UI Settings
	ui = {
		-- Fallback colorscheme used when auto_theme.enabled = false
		colorscheme = "tokyonight",
		transparent_background = false,
	},

	-- Auto-theming module settings
	-- Runtime overrides are stored in stdpath("data")/theme_state.json
	-- and take priority over these config-file defaults.
	auto_theme = {
		-- Master switch. false = use ui.colorscheme above (no randomisation)
		enabled = true,

		-- Background mode filter: "dark" | "light" | nil (nil = any)
		-- Override at runtime with :ThemeMode dark/light/any  or <leader>Td/Tl/Ta
		mode = nil,

		-- Allowlist: if non-empty, only themes in this list are candidates.
		-- Example: { "tokyonight-storm", "catppuccin-mocha", "rose-pine" }
		allowlist = {},

		-- persist = false → fresh random theme every nvim open
		-- persist = true  → replay the last applied theme on every open
		-- Toggle at runtime with :ThemeConfig or <leader>Tc
		persist = false,

		-- Re-apply lualine theme after every colorscheme switch
		sync_lualine = true,
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
	linting = {
		linters_by_ft = {
			python = { "ruff" },
			javascript = { "eslint" },
			typescript = { "eslint" },
		},
	},
}

return M
