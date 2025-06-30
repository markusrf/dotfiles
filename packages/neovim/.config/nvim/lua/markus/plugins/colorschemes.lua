return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function ()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,
      })
    end
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },
  {
    'kepano/flexoki-neovim',
    name = 'flexoki',
    lazy = true,
  },
}

