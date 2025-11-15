local util = require("conform.util")

local options = {
	formatters_by_ft = {
		-- Go
		go = {
			"gofumpt",
			"goimports",
			"goimports-reviser",
			"golines",
		},
		-- Lua
		lua = { "stylua" },
		-- JavaScript/TypeScript (biome-check with unsafe fixes for import removal)
		javascript = { "biome-check" },
		typescript = { "biome-check" },
		javascriptreact = { "biome-check" },
		typescriptreact = { "biome-check" },
		-- JSON (biome supports this)
		json = { "biome-check" },
		jsonc = { "biome-check" },
		-- CSS/HTML/Markdown (Biome doesn't support, use Prettier)
		css = { "prettier" },
		scss = { "prettier" },
		html = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
	},

	formatters = {
		-- Custom biome-check that runs format + lint with unsafe fixes
		-- This removes unused imports without renaming variables (via biome.json config)
		["biome-check"] = {
			command = util.from_node_modules("biome"),
			args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
			stdin = true,
			cwd = util.root_file({
				"biome.json",
				"biome.jsonc",
			}),
		},
	},

	format_on_save = {
		timeout_ms = 2500,
		lsp_fallback = true,
	},
}

return options
