return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "Find Files (dropdown)",
      },
      { "<leader>fF", "<cmd>Telescope find_files<cr>", desc = "Find Files (with preview)" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles(require("telescope.themes").get_dropdown({ previewer = false }))
        end,
        desc = "Recent Files",
      },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      {
        "<leader>fk",
        function()
          require("telescope.builtin").keymaps(require("telescope.themes").get_cursor({
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
        end,
        desc = "Keymaps",
      },
      {
        "<leader>f/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find({ previewer = false, winblend = 5 })
        end,
        desc = "Grep in Current Buffer",
      },
      {
        "<leader>fl",
        function()
          require("telescope.builtin").help_tags({ default_text = "lua" })
        end,
        desc = "Lua Help Tags",
      },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").help_tags({ default_text = "python" })
        end,
        desc = "Python Help Tags",
      },
      { "<leader>fs", "<cmd>Telescope treesitter<cr>", desc = "File Symbols (Treesitter)" },
      { "<leader>fS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "File Symbols (LSP)" },
      { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols (LSP)" },
      {
        "<leader>fcf",
        function()
          require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
            previewer = false,
            prompt_title = "Neovim Config Files",
            cwd = vim.fn.stdpath("config"),
            hidden = false,
          }))
        end,
        desc = "Find Config Files",
      },
      {
        "<leader>fcg",
        function()
          require("telescope.builtin").live_grep({
            prompt_title = "Grep Neovim Config",
            cwd = vim.fn.stdpath("config"),
          })
        end,
        desc = "Grep in Config",
      },
      { "<leader>fe", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
      {
        "<leader>fP",
        function()
          require("telescope").extensions.projects.projects()
        end,
        desc = "Projects",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "ghassan0/telescope-glyph.nvim",
    },
    config = function()
      require("plugins._telescope").setup()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "File Explorer" },
    },
    cmd = "NvimTreeToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.nvim-tree").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 100,
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("plugins.treesitter").setup()
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.project").setup()
    end,
  },
}
