local M = {}

function M.setup()
  if not vim.g.codeium then
    return ""
  end

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

  -- require("codeium.virtual_text").set_statusbar_refresh(function()
  --   require("lualine").refresh()
  -- end)
end

return M
