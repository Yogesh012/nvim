local M = {}

function M.setup()
  local config = require("config")
  local lint = require("lint")

  lint.linters_by_ft = config.linting.linters_by_ft

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("LintOnSave", { clear = true }),
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M

