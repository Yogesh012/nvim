local M = {}

function M.pick_model()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end

  local models = require("core.ollama").list_models()

  if #models == 0 then
    vim.notify("No models found!", vim.log.levels.ERROR)
    return
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Choose AI Model",
      finder = require("telescope.finders").new_table({
        results = models,
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      attach_mappings = function(_, map)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          local model = selection[1]
          local config = require("plugins.ai._gen").config
          config.model = model

          local gen = require("gen")
          gen.setup(config)

          vim.notify("🔁 Switched to model: " .. model)
        end)

        return true
      end,
    })
    :find()
end

return M
