local M = {}

function M.setup()
	local ok, render = pcall(require, "render-markdown")
	if not ok then
		return
	end

	render.setup({
		file_types = { "markdown", "codecompanion" },
		render_modes = true,
		-- completions = {
		--   lsp = {
		--     enabled = true,
		--   },
		-- },
	})
	-- vim.treesitter.language.register("markdown", "vimwiki")
end

return M
