local M = {}

-- Set leader keys (must be called before loading plugins)
function M.set_leader()
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
end

function M.setup()
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- Basic file operations
  map("n", "<leader>w", ":update!<CR>", opts)
  map("n", "<leader>q", ":bd<CR>", opts)

  -- Toggle between current and last buffer
  map("n", "<leader><leader>", "<C-^>", opts)

  -- Insert mode escape
  map("i", "jk", "<Esc>", opts)

  -- Window navigation
  map("n", "<C-h>", "<C-w>h", opts)
  map("n", "<C-j>", "<C-w>j", opts)
  map("n", "<C-k>", "<C-w>k", opts)
  map("n", "<C-l>", "<C-w>l", opts)

  -- Move text up and down
  map("n", "<M-j>", "<Esc>:m .+1<CR>==", opts)
  map("n", "<M-k>", "<Esc>:m .-2<CR>==", opts)
  map("v", "<M-j>", ":m .+1<CR>==", opts)
  map("v", "<M-k>", ":m .-2<CR>==", opts)
  map("x", "J", ":move '>+1<CR>gv-gv", opts)
  map("x", "K", ":move '<-2<CR>gv-gv", opts)
  map("x", "<M-j>", ":move '>+1<CR>gv-gv", opts)
  map("x", "<M-k>", ":move '<-2<CR>gv-gv", opts)

  -- Better paste in visual mode
  map("v", "p", '"_dP', opts)

  -- ── chromatic.nvim (<leader>T*) ───────────────────────────────────────────
  map("n", "<leader>Tn", "<cmd>ChromaticNext<cr>",        vim.tbl_extend("force", opts, { desc = "Theme: new random" }))
  map("n", "<leader>Tc", "<cmd>ChromaticConfig<cr>",      vim.tbl_extend("force", opts, { desc = "Theme: settings picker" }))
  map("n", "<leader>Td", "<cmd>ChromaticMode dark<cr>",   vim.tbl_extend("force", opts, { desc = "Theme: dark mode (persisted)" }))
  map("n", "<leader>Tl", "<cmd>ChromaticMode light<cr>",  vim.tbl_extend("force", opts, { desc = "Theme: light mode (persisted)" }))
  map("n", "<leader>Ta", "<cmd>ChromaticMode any<cr>",    vim.tbl_extend("force", opts, { desc = "Theme: any mode (persisted)" }))
  map("n", "<leader>Ti", "<cmd>ChromaticInfo<cr>",        vim.tbl_extend("force", opts, { desc = "Theme: info" }))
end

return M
