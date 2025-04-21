local M = {}

function M.setup()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    vim.notify("nvim-web-devicons not found!", vim.log.levels.ERROR)
    return
  end

  devicons.setup {
    override = {},
    default = true,
  }
end

return M
