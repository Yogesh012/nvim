local M = {}

local buf, win
local available_models = require("core.ollama").list_models()

function M.toggle_sidebar()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    return
  end

  -- Create buffer if doesn't exist
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "AI Sidebar")
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  end

  -- Window config
  local width = math.floor(vim.o.columns * 0.4)
  local height = vim.o.lines - 2
  local col = vim.o.columns - width
  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = 1,
    col = col,
    border = "single",
    style = "minimal",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "## AI Assistant", "" })
end

function M.ask(prompt)
  if not buf then
    M.toggle_sidebar()
  end

  -- Show question
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "> " .. prompt })

  -- Call Ollama's /api/generate
  local body = vim.fn.json_encode({
    model = available_models[2], -- ✅ chat model
    prompt = prompt,
    stream = false,
  })

  local response = vim.fn.system({
    "curl",
    "-s",
    "-X",
    "POST",
    "http://localhost:11434/api/generate",
    "-H",
    "Content-Type: application/json",
    "-d",
    body,
  })

  local ok, data = pcall(vim.fn.json_decode, response)
  if not ok or not data or not data.response then
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "[Error in AI response]" })
    return
  end

  -- Show answer
  local lines = vim.split(data.response, "\n", { trimempty = true })
  for _, line in ipairs(lines) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
  end
end

return M
