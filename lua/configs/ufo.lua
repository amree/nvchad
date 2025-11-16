-- Configure fold options (for when UFO loads)
vim.o.foldcolumn = "1" -- Show fold markers (-, |) and levels
vim.o.foldlevel = 99 -- Start with all folds open
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Softer fold column colors
vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#4a4a4a", bg = "NONE" })
vim.api.nvim_set_hl(0, "Folded", { fg = "#6a6a6a", bg = "#1a1a1a" })

-- Setup nvim-ufo
require("ufo").setup({
	-- Use LSP for folding when available, fallback to indent
	provider_selector = function(bufnr, filetype, buftype)
		return { "lsp", "indent" }
	end,
})

-- Custom command to fully re-enable after UfoDisableFully
vim.api.nvim_create_user_command("UfoEnableFully", function()
	vim.o.foldcolumn = "1"
	vim.o.foldlevel = 99
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true
	require("ufo").enable()
end, { desc = "Fully enable UFO and restore fold column" })

vim.api.nvim_create_user_command("UfoDisableFully", function()
	require("ufo").disable()
	vim.o.foldenable = false
	vim.o.foldcolumn = "0"
end, { desc = "Disable UFO and hide fold column" })
