local M = {}

function M.setup()
  require("lualine").setup {
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
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  }
end

return M
