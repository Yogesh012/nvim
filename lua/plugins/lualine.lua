local M = {}

function M.setup()
  local ok, aiconfig = pcall(require, "core.ai_config")

  local function ollama_status()
    if not ok then
      return ""
    end

    local stauts, gen = pcall(require, "gen")
    if not stauts then
      return ""
    end

    --  󰫥 󰫢
    if gen and gen.config and gen.config.model and aiconfig.is_ollama_enabled() then
      return " " .. gen.config.model
      -- return "🦙 OLM"
    end
    return ""
  end

  local function codeium_status()
    if not ok then
      return ""
    end

    if aiconfig.is_codium_enabled() then
      --  󰫥 󰫢
      local status_string = require("codeium.virtual_text").status_string()
      return (not string.find(status_string, "0") and status_string) or "✨ COD"
    elseif aiconfig.is_chatgpt_enabled() then
      return "🗨️ GPT"
    end
    return ""
  end

  require("lualine").setup({
    options = {
      -- theme = "tokyonight",
      icons_enabled = true,
      section_separators = { left = "", right = "" },
      component_separators = "|",
      globalstatus = true,
    },

    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = { codeium_status, ollama_status, "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

return M
