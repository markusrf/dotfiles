-- press n to remove highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", {desc="Clear search highlights"})

-- increment and decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", {desc = "Increment Number"}) -- increment
vim.keymap.set("n", "<leader>-", "<C-x>", {desc = "Decrement Number"}) -- decrement


-- nvim.tree
local api = require("nvim-tree.api")

local function edit_or_open()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file
    api.node.open.edit()
    -- Close the tree if file was opened
    api.tree.close()
  end
end

-- open as vsplit on current node
local function vsplit_preview()
  local node = api.tree.get_node_under_cursor()

  if node.nodes ~= nil then
    -- expand or collapse folder
    api.node.open.edit()
  else
    -- open file as vsplit
    api.node.open.vertical()
  end

  -- Finally refocus on tree if it was lost
  api.tree.focus()
end

vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {desc="Toggle file explorer"})
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {desc="Toggle file explore on current file"})
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {desc="Collapse file explore"})
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {desc="Refresh file explorer"})
--vim.keymap.set("n", "l", edit_or_open,          {desc="Edit Or Open"})
--vim.keymap.set("n", "L", vsplit_preview,        {desc="Vsplit Preview"})
--vim.keymap.set("n", "h", api.tree.close,        {desc="Close"})
--vim.keymap.set("n", "H", api.tree.collapse_all, {desc="Collapse All"})

