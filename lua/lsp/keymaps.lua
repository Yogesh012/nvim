local highlight = require("lsp.highlight")
local M = {}

function M.on_attach(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  local telescope = require("telescope.builtin")
  local themes = require("telescope.themes")

  -- Core LSP
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)

  -- Diagnostic
  vim.keymap.set("n", "gj", function()
    vim.diagnostic.goto_next({ float = { border = "rounded" } })
  end, opts)

  vim.keymap.set("n", "gk", function()
    vim.diagnostic.goto_prev({ float = { border = "rounded" } })
  end, opts)

  vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

  vim.keymap.set("n", "gL", function()
    telescope.diagnostics(themes.get_ivy({ previewer = false }))
  end, opts)

  -- Telescope-enhanced LSP navigation
  vim.keymap.set("n", "gd", function()
    telescope.lsp_definitions(themes.get_ivy({ previewer = false }))
  end, opts)

  vim.keymap.set("n", "gi", function()
    telescope.lsp_implementations(themes.get_ivy({ previewer = false }))
  end, opts)

  vim.keymap.set("n", "gr", function()
    telescope.lsp_references(themes.get_ivy({ previewer = false }))
  end, opts)

  vim.keymap.set("n", "gt", function()
    telescope.lsp_type_definitions(themes.get_ivy({ previewer = false }))
  end, opts)

  -- Workspace
  vim.keymap.set("n", "gwa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "gwr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "gwl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)

  -- Toggle virtual text
  vim.keymap.set("n", "<leader>tt", require("lsp.utils").toggle_virtual_text, { desc = "Toggle Virtual Text" })

  -- Toggle inlay hints
  vim.keymap.set("n", "<leader>th", require("lsp.utils").toggle_inlay_hints, { desc = "Toggle Inlay Hints" })

  -- Diagnostics to quickfix/loclist
  vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, { buffer = bufnr, desc = "Diagnostics to Quickfix" })
  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { buffer = bufnr, desc = "Diagnostics to Loclist" })

  -- Format
  vim.keymap.set("n", "gf", function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]])

  -- document highlighting- symbols under cursor are highlighted after a short pause),
  highlight.setup(client, bufnr)
end

return M
