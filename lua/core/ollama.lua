local M = {}

-- List all available local models from Ollama
function M.list_models()
  local output = vim.fn.system("curl -s http://127.0.0.1:11434/api/tags")

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to contact Ollama server.", vim.log.levels.ERROR)
    return {}
  end

  local ok, parsed = pcall(vim.fn.json_decode, output)
  if not ok then
    vim.notify("Failed to parse Ollama model list!", vim.log.levels.ERROR)
    return {}
  end

  local models = {}
  for _, tag in ipairs(parsed.models or {}) do
    table.insert(models, tag.name)
  end
  return models
end

return M
