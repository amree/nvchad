-- Just return the custom keymap config
local opts = {
	completion = {
		-- Don't auto-select first item - require explicit selection with arrows
		list = {
			selection = {
				preselect = false,
				auto_insert = false,
			},
		},
	},

	keymap = {
		preset = "default",
		-- Enter accepts ONLY if explicitly selected, otherwise insert newline
		["<CR>"] = {
			function(cmp)
				if cmp.is_visible() and cmp.get_selected_item() then
					return cmp.accept()
				else
					-- Explicitly insert newline when nothing is selected
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
					return true
				end
			end,
		},
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		-- Tab ONLY for snippet navigation, never for completion selection
		["<Tab>"] = {
			function(cmp)
				local luasnip = require("luasnip")
				-- Prioritize snippet navigation over completion selection
				if luasnip.in_snippet() and luasnip.jumpable(1) then
					luasnip.jump(1)
					return true
				end
				-- Block Tab from selecting completion (use arrows/Ctrl+n/p instead)
				if cmp.is_visible() then
					return false
				end
				return false
			end,
		},
		["<S-Tab>"] = {
			function(cmp)
				local luasnip = require("luasnip")
				-- Prioritize snippet navigation over completion selection
				if luasnip.in_snippet() and luasnip.jumpable(-1) then
					luasnip.jump(-1)
					return true
				end
				-- Block Shift+Tab from selecting completion
				if cmp.is_visible() then
					return false
				end
				return false
			end,
		},
	},
}

return opts
