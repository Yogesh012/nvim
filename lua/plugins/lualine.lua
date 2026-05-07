local M = {}

function M.setup()
  require("lualine").setup({
    options = {
      icons_enabled = true,
      section_separators = { left = "", right = "" },
      component_separators = "|",
      globalstatus = true,
    },

    sections = {
      lualine_a = { "mode", { "diff" } },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = {
        require("plugins.lualine_component"),
        "encoding",
        {
          "fileformat",
          symbols = {
            unix = "",
            dos = "",
            mac = "",
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
