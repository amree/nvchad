require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- tmux navigator mappings - override NvChad defaults
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })

-- Toggle invisible character display
map("n", "<leader>ti", "<cmd>set list!<cr>", { desc = "Toggle invisible chars" })

-- Telescope: live_grep prefilled with word under cursor / visual selection
map("n", "<leader>fW", function()
	require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Live grep word under cursor" })

map("v", "<leader>fW", function()
	vim.cmd('noau normal! "vy"')
	require("telescope.builtin").live_grep({ default_text = vim.fn.getreg("v") })
end, { desc = "Live grep visual selection" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
