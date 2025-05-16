local M = {}
-- local available_models = require("core.ollama").list_models()

function M.setup()
  local config = require("core.ai_config")
  if not config.ai.codecompanion then
    return
  end

  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = "ollama",

        roles = {
          ---The header name for the LLM's messages
          llm = function(adapter)
            local model_name = adapter.schema.model.default()
            -- print(require("utils.utils").deepPrint(adapter.schema.model.choices()))
            return "CodeCompanion (" .. model_name .. ")"
          end,

          ---The header name for your messages
          ---@type string
          user = "Me",
        },

        keymaps = {
          close = {
            modes = { n = { "<esc>", "<C-c>" }, i = "<esc>" },
          },
        },
      },

      inline = {
        adapter = "ollama",
      },

      cmd = {
        adapter = "ollama",
      },
    },

    display = {
      chat = {
        auto_scroll = false,
        show_settings = true,
        show_header_separator = false,
        start_in_insert_mode = false,

        icons = {
          pinned_buffer = " ",
          watched_buffer = "",
        },

        window = {
          layout = "vertical", -- float|vertical|horizontal|buffer
          -- position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
          -- border = "solid", -- none|single|double|rounded|solid
          -- full_height = true,
          -- relative = "cursor", -- cursor|editor
          -- width = 0.50,
          -- height = 0.95,
        },
      },
    },

    -- adapters = {
    --   ollama = {
    --     enabled = #available_models > 0 and true or false,
    --     command = "ollama",
    --     model = #available_models > 0 and available_models[1] or "",
    --     -- options = {
    --     --   temperature = 0.4,
    --     -- },
    --   },
    -- },
  })
end

return M
