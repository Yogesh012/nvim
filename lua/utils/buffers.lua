local M = {}

-- Toggle to last buffer, but only if it's still listed
function M.toggle_last_buffer()
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and vim.fn.buflisted(alt) == 1 then
    vim.cmd("buffer #")
  else
    vim.notify("No alternate buffer available", vim.log.levels.WARN)
  end
end

-- Close buffer or quit if it's the last one
function M.close()
  if M.count() <= 1 then
    vim.cmd("q")
  else
    vim.cmd("bd")
  end
end

-- Count listed buffers
function M.count()
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      count = count + 1
    end
  end
  return count
end

-- Close all buffers except current, unless another is modified
function M.close_others()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.fn.buflisted(buf) == 1 then
      if vim.bo[buf].modified then
        vim.notify("Buffer " .. buf .. " is modified. Save it first.", vim.log.levels.WARN)
        return
      else
        vim.cmd("silent bdelete " .. buf)
      end
    end
  end
  vim.cmd("silent only")
end

-- Create directory before writing
function M.write_pre()
  local dir = vim.fn.expand("%:p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

return M
