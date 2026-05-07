local M = {}

function M.setup(client, bufnr)
  local opts     = { buffer = bufnr, noremap = true, silent = true }
  local telescope = require("telescope.builtin")
  local themes    = require("telescope.themes")

  -- ── Core LSP ──────────────────────────────────────────────────────────────
  vim.keymap.set("n", "gca",        vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "LSP: Code Action"     }))
  vim.keymap.set("v", "gca",        vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "LSP: Code Action"     }))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         vim.tbl_extend("force", opts, { desc = "LSP: Rename Symbol"   }))
  vim.keymap.set("n", "K",          vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "LSP: Hover Docs"      }))
  vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    vim.tbl_extend("force", opts, { desc = "LSP: Go to Declaration" }))
  vim.keymap.set("n", "gS",         vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP: Signature Help"  }))

  -- ── Diagnostics ───────────────────────────────────────────────────────────
  vim.keymap.set("n", "gj", function()
    vim.diagnostic.goto_next({ float = { border = "rounded" } })
  end, vim.tbl_extend("force", opts, { desc = "LSP: Next Diagnostic" }))

  vim.keymap.set("n", "gk", function()
    vim.diagnostic.goto_prev({ float = { border = "rounded" } })
  end, vim.tbl_extend("force", opts, { desc = "LSP: Prev Diagnostic" }))

  vim.keymap.set("n", "gl", vim.diagnostic.open_float,
    vim.tbl_extend("force", opts, { desc = "LSP: Diagnostic Float" }))

  vim.keymap.set("n", "gL", function()
    telescope.diagnostics(themes.get_ivy({ previewer = false }))
  end, vim.tbl_extend("force", opts, { desc = "LSP: All Diagnostics (Telescope)" }))

  -- ── Telescope-enhanced navigation ─────────────────────────────────────────
  vim.keymap.set("n", "gd", function()
    telescope.lsp_definitions(themes.get_ivy({ previewer = false }))
  end, vim.tbl_extend("force", opts, { desc = "LSP: Go to Definition" }))

  vim.keymap.set("n", "gi", function()
    telescope.lsp_implementations(themes.get_ivy({ previewer = false }))
  end, vim.tbl_extend("force", opts, { desc = "LSP: Go to Implementation" }))

  vim.keymap.set("n", "gr", function()
    telescope.lsp_references(themes.get_ivy({ previewer = false }))
  end, vim.tbl_extend("force", opts, { desc = "LSP: References" }))

  vim.keymap.set("n", "gt", function()
    telescope.lsp_type_definitions(themes.get_ivy({ previewer = false }))
  end, vim.tbl_extend("force", opts, { desc = "LSP: Go to Type Definition" }))

  -- ── Workspace ─────────────────────────────────────────────────────────────
  vim.keymap.set("n", "gwa", vim.lsp.buf.add_workspace_folder,
    vim.tbl_extend("force", opts, { desc = "LSP: Add Workspace Folder" }))
  vim.keymap.set("n", "gwr", vim.lsp.buf.remove_workspace_folder,
    vim.tbl_extend("force", opts, { desc = "LSP: Remove Workspace Folder" }))
  vim.keymap.set("n", "gwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, vim.tbl_extend("force", opts, { desc = "LSP: List Workspace Folders" }))

  -- ── LSP toggles (<leader>l group) ────────────────────────────────────────
  vim.keymap.set("n", "<leader>lv", require("lsp.utils").toggle_virtual_text,
    vim.tbl_extend("force", opts, { desc = "LSP: Toggle Virtual Text" }))
  vim.keymap.set("n", "<leader>lh", require("lsp.utils").toggle_inlay_hints,
    vim.tbl_extend("force", opts, { desc = "LSP: Toggle Inlay Hints" }))

  -- ── Diagnostics lists ─────────────────────────────────────────────────────
  vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist,
    vim.tbl_extend("force", opts, { desc = "LSP: Diagnostics → Quickfix" }))
  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist,
    vim.tbl_extend("force", opts, { desc = "LSP: Diagnostics → Loclist" }))

end

return M
