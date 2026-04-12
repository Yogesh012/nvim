local config = require("config")
local reload = require("utils.reload")

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
--   group = vim.api.nvim_create_augroup("AutoReloadNvimConfig", { clear = true }),
--   callback = function(args)
--     local file = args.file
--     reload.reload_config_for_file(file)
--   end,
-- })

 

-- Treesitter rewrite: enable highlighting + indentexpr per buffer
-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("TreesitterRewriteEnable", { clear = true }),
--   callback = function()
--     local ok = pcall(require, "nvim-treesitter")
--     if not ok then
--       return
--     end
--
--     pcall(vim.treesitter.start)
--     vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--   end,
-- })

-- Format on save toggle
vim.g.format_on_save = config.editor.format_on_save
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.g.format_on_save = not vim.g.format_on_save
  print("Format on save: " .. tostring(vim.g.format_on_save))
end, {})

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


