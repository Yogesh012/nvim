local M = {}

-- Convert internal key representation to human-readable form.
-- Replaces <Space> with <leader> when mapleader is space.
local function pretty_lhs(lhs)
  local display = vim.fn.keytrans(lhs)
  if (vim.g.mapleader or "\\") == " " then
    display = display:gsub("<Space>", "<leader>")
  end
  return display
end

-- Collect keymaps that follow the "Category: Description" convention.
-- Reads global + buffer-local keymaps for n, v, x modes.
local function collect_keymaps()
  local results = {}
  local seen    = {}

  local function process(kms, mode)
    for _, km in ipairs(kms) do
      -- Only include keymaps that follow "Word: description" convention
      if km.desc and km.desc:match("^%u%a*: ") then
        local uid = mode .. "|" .. km.lhs
        if not seen[uid] then
          seen[uid] = true
          local category    = km.desc:match("^(%u%a*): ")
          local description = km.desc:gsub("^%u%a*: ", "", 1)
          table.insert(results, {
            lhs         = pretty_lhs(km.lhs),
            lhs_raw     = km.lhs,
            mode        = mode,
            category    = category,
            description = description,
            full_desc   = km.desc,
          })
        end
      end
    end
  end

  for _, mode in ipairs({ "n", "v", "x" }) do
    process(vim.api.nvim_get_keymap(mode), mode)
    process(vim.api.nvim_buf_get_keymap(0, mode), mode)
  end

  -- Sort: category → mode → lhs
  table.sort(results, function(a, b)
    if a.category ~= b.category then return a.category < b.category end
    if a.mode     ~= b.mode     then return a.mode     < b.mode     end
    return a.lhs < b.lhs
  end)

  return results
end

-- Word-boundary sorter: every space-separated token in the query must appear
-- as a plain substring in the ordinal. Avoids fuzzy per-character matching so
-- that typing 'git' only surfaces entries that literally contain 'git'.
local function word_sorter()
  return require("telescope.sorters").new({
    scoring_function = function(_, prompt, line)
      if not prompt or prompt == "" then return 1 end
      local lower = line:lower()
      for token in prompt:lower():gmatch("%S+") do
        if not lower:find(token, 1, true) then
          return -1  -- token not found → exclude entry
        end
      end
      return 1
    end,
  })
end

function M.open()
  local ok1, pickers       = pcall(require, "telescope.pickers")
  local ok2, finders       = pcall(require, "telescope.finders")
  local ok3, entry_display = pcall(require, "telescope.pickers.entry_display")
  local ok4, actions       = pcall(require, "telescope.actions")

  if not (ok1 and ok2 and ok3 and ok4) then
    vim.notify("[keymap-help] Telescope not available", vim.log.levels.ERROR)
    return
  end

  local keymaps = collect_keymaps()

  -- Column widths: [Category]  mode  key_combo  description
  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = 10 },       -- [Category]
      { width = 3  },       -- mode (n/v/x)
      { width = 22 },       -- key combination
      { remaining = true }, -- description
    },
  })

  local mode_hl = {
    n = "TelescopeResultsSpecialComment",
    v = "TelescopeResultsNumber",
    x = "TelescopeResultsNumber",
  }

  local make_display = function(entry)
    local item = entry.value
    return displayer({
      { "[" .. item.category .. "]", "TelescopeResultsIdentifier"                  },
      { item.mode,                    mode_hl[item.mode] or "TelescopeResultsComment" },
      { item.lhs,                     "TelescopeResultsField"                         },
      { item.description,             "TelescopeResultsNormal"                        },
    })
  end

  pickers.new({}, {
    prompt_title    = "  Keymap Help  (search by key, category, or description)",
    finder          = finders.new_table({
      results     = keymaps,
      entry_maker = function(entry)
        return {
          value   = entry,
          display = make_display,
          ordinal = entry.category
            .. " " .. entry.mode
            .. " " .. entry.lhs
            .. " " .. entry.full_desc,
        }
      end,
    }),
    sorter          = word_sorter(),
    layout_strategy = "bottom_pane",
    layout_config   = { height = 0.4 },
    sorting_strategy = "ascending",   -- fill from prompt downward, no gap
    previewer       = false,
    border          = true,
    winblend        = 12,   -- slight transparency for glossy look
    attach_mappings = function(prompt_bufnr, map)
      -- Override Enter: this is a lookup tool, not a file opener.
      -- The default action crashes because it tries to split the
      -- display *function* as if it were a filename string.
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
      end)
      -- j/k navigation in normal mode (press <Esc> then j/k)
      map("n", "j", actions.move_selection_next)
      map("n", "k", actions.move_selection_previous)
      return true
    end,
  }):find()
end

return M
