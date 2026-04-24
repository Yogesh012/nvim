-- lua/plugins/incremental_selection.lua
-- Replicates nvim-treesitter's incremental_selection module using
-- only Neovim 0.12 built-in vim.treesitter APIs.
-- Owns both the selection logic AND the keymaps — fully self-contained.
--
-- Architecture: state-based with a node stack.
-- Storing selected nodes directly avoids re-inferring them from visual
-- selection positions (fragile due to mark ownership and off-by-one bugs).
-- Incremental = push parent. Decremental = pop. vv = reset + push leaf.
--
-- Key subtlety: select_node must exit visual mode (feedkeys Esc) before
-- re-entering it. The "x" flag makes this synchronous, which fires our
-- ModeChanged autocmd and would reset the stack mid-call. The _programmatic
-- flag tells the autocmd to skip the reset during our own transitions.
local M = {}

-- ── State ─────────────────────────────────────────────────────────────────────
local _stack = {} -- nodes selected so far in the current session
local _programmatic = false -- true while select_node is doing its Esc/reenter

-- ── Core helper ───────────────────────────────────────────────────────────────

local function select_node(node)
	if not node then
		return
	end
	local sr, sc, er, ec = node:range() -- 0-indexed; ec is exclusive

	local end_row, end_col
	if ec == 0 and er > sr then
		-- Node ends at the exclusive-start of row `er` (common for blocks).
		-- Real last content is on row er-1 (0-indexed) = row er (1-indexed).
		local line = vim.api.nvim_buf_get_lines(0, er - 1, er, false)[1] or ""
		end_row = er
		end_col = math.max(#line - 1, 0)
	else
		end_row = er + 1
		end_col = math.max(ec - 1, 0)
	end

	-- Suppress ModeChanged reset while we programmatically exit + re-enter visual.
	_programmatic = true
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false) -- exits visual; ModeChanged fires here
	_programmatic = false -- reset BEFORE the subsequent mode change back to visual

	vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
	vim.api.nvim_feedkeys("v", "nx", false) -- always enters (not toggles) visual
	vim.api.nvim_win_set_cursor(0, { end_row, end_col })
end

-- ── Selection functions ───────────────────────────────────────────────────────

-- vv (normal): reset the stack and select the named node under the cursor.
function M.init_selection()
	_stack = {}

	local buf = vim.api.nvim_get_current_buf()
	local pos = vim.api.nvim_win_get_cursor(0)
	local ok, node = pcall(vim.treesitter.get_node, {
		bufnr = buf,
		pos = { pos[1] - 1, pos[2] },
		ignore_injections = false,
	})
	if not ok or not node then
		return
	end
	if not node:named() then
		node = node:parent()
	end
	if not node then
		return
	end

	_stack[#_stack + 1] = node
	select_node(node)
end

-- <S-l> (visual): push the next parent with a DIFFERENT (larger) range.
-- Some parent nodes wrap a child with an identical range (e.g. Python's
-- expression_statement around a call). Pressing <S-l> on them produces no
-- visible change — the "dead press" bug. We walk up the tree until we find
-- a parent whose range actually differs from the current selection.
function M.node_incremental()
	local current = _stack[#_stack]
	if not current then
		return
	end

	local csr, csc, cer, cec = current:range()

	-- Walk up, skipping nodes whose range is identical to the current node.
	local parent = current:parent()
	while parent do
		local psr, psc, per, pec = parent:range()
		if psr ~= csr or psc ~= csc or per ~= cer or pec ~= cec then
			break -- found a node whose range actually differs → stop here
		end
		parent = parent:parent()
	end

	if parent then
		_stack[#_stack + 1] = parent
		select_node(parent)
	end
end

-- <S-h> (visual): pop the stack and re-select the previous node.
function M.node_decremental()
	if #_stack > 1 then
		_stack[#_stack] = nil
		local prev = _stack[#_stack]
		if prev then
			select_node(prev)
		end
	end
end

-- <S-s> (visual): push the nearest scope ancestor (function/class/block/…).
function M.scope_incremental()
	local current = _stack[#_stack]
	if not current then
		return
	end

	local scope_types = {
		function_definition = true,
		function_declaration = true,
		method_definition = true,
		method_declaration = true,
		arrow_function = true,
		class_definition = true,
		class_declaration = true,
		for_statement = true,
		while_statement = true,
		if_statement = true,
		block = true,
	}

	local cur = current:parent()
	while cur do
		if scope_types[cur:type()] then
			_stack[#_stack + 1] = cur
			select_node(cur)
			return
		end
		cur = cur:parent()
	end

	-- Fallback: plain parent expansion.
	M.node_incremental()
end

-- ── Setup (keymaps + autocmd) ─────────────────────────────────────────────────

function M.setup()
	-- Reset the stack when the user manually returns to normal mode.
	-- Skipped (_programmatic=true) when select_node exits visual itself.
	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "*:n",
		group = vim.api.nvim_create_augroup("IncrementalSelectionReset", { clear = true }),
		callback = function()
			if not _programmatic then
				_stack = {}
			end
		end,
	})

	local map = vim.keymap.set
	local opts = { noremap = true, silent = true }

	map("n", "vv", M.init_selection, vim.tbl_extend("force", opts, { desc = "TS: init selection" }))
	map("x", "<S-l>", M.node_incremental, vim.tbl_extend("force", opts, { desc = "TS: expand to parent node" }))
	map("x", "<S-s>", M.scope_incremental, vim.tbl_extend("force", opts, { desc = "TS: expand to scope" }))
	map("x", "<S-h>", M.node_decremental, vim.tbl_extend("force", opts, { desc = "TS: shrink to child node" }))
end

return M
