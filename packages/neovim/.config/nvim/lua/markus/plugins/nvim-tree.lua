-- -- nvim.tree

local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- function for left to assign to keybindings
  local lefty = function ()
    local node_at_cursor = api.tree.get_node_under_cursor()
    -- if it's a node and it's open, close
    if node_at_cursor.nodes and node_at_cursor.open then
      api.node.open.edit()
    -- else left jumps up to parent
    else
      api.node.navigate.parent()
    end
  end

  -- function for right to assign to keybindings
  local righty = function ()
    local node_at_cursor = api.tree.get_node_under_cursor()
    -- if it's a closed node, open it
    if node_at_cursor.nodes and not node_at_cursor.open then
      api.node.open.edit()
    end
  end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '?', api.tree.toggle_help,  opts('Help'))
  vim.keymap.set("n", "h", lefty , opts("Close node") )
  vim.keymap.set("n", "<Left>", lefty , opts("Close node") )
  vim.keymap.set("n", "<Right>", righty , opts("Open node") )
  vim.keymap.set("n", "l", righty , opts("Open node") )
end


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
        custom = { ".DS_Store", "^\\.git$" },
        exclude = { ".env", "libecalc" },
      },
      git = {
        ignore = false,
      },
      on_attach = my_on_attach,
    }
  end,
}

