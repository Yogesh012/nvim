--- themes/init.lua
--- Auto-theming engine — public API and selection logic.
---
--- Public API:
---   themes.apply()              startup entry point (called from VimEnter)
---   themes.next()               pick & apply a new random theme right now
---   themes.current()            return name of the active colorscheme
---   themes.list_available()     return filtered candidate list
---   themes.set_mode(m)          "dark"|"light"|nil, persisted to state.json
---   themes.set_persist(bool)    toggle persist, persisted to state.json
---   themes.ensure_applied()     idempotent safety call from VimEnter hook

local M = {}

local registry = require("themes.registry")
local compat   = require("themes.compat")
local state    = require("themes.state")

-- Track whether we have already applied a theme this session.
local _applied = false
-- Track the currently active colorscheme name.
local _current = nil

-- ─────────────────────────────────────────────────────────────────────────────
-- Internal helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Lazy-load a plugin through lazy.nvim if it hasn't been loaded yet.
--- For built-in themes (plugin = nil) this is a no-op.
---@param plugin_name string|nil  plugin slug as registered in lazy (e.g. "tokyonight.nvim")
local function lazy_load_plugin(plugin_name)
  if not plugin_name then return end
  local ok, lazy = pcall(require, "lazy")
  if not ok then return end
  -- require("lazy").load triggers the plugin's config/init
  pcall(lazy.load, { plugins = { plugin_name } })
end

--- Apply a resolved colorscheme entry (non-legacy path).
---@param entry table  registry entry
local function apply_modern(entry)
  vim.opt.background = entry.background
  local ok, err = pcall(vim.cmd, "colorscheme " .. entry.name)
  if not ok then
    vim.notify(
      "[themes] Failed to apply colorscheme '" .. entry.name .. "': " .. tostring(err),
      vim.log.levels.WARN
    )
    return false
  end
  return true
end

--- Sync lualine theme to "auto" so it picks up the new colorscheme.
local function sync_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then return end
  pcall(lualine.setup, { options = { theme = "auto" } })
end

--- Notify the user via vim.notify about the chosen theme.
---@param name string
local function announce(name)
  vim.notify(
    "  Theme: " .. name,
    vim.log.levels.INFO,
    { title = "Auto Theme" }
  )
end

--- Build the filtered candidate list from registry + effective config.
---@return table[]  list of registry entries
local function build_candidates()
  local cfg = state.effective_config()
  local pool = registry.installed()

  -- Filter by allowlist (if non-empty)
  if cfg.allowlist and #cfg.allowlist > 0 then
    local allowed = {}
    for _, entry in ipairs(pool) do
      if vim.tbl_contains(cfg.allowlist, entry.name) then
        table.insert(allowed, entry)
      end
    end
    pool = allowed
  end

  -- Filter by mode ("dark" / "light" / nil)
  if cfg.mode then
    pool = vim.tbl_filter(function(e)
      return e.background == cfg.mode
    end, pool)
  end

  return pool, cfg
end

--- Core: pick an entry from candidates and apply it.
---@param candidates table[]
---@param cfg        table     effective config
---@param force_new  boolean   if true, ignore persist and always pick randomly
local function pick_and_apply(candidates, cfg, force_new)
  if #candidates == 0 then
    vim.notify("[themes] No eligible themes found. Falling back to default.", vim.log.levels.WARN)
    pcall(vim.cmd, "colorscheme " .. (require("config").ui.colorscheme or "default"))
    return
  end

  local chosen

  -- Persist: replay last theme if it exists in the candidate list
  if not force_new and cfg.persist then
    local last = state.get("last_theme")
    if last then
      for _, e in ipairs(candidates) do
        if e.name == last then
          chosen = e
          break
        end
      end
    end
  end

  -- Random pick
  if not chosen then
    math.randomseed(os.time())
    chosen = candidates[math.random(#candidates)]
  end

  -- Lazy-load the plugin if needed
  lazy_load_plugin(chosen.plugin)

  -- Apply
  local ok
  if chosen.legacy then
    ok = compat.apply_legacy(chosen.name, chosen)
  else
    ok = apply_modern(chosen)
  end

  if not ok then
    return
  end

  -- Post-apply
  _current = chosen.name
  _applied = true

  if cfg.sync_lualine then
    sync_lualine()
  end

  if cfg.persist then
    state.set("last_theme", chosen.name)
  end

  announce(chosen.name)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- ColorScheme autocmd — stay in sync with manual :colorscheme calls
-- ─────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ThemesModuleSync", { clear = true }),
  callback = function(ev)
    local name = ev.match
    _current = name
    _applied = true

    local cfg = state.effective_config()
    -- If persist is on, save the manually chosen theme
    if cfg.persist then
      state.set("last_theme", name)
    end
    -- Keep lualine in sync
    if cfg.sync_lualine then
      sync_lualine()
    end
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────────────────────

--- Primary startup entry point.  Call from VimEnter.
function M.apply()
  local cfg = state.effective_config()

  -- Passthrough: auto_theme disabled → honour the static config colorscheme
  if not cfg.enabled then
    local cs = (require("config").ui or {}).colorscheme or "default"
    pcall(vim.cmd, "colorscheme " .. cs)
    _applied = true
    return
  end

  local candidates = build_candidates()
  pick_and_apply(candidates, cfg, false)
end

--- Idempotent guard called from the VimEnter safety autocmd.
--- Only runs apply() if a theme hasn't been set yet this session.
function M.ensure_applied()
  if not _applied then
    M.apply()
  end
end

--- Pick and apply a brand-new random theme right now (ignores persist).
function M.next()
  local candidates, cfg = build_candidates()
  pick_and_apply(candidates, cfg, true)
end

--- Return the name of the currently active colorscheme.
---@return string
function M.current()
  return _current or vim.g.colors_name or "unknown"
end

--- Return the current filtered candidate list (useful for pickers/debug).
---@return table[]
function M.list_available()
  return (build_candidates())
end

--- Set the background mode filter and persist it.
---@param mode "dark"|"light"|nil
function M.set_mode(mode)
  -- Store "nil" as a sentinel string so JSON can represent "unset"
  state.set("mode", mode == nil and "nil" or mode)
  vim.notify(
    "[themes] Mode set to: " .. (mode or "any"),
    vim.log.levels.INFO,
    { title = "Auto Theme" }
  )
end

--- Toggle persist and save it.
---@param value boolean
function M.set_persist(value)
  state.set("persist", value)
  vim.notify(
    "[themes] Persist set to: " .. tostring(value),
    vim.log.levels.INFO,
    { title = "Auto Theme" }
  )
end

return M
