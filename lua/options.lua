require("nvchad.options")

-- add yours here!

local o = vim.o
-- set multiple colorcolumn
o.colorcolumn = "80,100"
-- o.cursorlineopt ='both' -- to enable cursorline!

-- Disable swap files
o.swapfile = false

-- Show invisible characters (tabs, trailing spaces, etc.)
o.list = true
o.listchars = "tab:→ ,trail:·,nbsp:␣"

-- Reduce which-key popup delay (default is 1000ms)
o.timeoutlen = 300

-- Auto-reload buffers when files change on disk (e.g. Claude Code edits from tmux pane)
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "BufEnter", "CursorHold" }, {
  command = "checktime",
})
