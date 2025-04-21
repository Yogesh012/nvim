local M = {}

function M.setup()
  local autopairs = require("nvim-autopairs")

  autopairs.setup({
    check_ts = true, -- use treesitter to avoid pairing in comments etc.
    ts_config = {
      lua = { "string" }, -- don't auto-pair in strings
      javascript = { "template_string" },
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      map = "<M-e>", -- alt+e to trigger wrap on demand
      chars = { "{", "[", "(", '"', "'" },
      pattern = [=[[%'%"%)%>%]%)%}%,]]=],
      offset = 0,
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
  })

  -- integrate with cmp
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if cmp_status_ok then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

return M
