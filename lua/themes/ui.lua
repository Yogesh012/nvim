--- themes/ui.lua
--- User-facing Neovim commands and interactive pickers for the auto-theming module.
---
--- Commands registered:
---   :ThemeNext           — random new theme immediately
---   :ThemeMode <mode>    — set dark / light / any (persisted)
---   :ThemeConfig         — interactive vim.ui.select settings picker
---   :ThemeInfo           — print current theme + active settings

local M = {}

local function themes() return require("themes") end
local function state()  return require("themes.state") end

function M.setup()
  -- ── :ThemeNext ─────────────────────────────────────────────────────────────
  vim.api.nvim_create_user_command("ThemeNext", function()
    themes().next()
  end, { desc = "Pick a new random theme" })

  -- ── :ThemeMode [dark|light|any] ────────────────────────────────────────────
  vim.api.nvim_create_user_command("ThemeMode", function(opts)
    local arg = opts.args and opts.args:lower() or ""
    if arg == "dark" then
      themes().set_mode("dark")
    elseif arg == "light" then
      themes().set_mode("light")
    elseif arg == "any" or arg == "" then
      themes().set_mode(nil)
    else
      vim.notify("[themes] Unknown mode '" .. arg .. "'. Use: dark | light | any", vim.log.levels.WARN)
    end
  end, {
    nargs    = "?",
    complete = function()
      return { "dark", "light", "any" }
    end,
    desc = "Set theme mode filter: dark | light | any",
  })

  -- ── :ThemeInfo ─────────────────────────────────────────────────────────────
  vim.api.nvim_create_user_command("ThemeInfo", function()
    local cfg  = state().effective_config()
    local cur  = themes().current()
    local mode = cfg.mode or "any"
    local persist = tostring(cfg.persist)
    local al   = (#cfg.allowlist > 0) and table.concat(cfg.allowlist, ", ") or "all"

    vim.notify(
      table.concat({
        "  Current   : " .. cur,
        "  Mode      : " .. mode,
        "  Persist   : " .. persist,
        "  Allowlist : " .. al,
      }, "\n"),
      vim.log.levels.INFO,
      { title = "Auto Theme Info" }
    )
  end, { desc = "Show current theme and auto-theme settings" })

  -- ── :ThemeConfig (interactive picker) ─────────────────────────────────────
  vim.api.nvim_create_user_command("ThemeConfig", function()
    local cfg = state().effective_config()

    local options = {
      "Set mode → dark",
      "Set mode → light",
      "Set mode → any (no filter)",
      "Toggle persist  (currently: " .. tostring(cfg.persist) .. ")",
      "Pick a new random theme now",
      "Reset all settings to config.lua defaults",
    }

    vim.ui.select(options, {
      prompt  = "Auto Theme — Settings",
      format_item = function(item) return "  " .. item end,
    }, function(choice)
      if not choice then return end

      if choice:find("mode → dark") then
        themes().set_mode("dark")

      elseif choice:find("mode → light") then
        themes().set_mode("light")

      elseif choice:find("mode → any") then
        themes().set_mode(nil)

      elseif choice:find("Toggle persist") then
        themes().set_persist(not cfg.persist)

      elseif choice:find("Pick a new random") then
        themes().next()

      elseif choice:find("Reset all") then
        state().reset()
        vim.notify(
          "[themes] Settings reset to config.lua defaults.",
          vim.log.levels.INFO,
          { title = "Auto Theme" }
        )
      end
    end)
  end, { desc = "Interactive auto-theme settings picker" })
end

return M
