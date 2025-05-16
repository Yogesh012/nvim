local M = {}

function M.setup()
  if not require("core.ai_config").is_codium_enabled() then
    return ""
  end

  local ok = pcall(function()
    vim.g.codeium_enabled = 1
    require("codeium").setup({
      enable_tab_completion = false,
      -- You can hook this into cmp if you're using it
      -- or keep it native with ghost text
      virtual_text = {
        enabled = true,
        prefix = " ", -- fancy icon before the ghost text
        hl_group = "Comment",
        key_bindings = {
          accept = "<C-i>",
          accept_word = false,
          accept_line = false,
          next = "<C-]>",
          prev = "<C-[>",
          clear = "<C-x>",
        },
      },
    })
  end)

  if not ok then
    vim.notify("Codeium failed to load or auth missing. Disabling.", vim.log.levels.WARN)
    require("ai_config").ai.codeium = false
  end
end

return M
