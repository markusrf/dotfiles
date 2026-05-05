local function db_completion()
  require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
end

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
  config = function()
    local sep = package.config:sub(1, 1)
    vim.g.db_ui_save_location = vim.fn.stdpath("config") .. sep .. "db_ui"

    local group = vim.api.nvim_create_augroup("custom.dadbod", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "sql" },
      command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
    })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        vim.schedule(db_completion)
      end,
    })
  end,
}
