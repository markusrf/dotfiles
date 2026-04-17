return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>gh",
      "<cmd>DiffviewFileHistory<cr>",
      desc = "Open git branch history",
    },
    {
      "<leader>gf",
      "<cmd>DiffviewFileHistory %<cr>",
      desc = "Open git file history",
    },
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      desc = "Open git diff",
    },
  },
}
