local default_args = {
  "--hidden",
  "--no-ignore",
  "--glob=!**/.git/*",
  "--glob=!**/.venv/*",
  "--glob=!**/.idea/*",
  "--glob=!**/.vscode/*",
  "--glob=!**/.mypy_cache/*",
  "--glob=!**/.pytest_cache/*",
  "--glob=!**/.ruff_cache/*",
  "--glob=!**/__pycache__/*",
  "--glob=!**/node_modules/*",
  "--glob=!**/build/*",
  "--glob=!**/dist/*",
  "--glob=!**/main/data/*",
  "--glob=!**/.terraform/*",
  "--glob=!**/.DS_Store",
}

local grep_args = {
  "--glob=!**/package-lock.json",
  "--glob=!**/poetry.lock",
}
for _, v in ipairs(default_args) do
  table.insert(grep_args, v)
end

local find_command = {
  "rg",
  "--files",
}
for _, v in ipairs(default_args) do
  table.insert(find_command, v)
end

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return string.format("%s\t\t", tail)
  end
  return string.format("%s\t\t%s\t\t", tail, parent)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", {
        link = "Comment",
      })
      vim.fn.matchadd("TelescopeParent2", "▏.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent2", {
        link = "TelescopeMatching",
      })
    end)
  end,
})

-- Set linenumbers in preview pane
vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  -- commit = "814f102cd1da3dc78c7d2f20f2ef3ed3cdf0e6e4",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      pickers = {
        find_files = {
          find_command = find_command,
        },
        buffers = {
          mappings = {
            i = {
              ["<C-w>"] = actions.delete_buffer,
            }
          }
        },
        git_files = {
          show_untracked = true,
        },
        grep_string = {
          additional_args = grep_args,
        },
        live_grep = {
          additional_args = grep_args,
        },
        lsp_references = {
          trim_text = true,
          fname_width = 120,
        },
      },
      defaults = {
        layout_strategy = "vertical",
        path_display = filename_first,
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case"
        }
      }
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>fF", builtin.git_files, { desc = "Telescope find git files" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope oldfiles" })
    vim.keymap.set("n", "<leader>fb", function()
        builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
      end,
      { desc = "Telescope buffers" }
    )
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    vim.keymap.set("n", "<leader>fc", builtin.command_history, { desc = "Telescope command history" })
    vim.keymap.set("n", "<leader>fC", builtin.commands, { desc = "Telescope commands" })
    vim.keymap.set("n", "<leader>fd", builtin.git_bcommits, { desc = "Telescope buffer commits" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope find word" })
    vim.keymap.set("n", "<leader>ft",
      function()
        builtin.grep_string({ word_match = "-w", search = "TODO" })
      end,
      { desc = "Telescope grep TODO" }
    )
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })
  end,
}
