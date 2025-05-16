local reload = require("utils.reload")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
  group = vim.api.nvim_create_augroup("AutoReloadNvimConfig", { clear = true }),
  callback = function(args)
    local file = args.file
    reload.reload_config_for_file(file)

    -- Special case: if plugins/init.lua is saved → run :PackerSync
    local plugins_init = "lua/plugins/plugin.lua"
    if file == plugins_init then
      vim.schedule(function()
        vim.cmd("PackerSync")
        vim.notify("PackerSync triggered", vim.log.levels.INFO)
      end)
    end
  end,
})

-- Format on save (optional)
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   buffer = bufnr,
--   callback = function()
--     vim.lsp.buf.format({ async = false })
--   end,
-- })

-- Format Toggle
vim.g.format_on_save = true
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.g.format_on_save = not vim.g.format_on_save
  print("Format on save: " .. tostring(vim.g.format_on_save))
end, {})

local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionInline*",
  group = group,
  callback = function(request)
    if request.match == "CodeCompanionInlineFinished" then
      -- Format the buffer after the inline request has completed
      require("conform").format({ bufnr = request.buf })
    end
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequestStarted",
  group = group,
  callback = function(request)
    vim.g.codecompanion_model = request.data.adapter.model
  end,
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionChatClosed",
  group = group,
  callback = function(_)
    vim.g.codecompanion_model = ""
  end,
})
