local M = {}

function M.setup()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local action_layout = require("telescope.actions.layout")

  -- True when the prompt bar sits above the results (e.g. dropdown).
  -- Measured directly from window positions so it works for any layout/theme.
  local function prompt_at_top(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local prompt_row  = vim.api.nvim_win_get_position(picker.prompt_win)[1]
    local results_row = vim.api.nvim_win_get_position(picker.results_win)[1]
    return prompt_row <= results_row
  end

  -- True when a previewer window is initialised and active.
  local function has_preview(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local p = type(picker.all_previewers) == "table" and picker.all_previewers[1]
    return p and p.state ~= nil
  end

  -- Navigate results away from the prompt bar (the "natural next" direction).
  local nav_next = function(prompt_bufnr)
    if prompt_at_top(prompt_bufnr) then
      actions.move_selection_next(prompt_bufnr)
    else
      actions.move_selection_previous(prompt_bufnr)
    end
  end

  -- Navigate results toward the prompt bar.
  local nav_prev = function(prompt_bufnr)
    if prompt_at_top(prompt_bufnr) then
      actions.move_selection_previous(prompt_bufnr)
    else
      actions.move_selection_next(prompt_bufnr)
    end
  end

  -- j/k: scroll preview when one exists, navigate results otherwise.
  local j_action = function(prompt_bufnr)
    if has_preview(prompt_bufnr) then
      actions.preview_scrolling_down(prompt_bufnr)
    else
      actions.move_selection_next(prompt_bufnr)
    end
  end

  local k_action = function(prompt_bufnr)
    if has_preview(prompt_bufnr) then
      actions.preview_scrolling_up(prompt_bufnr)
    else
      actions.move_selection_previous(prompt_bufnr)
    end
  end

  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      border = true,
      dynamic_preview_title = true,
      wrap_results = true,
      layout_config = {
        scroll_speed = 1,
        horizontal = {
          preview_width = 0.58,
        },
        vertical = {
          preview_height = 0.65,
        },
      },
      file_ignore_patterns = {
        "node_modules",
        "%.lock",
        ".git/",
        "__pycache__",
      },

      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-c>"] = actions.close,
          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,
          ["<Tab>"] = nav_next,
          ["<S-Tab>"] = nav_prev,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-_>"] = actions.which_key,
          ["<M-p>"] = action_layout.toggle_preview,
          ["<esc>"] = actions.close,
        },
        n = {
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<Tab>"] = nav_next,
          ["<S-Tab>"] = nav_prev,
          ["<Down>"] = nav_next,
          ["<Up>"] = nav_prev,
          ["f"] = nav_next,
          ["d"] = nav_prev,
          ["j"] = j_action,
          ["k"] = k_action,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,
          ["zz"] = actions.move_to_middle,
          ["?"] = actions.which_key,
          ["<M-p>"] = action_layout.toggle_preview,
        },
      },
    },

    pickers = {
      find_files = {
        initial_mode = "insert",
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        mappings = {
          n = {
            ["cd"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              actions.close(prompt_bufnr)
              vim.cmd("silent lcd " .. dir)
            end,
          },
        },
      },

      git_status = {
        mappings = {
          n = {
            ["f"] = nav_next,
            ["d"] = nav_prev,
          },
        },

        -- entry_maker = function(entry)
        --   local raw = entry
        --   local status, file = raw:match("^(..)%s+(.*)")
        --
        --   local icons = {
        --     ["M"] = "",
        --     ["A"] = "",
        --     ["R"] = "",
        --     ["D"] = "",
        --     ["??"] = "",
        --   }
        --
        --   status = status or "??"
        --   file = file or raw
        --
        --   local indicator = "✗"
        --   if status:match("[MARC]") then
        --     indicator = "✓"
        --   end
        --
        --   return {
        --     value = file,
        --     ordinal = file,
        --     display = string.format("%s  %s", indicator, file),
        --     filename = file,
        --     status = status,
        --   }
        -- end,
      },
    },

    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      glyph = {
        action = function(glyph)
          vim.fn.setreg("*", glyph.value)
          print([[Press p or "*p to paste this glyph ]] .. glyph.value)
        end,
      },
    },
  })

  -- Load extensions
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "glyph")
end

return M
