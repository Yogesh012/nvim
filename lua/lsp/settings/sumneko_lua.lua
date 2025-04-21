return {
  settings = {
    Lua = {
      completion = {
        autoRequire = true,
        callSnippet = "Replace",
        displayContext = 0,
      },

      diagnostics = {
        globals = { "vim" },
      },

      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },

        checkThirdParty = false,
      },
    },
  },
}
