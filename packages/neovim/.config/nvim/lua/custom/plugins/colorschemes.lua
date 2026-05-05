return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1001,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        transparent_background = false,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
  },
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = true,
  },
}
