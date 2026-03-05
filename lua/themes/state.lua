--- themes/state.lua
--- Runtime user-preference persistence.
--- Reads/writes ~/.local/share/nvim/theme_state.json.
---
--- Priority (highest wins):
---   runtime theme_state.json  >  config.lua auto_theme block
---
--- Schema:
---   {
---     "mode":       "dark"|"light"|null,
---     "persist":    true|false,
---     "last_theme": "<colorscheme name>"
---   }

local M = {}

local _state_path = vim.fn.stdpath("data") .. "/theme_state.json"

-- Cached in-memory copy so we don't re-read from disk on every call.
local _cache = nil

-- ─────────────────────────────────────────────────────────────────────────────
-- JSON helpers (Neovim ships vim.json since 0.9)
-- ─────────────────────────────────────────────────────────────────────────────

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local content = f:read("*a")
  f:close()
  return content
end

local function write_file(path, content)
  local f = io.open(path, "w")
  if not f then
    vim.notify("[themes.state] Cannot write to " .. path, vim.log.levels.ERROR)
    return false
  end
  f:write(content)
  f:close()
  return true
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Public API
-- ─────────────────────────────────────────────────────────────────────────────

--- Load and cache the state file. Returns {} on any error.
---@return table
function M.load()
  if _cache then return _cache end
  local raw = read_file(_state_path)
  if not raw or raw == "" then
    _cache = {}
    return _cache
  end
  local ok, parsed = pcall(vim.json.decode, raw)
  _cache = (ok and type(parsed) == "table") and parsed or {}
  return _cache
end

--- Persist the entire state table to disk.
---@param tbl table
function M.save(tbl)
  _cache = tbl
  local ok, json = pcall(vim.json.encode, tbl)
  if ok then
    write_file(_state_path, json)
  end
end

--- Get one key from the state. Returns nil if the key is absent.
---@param key string
---@return any
function M.get(key)
  local s = M.load()
  return s[key]
end

--- Set one key and immediately persist the full state.
---@param key   string
---@param value any
function M.set(key, value)
  local s = M.load()
  s[key] = value
  M.save(s)
end

--- Clear ALL runtime state (useful for resetting to config defaults).
function M.reset()
  _cache = {}
  write_file(_state_path, "{}")
end

--- Return the effective merged config:
---   config.lua auto_theme block, then override with any runtime state values.
--- The result is a plain table safe to read without side effects.
---@return table
function M.effective_config()
  local base_ok, cfg = pcall(require, "config")
  local base = (base_ok and cfg.auto_theme) and vim.deepcopy(cfg.auto_theme) or {}

  -- Defaults in case config.lua hasn't been updated yet
  base.enabled      = base.enabled      ~= nil and base.enabled      or true
  base.mode         = base.mode         ~= nil and base.mode         or nil
  base.allowlist    = base.allowlist    ~= nil and base.allowlist     or {}
  base.persist      = base.persist      ~= nil and base.persist       or false
  base.sync_lualine = base.sync_lualine ~= nil and base.sync_lualine  or true

  -- Runtime state overrides config values where present
  -- (only override if the key is explicitly set in state, not just nil)
  local s = M.load()
  if s.mode ~= nil then
    base.mode = s.mode  -- can be the string "nil" sentinel, handled in engine
  end
  if s.persist ~= nil then
    base.persist = s.persist
  end

  -- "nil" sentinel string means the user explicitly cleared the mode filter
  if base.mode == "nil" then
    base.mode = nil
  end

  return base
end

return M
