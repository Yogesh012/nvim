local config = require("config")
local reload = require("utils.reload")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
  group = vim.api.nvim_create_augroup("AutoReloadNvimConfig", { clear = true }),
  callback = function(args)
    local file = args.file
    reload.reload_config_for_file(file)
  end,
})


-- ── Treesitter: Highlighting + Indentation ────────────────────────────────────
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
  callback = function(args)
    -- Enable treesitter syntax highlighting for this buffer.
    local hl_ok = pcall(vim.treesitter.start, args.buf)
    -- Enable nvim-treesitter's indentation only when a parser is available.
    if hl_ok then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- ── Format on save toggle ─────────────────────────────────────────────────────
vim.g.format_on_save = config.editor.format_on_save
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.g.format_on_save = not vim.g.format_on_save
  print("Format on save: " .. tostring(vim.g.format_on_save))
end, {})

-- ── Wipe stale no-name buffer ─────────────────────────────────────────────────
-- When a real file buffer is entered (e.g. opened via nvim-tree), wipe any
-- leftover empty unnamed buffer that Neovim creates on startup.
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("WipeNoNameBuffer", { clear = true }),
  callback = function()
    local cur = vim.api.nvim_get_current_buf()
    -- Only act when we've landed on a real file buffer
    if vim.bo[cur].buftype ~= "" or vim.api.nvim_buf_get_name(cur) == "" then
      return
    end
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if b ~= cur
        and vim.api.nvim_buf_is_valid(b)
        and vim.api.nvim_buf_get_name(b) == ""  -- unnamed
        and not vim.bo[b].modified              -- unmodified
        and vim.bo[b].buftype == ""             -- normal buffer (not quickfix etc.)
      then
        vim.api.nvim_buf_delete(b, { force = false })
      end
    end
  end,
})

-- ── LSP Attach ────────────────────────────────────────────────────────────────
-- All buffer-local LSP setup (keymaps, highlights, virtual text) lives here.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local bufnr = args.buf

    -- Keymaps
    require("lsp.keymaps").setup(client, bufnr)

    -- Document highlight (symbols under cursor)
    require("lsp.highlight").setup(client, bufnr)

    -- Virtual text per buffer
    local lsp_utils = require("lsp.utils")
    vim.diagnostic.config({
      virtual_text = lsp_utils._virtual_text_enabled and {
        prefix = "●",
        spacing = 2,
      } or false,
    }, bufnr)

    -- Inlay hints
    if config.lsp.inlay_hints ~= false then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end

    -- Per-server extras
    local server = client.name
    if server == "pyright" or server == "ruff" then
      require("lsp.utils").disable_format(client)
    end
  end,
})


-- ── Dynamic High Contrast Search Highlights ─────────────────────────────────
-- Guarantees clear visibility while randomly picking from aesthetically appealing color pairs.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("HighContrastSearch", { clear = true }),
  callback = function()
    local themes = {
      { search = { bg = "#1348d8ff", fg = "#FFFFFF" }, cur = { bg = "#ec7028ff", fg = "#000000" } }, -- Classic Blue & Orange
      { search = { bg = "#8969dcff", fg = "#FFFFFF" }, cur = { bg = "#8545d3ff", fg = "#000000" } }, -- Deep Purple & Bright Violet
      { search = { bg = "#1cd4b9ff", fg = "#FFFFFF" }, cur = { bg = "#7DCFFF", fg = "#000000" } }, -- Dark Teal & Neon Cyan
      { search = { bg = "#70395D", fg = "#FFFFFF" }, cur = { bg = "#F7768E", fg = "#000000" } }, -- Plum & Bright Coral/Pink
      { search = { bg = "#668731ff", fg = "#FFFFFF" }, cur = { bg = "#aec733ff", fg = "#000000" } }, -- Olive & Bright Yellow-Green
    }

    -- Randomly select a theme pair
    math.randomseed(os.time())
    local selected = themes[math.random(1, #themes)]

    -- Non-focused matches
    vim.api.nvim_set_hl(0, "Search", {
      bg = selected.search.bg,
      fg = selected.search.fg,
      default = false
    })

    -- Focused match under cursor
    local active_match = {
      bg = selected.cur.bg,
      fg = selected.cur.fg,
      bold = true,
      default = false
    }
    
    vim.api.nvim_set_hl(0, "CurSearch", active_match)
    vim.api.nvim_set_hl(0, "IncSearch", active_match)
  end,
})
