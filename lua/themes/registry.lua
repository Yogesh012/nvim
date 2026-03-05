--- themes/registry.lua
--- Static catalog of known colorscheme themes.
--- Each entry describes a theme's name, background type, lazy.nvim plugin,
--- optional sub-variants, and whether it needs legacy compat shims.

local M = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- Catalog
-- Add entries here whenever you install a new theme plugin.
-- ─────────────────────────────────────────────────────────────────────────────
M.catalog = {
  -- ── Dark themes ────────────────────────────────────────────────────────────
  {
    name       = "tokyonight-storm",
    background = "dark",
    plugin     = "tokyonight.nvim",
    parent     = "folke/tokyonight.nvim",
  },
  {
    name       = "tokyonight-night",
    background = "dark",
    plugin     = "tokyonight.nvim",
    parent     = "folke/tokyonight.nvim",
  },
  {
    name       = "tokyonight-moon",
    background = "dark",
    plugin     = "tokyonight.nvim",
    parent     = "folke/tokyonight.nvim",
  },
  {
    name       = "catppuccin-mocha",
    background = "dark",
    plugin     = "nvim",         -- catppuccin/nvim registers as "nvim"
    parent     = "catppuccin/nvim",
  },
  {
    name       = "catppuccin-macchiato",
    background = "dark",
    plugin     = "nvim",
    parent     = "catppuccin/nvim",
  },
  {
    name       = "catppuccin-frappe",
    background = "dark",
    plugin     = "nvim",
    parent     = "catppuccin/nvim",
  },
  {
    name       = "gruvbox",
    background = "dark",
    plugin     = "gruvbox.nvim",
    parent     = "ellisonleao/gruvbox.nvim",
  },
  {
    name       = "kanagawa-wave",
    background = "dark",
    plugin     = "kanagawa.nvim",
    parent     = "rebelot/kanagawa.nvim",
  },
  {
    name       = "kanagawa-dragon",
    background = "dark",
    plugin     = "kanagawa.nvim",
    parent     = "rebelot/kanagawa.nvim",
  },
  {
    name       = "rose-pine",
    background = "dark",
    plugin     = "neovim",       -- rose-pine/neovim registers as "neovim"
    parent     = "rose-pine/neovim",
  },
  {
    name       = "rose-pine-moon",
    background = "dark",
    plugin     = "neovim",
    parent     = "rose-pine/neovim",
  },
  {
    name       = "nightfox",
    background = "dark",
    plugin     = "nightfox.nvim",
    parent     = "EdenEast/nightfox.nvim",
  },
  {
    name       = "carbonfox",
    background = "dark",
    plugin     = "nightfox.nvim",
    parent     = "EdenEast/nightfox.nvim",
  },
  {
    name       = "duskfox",
    background = "dark",
    plugin     = "nightfox.nvim",
    parent     = "EdenEast/nightfox.nvim",
  },
  {
    name       = "nordfox",
    background = "dark",
    plugin     = "nightfox.nvim",
    parent     = "EdenEast/nightfox.nvim",
  },
  {
    name       = "onedark",
    background = "dark",
    plugin     = "onedark.nvim",
    parent     = "navarasu/onedark.nvim",
  },
  {
    name       = "everforest",
    background = "dark",
    plugin     = "everforest",
    parent     = "sainnhe/everforest",
  },
  {
    name       = "dracula",
    background = "dark",
    plugin     = "dracula.nvim",
    parent     = "Mofiqul/dracula.nvim",
  },
  {
    name       = "nord",
    background = "dark",
    plugin     = "nord.nvim",
    parent     = "shaunsingh/nord.nvim",
  },
  {
    name       = "github_dark",
    background = "dark",
    plugin     = "github-nvim-theme",
    parent     = "projekt0n/github-nvim-theme",
  },
  {
    name       = "ayu-mirage",
    background = "dark",
    plugin     = "neovim-ayu",
    parent     = "Shatur/neovim-ayu",
  },
  {
    name       = "ayu-dark",
    background = "dark",
    plugin     = "neovim-ayu",
    parent     = "Shatur/neovim-ayu",
  },

  -- ── Light themes ───────────────────────────────────────────────────────────
  {
    name       = "tokyonight-day",
    background = "light",
    plugin     = "tokyonight.nvim",
    parent     = "folke/tokyonight.nvim",
  },
  {
    name       = "catppuccin-latte",
    background = "light",
    plugin     = "nvim",
    parent     = "catppuccin/nvim",
  },
  {
    name       = "rose-pine-dawn",
    background = "light",
    plugin     = "neovim",
    parent     = "rose-pine/neovim",
  },
  {
    name       = "dayfox",
    background = "light",
    plugin     = "nightfox.nvim",
    parent     = "EdenEast/nightfox.nvim",
  },
  {
    name       = "github_light",
    background = "light",
    plugin     = "github-nvim-theme",
    parent     = "projekt0n/github-nvim-theme",
  },
  {
    name       = "ayu-light",
    background = "light",
    plugin     = "neovim-ayu",
    parent     = "Shatur/neovim-ayu",
  },
  {
    name       = "everforest",
    background = "light",
    plugin     = "everforest",
    parent     = "sainnhe/everforest",
    -- everforest uses vim.opt.background to switch between dark/light.
    -- The themes engine sets entry.background before calling :colorscheme,
    -- so both dark and light entries work with the same plugin.
    -- We use a unique key below to prevent deduplication with the dark entry.
    _key       = "everforest-light",
  },

  -- ── Legacy / built-in Vim themes (always available, compat shims applied) ──
  {
    name       = "desert",
    background = "dark",
    plugin     = nil,
    legacy     = true,
  },
  {
    name       = "slate",
    background = "dark",
    plugin     = nil,
    legacy     = true,
  },
  {
    name       = "habamax",
    background = "dark",
    plugin     = nil,
    legacy     = true,
  },
  {
    name       = "zaibatsu",
    background = "dark",
    plugin     = nil,
    legacy     = true,
  },
  {
    name       = "lunaperche",
    background = "dark",
    plugin     = nil,
    legacy     = true,
  },
  {
    name       = "morning",
    background = "light",
    plugin     = nil,
    legacy     = true,
  },
  {
    name       = "peachpuff",
    background = "light",
    plugin     = nil,
    legacy     = true,
  },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Returns the subset of catalog entries whose plugin is installed via lazy.nvim.
--- Built-in themes (plugin = nil) are always included.
---@return table[]
function M.installed()
  local result = {}
  local lazy_plugins = {}

  local ok, lazy_cfg = pcall(require, "lazy.core.config")
  if ok and lazy_cfg.plugins then
    lazy_plugins = lazy_cfg.plugins
  end

  -- Deduplicate: for themes sharing a plugin (e.g. tokyonight variants),
  -- we only want to lazy-load the plugin once, but all variants are valid candidates.
  -- Use _key if present (for same-name entries like everforest dark/light), else name.
  local seen = {}
  for _, entry in ipairs(M.catalog) do
    local key = entry._key or entry.name
    if seen[key] then
      goto continue
    end
    seen[key] = true

    if entry.plugin == nil then
      -- Always-available built-in theme
      table.insert(result, entry)
    elseif lazy_plugins[entry.plugin] then
      table.insert(result, entry)
    end

    ::continue::
  end

  return result
end

--- Return catalog entries filtered by background class ("dark" or "light").
---@param bg "dark"|"light"
---@return table[]
function M.by_background(bg)
  return vim.tbl_filter(function(e)
    return e.background == bg
  end, M.catalog)
end

--- Find a single entry by name. Returns nil if not found.
---@param name string
---@return table|nil
function M.find(name)
  for _, entry in ipairs(M.catalog) do
    if entry.name == name then
      return entry
    end
  end
  return nil
end

return M
