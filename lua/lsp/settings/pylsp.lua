return {
  settings = {
    pylsp = {
      configurationSources = { "pycodestyle" }, -- other value : "pycodestyle"
      plugins = {
        jedi_completion = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true, all_scopes = true },
        pycodestyle = {
          enable = true,
          indentSize = 2,
          maxLineLength = 160,
          convention = "google",
          ignore = { "E701" }
        },
        pydocstyle = {
          enable = false,
          convention = "google"
        },
        flake8 = {
          enabled = false,
          ignore = {},
          maxLineLength = 160,
        },
        --     mypy = {enabled = false},
        -- isort = {enabled = true},
        --     yapf = {enabled = false},
        --     pylint = {enabled = false},
        --     pydocstyle = {enabled = false},
        -- mccabe = {enabled = false},
        --     preload = {enabled = false},
        -- rope_completion = {enabled = true},
        -- rope_autoimport = {enabled = true}
        -- ruff = { enable = true}
      }
    }
  },
}
