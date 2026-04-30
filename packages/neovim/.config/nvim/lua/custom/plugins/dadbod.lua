return {
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
  },
  keys = {
    { "<leader>dt", "<cmd>DBUIToggle<cr>", desc = "DB toggle ui" },
    { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "DB find buffer" },
    { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "DB rename buffer" },
    { "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", desc = "DB last query " },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  config = function(_, opts)
    vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
      },
      command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
        "mysql",
        "plsql",
      },
      callback = function()
        vim.schedule(opts.db_completion)
      end,
    })
  end,
}
