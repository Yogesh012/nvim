-- Set leader key first (required before loading plugins)
require("core.keymaps").set_leader()

require("core.init")
require("plugins.lazy")

vim.g.python3_host_prog = vim.env.HOME .. vim.env.PYTHONPATH
