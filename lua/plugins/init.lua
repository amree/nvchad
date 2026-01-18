return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = function()
			return require("configs.conform")
		end,
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
		config = function(_, opts)
			-- Use pcall to handle both old and new nvim-treesitter APIs
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup(opts)
			else
				-- New nvim-treesitter uses vim.treesitter directly
				-- Install parsers manually
				local parsers = opts.ensure_installed or {}
				if #parsers > 0 then
					vim.cmd("TSInstall " .. table.concat(parsers, " "))
				end
			end
		end,
	},
}
