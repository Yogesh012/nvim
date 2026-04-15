-- lua/plugins/treesitter_v3.lua
-- nvim-treesitter main-branch config for Neovim 0.12+.
--
-- What this file does:
--   1. Installs parsers via the new nvim-treesitter.install() API
--   2. Sets up companion plugins (rainbow, ts-autotag, ts-context-commentstring)
--   3. Delegates incremental-selection setup to plugins/incremental_selection.lua
--   4. Wires textobject keymaps via the new nvim-treesitter-textobjects API
--
-- What this file does NOT do (handled elsewhere):
--   • Highlighting / indentation  → FileType autocmd in core/autocmds.lua
--   • Folding                     → vim.opt.foldexpr in core/options.lua  ✅
local M = {}

function M.setup()
	local ok, ts = pcall(require, "nvim-treesitter")
	if not ok then
		vim.notify("nvim-treesitter not loaded.", vim.log.levels.WARN)
		return
	end

	-- ── Parser installation (async, idempotent) ────────────────────────────────
	-- Skips parsers that are already up-to-date. Run :TSUpdate to refresh all.
	ts.install({
		"lua",
		"vim",
		"vimdoc",
		"bash",
		"python",
		"javascript",
		"typescript",
		"tsx",
		"html",
		"css",
		"json",
		"jsonc",
		"markdown",
		"markdown_inline",
		"yaml",
		"toml",
		"rust",
		"c",
		"query",
	})

	-- ── Companion plugins ──────────────────────────────────────────────────────

	local rainbow_ok, rainbow = pcall(require, "rainbow-delimiters.setup")
	if rainbow_ok then
		rainbow.setup({})
	end

	local ts_comment_ok, ts_comment = pcall(require, "ts_context_commentstring")
	if ts_comment_ok then
		ts_comment.setup({ enable_autocmd = false })
	end

	-- ── Incremental selection (fully self-contained in its own module) ─────────
	require("plugins.incremental_selection").setup()

	-- ── Textobjects (nvim-treesitter-textobjects main branch API) ─────────────
	-- The new API exposes sub-modules directly; no configs.setup() block needed.
	local to_ok, to_select = pcall(require, "nvim-treesitter-textobjects.select")
	local _, to_move = pcall(require, "nvim-treesitter-textobjects.move")

	if to_ok then
		require("nvim-treesitter-textobjects").setup({
			select = { lookahead = true },
			move = { set_jumps = true },
		})

		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Select text objects (visual + operator-pending)
		-- af / if → outer/inner function
		-- ac / ic → outer/inner class
		map({ "x", "o" }, "af", function()
			to_select.select_textobject("@function.outer", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: outer function" }))
		map({ "x", "o" }, "if", function()
			to_select.select_textobject("@function.inner", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: inner function" }))
		map({ "x", "o" }, "ac", function()
			to_select.select_textobject("@class.outer", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: outer class" }))
		map({ "x", "o" }, "ic", function()
			to_select.select_textobject("@class.inner", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: inner class" }))

		-- Navigate to next / previous function or class (n + visual + operator-pending)
		-- ]m / [m → next/prev function start
		-- ]c / [c → next/prev class start
		map({ "n", "x", "o" }, "]m", function()
			to_move.goto_next_start("@function.outer", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: next function start" }))
		map({ "n", "x", "o" }, "]c", function()
			to_move.goto_next_start("@class.outer", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: next class start" }))
		map({ "n", "x", "o" }, "[m", function()
			to_move.goto_previous_start("@function.outer", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: prev function start" }))
		map({ "n", "x", "o" }, "[c", function()
			to_move.goto_previous_start("@class.outer", "textobjects")
		end, vim.tbl_extend("force", opts, { desc = "TS: prev class start" }))
	end
end

return M
