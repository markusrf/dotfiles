local detail = false

return {
  "stevearc/oil.nvim",
  ---@module "oil"
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  cmd = "Oil",
  keys = {
    {
      "-",
      function()
        require("oil").open_float(nil, { preview = { vertical = true } })
      end,
      desc = "Oil: Open parent directory",
    },
  },
  -- Load Oil if nvim is started with a directory as an argument
  init = function()
    if vim.fn.argc() >= 1 then
      local arg = vim.fn.argv(0)
      if type(arg) == "string" and vim.fn.isdirectory(arg) == 1 then
        require("lazy").load({ plugins = { "oil.nvim" } })
      end
    end
  end,
  config = function()
    local oil = require("oil")
    oil.setup({
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".DS_Store"
        end,
      },
      float = {
        padding = 4,
        border = "rounded",
        get_win_title = function(winid)
          local cwd = vim.fn.getcwd()
          local buf = vim.api.nvim_win_get_buf(winid)
          local oil_file_path = vim.api.nvim_buf_get_name(buf)
          local file_path = string.gsub(oil_file_path, "oil://", "")
          if string.find(file_path, cwd, 1, true) then
            file_path = file_path:sub(#cwd + 1)
          end
          return " " .. file_path .. " "
        end,
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
  end,
}
