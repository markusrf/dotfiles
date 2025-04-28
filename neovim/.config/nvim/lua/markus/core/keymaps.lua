-- remove highlights
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", {desc="Clear search highlights"})

-- increment and decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", {desc = "Increment Number"}) -- increment
vim.keymap.set("n", "<leader>-", "<C-x>", {desc = "Decrement Number"}) -- decrement


-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Save All
vim.keymap.set("n", "<leader>wa", "<cmd>wa!<CR>", { desc = "Save all" })
-- Quit all
vim.keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all" })

-- nvim.tree
vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeFindFileToggle<CR>", {desc="Toggle file explorer"})
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {desc="Collapse file explore"})
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {desc="Refresh file explorer"})

