local M = {}

function M.setup()
  local lint = require("lint")

  lint.linters_by_ft = {
    python = { "ruff", "pylint" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    lua = { "luacheck" },
    rust = { "clippy" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end

return M

