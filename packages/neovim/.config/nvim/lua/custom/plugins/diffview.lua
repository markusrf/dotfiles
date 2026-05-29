return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>gH",
      "<cmd>DiffviewFileHistory<cr>",
      desc = "Open git branch history",
    },
    {
      "<leader>gh",
      "<cmd>DiffviewFileHistory %<cr>",
      desc = "Open git file history",
    },
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      desc = "Open git diff",
    },
  },
  config = function()
    require("diffview").setup({
      view = {
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    })
  end,
}
