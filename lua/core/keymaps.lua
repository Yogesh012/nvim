local M = {}

-- Set leader keys (must be called before loading plugins)
function M.set_leader()
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
end

function M.setup()
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- ── File / session ────────────────────────────────────────────────────────
  map("n", "<leader>w", ":update!<CR>", vim.tbl_extend("force", opts, { desc = "Editor: Save File" }))

  map("n", "<leader>q", function()
    local cur = vim.api.nvim_get_current_buf()

    local file_bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_is_valid(b)
        and vim.bo[b].buflisted
        and vim.bo[b].buftype == ""
        and vim.bo[b].filetype ~= "NvimTree"
    end, vim.api.nvim_list_bufs())

    local cur_idx = nil
    for i, b in ipairs(file_bufs) do
      if b == cur then cur_idx = i break end
    end

    if cur_idx == nil then
      vim.api.nvim_buf_delete(cur, { force = false })
      return
    end

    if cur_idx > 1 then
      vim.api.nvim_set_current_buf(file_bufs[cur_idx - 1])
    else
      local ok, api = pcall(require, "nvim-tree.api")
      if ok and api.tree.is_visible() then
        api.tree.focus()
      end
    end

    vim.api.nvim_buf_delete(cur, { force = false })
  end, vim.tbl_extend("force", opts, { desc = "Editor: Close Buffer" }))

  -- Toggle between current and last buffer
  map("n", "<leader><leader>", "<C-^>", vim.tbl_extend("force", opts, { desc = "Editor: Toggle Last Buffer" }))

  -- ── Insert mode ───────────────────────────────────────────────────────────
  map("i", "jk", "<Esc>", vim.tbl_extend("force", opts, { desc = "Editor: Escape Insert Mode" }))

  -- ── Window navigation ─────────────────────────────────────────────────────
  map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Editor: Window Left"  }))
  map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Editor: Window Down"  }))
  map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Editor: Window Up"    }))
  map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Editor: Window Right" }))

  -- ── Move text ─────────────────────────────────────────────────────────────
  map("n", "<M-j>", "<Esc>:m .+1<CR>==", vim.tbl_extend("force", opts, { desc = "Editor: Move Line Down" }))
  map("n", "<M-k>", "<Esc>:m .-2<CR>==", vim.tbl_extend("force", opts, { desc = "Editor: Move Line Up"   }))
  map("v", "<M-j>", ":m .+1<CR>==",      vim.tbl_extend("force", opts, { desc = "Editor: Move Line Down" }))
  map("v", "<M-k>", ":m .-2<CR>==",      vim.tbl_extend("force", opts, { desc = "Editor: Move Line Up"   }))
  map("x", "J",     ":move '>+1<CR>gv-gv", vim.tbl_extend("force", opts, { desc = "Editor: Move Block Down" }))
  map("x", "K",     ":move '<-2<CR>gv-gv", vim.tbl_extend("force", opts, { desc = "Editor: Move Block Up"   }))
  map("x", "<M-j>", ":move '>+1<CR>gv-gv", vim.tbl_extend("force", opts, { desc = "Editor: Move Block Down" }))
  map("x", "<M-k>", ":move '<-2<CR>gv-gv", vim.tbl_extend("force", opts, { desc = "Editor: Move Block Up"   }))

  -- ── Better paste ──────────────────────────────────────────────────────────
  map("v", "p", '"_dP', vim.tbl_extend("force", opts, { desc = "Editor: Paste Without Yank" }))

  -- ── Keymap help ───────────────────────────────────────────────────────────
  map("n", "?", function()
    require("plugins.keymaps.help").open()
  end, vim.tbl_extend("force", opts, { desc = "Editor: Keymap Help" }))

  -- ── chromatic.nvim (<leader>T*) ───────────────────────────────────────────
  map("n", "<leader>Tn", "<cmd>ChromaticNext<cr>",        vim.tbl_extend("force", opts, { desc = "Theme: Random Next"          }))
  map("n", "<leader>Tc", "<cmd>ChromaticConfig<cr>",      vim.tbl_extend("force", opts, { desc = "Theme: Settings Picker"      }))
  map("n", "<leader>Td", "<cmd>ChromaticMode dark<cr>",   vim.tbl_extend("force", opts, { desc = "Theme: Set Dark Mode"        }))
  map("n", "<leader>Tl", "<cmd>ChromaticMode light<cr>",  vim.tbl_extend("force", opts, { desc = "Theme: Set Light Mode"       }))
  map("n", "<leader>Ta", "<cmd>ChromaticMode any<cr>",    vim.tbl_extend("force", opts, { desc = "Theme: Set Any Mode"         }))
  map("n", "<leader>Ti", "<cmd>ChromaticInfo<cr>",        vim.tbl_extend("force", opts, { desc = "Theme: Info"                 }))

  -- ── Folds (nvim-ufo) ──────────────────────────────────────────────────────
  map("n", "zR", function() require("ufo").openAllFolds()  end, vim.tbl_extend("force", opts, { desc = "Fold: Open All"         }))
  map("n", "zM", function() require("ufo").closeAllFolds() end, vim.tbl_extend("force", opts, { desc = "Fold: Close All"        }))
  map("n", "zr", function() require("ufo").openFoldsExceptKinds() end, vim.tbl_extend("force", opts, { desc = "Fold: Open Level"  }))
  map("n", "zm", function() require("ufo").closeFoldsWith() end, vim.tbl_extend("force", opts, { desc = "Fold: Close Level"      }))
  map("n", "zp", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      -- No fold under cursor → fall back to LSP hover
      vim.lsp.buf.hover()
    end
  end, vim.tbl_extend("force", opts, { desc = "Fold: Peek / Hover" }))

  -- zC: collapse to function outline — closes only depth-1 folds (functions /
  -- top-level classes), leaving all inner content unfolded so opening any fold
  -- immediately shows the full body without nested folds.
  map("n", "zC", function()
    require("ufo").openAllFolds()
    vim.schedule(function()
      local n = vim.api.nvim_buf_line_count(0)
      for i = 1, n do
        local cur  = vim.fn.foldlevel(i)
        local prev = i > 1 and vim.fn.foldlevel(i - 1) or 0
        if cur == 1 and prev == 0 then
          vim.fn.cursor(i, 1)
          vim.cmd("normal! zc")
        end
      end
    end)
  end, vim.tbl_extend("force", opts, { desc = "Fold: Outline (depth-1 only)" }))

  -- zO: recursively open the fold under the cursor and every nested fold inside it.
  -- map("n", "zO", "zO", vim.tbl_extend("force", opts, { desc = "Fold: Open recursively" }))
end

return M
