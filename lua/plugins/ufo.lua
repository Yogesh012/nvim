-- lua/plugins/ufo.lua
-- VSCode-like folding via nvim-ufo.
--
-- Provider chain: LSP foldingRange → Treesitter → indent
-- Files that have no LSP attached fall back to Treesitter automatically.
-- Fold text mimics VSCode: first line of code  ···  N lines
local M = {}

-- ── Fold text decorator ──────────────────────────────────────────────────────
-- Called by ufo for every closed fold.  Returns a virtual-text table so ufo
-- can keep syntax colouring on the leading portion.
local function fold_virt_text_handler(virt_text, lnum, end_lnum, width, truncate)
  local new_virt_text = {}
  local suffix        = ("  ··· %d lines "):format(end_lnum - lnum)
  local suffix_width  = vim.fn.strdisplaywidth(suffix)
  local target_width  = width - suffix_width
  local cur_width     = 0

  -- Re-emit tokens from the first line until we hit the target width.
  for _, chunk in ipairs(virt_text) do
    local chunk_text = chunk[1]
    local chunk_width = vim.fn.strdisplaywidth(chunk_text)
    if target_width > cur_width + chunk_width then
      table.insert(new_virt_text, chunk)
    else
      -- Truncate the last token so it fits exactly.
      chunk_text = truncate(chunk_text, target_width - cur_width)
      local hl_group = chunk[2]
      table.insert(new_virt_text, { chunk_text, hl_group })
      chunk_width = vim.fn.strdisplaywidth(chunk_text)
      if cur_width + chunk_width < target_width then
        -- Pad with a space if there's a small gap before the suffix.
        suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
      end
      break
    end
    cur_width = cur_width + chunk_width
  end

  -- Append the styled suffix  "··· N lines"
  table.insert(new_virt_text, { suffix, "UfoFoldedEllipsis" })
  return new_virt_text
end

-- ── Provider selector ────────────────────────────────────────────────────────
-- Returns a custom function that chains lsp → treesitter → indent by catching
-- UfoFallbackException at each step.  This bypasses the 2-provider string limit
-- while still hitting indent for buffers with no treesitter parser.
local function provider_selector(_, _, _)
  return function(bufnr)
    local function fallback(err, next_provider)
      if type(err) == "string" and err:match("UfoFallbackException") then
        return require("ufo").getFolds(bufnr, next_provider)
      end
      return require("promise-async").reject(err)
    end

    return require("ufo").getFolds(bufnr, "lsp")
      :catch(function(err) return fallback(err, "treesitter") end)
      :catch(function(err) return fallback(err, "indent") end)
  end
end

function M.setup()
  local ok, ufo = pcall(require, "ufo")
  if not ok then
    vim.notify("[ufo] nvim-ufo not loaded.", vim.log.levels.WARN)
    return
  end

  ufo.setup({
    provider_selector       = provider_selector,
    fold_virt_text_handler  = fold_virt_text_handler,
    -- Show a small count badge on the fold gutter icon (like VSCode).
    enable_get_fold_virt_text = true,
    -- Keep the preview window open on cursor movement inside it.
    preview = {
      win_config = {
        border     = "rounded",
        winblend   = 12,
        winhighlight = "Normal:UfoPreviewNormal,FloatBorder:UfoPreviewBorder",
      },
      mappings = {
        -- Close the peek popup with q or <Esc>
        scrollU = "<C-u>",
        scrollD = "<C-d>",
      },
    },
  })

  -- ── Highlight for the ellipsis suffix ──────────────────────────────────────
  -- Set a muted colour; overridden on each ColorScheme change.
  local function set_hl()
    local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
    vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", {
      fg      = comment_hl.fg,
      italic  = true,
      default = false,
    })
  end
  set_hl()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group    = vim.api.nvim_create_augroup("UfoEllipsisHL", { clear = true }),
    callback = set_hl,
  })
end

return M
