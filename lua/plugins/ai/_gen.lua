local M = {}
local ollama = require("core.ollama")
local available_models = ollama.list_models()

M.config = {
  model = #available_models > 0 and available_models[1] or "",
  host = "localhost",
  port = 11434,
  display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
  show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
  show_model = true, -- Displays which model you are using at the beginning of your chat session.
}

function M.setup()
  if #available_models == 0 then
    require("core.ai_config").ai.ollama = false
    return
  end

  if not require("core.ai_config").is_ollama_enabled() then
    return ""
  end

  require("gen").setup(M.config)
  require("lualine").refresh()
end

return M
