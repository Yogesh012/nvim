local M = {}

M.ai = {
  codeium = true,
  ollama = true,
  chatgpt = false,
}

function M.toggle_codium()
  M.ai.codeium = not M.ai.codeium
  vim.g.codeium_enabled = M.ai.codeium and 1 or 0

  if M.ai.codeium then
    vim.notify("✅ Codeium Enabled")
  else
    vim.notify("⛔ Codeium Disabled")
  end
end

function M.toggle_ollama()
  M.ai.ollama = not M.ai.ollama
  -- vim.g.codeium_enabled = M.ai.codeium and 1 or 0

  if M.ai.ollama then
    vim.notify("✅ Ollama Enabled")
  else
    vim.notify("⛔ Ollama Disabled")
  end
end

function M.is_codium_enabled()
  return M.ai.codeium
end

function M.is_ollama_enabled()
  return M.ai.ollama
end

return M
