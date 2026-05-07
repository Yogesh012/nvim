local M = {}

function M.setup()
  require("git-conflict").setup({
    default_mappings = false, -- Disable default mappings, use custom
    default_commands = true, -- Enable default commands
    disable_diagnostics = false, -- Show diagnostics for conflicts
    list_opener = "copen", -- Open conflicts in quickfix
    highlights = {
      incoming = "DiffAdd",
      current = "DiffText",
    },
  })

  -- Keymaps for conflict resolution
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- Navigation
  map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Git: Conflict – Next" })
  map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Git: Conflict – Previous" })

  -- Resolution  (<leader>x = conflict domain, mirrors ]x/[x navigation)
  map("n", "<leader>xo", "<cmd>GitConflictChooseOurs<cr>",   { desc = "Conflict: Choose Ours"   })
  map("n", "<leader>xt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Conflict: Choose Theirs" })
  map("n", "<leader>xb", "<cmd>GitConflictChooseBoth<cr>",   { desc = "Conflict: Choose Both"   })
  map("n", "<leader>xn", "<cmd>GitConflictChooseNone<cr>",   { desc = "Conflict: Choose None"   })

  -- List conflicts
  map("n", "<leader>xx", function()
    require("telescope.builtin").quickfix(require("telescope.themes").get_ivy({
      prompt_title = "Git Conflicts",
      previewer = false,
    }))
    vim.cmd("GitConflictListQf")
  end, { desc = "Conflict: List All" })

  -- Merge views
  map("n", "<leader>gm", function()
    local merge_head = vim.fn.findfile(".git/MERGE_HEAD", ".;")
    if merge_head ~= "" then
      vim.cmd("DiffviewOpen HEAD...MERGE_HEAD")
    else
      vim.notify("Not in merge state. Use :DiffviewOpen for regular diff.", vim.log.levels.WARN)
    end
  end, { desc = "Git: 2-Way Merge View" })
  map("n", "<leader>gM", "<cmd>DiffviewOpen<cr>",  { desc = "Git: 3-Way Merge View" })
  map("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Git: Close Diffview"   })
end

return M
