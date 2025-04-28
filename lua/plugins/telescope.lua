local M = {}

function M.setup()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local action_layout = require("telescope.actions.layout")

  local tab = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    if type(current_picker.all_previewers) == "table" and current_picker.all_previewers[1] then
      local pstate = current_picker.all_previewers[1].state
      if pstate then
        actions.move_selection_previous(prompt_bufnr)
        return
      end
    end
    actions.move_selection_next(prompt_bufnr)
  end

  local shift_tab = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    if type(current_picker.all_previewers) == "table" and current_picker.all_previewers[1] then
      local pstate = current_picker.all_previewers[1].state
      if pstate then
        actions.move_selection_next(prompt_bufnr)
        return
      end
    end
    actions.move_selection_previous(prompt_bufnr)
  end

  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "smart" },
      border = true,
      dynamic_preview_title = false,
      short_path = true,
      wrap_results = true,
      layout_config = {
        scroll_speed = 1,
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
          ["<Tab>"] = tab,
          ["<S-Tab>"] = shift_tab,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
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
          ["<Tab>"] = tab,
          ["f"] = tab,
          ["<S-Tab>"] = shift_tab,
          ["d"] = shift_tab,
          ["<Down>"] = actions.preview_scrolling_down,
          ["<Up>"] = actions.preview_scrolling_up,
          ["j"] = actions.preview_scrolling_down,
          ["k"] = actions.preview_scrolling_up,
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
          i = {
            ["f"] = tab,
            ["<S-Tab>"] = shift_tab,
            ["d"] = shift_tab,
          },
          n = {
            ["f"] = tab,
            ["<S-Tab>"] = shift_tab,
            ["d"] = shift_tab,
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
    },

    file_ignore_patterns = {
      "node_modules",
      "%.lock",
      ".git/",
      "__pycache__",
    },

    glyph = {
      action = function(glyph)
        -- argument glyph is a table.
        -- {name="", value="", category="", description=""}

        vim.fn.setreg("*", glyph.value)
        print([[Press p or "*p to paste this glyph]] .. glyph.value)

        -- insert glyph when picked
        -- vim.api.nvim_put({ glyph.value }, 'c', false, true)
      end,
    },
  })

  -- Load extensions
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "glyph")
end

return M
