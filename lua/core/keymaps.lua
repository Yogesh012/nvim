local M = {}

function M.setup()
  vim.g.mapleader = " "
  local buffers = require("utils.buffers")
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }
  local tb = require("telescope.builtin")
  local th = require("telescope.themes")

  -- File explorer
  map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

  -- Normal Mode: basic file commands
  map("n", "<leader>w", ":update!<CR>", opts) -- Save file
  map("n", "<leader>q", buffers.close, opts)
  map("n", "<leader><leader>", buffers.toggle_last_buffer, opts)
  map("n", "<leader>bo", buffers.close_others, opts) -- optional: close other buffers

  -- Insert Mode: "jk" to exit to Normal mode
  map("i", "jk", "<Esc>", opts)

  -- Window navigation
  map("n", "<C-h>", "<C-w>h", opts)
  map("n", "<C-j>", "<C-w>j", opts)
  map("n", "<C-k>", "<C-w>k", opts)
  map("n", "<C-l>", "<C-w>l", opts)

  -- Telescope mappings (if already setup)
  map("n", "<leader>ff", function()
    tb.find_files(th.get_dropdown({ previewer = false }))
  end, opts)
  map("n", "<leader>fF", tb.find_files, opts) -- with preview
  map("n", "<leader>fg", tb.live_grep, opts)
  map("n", "<leader>fh", tb.help_tags, opts)
  map("n", "<leader>fb", tb.buffers, opts)
  map("n", "<leader>fP", require("telescope").extensions.projects.projects, opts) -- project switcher

  map("n", "<leader>fr", function()
    tb.oldfiles(th.get_dropdown({ previewer = false }))
  end, { desc = "Find Recent Files" })

  map("n", "<leader>fc", tb.commands, { desc = "Find commands" })

  map("n", "<leader>fk", function()
    tb.keymaps(th.get_cursor({
      previewer = false,
      winblend = 20,
      layout_config = {
        preview_cutoff = 120,
        width = 0.95,
        height = 0.5,
        prompt_position = "top",
      },
      sorting_strategy = "ascending",
      scroll_strategy = "cycle",
      hidden = true,
    }))
  end, { desc = "Find Keymaps" })

  map("n", "<leader>f/", function()
    tb.current_buffer_fuzzy_find({
      previewer = false,
      winblend = 5,
    })
  end, { desc = "Grep in Current Buffer" })

  map("n", "<leader>fl", function()
    tb.help_tags({
      default_text = "lua",
    })
  end, { desc = "Lua Help Tags" })

  map("n", "<leader>fp", function()
    tb.help_tags({
      default_text = "python",
    })
  end, { desc = "Python Help Tags" })

  map("n", "<leader>fs", function()
    tb.treesitter()
  end, { desc = "File Symbols (Treesitter)" })

  map("n", "<leader>fS", function()
    tb.lsp_document_symbols()
  end, { desc = "File Symbols (LSP)" })

  map("n", "<leader>fw", function()
    tb.lsp_workspace_symbols()
  end, { desc = "Workspace Symbols (LSP)" })

  map("n", "<leader>fcf", function()
    tb.find_files(th.get_dropdown({
      previewer = false,
      prompt_title = "Neovim Config Files",
      cwd = vim.fn.stdpath("config"),
      hidden = false,
    }))
  end, { desc = "Find Config Files" })

  map("n", "<leader>fcg", function()
    tb.live_grep({
      prompt_title = "Grep Neovim Config",
      cwd = vim.fn.stdpath("config"),
    })
  end, { desc = "Grep in Config" })

  map("n", "<leader>fe", tb.symbols)

  -- Cycle through buffers
  map("n", "<Tab>", ":BufferLineCycleNext<CR>", opts)
  map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", opts)
  -- map("n", "<leader>l", ":BufferLineCycleNext<CR>", opts)
  -- map("n", "<leader>h", ":BufferLineCyclePrev<CR>", opts)
  -- map("n", "<S-l>", ":bnext<CR>", opts)
  -- map("n", "<S-h>", ":bprevious<CR>", opts)

  -- Pick buffer
  map("n", "<leader>bp", ":BufferLinePick<CR>", opts)

  -- Git
  -- map("n", "<leader>gc", tb.git_commits, { desc = "Git Commits" })
  -- map("n", "<leader>gB", tb.git_branches, { desc = "Git Branches" })
  -- map("n", "<leader>gs", tb.git_status, { desc = "Git Status" })
  -- map("n", "<leader>gS", tb.git_stash, { desc = "Stash" })

  -- Move text up and down
  map("n", "<M-j>", "<Esc>:m .+1<CR>==", opts)
  map("n", "<M-k>", "<Esc>:m .-2<CR>==", opts)
  map("v", "<M-j>", ":m .+1<CR>==", opts)
  map("v", "<M-k>", ":m .-2<CR>==", opts)
  map("v", "p", '"_dP', opts)
  map("x", "J", ":move '>+1<CR>gv-gv", opts)
  map("x", "K", ":move '<-2<CR>gv-gv", opts)

  map("x", "<M-j>", ":move '>+1<CR>gv-gv", opts)
  map("x", "<M-k>", ":move '<-2<CR>gv-gv", opts)

  -- Icon picker
  -- vim.keymap.set("n", "<leader>ui", function()
  --   require("plugins.telescope.icon_picker").pick_devicons()
  -- end, { desc = "Pick NerdFont Icon" })

  -- vim.keymap.set("i", "<C-l>", function()
  --   return vim.fn["codeium#Accept"]()
  -- end, { expr = true, silent = true })

  -- vim.keymap.set("i", "<C-]>", function()
  --   return vim.fn
  -- end, { expr = true })

  -- vim.keymap.set("i", "<C-[>", function()
  --   return vim.fn["codeium#CycleCompletions"](-1)
  -- end, { expr = true })
end

return M
