local M = {}

function M.setup()
  require("project_nvim").setup {
    manual_mode = false,  -- auto-detect root
    detection_methods = { "lsp", "pattern" },
    patterns = { ".git", "Makefile", "package.json", "pyproject.toml" },
    exclude_dirs = {},
    show_hidden = true,
    silent_chdir = true,  -- no messages when switching dirs
    scope_chdir = "global",  -- can be "global", "tab", "win"
  }

  -- Integrate with Telescope
  require("telescope").load_extension("projects")
end

return M
