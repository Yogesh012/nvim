local M = {}

function M.setup()
  -- Diagnostic virtual text colors (subtle but distinct)
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#9d5f68", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#9d7a58", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#5a729d", italic = true })
  vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#5a8d82", italic = true })

  -- Inlay hints styling
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#565f89", italic = true })

  -- Git signs colors (bright and visible)
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#a6e3a1" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#f9e2af" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f38ba8" })
  vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = "#f38ba8" })
  vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = "#fab387" })

  -- Git conflict markers (subtle backgrounds, good contrast)
  vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#2d3f5c", fg = "none" })  -- Subtle blue for ours
  vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#2d4f3c", fg = "none" }) -- Subtle green for theirs
  vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#3d3d3d", fg = "none" }) -- Subtle gray for base
  vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { bg = "#3d5a7a", fg = "#c0caf5", bold = true }) -- Ours label
  vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#3d6a5a", fg = "#c0caf5", bold = true }) -- Theirs label
  vim.api.nvim_set_hl(0, "GitConflictAncestorLabel", { bg = "#5a5a5a", fg = "#c0caf5", bold = true }) -- Base label

  -- Diffview hunk highlighting (clear visual separation)
  vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#2d4f3c", fg = "none" })  -- Green for additions
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4f2d3c", fg = "#6b4f5a" })  -- Red for deletions
  vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3d3f2c", fg = "none" })  -- Yellow for changes
  vim.api.nvim_set_hl(0, "DiffText", { bg = "#5a5f3c", fg = "none", bold = true })  -- Highlighted changed text
  
  -- Hunk headers (@@ ... @@) - Make them stand out
  vim.api.nvim_set_hl(0, "DiffviewDiffHunkHeader", { bg = "#3d3d5a", fg = "#7aa2f7", bold = true })

  -- Fold styling (VSCode-like)
  vim.api.nvim_set_hl(0, "Folded", { fg = "#a9b1d6", bg = "#24283b", italic = false })
  vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#7aa2f7", bg = "none", bold = true })
  
  -- Whitespace
  vim.cmd([[highlight Whitespace guifg=#3b3b3b]])
end

return M
