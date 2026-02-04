local config = require("config")
local reload = require("utils.reload")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
  group = vim.api.nvim_create_augroup("AutoReloadNvimConfig", { clear = true }),
  callback = function(args)
    local file = args.file
    reload.reload_config_for_file(file)
  end,
})

-- Force filetype detection for buffers without filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("ForceFiletypeDetection", { clear = true }),
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

-- Format on save toggle
vim.g.format_on_save = config.editor.format_on_save
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.g.format_on_save = not vim.g.format_on_save
  print("Format on save: " .. tostring(vim.g.format_on_save))
end, {})
