return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = require("configs.conform"),
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- Existing
				"css",
				"html",
				"lua",
				"ruby",
				"vim",
				"vimdoc",
				-- Go
				"go",
				"gomod",
				"gosum",
				-- React/TypeScript/Vite
				"javascript",
				"typescript",
				"tsx",
				"json",
				"jsonc",
				"scss",
				"markdown",
				"markdown_inline",
			},
		},
	},
}
