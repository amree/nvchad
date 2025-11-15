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
