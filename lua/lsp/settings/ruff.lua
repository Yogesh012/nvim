return {
  cmd = { "ruff", "server", "--preview" },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  init_options = {
    settings = {
      lint = {
        preview = true
      },
    },
  }, 
}
