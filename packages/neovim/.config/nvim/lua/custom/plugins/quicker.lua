return {
  "stevearc/quicker.nvim",
  ft = "qf",
  keys = {
    {
      "<leader>qq",
      function()
        require("quicker").toggle({ focus = true })
      end,
      desc = "Toggle quickfix",
    },
    {
      "<leader>ql",
      function()
        require("quicker").toggle({ loclist = true, focus = true })
      end,
      desc = "Toggle loclist",
    },
  },
  ---@module "quicker"
  ---@type quicker.SetupOptions
  config = function()
    require("quicker").setup({
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    })
  end,
}
