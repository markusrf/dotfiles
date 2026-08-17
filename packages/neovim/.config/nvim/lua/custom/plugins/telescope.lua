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
  "--glob=!**/uv.lock",
}
vim.list_extend(grep_args, default_args)

local find_command = {
  "rg",
  "--files",
}
vim.list_extend(find_command, default_args)

local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return string.format("%s\t\t", tail)
  end
  return string.format("%s\t\t%s\t\t", tail, parent)
end

-- Based on https://github.com/nvim-telescope/telescope.nvim/issues/609#issuecomment-860963901
local function setup_git_bcommits()
  local previewers = require("telescope.previewers")
  local builtin = require("telescope.builtin")

  local delta = previewers.new_termopen_previewer({
    get_command = function(entry)
      return {
        "git",
        "-c",
        "core.pager=delta",
        "-c",
        "delta.side-by-side=false",
        "diff",
        entry.value .. "^!",
        "--",
        entry.current_file,
      }
    end,
  })

  local git_bcommits_func = function(opts)
    opts = opts or {}
    opts.previewer = {
      delta,
      previewers.git_commit_message.new(opts),
      previewers.git_commit_diff_as_was.new(opts),
    }

    -- The trailing newline %n is added as workaround for the following telescope issue:
    -- https://github.com/nvim-telescope/telescope.nvim/issues/2517
    opts.git_command = { "git", "log", "--pretty=format:%C(auto)%h %cs -%d %s <%an>%n", "--abbrev-commit" }

    builtin.git_bcommits(opts)
  end

  return git_bcommits_func
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  event = "VeryLazy",
  config = function()
    local telescope_group = vim.api.nvim_create_augroup("custom.telescope", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = telescope_group,
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
    vim.api.nvim_create_autocmd("User", {
      group = telescope_group,
      pattern = "TelescopePreviewerLoaded",
      callback = function()
        vim.wo.number = true
      end,
    })

    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      pickers = {
        find_files = {
          find_command = find_command,
        },
        buffers = {
          mappings = {
            i = {
              ["<C-w>"] = actions.delete_buffer,
            },
          },
        },
        oldfiles = {
          initial_mode = "normal",
        },
        git_files = {
          show_untracked = true,
        },
        grep_string = {
          additional_args = grep_args,
        },
        live_grep = {
          additional_args = grep_args,
          mappings = {
            i = {
              ["<C-f>"] = actions.to_fuzzy_refine,
              ["<C-q>"] = function(bufnr)
                actions.smart_send_to_qflist(bufnr)
                actions.open_qflist(bufnr)
              end,
            },
            n = {
              ["<C-q>"] = function(bufnr)
                actions.smart_send_to_qflist(bufnr)
                actions.open_qflist(bufnr)
              end,
            },
          },
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
        live_grep_args = {
          additional_args = grep_args,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-f>"] = actions.to_fuzzy_refine,
              ["<C-q>"] = function(bufnr)
                actions.smart_send_to_qflist(bufnr)
                actions.open_qflist(bufnr)
              end,
            },
            n = {
              ["<C-q>"] = function(bufnr)
                actions.smart_send_to_qflist(bufnr)
                actions.open_qflist(bufnr)
              end,
            },
          },
        },
      },
    })

    telescope.load_extension("noice")
    telescope.load_extension("live_grep_args")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    vim.keymap.set("n", "<leader>fF", builtin.git_files, { desc = "Telescope find git files" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope oldfiles" })
    vim.keymap.set("n", "<leader>fb", function()
      builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
    end, { desc = "Telescope buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    vim.keymap.set("n", "<leader>fc", builtin.command_history, { desc = "Telescope command history" })
    vim.keymap.set("n", "<leader>fC", builtin.commands, { desc = "Telescope commands" })
    vim.keymap.set("n", "<leader>fd", function()
      setup_git_bcommits()()
    end, { desc = "Telescope buffer commits" })
    vim.keymap.set(
      "n",
      "<leader>fg",
      telescope.extensions.live_grep_args.live_grep_args,
      { desc = "Telescope live grep" }
    )
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Telescope find word" })
    vim.keymap.set("n", "<leader>fW", function()
      builtin.grep_string({ word_match = "-w", additional_args = { "--case-sensitive" } })
    end, { desc = "Telescope find exact word" })
    vim.keymap.set("n", "<leader>ft", function()
      builtin.grep_string({ word_match = "-w", search = "TODO" })
    end, { desc = "Telescope grep TODO" })
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })
    vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Telescope marks" })
    vim.keymap.set("n", "<leader>fs", builtin.spell_suggest, { desc = "Telescope spell suggestions" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
    vim.keymap.set("n", "<leader>fi", builtin.diagnostics, { desc = "Telescope diagnostics" })

    vim.keymap.set("n", "<leader>fn", function()
      telescope.extensions.noice.noice()
    end, { desc = "Noice messages" })
  end,
}
