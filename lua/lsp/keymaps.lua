local M = {}

function M.setup(client, bufnr)
  local opts     = { buffer = bufnr, noremap = true, silent = true }
  local telescope = require("telescope.builtin")
  local themes    = require("telescope.themes")

  -- ── Core LSP ──────────────────────────────────────────────────────────────
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,  { buffer = bufnr, desc = "LSP: Code Action"    })
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action,  { buffer = bufnr, desc = "LSP: Code Action"    })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,       { buffer = bufnr, desc = "LSP: Rename Symbol"  })
  vim.keymap.set("n", "K",          vim.lsp.buf.hover,        vim.tbl_extend("force", opts, { desc = "LSP: Hover Docs"        }))
  vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,  vim.tbl_extend("force", opts, { desc = "LSP: Go to Declaration" }))
  vim.keymap.set("n", "gs",         vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP: Signature Help" }))

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

  -- ── Toggles ───────────────────────────────────────────────────────────────
  vim.keymap.set("n", "<leader>tt", require("lsp.utils").toggle_virtual_text,
    { desc = "LSP: Toggle Virtual Text" })
  vim.keymap.set("n", "<leader>th", require("lsp.utils").toggle_inlay_hints,
    { desc = "LSP: Toggle Inlay Hints" })

  -- ── Diagnostics lists ─────────────────────────────────────────────────────
  vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist,
    { buffer = bufnr, desc = "LSP: Diagnostics → Quickfix" })
  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist,
    { buffer = bufnr, desc = "LSP: Diagnostics → Loclist" })

  -- ── Format ────────────────────────────────────────────────────────────────
  vim.keymap.set("n", "gf", function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend("force", opts, { desc = "LSP: Format Buffer" }))

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]])
end

return M
