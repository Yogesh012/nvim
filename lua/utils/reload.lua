local M = {}

-- Forcefully reload a Lua module
function M.reload_module(module)
  package.loaded[module] = nil
  return require(module)
end

-- Main reload function for any config file path
function M.reload_config_for_file(file_path)
  local config_root = vim.fn.stdpath("config") .. "/lua/"
  local module_path = file_path
    :gsub(config_root, "")       -- remove root
    :gsub("%.lua$", "")          -- remove .lua
    :gsub("/", ".")              -- convert path to module name

  -- Attempt to reload
  local ok, mod = pcall(M.reload_module, module_path)
  if not ok then
    vim.notify("Failed to reload module: " .. module_path, vim.log.levels.ERROR)
    return
  end

  vim.notify("Reloaded: " .. module_path, vim.log.levels.INFO)

  -- If the module returns a table with a `setup()` function, call it
  if type(mod) == "table" and type(mod.setup) == "function" then
    local ok_setup, err = pcall(mod.setup)
    if ok_setup then
      vim.notify("Auto-called setup() for: " .. module_path, vim.log.levels.INFO)
    else
      vim.notify("Error in setup(): " .. err, vim.log.levels.ERROR)
    end
  end
end

return M
