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

	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		opts = {
			-- add any opts here
			-- for example
			-- provider = "claude",
			provider = "gemini",
			-- gemini = {
			-- 	model = "gemini-2.5-pro-preview-03-25",
			-- 	api_key_name = "GEMINI_API_KEY",
			-- 	max_tokens = 64000,
			-- },
			gemini = {
				model = "gemini-2.0-flash",
				api_key_name = "GEMINI_API_KEY",
				max_tokens = 64000,
			},
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-7-sonnet-20250219",
				temperature = 0,
				max_tokens = 8192,
			},
		},
		behaviour = {
			enable_claude_text_editor_tool_mode = true,
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}

return plugins
