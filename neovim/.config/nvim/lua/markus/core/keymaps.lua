local keymap = vim.keymap -- for conciseness

-- press jk in insert mode to escape  
-- keymap.set("i", "jk", "<ESC>", {desc = "Exit Insert mode with jk"})

-- press n to remove highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc="Clear search highlights"})

-- increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>", {desc = "Increment Number"}) -- increment
keymap.set("n", "<leader>-", "<C-x>", {desc = "Decrement Number"}) -- decrement

keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {desc="Toggle file explorer"})
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {desc="Toggle file explore on current file"})
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {desc="Collapse file explore"})
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {desc="Refresh file explorer"})

