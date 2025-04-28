local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local devicons = require("nvim-web-devicons")

local M = {}

M.pick_devicons = function()
  local results = {}

  for name, data in pairs(devicons.get_icons()) do
    if type(name) == "string" and type(data.icon) == "string" then
      table.insert(results, {
        icon = data.icon,
        name = name,
        display = string.format("%s  %s", data.icon, name),
        ordinal = name,
      })
    end
  end

  table.sort(results, function(a, b)
    return tostring(a.name) < tostring(b.name)
  end)

  pickers
    .new({}, {
      prompt_title = "NerdFont Icons",
      finder = finders.new_table({
        results = results,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = tostring(entry.name),
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local picker = action_state.get_current_picker(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          actions.close(prompt_bufnr)

          local icon = selection.value.icon
          vim.api.nvim_put({ icon }, "c", true, true) -- insert at cursor
          vim.fn.setreg("+", icon)
          vim.notify("📋 Copied: " .. icon)
        end)
        return true
      end,
    })
    :find()
end

return M
