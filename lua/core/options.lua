local M = {}

function M.setup()
	-- Setup all the options
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.mouse = "a"
	vim.opt.termguicolors = true
	vim.opt.cursorline = true
	vim.opt.signcolumn = "yes"
	vim.opt.scrolloff = 8
	vim.opt.updatetime = 300
	vim.opt.cmdheight = 2
	vim.opt.completeopt = { "menu", "menuone", "noselect" }
	vim.opt.conceallevel = 0
	vim.opt.fileencoding = "utf-8"
	vim.opt.hlsearch = true
	vim.opt.ignorecase = true
	vim.opt.pumheight = 10
	vim.opt.showmode = false
	vim.opt.showtabline = 2
	vim.opt.smartcase = true
	vim.opt.smartindent = true
	vim.opt.autoindent = true
	vim.opt.splitbelow = true
	vim.opt.splitright = true
	vim.opt.swapfile = false
	vim.opt.timeoutlen = 1000
	vim.opt.undofile = true
	vim.opt.writebackup = false
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true
	vim.opt.numberwidth = 2
	vim.opt.wrap = false
	vim.opt.sidescrolloff = 8
	vim.opt.softtabstop = 2
	vim.opt.textwidth = 100
	vim.opt.list = true
	vim.opt.listchars = { lead = "·", trail = "•", tab = "│ ", eol = "↴" }
	vim.opt.clipboard:append("unnamedplus")
	vim.opt.shortmess:append("c")

	-- Folding (Treesitter-based)
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.foldenable = false
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.foldcolumn = "auto:1"
	vim.opt.fillchars = {
		fold = "─",
		foldopen = "▼",
		foldclose = "▶",
		foldsep = " ",
	}
	vim.opt.statuscolumn = "%s%=%{v:relnum?v:relnum:v:lnum} %C"

	vim.g.python_recommended_style = 0

	vim.cmd([[filetype plugin indent on]])

	-- Custom fold text (shows function name and line count)
	vim.opt.foldtext = "v:lua.CustomFoldText()"
end

-- Custom fold text function
function _G.CustomFoldText()
	local line = vim.fn.getline(vim.v.foldstart)
	local line_count = vim.v.foldend - vim.v.foldstart + 1
	local indent = string.rep(" ", vim.fn.indent(vim.v.foldstart))

	-- Clean up the line (remove leading whitespace and comments)
	line = line:gsub("^%s*", "")

	return string.format("%s  %s  (%d lines)", indent, line, line_count)
end

return M
