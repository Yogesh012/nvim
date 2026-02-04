return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("lsp").setup()
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
  },

  {
    "williamboman/mason-lspconfig.nvim",
  },
}
