local detail = false

return {
  "stevearc/oil.nvim",
  ---@module "oil"
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    local oil = require("oil")
    oil.setup({
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          local m = name:match("^.DS_Store$")
          return m ~= nil
        end
      },
      float = {
        padding = 4,
      },
      keymaps = {
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              oil.set_columns({ "icon", "permissions", "size", "mtime" })
            else
              oil.set_columns({ "icon" })
            end
          end,
        },
      },
    })
    vim.keymap.set("n", "-", function()
      oil.open_float(nil, { preview = { vertical = true } })
    end, {})
  end
}
