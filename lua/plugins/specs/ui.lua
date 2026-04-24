return {
	{
		"Yogesh012/chromatic.nvim",
		lazy     = false,
		priority = 999,
		opts = {
			mode    = "dark",   -- "dark" | "light" | nil (any)
			persist = false,    -- true = replay last theme on next open
		},
	},
	-- ── Fallback / default theme ─────────────────────────────────────────────
	-- Stays non-lazy so nvim is never colorscheme-less during early init.
	-- chromatic.nvim applies the final random theme on VimEnter.
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			style = "storm",
			transparent = require("config").ui.transparent_background,
			italic_functions = true,
		},
	},

	-- ── Optional extra themes ───────────────────────────────────────────────
	-- All are lazy = true — the themes engine loads only the one it picks.
	-- Uncomment whichever you want to include in the random pool.
	-- Add the corresponding entry to lua/themes/registry.lua if not present.
	--
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "navarasu/onedark.nvim", lazy = true },
	{ "Mofiqul/dracula.nvim", lazy = true },
	{ "shaunsingh/nord.nvim", lazy = true },
	{ "sainnhe/everforest", lazy = true },
	-- { "projekt0n/github-nvim-theme",                       lazy = true },
	{ "Shatur/neovim-ayu", lazy = true },

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins._lualine").setup()
		end,
	},

	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer: Next" },
			{ "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer: Previous" },
			{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Buffer: Pick" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.bufferline").setup()
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		config = function()
			require("plugins.devicons").setup()
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		config = function()
			require("plugins.render_markdown").setup()
		end,
	},
}
