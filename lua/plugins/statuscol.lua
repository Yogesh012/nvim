-- lua/plugins/statuscol.lua
-- Custom statuscolumn via statuscol.nvim.
--
-- Layout (left → right):
--   [fold chevron]  [signs (git, diagnostics)]  [line number]
--
-- This replaces the hand-written statuscolumn string in core/options.lua and
-- eliminates the default fold-depth *number* glyphs that Neovim renders when
-- foldcolumn is non-zero.
local M = {}

function M.setup()
  local ok, statuscol = pcall(require, "statuscol")
  if not ok then
    vim.notify("[statuscol] statuscol.nvim not loaded.", vim.log.levels.WARN)
    return
  end

  local builtin = require("statuscol.builtin")

  statuscol.setup({
    -- -- Let statuscol own the statuscolumn option.
    setopt   = true,
    -- -- Neovim ≥ 0.10 compatible relnum / number awareness.
    -- relculright = true,
    ft_ignore = {"NvimTree", "TelescopePrompt"},

    segments = {
      -- ── Fold column ──────────────────────────────────────────────────────
      -- Renders a clickable ▶ / ▼ (or blank) instead of the depth number.
      {
        text  = { builtin.foldfunc },
        click = "v:lua.ScFa",
        condition = { true, builtin.not_empty },
      },
      -- ── Signs (gitsigns, diagnostics, dap breakpoints, etc.) ─────────────
      {
        sign = {
          namespace = { ".*" },   -- all sign namespaces
          maxwidth  = 1,
          colwidth  = 2,
          auto      = true,
        },
        click = "v:lua.ScSa",
      },
      -- ── Line number (relative when cursor moves, absolute on current line) ──
      -- Preserves the existing look from the old statuscolumn string.
      {
        text  = { builtin.lnumfunc, " " },
        click = "v:lua.ScLa",
      },
    },
  })
end

return M
