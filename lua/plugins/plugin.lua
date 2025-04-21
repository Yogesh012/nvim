local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local PACKER_BOOTSTRAP
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Auto-reload Neovim and sync plugins when saving this file
local packer_group = vim.api.nvim_create_augroup("PackerUserConfig", { clear = true })

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

local M = {}

function M.setup()
  -- Install plugins here
  return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
    use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
    -- use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter

    -- Telescope
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-project.nvim",
      },
    })
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

    -- Commenting
    use({
      "numToStr/Comment.nvim",
    })
    use("JoosepAlviste/nvim-ts-context-commentstring")

    -- File explorer
    use({
      "nvim-tree/nvim-tree.lua",
      requires = { "nvim-tree/nvim-web-devicons" },
    })

    -- Bufferlines
    use({
      "akinsho/bufferline.nvim",
      version = "*",
      requires = "nvim-tree/nvim-web-devicons",
    })

    -- Icons
    use({ "nvim-tree/nvim-web-devicons" })

    -- Statusline
    use({
      "nvim-lualine/lualine.nvim",
      requires = { "nvim-tree/nvim-web-devicons" },
    })

    -- Theme
    use({
      "folke/tokyonight.nvim",
      config = function()
        vim.cmd("colorscheme tokyonight")
      end,
    })

    -- Project root
    use({ "ahmedkhalf/project.nvim" })

    -- Treesitter
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
    })

    -- Rainbow parentheses
    use("HiPhish/rainbow-delimiters.nvim")

    -- Core LSP
    use({ "neovim/nvim-lspconfig" })
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })

    -- Completion
    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets", -- optional: huge snippet collection
        "hrsh7th/cmp-cmdline", -- cmdline completions
      },
    })
    use("lukas-reineke/cmp-under-comparator")

    -- Formatter & Linting
    use({ "stevearc/conform.nvim" })
    use({ "mfussenegger/nvim-lint" })

    -- Git
    use({ "lewis6991/gitsigns.nvim" })
    use({
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    })

    -- Auto-pair
    use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
  end)
end

return M
