local M = {}

function M.setup()
  local map     = vim.keymap.set
  local builtin = require("telescope.builtin")
  local themes  = require("telescope.themes")

  -- ── File finding ──────────────────────────────────────────────────────────
  map("n", "<leader>ff", function()
    builtin.find_files(themes.get_dropdown({ previewer = false }))
  end, { desc = "Find: Files (dropdown)" })

  map("n", "<leader>fF", "<cmd>Telescope find_files<cr>",
    { desc = "Find: Files (with preview)" })

  map("n", "<leader>fr", function()
    builtin.oldfiles(themes.get_dropdown({ previewer = false }))
  end, { desc = "Find: Recent Files" })

  -- ── Search ────────────────────────────────────────────────────────────────
  map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",
    { desc = "Find: Live Grep" })

  map("n", "<leader>f/", function()
    builtin.current_buffer_fuzzy_find({ previewer = false, winblend = 5 })
  end, { desc = "Find: Grep in Current Buffer" })

  -- ── Neovim config ─────────────────────────────────────────────────────────
  map("n", "<leader>fcf", function()
    builtin.find_files(themes.get_dropdown({
      previewer    = false,
      prompt_title = "Neovim Config Files",
      cwd          = vim.fn.stdpath("config"),
      hidden       = false,
    }))
  end, { desc = "Find: Config Files" })

  map("n", "<leader>fcg", function()
    builtin.live_grep({
      prompt_title = "Grep Neovim Config",
      cwd          = vim.fn.stdpath("config"),
    })
  end, { desc = "Find: Grep in Config" })

  -- ── Meta / vim ────────────────────────────────────────────────────────────
  map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",   { desc = "Find: Buffers"   })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find: Help Tags" })
  map("n", "<leader>fc", "<cmd>Telescope commands<cr>",  { desc = "Find: Commands"  })

  map("n", "<leader>fl", function()
    builtin.help_tags({ default_text = "lua" })
  end, { desc = "Find: Lua Help Tags" })

  map("n", "<leader>fp", function()
    builtin.help_tags({ default_text = "python" })
  end, { desc = "Find: Python Help Tags" })

  map("n", "<leader>fk", function()
    builtin.keymaps(themes.get_cursor({
      previewer        = false,
      winblend         = 20,
      layout_config    = {
        preview_cutoff = 120,
        width          = 0.95,
        height         = 0.5,
        prompt_position = "top",
      },
      sorting_strategy = "ascending",
      scroll_strategy  = "cycle",
      hidden           = true,
    }))
  end, { desc = "Find: Keymaps (raw)" })

  -- ── Symbols ───────────────────────────────────────────────────────────────
  map("n", "<leader>fs", "<cmd>Telescope treesitter<cr>",            { desc = "Find: File Symbols (Treesitter)" })
  map("n", "<leader>fS", "<cmd>Telescope lsp_document_symbols<cr>",  { desc = "Find: File Symbols (LSP)"       })
  map("n", "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Find: Workspace Symbols (LSP)"  })
  map("n", "<leader>fe", "<cmd>Telescope symbols<cr>",               { desc = "Find: Symbols"                  })

  -- ── Extensions ────────────────────────────────────────────────────────────
  map("n", "<leader>fP", function()
    require("telescope").extensions.projects.projects()
  end, { desc = "Find: Projects" })
end

return M
