local plugins = {
	-- add/delete/replace surround
	{
		"machakann/vim-sandwich",
		lazy = false,
		keys = { "sa", "sd", "sr" },
		event = "BufRead",
	},

	-- open code on the web
	{
		"linrongbin16/gitlinker.nvim",
		event = "BufRead",
		config = function()
			require("gitlinker").setup()
		end,
	},

	-- strip trailing whitespace
	{
		"echasnovski/mini.trailspace",
		version = false,
		event = "BufRead",
		config = function()
			require("mini.trailspace").setup()

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				command = "lua MiniTrailspace.trim()",
			})
		end,
	},

	-- git
	{
		"tpope/vim-fugitive",
		event = "BufRead",
	},

	-- end block support
	{
		"RRethy/nvim-treesitter-endwise",
		event = "InsertEnter",
		config = function()
			require("nvim-treesitter.configs").setup({
				endwise = {
					enable = true,
				},
			})
		end,
	},

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("configs.copilot")
		end,
	},

	-- matching brackets
	{
		"andymass/vim-matchup",
		event = "CursorMoved",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},

	-- cool notifier
	{
		"rcarriga/nvim-notify",
		event = "BufRead",
		config = function()
			vim.notify = require("notify")
		end,
	},

	-- better diff viewer
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
		config = function()
			require("diffview").setup()
		end,
	},

	{ import = "nvchad.blink.lazyspec" },
}

return plugins
