-- remove highlights
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })


-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

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

-- Diagnostics
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { desc = "Jump to next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { desc = "Jump to previous diagnostic" })

-- Save All
vim.keymap.set("n", "<leader>wa", "<cmd>wa!<CR>", { desc = "Save all" })
-- Quit all
vim.keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all" })

-- Substitude whole word under cursor, case sensitive
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace text" })

-- Navigate qflist
vim.keymap.set("n", "<leader>qj", "<cmd>cnext<CR>zz", { desc = "Next in quickfix list" })
vim.keymap.set("n", "<leader>qk", "<cmd>cprev<CR>zz", { desc = "Next in quickfix list" })


vim.keymap.set("n", "<leader><leader>fml", function()
  require("cellular-automaton").start_animation("make_it_rain")
end, { desc = "Make it rain" })
vim.keymap.set("n", "<leader><leader>ca", function()
  require("cellular-automaton").start_animation("game_of_life")
end, { desc = "Game of life" })
vim.keymap.set("n", "<leader><leader>sc", function()
  require("cellular-automaton").start_animation("scramble")
end, { desc = "Scramble" })
