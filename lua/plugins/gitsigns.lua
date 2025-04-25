local M = {}

function M.setup()
  local tb = require("telescope.builtin")
  -- Set custom highlights (optional)
  local function set_git_highlights()
    local hl = vim.api.nvim_set_hl
    local link = function(name, target)
      hl(0, name, { link = target })
    end

    link("GitSignsAdd", "DiffAdd")
    link("GitSignsChange", "DiffChange")
    link("GitSignsDelete", "DiffDelete")
    link("GitSignsTopdelete", "DiffDelete")
    link("GitSignsChangedelete", "DiffChange")

    link("GitSignsAddLn", "DiffAdd")
    link("GitSignsChangeLn", "DiffChange")
    link("GitSignsDeleteLn", "DiffDelete")
    link("GitSignsTopdeleteLn", "DiffDelete")
    link("GitSignsChangedeleteLn", "DiffChange")

    link("GitSignsAddNr", "DiffAdd")
    link("GitSignsChangeNr", "DiffChange")
    link("GitSignsDeleteNr", "DiffDelete")
    link("GitSignsTopdeleteNr", "DiffDelete")
    link("GitSignsChangedeleteNr", "DiffChange")
  end

  set_git_highlights()

  require("gitsigns").setup({
    signs = {
      add = { text = "▎", linehl = nil },
      change = { text = "▎", linehl = nil },
      delete = { text = "Ԁ", linehl = nil },
      topdelete = { text = "Ԁ" },
      changedelete = { text = "▎" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`

    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    -- word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    -- watch_gitdir = {
    --   interval = 1000,
    --   follow_files = true,
    -- },

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
      map("n", "]g", gs.next_hunk, "Next Hunk")
      map("n", "[g", gs.prev_hunk, "Prev Hunk")

      -- Actions
      -- map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
      -- map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
      -- map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
      -- map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle Blame")
      map("n", "<leader>gd", gs.diffthis, "Git Diff")
      map("n", "<leader>gc", tb.git_commits, "Git Commits")
      map("n", "<leader>gB", tb.git_branches, "Git Branches")
      map("n", "<leader>gs", tb.git_status, "Git Status")
      map("n", "<leader>gS", tb.git_stash, "Stash")
    end,
  })
end

return M
