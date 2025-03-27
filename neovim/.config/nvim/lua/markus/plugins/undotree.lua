return {
  "mbbill/undotree",

  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_CustomUndotreeCmd = "topleft vertical 40 new"
    vim.g.undotree_CustomDiffpanelCmd = "botright 10 new"
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree toggle" })
    vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeFocus, { desc = "Undotree focus" })
  end
}
