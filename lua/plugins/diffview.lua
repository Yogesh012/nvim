local M = {}

function M.setup()
  local actions = require("diffview.actions")

  require("diffview").setup({
    diff_binaries = false,
    use_icons = true,
    
    -- File panel configuration
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },

    -- Commit view configuration
    commit_log_panel = {
      win_config = {
        height = 16,
      },
    },

    -- Custom keymaps
    keymaps = {
      disable_defaults = false,
      view = {
        -- File navigation
        ["<tab>"] = actions.select_next_entry,
        ["<s-tab>"] = actions.select_prev_entry,
        
        -- Hunk navigation
        ["]h"] = "<cmd>normal! ]c<cr>",
        ["[h"] = "<cmd>normal! [c<cr>",
        
        -- Conflict navigation
        ["]c"] = actions.next_conflict,
        ["[c"] = actions.prev_conflict,
        
        -- Close
        ["q"] = "<cmd>DiffviewClose<cr>",
        ["<esc>"] = "<cmd>DiffviewClose<cr>",
      },
      
      file_panel = {
        -- Navigation
        ["j"] = actions.next_entry,
        ["k"] = actions.prev_entry,
        ["<cr>"] = actions.select_entry,
        ["o"] = actions.select_entry,
        ["<tab>"] = actions.select_next_entry,
        ["<s-tab>"] = actions.select_prev_entry,
        
        -- Staging files
        ["s"] = actions.toggle_stage_entry,
        ["S"] = actions.stage_all,
        ["U"] = actions.unstage_all,
        
        -- Refresh
        ["R"] = actions.refresh_files,
        
        -- Close
        ["q"] = "<cmd>DiffviewClose<cr>",
        ["<esc>"] = "<cmd>DiffviewClose<cr>",
      },
      
      file_history_panel = {
        -- Navigation
        ["j"] = actions.next_entry,
        ["k"] = actions.prev_entry,
        ["<cr>"] = actions.select_entry,
        ["o"] = actions.select_entry,
        ["<tab>"] = actions.select_next_entry,
        ["<s-tab>"] = actions.select_prev_entry,
        
        -- Close
        ["q"] = "<cmd>DiffviewClose<cr>",
        ["<esc>"] = "<cmd>DiffviewClose<cr>",
      },
    },

    -- Enhanced diff options
    enhanced_diff_hl = true,
    
    -- File history options
    file_history = {
      show_commit_details = true,
    },
  })
end

return M
