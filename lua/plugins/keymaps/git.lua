local M = {}

-- Called from gitsigns on_attach — keymaps are buffer-local.
function M.on_attach(bufnr)
  local gs = package.loaded.gitsigns
  local tb = require("telescope.builtin")
  local map = function(mode, l, r, desc)
    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, noremap = true, silent = true })
  end

  -- ── Navigation ────────────────────────────────────────────────────────────
  map("n", "]g", gs.next_hunk, "Git: Next Hunk")
  map("n", "[g", gs.prev_hunk, "Git: Prev Hunk")

  -- ── Hunk operations ───────────────────────────────────────────────────────
  map("n", "<leader>ga", gs.stage_hunk, "Git: Stage Hunk")
  map("v", "<leader>ga", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git: Stage Selected")
  map("n", "<leader>gr", gs.reset_hunk, "Git: Reset Hunk")
  map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git: Reset Selected")
  map("n", "<leader>gu", gs.undo_stage_hunk, "Git: Undo Stage Hunk")
  map("n", "<leader>gp", gs.preview_hunk,    "Git: Preview Hunk")

  -- ── Buffer operations ─────────────────────────────────────────────────────
  map("n", "<leader>gA", gs.stage_buffer,  "Git: Stage Buffer")
  map("n", "<leader>gR", gs.reset_buffer,  "Git: Reset Buffer")

  -- ── Git operations ────────────────────────────────────────────────────────
  map("n", "<leader>gb", gs.toggle_current_line_blame, "Git: Toggle Blame")
  map("n", "<leader>gd", gs.diffthis,                  "Git: Diff This")

  -- ── Telescope git ─────────────────────────────────────────────────────────
  map("n", "<leader>gc", tb.git_commits,  "Git: Commits")
  map("n", "<leader>gB", tb.git_branches, "Git: Branches")
  map("n", "<leader>gs", tb.git_status,   "Git: Status")
  map("n", "<leader>gS", tb.git_stash,    "Git: Stash")

  -- ── Diffview ──────────────────────────────────────────────────────────────
  map("n", "<leader>gv", "<cmd>DiffviewOpen<cr>",          "Git: Diff View")
  map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   "Git: Diff History (All)")
  map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", "Git: Diff History (File)")
end

return M
