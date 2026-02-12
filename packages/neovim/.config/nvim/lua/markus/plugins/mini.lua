return {
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup({})
    end,
  },

  {
    "echasnovski/mini.splitjoin",
    version = "*",
    event = "BufEnter",
    config = function()
      require("mini.splitjoin").setup({})
    end,
  },
}
