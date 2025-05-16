local M = {}

function M.setup()
  local ok, aiconfig = pcall(require, "core.ai_config")

  local function ollama_status()
    if not ok then
      return ""
    end

    if not aiconfig.is_ollama_enabled() then
      return ""
    end

    local model = require("plugins.ai._gen").config.model
    if model ~= "" then
      return "🦙 " .. model
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
      lualine_a = { "mode", {
        "diff",
      } },
      lualine_b = { "branch" },
      lualine_c = { "filename", "lsp_status" },
      lualine_x = {
        require("plugins.lualine_component"),
        codeium_status,
        ollama_status,
        "encoding",
        {
          "fileformat",
          symbols = {
            unix = "", -- e712
            dos = "", -- e70f
            mac = "", -- e711
          },
        },
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location", { "datetime", style = "%h:%m" } },
    },
  })
end

return M
