local M = {}

function M.setup()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, {
      texthl = sign.name,
      text = sign.text,
      numhl = "",
    })
  end

  vim.diagnostic.config({
    -- virtual_text = false,
    virtual_text = {
      prefix = "●", -- could use "", "", "●"
      spacing = 2,
    },
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  -- LSP handler borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

  -- Color-code Ruff Diagnostic Rule Types (E, F, I…)
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(args)
      local bufnr = args.buf
      for _, d in ipairs(vim.diagnostic.get(bufnr)) do
        if d.source == "ruff" then
          if d.code and type(d.code) == "string" then
            local hl_group = "DiagnosticRuff" .. d.code:sub(1, 1)
            vim.api.nvim_set_hl(0, hl_group, { fg = "#999999" }) -- default to gray

            if d.code:match("^F") then
              vim.api.nvim_set_hl(0, hl_group, { fg = "#ff5f5f" }) -- red-ish
            elseif d.code:match("^E") then
              vim.api.nvim_set_hl(0, hl_group, { fg = "#fabd2f" }) -- yellow-ish
            elseif d.code:match("^I") then
              vim.api.nvim_set_hl(0, hl_group, { fg = "#83a598" }) -- blue-ish
            end
          end
        end
      end
    end,
  })
end

return M
