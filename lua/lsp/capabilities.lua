local M = {}

local base = vim.lsp.protocol.make_client_capabilities()

base = vim.tbl_deep_extend("force", base, {
	offsetEncoding = { "utf-16" },
	general = {
		positionEncodings = { "utf-16" },
	},
})

local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
	M = cmp.default_capabilities(base)
else
	base.textDocument.completion.completionItem.snippetSupport = true
	M = base
end

-- Enable inlay hints support
M.textDocument = M.textDocument or {}
M.textDocument.inlayHint = {
	dynamicRegistration = true,
	resolveSupport = {
		properties = { "tooltip", "textEdits", "label.tooltip" },
	},
}

return M
