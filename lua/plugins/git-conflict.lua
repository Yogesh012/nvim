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
  map("n", "]x", "<cmd>GitConflictNextConflict<cr>", { desc = "Conflict: Next" })
  map("n", "[x", "<cmd>GitConflictPrevConflict<cr>", { desc = "Conflict: Previous" })

  -- Resolution
  map("n", "<leader>co", "<cmd>GitConflictChooseOurs<cr>", { desc = "Conflict: Choose Ours" })
  map("n", "<leader>ct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Conflict: Choose Theirs" })
  map("n", "<leader>cb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Conflict: Choose Both" })
  map("n", "<leader>cn", "<cmd>GitConflictChooseNone<cr>", { desc = "Conflict: Choose None" })

  -- List conflicts (Telescope with ivy theme)
  map("n", "<leader>cx", function()
    require("telescope.builtin").quickfix(require("telescope.themes").get_ivy({
      prompt_title = "Git Conflicts",
      previewer = false,
    }))
    vim.cmd("GitConflictListQf")
  end, { desc = "Conflict: List All" })

  -- Merge views (manual)
  map("n", "<leader>gm3", "<cmd>DiffviewOpen<cr>", { desc = "Git: 3-Way Merge View" })
  map("n", "<leader>gm", function()
    -- Check if in merge state
    local merge_head = vim.fn.findfile(".git/MERGE_HEAD", ".;")
    if merge_head ~= "" then
      -- In merge: show 2-way diff (ours vs theirs)
      vim.cmd("DiffviewOpen HEAD...MERGE_HEAD")
    else
      -- Not in merge: show regular diff
      vim.notify("Not in merge state. Use :DiffviewOpen for regular diff.", vim.log.levels.WARN)
    end
  end, { desc = "Git: 2-Way Merge View" })
  map("n", "<leader>gmc", "<cmd>DiffviewClose<cr>", { desc = "Git: Close Merge View" })
end

return M
