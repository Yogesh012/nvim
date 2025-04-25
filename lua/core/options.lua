local M = {}

function M.setup()
  local options = {

    -- UI and editing
    number = true, -- set numbered lines
    relativenumber = true, -- set relative numbered lines
    mouse = "a", -- allow the mouse to be used in neovim
    termguicolors = true, -- set term gui colors (most terminals support this)
    cursorline = true, -- highlight the current line
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
    scrolloff = 8, -- is one of my fav
    updatetime = 300, -- faster completion (4000ms default)

    cmdheight = 2, -- more space in the neovim command line for displaying messages
    completeopt = { "menu", "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    hlsearch = true, -- highlight all matches on previous search pattern
    ignorecase = true, -- ignore case in search patterns
    pumheight = 10, -- pop up menu height
    showmode = false, -- we don't need to see things like -- INSERT -- anymore

    showtabline = 2, -- always show tabs
    smartcase = true, -- smart case
    smartindent = true, -- make indenting smarter again
    autoindent = true,
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window
    swapfile = false, -- creates a swapfile
    timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)

    undofile = true, -- enable persistent undo
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

    -- Tabs & indentation
    tabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    numberwidth = 2, -- set number column width to 2 {default 4}
    wrap = false, -- display lines as one long line
    sidescrolloff = 8,
    softtabstop = 2,
    textwidth = 100,

    list = true,
    listchars = {
      lead = "·",
      -- multispace = "·",
      trail = "•",
      tab = "│ ",
      eol = "↴",
    },
  }

  -- Setup all the options
  for k, v in pairs(options) do
    vim.opt[k] = v
  end

  -- Clipboard for macOS
  vim.opt.clipboard:append("unnamedplus")
  vim.opt.shortmess:append("c")
  vim.g.python_recommended_style = 0

  vim.cmd([[filetype plugin indent on]])
  vim.cmd([[highlight Whitespace guifg=#3b3b3b]])
end

return M
