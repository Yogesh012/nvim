local M = {}

M.config = {
  model = "codellama:7b",
  -- model = "codellama",
  host = "localhost",
  port = 11434,
  display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
  show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
  show_model = true, -- Displays which model you are using at the beginning of your chat session.
  -- prompts = {
  --   chat = {
  --     prompt = "You are a helpful AI assistant.",
  --     replace = false,
  --     extract = false,
  --   },
  --   edit = {
  --     prompt = "Edit and fix this code:",
  --     replace = true,
  --     extract = true,
  --   },
  --   explain = {
  --     prompt = "Explain what this code does:",
  --     replace = false,
  --     extract = true,
  --   },
  -- },
}

function M.setup()
  require("gen").setup(M.config)
end

return M
