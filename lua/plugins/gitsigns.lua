local M = {}

function M.setup()
  require("gitsigns").setup({
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "-" },
      topdelete    = { text = "-" },
      changedelete = { text = "~" },
    },
    signcolumn          = true,
    numhl               = false,
    linehl              = false,
    attach_to_untracked = true,
    current_line_blame  = false,
    current_line_blame_opts = {
      virt_text         = true,
      virt_text_pos     = "eol",
      delay             = 300,
      ignore_whitespace = false,
    },
    on_attach = function(bufnr)
      require("plugins.keymaps.git").on_attach(bufnr)
    end,
  })
end

return M
