local config = require("config")

vim.g.tokyonight_style = "storm"
vim.g.tokyonight_transparent = config.ui.transparent_background
vim.g.tokyonight_italic_functions = true

vim.cmd("colorscheme " .. config.ui.colorscheme)
