local M = {}

function M.setup()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")

  require("luasnip.loaders.from_vscode").lazy_load()

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_get_current_line():sub(col, col):match("%s") == nil
  end

  local menu_labels = {
    nvim_lsp                = "[LSP]",
    nvim_lsp_signature_help = "[Sig]",
    nvim_lua                = "[Lua]",
    luasnip                 = "[Snip]",
    buffer                  = "[Buf]",
    path                    = "[Path]",
  }

  cmp.setup({
    preselect = cmp.PreselectMode.None,

    matching = {
      disallow_partial_fuzzy_matching = true,
      disallow_prefix_unmatching = true,
    },

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    window = {
      completion    = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
      ["<C-k>"]     = cmp.mapping.select_prev_item(),
      ["<C-j>"]     = cmp.mapping.select_next_item(),
      ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
      ["<C-f>"]     = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"]     = cmp.mapping.abort(),
      ["<esc>"]     = cmp.mapping.abort(),
      ["<CR>"]      = cmp.mapping.confirm({ select = false }),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        elseif cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    }),

    -- Layout: [ icon  Kind ]  completion_text   [Source]
    -- lspkind.cmp_format only handles maxwidth/menu truncation — it does NOT set
    -- vim_item.kind. Icons must be applied manually via lspkind.symbol_map.
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local icon = lspkind.symbol_map[vim_item.kind] or ""
        vim_item.kind = string.format("%s %s", icon, vim_item.kind)
        vim_item.menu = menu_labels[entry.source.name] or ""
        if vim.fn.strchars(vim_item.abbr) > 50 then
          vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, 50) .. "…"
        end
        return vim_item
      end,
    },

    sources = cmp.config.sources({
      -- Group 1: high-signal (always shown first)
      { name = "nvim_lsp",                priority = 1000, max_item_count = 30 },
      { name = "nvim_lsp_signature_help", priority = 900 },
      { name = "nvim_lua",                priority = 800 },
      { name = "luasnip",                 priority = 750 },
    }, {
      -- Group 2: fallbacks (only when group 1 is empty)
      { name = "buffer", priority = 500, keyword_length = 3, max_item_count = 10 },
      { name = "path",   priority = 250, max_item_count = 10 },
    }),

    -- sort_text removed: LSP servers set it to arbitrary internal strings (e.g. "0001")
    -- which overrides score-based ranking and produces seemingly random ordering.
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        require("cmp-under-comparator").under,
        cmp.config.compare.kind,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },

    experimental = {
      ghost_text  = { hl_group = "CmpGhostText" },
      native_menu = false,
    },
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer", keyword_length = 2 },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
    }),
  })
end

return M
