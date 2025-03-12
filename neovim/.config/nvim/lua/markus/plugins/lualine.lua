return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },   -- Optional for icons
  config = function()
    require("lualine").setup({
      options = {
        theme = "auto",         -- Change theme (examples: "onedark", "tokyonight", "dracula")
        -- theme = {
        --     normal = {
        --         a = { fg = 'black', bg = 'red' }
        --     }
        -- },
        section_separators = { left = "", right = "" },
        component_separators = { left = " ", right = " " },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { left = '' } },
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename", "searchcount" },
        lualine_x = {
          "encoding",
          {
            "fileformat",
            symbols = {
              -- unix = '', -- e712
              unix = '', -- e711
              dos = '', -- e70f
              mac = '', -- e711
            }
          },
          "filetype"
        },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { right = '' } },
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
