return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("lsp").setup()
    end,
  },
}
