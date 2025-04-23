local M = {}

function M.setup()
  local highlight = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  }

  for _, hl in ipairs(highlight) do
    vim.api.nvim_set_hl(0, hl, { fg = "#3b3b3b" }) -- change color if needed
  end

  require("ibl").setup({
    indent = {
      char = "│",
      highlight = highlight,
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = { "help", "alpha", "dashboard", "NvimTree", "lazy" },
      buftypes = { "terminal", "nofile" },
    },
  })
end

return M
