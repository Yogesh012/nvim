local config = require("config")
local reload = require("utils.reload")

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
--   group = vim.api.nvim_create_augroup("AutoReloadNvimConfig", { clear = true }),
--   callback = function(args)
--     local file = args.file
--     reload.reload_config_for_file(file)
--   end,
-- })

 

-- Treesitter rewrite: enable highlighting + indentexpr per buffer
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterRewriteEnable", { clear = true }),
  callback = function()
    local ok = pcall(require, "nvim-treesitter")
    if not ok then
      return
    end

    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Format on save toggle
vim.g.format_on_save = config.editor.format_on_save
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.g.format_on_save = not vim.g.format_on_save
  print("Format on save: " .. tostring(vim.g.format_on_save))
end, {})

-- ── Auto-theming module ───────────────────────────────────────────────────────
-- Apply a random theme after all plugins are loaded.
-- ensure_applied() is idempotent — safe to call even if the theme was already
-- set by the tokyonight fallback spec during plugin init.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("AutoThemeStartup", { clear = true }),
  once  = true,
  callback = function()
    require("themes").ensure_applied()
  end,
})

-- Register :ThemeNext, :ThemeMode, :ThemeConfig, :ThemeInfo commands
require("themes.ui").setup()

