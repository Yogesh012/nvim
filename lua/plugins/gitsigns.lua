local M = {}

function M.setup()
  local tb = require("telescope.builtin")

  require("gitsigns").setup({
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "-" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 300,
      ignore_whitespace = false,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, noremap = true, silent = true })
      end

      -- Navigation
      map("n", "]g", gs.next_hunk, "Git: Next Hunk")
      map("n", "[g", gs.prev_hunk, "Git: Prev Hunk")

      -- Hunk operations (VSCode-like)
      map("n", "<leader>hs", gs.stage_hunk, "Git: Stage Hunk")
      map("v", "<leader>hs", function() gs.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Git: Stage Selected Lines")
      map("n", "<leader>hr", gs.reset_hunk, "Git: Reset Hunk")
      map("v", "<leader>hr", function() gs.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, "Git: Reset Selected Lines")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Git: Undo Stage Hunk")
      map("n", "<leader>hp", gs.preview_hunk, "Git: Preview Hunk")
      
      -- Buffer operations
      map("n", "<leader>hS", gs.stage_buffer, "Git: Stage Buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Git: Reset Buffer")
      
      -- Git operations
      map("n", "<leader>gb", gs.toggle_current_line_blame, "Git: Toggle Blame")
      map("n", "<leader>gd", gs.diffthis, "Git: Diff This")
      
      -- Telescope git commands
      map("n", "<leader>gc", tb.git_commits, "Git: Commits")
      map("n", "<leader>gB", tb.git_branches, "Git: Branches")
      map("n", "<leader>gs", tb.git_status, "Git: Status")
      map("n", "<leader>gS", tb.git_stash, "Git: Stash")
      
      -- Diffview (better keymaps)
      map("n", "<leader>dv", "<cmd>DiffviewOpen<cr>", "Git: Diff View")
      map("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", "Git: Diff History (All)")
      map("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", "Git: Diff History (Current)")
    end,
  })
end

return M
