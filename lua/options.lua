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
