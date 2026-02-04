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
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = function(diagnostic)
        local icons = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "●",
        }
        return icons[diagnostic.severity] or "●"
      end,
    },
    signs = { active = signs },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = function(diagnostic)
        local severity = vim.diagnostic.severity[diagnostic.severity]
        return string.format("[%s] ", severity)
      end,
      format = function(diagnostic)
        if diagnostic.code then
          return string.format("%s (%s)", diagnostic.message, diagnostic.code)
        end
        return diagnostic.message
      end,
    },
  })

  -- LSP handler borders
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

  -- Severity filtering commands (with short aliases)
  vim.api.nvim_create_user_command("DiagnosticsShowAll", function()
    vim.diagnostic.config({ virtual_text = true })
    vim.notify("Showing all diagnostics")
  end, {})
  vim.api.nvim_create_user_command("DSA", function()
    vim.cmd("DiagnosticsShowAll")
  end, {})

  vim.api.nvim_create_user_command("DiagnosticsShowErrors", function()
    vim.diagnostic.config({
      virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
    })
    vim.notify("Showing only errors")
  end, {})
  vim.api.nvim_create_user_command("DSE", function()
    vim.cmd("DiagnosticsShowErrors")
  end, {})

  vim.api.nvim_create_user_command("DiagnosticsShowWarnings", function()
    vim.diagnostic.config({
      virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
    })
    vim.notify("Showing errors and warnings")
  end, {})
  vim.api.nvim_create_user_command("DSW", function()
    vim.cmd("DiagnosticsShowWarnings")
  end, {})

  vim.api.nvim_create_user_command("DiagnosticsHide", function()
    vim.diagnostic.config({ virtual_text = false })
    vim.notify("Diagnostics hidden")
  end, {})
  vim.api.nvim_create_user_command("DSH", function()
    vim.cmd("DiagnosticsHide")
  end, {})

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
