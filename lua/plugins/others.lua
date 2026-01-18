local plugins = {
	-- add/delete/replace surround
	{
		"machakann/vim-sandwich",
		keys = { "sa", "sd", "sr" },
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
		cmd = { "Git", "G", "Gvdiffsplit", "Gread", "Gwrite", "Gblame" },
	},

	-- lazygit integration
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	-- show git commit message for current line
	-- Inside popup: o = older commit, O = newer commit, d = diff, q = close
	{
		"rhysd/git-messenger.vim",
		keys = {
			{ "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Git Messenger" },
		},
		init = function()
			vim.g.git_messenger_floating_win_opts = { border = "single" }
			vim.g.git_messenger_always_into_popup = true
		end,
	},

	-- end block support (auto-enables with treesitter)
	{
		"RRethy/nvim-treesitter-endwise",
		event = "InsertEnter",
		dependencies = "nvim-treesitter/nvim-treesitter",
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
		lazy = false,
		config = function()
			vim.notify = require("notify")
		end,
	},

	-- better diff viewer
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
		},
	},

	-- better diagnostics list
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		},
		opts = {},
	},

	-- better code folding (disabled by default, use :UfoEnable to activate)
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		cmd = "UfoEnable",
		keys = {
			{ "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
			{ "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
		},
		config = function()
			require("configs.ufo")
		end,
	},

	-- Import NvChad's blink.cmp config
	{ import = "nvchad.blink.lazyspec" },

	-- Override blink.cmp keymap for snippet navigation
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			-- Merge with NvChad's default config, but override keymap and completion settings
			local custom_config = require("configs.blink")
			opts.keymap = custom_config.keymap
			-- Merge completion settings instead of replacing
			opts.completion = opts.completion or {}
			opts.completion.list = custom_config.completion.list
			return opts
		end,
	},

	-- integrate with tmux
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},

	-- TypeScript enhanced tools (auto-import, organize imports)
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		config = function()
			local configs = require("nvchad.configs.lspconfig")
			require("typescript-tools").setup({
				on_attach = configs.on_attach,
				capabilities = configs.capabilities,
				settings = {
					-- Auto-complete function calls with parentheses
					-- Note: Also adds () to JSX components, but usually you don't accept that completion
					complete_function_calls = true,
					-- Enable code actions for organizing imports
					expose_as_code_action = "all",
					-- JSX close tag completion
					jsx_close_tag = {
						enable = true,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
					-- Configure auto-imports
					tsserver_file_preferences = {
						includeCompletionsForModuleExports = true,
						importModuleSpecifierPreference = "relative",
						-- Disable type-only auto imports (only works if tsconfig has verbatimModuleSyntax = false)
						preferTypeOnlyAutoImports = false,
					},
				},
			})
			-- Note: Organize imports is handled by biome-check formatter in conform.nvim
		end,
	},

	-- Show package.json versions inline
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = "json",
		config = function()
			require("package-info").setup({
				package_manager = "npm",
				highlights = {
					up_to_date = { fg = "#8fbcbb" }, -- Cyan/teal for up-to-date
					outdated = { fg = "#ebcb8b" }, -- Yellow/gold for outdated
					invalid = { fg = "#bf616a" }, -- Red for invalid
				},
				icons = {
					enable = true,
					style = {
						up_to_date = " ✓ ",
						outdated = " ⚠ ",
						invalid = " ✗ ",
					},
				},
				autostart = true,
				hide_up_to_date = false,
				hide_unstable_versions = false,
			})
		end,
	},
}

return plugins
