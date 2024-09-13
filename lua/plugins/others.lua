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

	-- noice
	{
		"folke/noice.nvim",
		event = "BufRead",
		config = function()
			require("noice").setup({
				lsp = {
					signature = {
						enabled = false, -- Add this line to disable signature help
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
}

return plugins
