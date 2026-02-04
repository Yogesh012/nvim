return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },

      diagnostics = {
        globals = { "vim" }, -- no "vim is undefined" warning
        disable = { ".luacheckrc" }, -- or just ignore the file entirely
      },

      codeLens = {
        enable = true,
      },

      hint = {
        enable = true,
        setType = true,
        paramType = true,
        paramName = "All",
        semicolon = "All",
        arrayIndex = "Auto",
      },

      workspace = {
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
        checkThirdParty = false,
        ignoreDir = { ".luacheckrc" },
        ignore = { ".luacheckrc" },
      },

      telemetry = {
        enable = false,
      },
    },
  },
}
