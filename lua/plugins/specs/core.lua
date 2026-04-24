return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "ghassan0/telescope-glyph.nvim",
    },
    config = function()
      require("plugins._telescope").setup()
      require("plugins.keymaps.telescope").setup()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Tree: Toggle Explorer" },
    },
    cmd = "NvimTreeToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.nvim-tree").setup()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- rewritten for Neovim 0.12+ (master is frozen)
    lazy = false,
    priority = 100,
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      "JoosepAlviste/nvim-ts-context-commentstring",
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("plugins.treesitter_v3").setup()
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
