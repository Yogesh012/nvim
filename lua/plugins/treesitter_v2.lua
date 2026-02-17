local M = {}

function M.setup()
	local ok, treesitter = pcall(require, "nvim-treesitter")
	if not ok then
		vim.notify("nvim-treesitter not loaded.", vim.log.levels.WARN)
		return
	end

	local parsers = {
		"lua",
		"vim",
		"bash",
		"python",
		"javascript",
		"typescript",
		"html",
		"css",
		"json",
		"markdown",
		"markdown_inline",
		"yaml",
		"toml",
		"tsx",
		"rust",
		"c",
	}

	local rainbow_ok, rainbow = pcall(require, "rainbow-delimiters.setup")
	if rainbow_ok then
		rainbow.setup({})
	end

	treesitter.setup({
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},

		indent = {
			enable = true,
		},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "vv",
				node_incremental = "<S-l>",
				scope_incremental = "<S-s>",
				node_decremental = "<S-h>",
			},
		},

		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
		},

		autopairs = {
			enable = true,
		},

		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
	})

	treesitter.install(parsers)
end

return M
