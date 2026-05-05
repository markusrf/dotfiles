-- Used to show "recording" macro messages
local function macro_recording()
  local mode = require("noice").api.status.mode.get()
  if string.find(mode, "recording") then
    return mode
  end
  return ""
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto", -- Change theme (examples: "onedark", "tokyonight", "dracula")
        -- theme = {
        --     normal = {
        --         a = { fg = "black", bg = "red" }
        --     }
        -- },
        section_separators = { left = "", right = "" },
        component_separators = { left = " ", right = " " },
        disabled_filetypes = { "undotree", "diff" },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = "", right = "" } },
        },
        lualine_b = {
          -- "branch",
          "diff",
          "diagnostics",
        },
        lualine_c = {
          { "filename", path = 4 },
          "searchcount",
          {
            macro_recording,
            cond = function()
              return require("noice").api.status.mode.has()
            end,
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return require("noice").api.status.command.has()
            end,
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { left = "", right = "" } },
        },
      },
      extensions = { "oil", "nvim-tree" },
    })
  end,
}

-- some separators
-- Powerline		
-- Powerline (thin)		
-- Rounded		
-- Arrow		
-- Slanted 1		
-- Slanted 2       
-- Chevron		
-- Vertical Bar	│	│
-- Double Vertical Bar	║	║
-- Slashes		
-- Blocks	█	█
-- Dashes	─	─
-- Triangle	▶	◀
-- Double Arrow	»	«
-- Half Blocks	▌	▐
-- Arrows	➤	➤
-- Wavy	〰	〰
