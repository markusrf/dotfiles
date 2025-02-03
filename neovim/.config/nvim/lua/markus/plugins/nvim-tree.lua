-- -- nvim.tree
-- local api = require("nvim-tree.api")
--
-- local function edit_or_open()
--   local node = api.tree.get_node_under_cursor()
--
--   if node.nodes ~= nil then
--     -- expand or collapse folder
--     api.node.open.edit()
--   else
--     -- open file
--     api.node.open.edit()
--     -- Close the tree if file was opened
--     api.tree.close()
--   end
-- end
--
-- -- open as vsplit on current node
-- local function vsplit_preview()
--   local node = api.tree.get_node_under_cursor()
--
--   if node.nodes ~= nil then
--     -- expand or collapse folder
--     api.node.open.edit()
--   else
--     -- open file as vsplit
--     api.node.open.vertical()
--   end
--
--   -- Finally refocus on tree if it was lost
--   api.tree.focus()
-- end


return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      view = {
        width = 45,
        relativenumber = true,
        -- mappings = {
        --   list = {
        --     { key = "l", cb = edit_or_open "open" },
        --   },
        -- },
      },

      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
      },
    }
  end,
}

--vim.keymap.set("n", "l", edit_or_open,          {desc="Edit Or Open"})
--vim.keymap.set("n", "L", vsplit_preview,        {desc="Vsplit Preview"})
--vim.keymap.set("n", "h", api.tree.close,        {desc="Close"})
--vim.keymap.set("n", "H", api.tree.collapse_all, {desc="Collapse All"})


