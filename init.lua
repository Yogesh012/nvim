-- Set leader key first (required before loading plugins)
require("core.keymaps").set_leader()

require("plugins.lazy")
require("core.options").setup()
require("core.keymaps").setup()
require("core.autocmds")
