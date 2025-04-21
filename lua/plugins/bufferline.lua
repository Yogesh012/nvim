local M = {}

function M.setup()
  local status_ok, bufferline = pcall(require, "bufferline")
  if not status_ok then
    return
  end

  require("bufferline").setup {
    options = {
      mode = "buffers",         -- or "tabs"
      numbers = "none",      -- or "none" | "buffer_id" | "both"
      diagnostics = "nvim_lsp", -- show LSP diagnostics on tabs
      show_buffer_close_icons = true,
      show_close_icon = false,
      separator_style = "slant", -- "slant" | "padded_slant" | "thick" | "thin"
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          highlight = "Directory",
          separator = true
        }
      }
    }
  }
end

return M
