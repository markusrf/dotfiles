local grep_args = { "-.", "-g=!.git/**", "-g=!**/dist/**" }

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup {
      pickers = {
        find_files = {
        },
        git_files = {
          show_untracked = true,
        },
        grep_string = {
          additional_args = grep_args,
        },
        live_grep = {
          additional_args = grep_args,
        }
      },
    }

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fF", builtin.git_files,       { desc = "Telescope find git files" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles,        { desc = "Telescope oldfiles" })
    vim.keymap.set("n", "<leader>fc", builtin.command_history, { desc = "Telescope command history" })
    vim.keymap.set("n", "<leader>fC", builtin.commands,        { desc = "Telescope commands" })
    vim.keymap.set("n", "<leader>fd", builtin.git_bcommits,    { desc = "Telescope buffer commits" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string,     { desc = "Telescope buffer commits" })
    vim.keymap.set("n", "<leader>ft",
      function()
        builtin.grep_string({ word_match = "-w", search = "TODO" })
      end,
      { desc = "Telescope grep TODO" }
    )
  end,
}

