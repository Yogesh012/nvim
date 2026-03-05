--- themes/compat.lua
--- Legacy Vim colorscheme compatibility layer.
--- ONLY called when registry entry has legacy = true.
--- Modern Lua themes (tokyonight, catppuccin, etc.) bypass this entirely.

local M = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Internal helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Map a cterm color index (0–255) to its approximate hex RGB string.
--- Uses the standard 256-color xterm palette.
---@param idx number
---@return string  e.g. "#5f87af"
local function cterm_to_hex(idx)
  -- The 16 named colors vary by terminal; use reasonable defaults.
  local base16 = {
    [0]  = "#1c1c1c", [1]  = "#af0000", [2]  = "#00af00", [3]  = "#afaf00",
    [4]  = "#0087af", [5]  = "#af00af", [6]  = "#00afaf", [7]  = "#c0c0c0",
    [8]  = "#767676", [9]  = "#ff5f5f", [10] = "#5fff5f", [11] = "#ffff5f",
    [12] = "#5f87ff", [13] = "#ff5fff", [14] = "#5fffff", [15] = "#ffffff",
  }
  if idx < 16 then
    return base16[idx] or "#ffffff"
  end
  if idx >= 232 then
    -- Grayscale ramp: 232-255 → #080808 to #eeeeee
    local v = 8 + (idx - 232) * 10
    return string.format("#%02x%02x%02x", v, v, v)
  end
  -- 6×6×6 color cube: indices 16-231
  idx = idx - 16
  local b = idx % 6
  local g = math.floor(idx / 6) % 6
  local r = math.floor(idx / 36)
  local function cube(n)
    return n == 0 and 0 or (55 + n * 40)
  end
  return string.format("#%02x%02x%02x", cube(r), cube(g), cube(b))
end

--- Safely get a highlight attribute using the legacy synIDattr interface.
---@param name string  highlight group name
---@param attr string  e.g. "fg", "bg", "ctermfg", "ctermbg"
---@return string
local function hl_attr(name, attr)
  local id = vim.fn.synIDtrans(vim.fn.hlID(name))
  return vim.fn.synIDattr(id, attr) or ""
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────────────────────

--- Convert every cterm-only highlight group in the current colorscheme
--- to its GUI equivalent. Safe to call on any colorscheme — is a no-op
--- for groups that already carry gui attributes.
function M.patch_cterm_to_gui()
  -- Retrieve all highlight group names
  local groups = vim.fn.getcompletion("", "highlight")
  for _, name in ipairs(groups) do
    local ok, info = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok or not info then
      goto continue
    end

    -- Only patch if the group has no gui fg/bg defined yet
    local needs_patch = not info.fg and not info.bg

    if needs_patch then
      local ctermfg_raw = hl_attr(name, "ctermfg")
      local ctermbg_raw = hl_attr(name, "ctermbg")
      local ctermfg = tonumber(ctermfg_raw)
      local ctermbg = tonumber(ctermbg_raw)

      local new_hl = {}
      if ctermfg then
        new_hl.fg = cterm_to_hex(ctermfg)
      end
      if ctermbg then
        new_hl.bg = cterm_to_hex(ctermbg)
      end

      if next(new_hl) then
        -- Preserve existing attributes (bold, italic, etc.)
        if info.bold      then new_hl.bold      = true end
        if info.italic    then new_hl.italic     = true end
        if info.underline then new_hl.underline  = true end
        if info.reverse   then new_hl.reverse    = true end
        pcall(vim.api.nvim_set_hl, 0, name, new_hl)
      end
    end

    ::continue::
  end
end

--- Ensure all Neovim-specific UI highlight groups are defined with sensible
--- fallbacks if the legacy theme did not set them.
--- This prevents invisible floats, broken borders, etc.
function M.fill_missing_groups()
  -- Grab Normal's gui colors as the baseline
  local normal_ok, normal = pcall(vim.api.nvim_get_hl, 0, { name = "Normal", link = false })
  local normal_fg = (normal_ok and normal.fg) and string.format("#%06x", normal.fg) or "#c0c0c0"
  local normal_bg = (normal_ok and normal.bg) and string.format("#%06x", normal.bg) or "#1c1c1c"

  --- Helper: only set a group if it is empty / completely undefined.
  local function fill_if_missing(name, attrs)
    local ok, existing = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    local is_empty = not ok or (not existing.fg and not existing.bg and not existing.link)
    if is_empty then
      pcall(vim.api.nvim_set_hl, 0, name, attrs)
    end
  end

  fill_if_missing("NormalFloat",          { fg = normal_fg, bg = normal_bg })
  fill_if_missing("FloatBorder",          { fg = "#5c6370", bg = normal_bg })
  fill_if_missing("WinSeparator",         { fg = "#3b3b3b", bg = normal_bg })
  fill_if_missing("DiagnosticVirtualText",{ fg = "#767676" })
  fill_if_missing("DiagnosticError",      { fg = "#f44747" })
  fill_if_missing("DiagnosticWarn",       { fg = "#ff8800" })
  fill_if_missing("DiagnosticInfo",       { fg = "#75beff" })
  fill_if_missing("DiagnosticHint",       { fg = "#4ec9b0" })
  fill_if_missing("StatusLine",           { fg = normal_fg, bg = "#3a3a3a" })
  fill_if_missing("StatusLineNC",         { fg = "#767676", bg = "#2a2a2a" })
  fill_if_missing("CursorLine",           { bg = "#2a2a2a" })
  fill_if_missing("LineNr",               { fg = "#5a5a5a" })
  fill_if_missing("CursorLineNr",         { fg = "#d4d4d4", bold = true })
  fill_if_missing("Pmenu",                { fg = normal_fg, bg = "#252526" })
  fill_if_missing("PmenuSel",             { fg = "#ffffff", bg = "#094771" })
end

--- Full compat pipeline for a legacy Vim colorscheme.
--- Sets background, enables termguicolors, applies the colorscheme,
--- then patches cterm groups and fills missing Neovim UI groups.
---@param name    string  colorscheme name
---@param entry   table   registry entry
function M.apply_legacy(name, entry)
  -- 1. Background must be set BEFORE applying the colorscheme so that themes
  --    that branch on 'background' (e.g. solarized, everforest) render correctly.
  vim.opt.background = entry.background

  -- 2. True-color rendering is required for our hex patches to be meaningful.
  vim.opt.termguicolors = true

  -- 3. Apply the colorscheme, catching any load errors gracefully.
  local ok, err = pcall(vim.cmd, "colorscheme " .. name)
  if not ok then
    vim.notify(
      "[themes.compat] Failed to load legacy colorscheme '" .. name .. "': " .. tostring(err),
      vim.log.levels.WARN
    )
    return false
  end

  -- 4. Convert cterm-only groups to GUI colors.
  M.patch_cterm_to_gui()

  -- 5. Ensure Neovim UI groups are defined.
  M.fill_missing_groups()

  return true
end

return M
