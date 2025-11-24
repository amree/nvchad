-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "ashes",
	theme_toggle = { "ashes", "github_light" },

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
		-- Diff colors for diffview.nvim
		DiffAdd = { bg = "#2d4a3e" },
		DiffDelete = { bg = "#4a2d2d" },
		DiffChange = { bg = "#3d3d2d" },
		DiffText = { bg = "#4a4a2d" },
	},
}

return M
